using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameSceneManager : MonobehaviourSingleton<GameSceneManager>
{
    public GameObject loadingScreen;

    private List<AsyncOperation> _scenesLoading = new List<AsyncOperation>();
    private Slider _progressBar;
    private float _totalSceneProgress;

    private void Awake()
    {
        if (Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        SceneManager.LoadSceneAsync(ScenesDataContainer.TitleScreen, LoadSceneMode.Additive);
        _progressBar = loadingScreen.GetComponentInChildren<Slider>();
    }

    public void LoadGame()
    {
        loadingScreen.gameObject.SetActive(true);
        SceneManager.UnloadSceneAsync(ScenesDataContainer.TitleScreen);
        foreach (var sceneBuildIndex in ScenesDataContainer.LevelOneScenes)
        {
            _scenesLoading.Add(SceneManager.LoadSceneAsync(sceneBuildIndex, LoadSceneMode.Additive));
        }
        StartCoroutine(UpdateSceneLoadProgress());
    }

    private IEnumerator UpdateSceneLoadProgress()
    {
        for (var i = 0; i < _scenesLoading.Count; i++)
        {
            while (!_scenesLoading[i].isDone)
            {
                _totalSceneProgress = 0;

                foreach (var op in _scenesLoading) _totalSceneProgress += op.progress;

                _totalSceneProgress = (_totalSceneProgress / _scenesLoading.Count) * 100f;

                _progressBar.value = Mathf.RoundToInt(_totalSceneProgress);

                yield return null;
            }
        }

        loadingScreen.gameObject.SetActive(false);
    }
}