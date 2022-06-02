using System;
using System.Collections;
using System.Collections.Generic;
using Events.Channels;
using UnityEngine;
using UnityEngine.UI;

public class GameSceneManager : MonobehaviourSingleton<GameSceneManager>
{
    public GameObject loadingScreen;
    public LevelDataContainer titleScreen;

    public StringEventChannel sceneDataChannel;

    private List<AsyncOperation> _scenesLoading = new List<AsyncOperation>();
    private Slider _progressBar;
    private float _totalSceneProgress;
    private LevelDataContainer[] _levelData;
    private LevelDataContainer _currentLevel;

    private void Awake()
    {
        if (Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        _currentLevel = titleScreen;
        _currentLevel.Load();
        _progressBar = loadingScreen.GetComponentInChildren<Slider>();
        _levelData = Resources.LoadAll<LevelDataContainer>("SceneData");
    }

    private void OnEnable()
    {
        sceneDataChannel.Subscribe(LoadLevel);
    }

    private void OnDisable()
    {
        sceneDataChannel.Unsubscribe(LoadLevel);
    }

    public void LoadLevel(string levelName)
    {
        loadingScreen.gameObject.SetActive(true);
        _currentLevel.Unload();
        foreach (var data in _levelData)
        {
            if (data.name != levelName) continue;
            _scenesLoading = data.Load();
            _currentLevel = data;
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