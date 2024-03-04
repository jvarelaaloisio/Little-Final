using System;
using System.Collections;
using Core.Extensions;
using Events.UnityEvents;
using TMPro;
using UnityEngine;

namespace UI
{
    public class SimpleDialogueBehaviour : MonoBehaviour
    {
        [SerializeField] private TMP_Text tmpText;
        [SerializeField] private string skipButton = "Jump";
        [SerializeField] private Config config;
        
        private int _currentPhraseIndex;
        private int _currentChar;

        [field: SerializeField] public Dialogue Dialogue { get; set; }

        public SmartEvent onFinished;
        public SmartEvent OnStartPhrase;
        private Coroutine _dialogueCoroutine;

        private void OnValidate()
        {
            tmpText ??= GetComponent<TMP_Text>();
        }

        private IEnumerator Start()
        {
            yield return null;
            _dialogueCoroutine = StartCoroutine(ShowDialogue());
        }

        private IEnumerator ShowDialogue()
        {
            tmpText.text = "";
            if (!Dialogue)
            {
                this.LogError($"{nameof(Dialogue)} is null!");
                yield break;
            }
            OnStartPhrase.Invoke();
            while (!destroyCancellationToken.IsCancellationRequested)
            {
                if (IsFinished())
                    yield break;

                var phrase = Dialogue.Phrases[_currentPhraseIndex];
                tmpText.text = phrase[.._currentChar];
                _currentChar++;
                if (_currentChar > phrase.Length)
                {
                    yield return new WaitForSeconds(config.MinPhraseDuration);
                    AdvancePhrase();
                    OnStartPhrase.Invoke();
                }
                else
                    yield return new WaitForSeconds(1 / config.CharactersPerSecond);
            }
        }

        private bool IsFinished()
        {
            if (!Dialogue)
                return true;
            return _currentPhraseIndex >= Dialogue.Phrases.Count;
        }

        private void Update()
        {
            if (IsFinished())
                return;
            if (Input.GetButtonDown(skipButton))
            {
                AdvancePhrase();
                if (IsFinished())
                    return;
                if (_dialogueCoroutine != null)
                    StopCoroutine(_dialogueCoroutine);
                StartCoroutine(ShowDialogue());
            }
        }

        private void AdvancePhrase()
        {
            _currentPhraseIndex++;
            _currentChar = 0;
            if (IsFinished())
            {
                this.Log("Finished dialogue!");
                onFinished.Invoke();
                return;
            }

            this.Log($"Setting phrase: {_currentPhraseIndex}");
        }

        [Serializable]
        public class Config
        {
            [field: SerializeField] public float CharactersPerSecond { get; set; } = 1;
            [field: SerializeField] public float MinPhraseDuration { get; set; } = 1;
        }
    }
}
