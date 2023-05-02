using System.Collections;
using Events;
using Events.Channels;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameSceneManager : MonobehaviourSingleton<GameSceneManager>
{
    public GameObject loadingScreen;
    public LevelDataContainer titleScreen;

    public LevelDataContainerChannel sceneDataChannel;
    public VoidChannelSo quitGameChannel;
    
    [SerializeField]
    private float delayBeforeHidingLoadScreen = .5f;
    [SerializeField]
    private float delayBetweenBatches = 1f;
    [SerializeField]
    private float delayBeforeLoadingNextScene = 3f;
    [SerializeField]
    private float delayBeforeActivatingScene = .5f;
    
    private Slider _progressBar;
    private float _totalSceneProgress;
    private LevelDataContainer _currentLevel;

    private void Awake()
    {
        if (Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
        //TODO: Convert into separate script that loads the title screen as intended, through the event channel
        _currentLevel = titleScreen;
        _currentLevel.Load();
        _progressBar = loadingScreen.GetComponentInChildren<Slider>();
    }

    private void OnEnable()
    {
        sceneDataChannel.Subscribe(LoadLevel);
        quitGameChannel.Subscribe(QuitGame);
    }

    private void OnDisable()
    {
        sceneDataChannel.Unsubscribe(LoadLevel);
        quitGameChannel.Unsubscribe(QuitGame);
    }

    public void LoadLevel(LevelDataContainer levelData)
    {
        loadingScreen.gameObject.SetActive(true);
        _currentLevel.Unload();
        _currentLevel = levelData;

        StartCoroutine(LoadLevelCoroutine(levelData));
    }

    private IEnumerator LoadLevelCoroutine(LevelDataContainer levelData)
    {
        var scenesToLoadQty = levelData.immediateLoadBuildIndexes.Length;
        for (var i = 0; i < scenesToLoadQty; i++)
        {
            var buildIndex = levelData.immediateLoadBuildIndexes[i];
            var loadLevelOperation = SceneManager.LoadSceneAsync(buildIndex, LoadSceneMode.Additive);
            StartCoroutine(UpdateLevelLoadProgress(loadLevelOperation, i, scenesToLoadQty));
            yield return loadLevelOperation;
        }

        yield return new WaitForSeconds(delayBeforeHidingLoadScreen);
        var activeScene = SceneManager.GetSceneByBuildIndex(_currentLevel.activeSceneIndex);
        SceneManager.SetActiveScene(activeScene);
        loadingScreen.gameObject.SetActive(false);
        
        foreach (var levelBatch in levelData.batchedLoads)
        {
            foreach (var buildIndex in levelBatch.buildIndexes)
            {
                var loadOperation = SceneManager.LoadSceneAsync(buildIndex, LoadSceneMode.Additive);
                loadOperation.allowSceneActivation = false;
                var scenePath = SceneUtility.GetScenePathByBuildIndex(buildIndex);
                Debug.Log($"{name}: Loading {scenePath}");
                
                yield return new WaitUntil(() => loadOperation.progress >= 0.9f);

                yield return new WaitForSeconds(delayBeforeActivatingScene);
                Debug.Log($"{name}: Activating {scenePath}");
                loadOperation.allowSceneActivation = true;
                
                Debug.Log($"{name}: Loaded {scenePath}");
                yield return new WaitForSeconds(delayBeforeLoadingNextScene);
            }

            yield return new WaitForSeconds(delayBetweenBatches);
        }
    }

    private IEnumerator UpdateLevelLoadProgress(AsyncOperation loadOperation, int scenesAlreadyLoadedQty, int totalScenesToLoadQty)
    {
        while (!loadOperation.isDone)
        {
            var totalSceneProgress = (loadOperation.progress + scenesAlreadyLoadedQty) / totalScenesToLoadQty;

            _progressBar.value = totalSceneProgress;
            yield return null;
        }
    }

    private static void QuitGame()
    {
        Debug.Log("Quitting game...Bye!");
        Application.Quit();
    }
}