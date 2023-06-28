using System.Collections;
using Events.Channels;
using Menus.Events;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameSceneManager : MonobehaviourSingleton<GameSceneManager>
{
    public GameObject loadingScreen;
    public LevelDataContainerViaBuildIndexes titleScreen;

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
    private LevelDataContainerViaBuildIndexes _currentLevel;

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

    public void LoadLevel(LevelDataContainerViaBuildIndexes levelData)
    {
        loadingScreen.gameObject.SetActive(true);
        _currentLevel.Unload();
        _currentLevel = levelData;

        StartCoroutine(LoadLevelCoroutine(levelData));
    }

    private IEnumerator LoadLevelCoroutine(LevelDataContainer levelData)
    {
        var scenesLoadedQty = 0;
        var totalScenesToLoadQty = levelData.ImmediateLoadBatch.Length;
        foreach (var loadOperation in levelData.LoadImmediateScenes())
        {
            yield return UpdateLevelLoadProgress(loadOperation,
                scenesLoadedQty,
                totalScenesToLoadQty);
            scenesLoadedQty++;
        }

        yield return new WaitForSeconds(delayBeforeHidingLoadScreen);
        var activeScene = SceneManager.GetSceneByBuildIndex(_currentLevel.activeSceneIndex);
        SceneManager.SetActiveScene(activeScene);
        loadingScreen.gameObject.SetActive(false);
        
        foreach (var levelBatch in levelData.LevelBatches)
        {
            foreach (var loadOperation in levelBatch.LoadBatch())
            {
                loadOperation.allowSceneActivation = false;
                // var sceneName = SceneUtility.GetScenePathByBuildIndex(loadOperation).Split('/')[^1];
                var sceneName = "temp value";
                Debug.Log($"{name}: <color=yellow>Loading</color> {sceneName}");

                var loadStartTime = Time.realtimeSinceStartupAsDouble;
                yield return new WaitUntil(() => loadOperation.progress >= 0.9f);

                Debug.Log($"{name}: <color=green>Loaded</color> {sceneName} in <color=red>{(Time.realtimeSinceStartupAsDouble - loadStartTime) * 1000:F0}</color> ms"+
                          $"\n<color=black>Waiting {delayBeforeActivatingScene} seconds before activation</color>");
                
                yield return new WaitForSeconds(delayBeforeActivatingScene);
                
                var activationStartTime = Time.realtimeSinceStartupAsDouble;
                Debug.Log($"{name}: <color=yellow>Activating</color> {sceneName}");
                loadOperation.allowSceneActivation = true;
                
                Debug.Log($"{name}: <color=green>Activated</color> {sceneName} in <color=red>{(Time.realtimeSinceStartupAsDouble - activationStartTime) * 1000:F0}</color> ms" +
                          $"\n<color=black>Waiting {delayBetweenBatches * 1000} ms.</color>");
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