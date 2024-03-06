using System;
using System.Collections;
using Core.Extensions;
using Core.Missions;
using Events.UnityEvents;
using TMPro;
using UnityEngine;

namespace Missions.Implementations
{
    public class SimpleDialogueRunner : MonoBehaviour
    {
        [SerializeField] private GameObject dialogueContainer;
        [SerializeField] private TMP_Text tmpText;
        [SerializeField] private string skipButton = "Jump";
        [SerializeField] private Config config;
        
        private int _currentPhraseIndex;
        private int _currentChar;
        private bool _isRunning = false;

        [field: SerializeField] public Dialogue Dialogue { get; set; }

        public SmartEvent onFinished;
        public SmartEvent OnStartPhrase;
        private Coroutine _dialogueCoroutine;

        private void OnValidate()
        {
            tmpText ??= GetComponent<TMP_Text>();
        }

        private void Update()
        {
            if (!_isRunning || IsFinished())
                return;
            if (Input.GetButtonDown(skipButton))
            {
                this.Log($"Skipping phrase");
                AdvancePhrase();
                if (IsFinished())
                    return;
                if (_dialogueCoroutine != null)
                    StopCoroutine(_dialogueCoroutine);
                _dialogueCoroutine = StartCoroutine(ShowDialogue());
            }
        }

        public void Run(Dialogue dialogueOverride = null)
        {
            _isRunning = true;
            if (dialogueContainer)
                dialogueContainer.SetActive(true);
            if (dialogueOverride)
                SetDialogue(dialogueOverride);
            if (_dialogueCoroutine != null)
                StopCoroutine(_dialogueCoroutine);
            _dialogueCoroutine = StartCoroutine(ShowDialogue());
        }

        public void Deactivate()
        {
            if (dialogueContainer)
                dialogueContainer.SetActive(false);
            _isRunning = false;
        }

        public void SetDialogue(Dialogue dialogue)
        {
            Dialogue = dialogue;
            this.Log($"{nameof(Dialogue)} set to {dialogue.name}");
            _currentPhraseIndex = 0;
            _currentChar = 1;
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
            while (!destroyCancellationToken.IsCancellationRequested
                   && !IsFinished())
            {
                var phrase = Dialogue.Phrases[_currentPhraseIndex];
                var currentIndex = Mathf.Min(_currentChar, phrase.Length);
                tmpText.text = phrase[..currentIndex];
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

        public bool IsFinished()
        {
            if (!Dialogue)
                return true;
            return _currentPhraseIndex >= Dialogue.Phrases.Count;
        }

        private void AdvancePhrase()
        {
            _currentPhraseIndex++;
            _currentChar = 1;
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
