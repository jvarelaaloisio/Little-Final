using System.Collections;
using System.Linq;
using Core.Extensions;
using Events.Channels;
using Menus.Events;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace Menus
{
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

        /// <summary>
        /// Handle Load level event being raised in the <see cref="sceneDataChannel"/>
        /// </summary>
        /// <param name="newLevel">The level to change to</param>
        public void LoadLevel(LevelDataContainerViaBuildIndexes newLevel)
        {
            StartCoroutine(ChangeLevelCoroutine(_currentLevel, newLevel));
            _currentLevel = newLevel;
        }

        private IEnumerator ChangeLevelCoroutine(LevelDataContainer oldLevel, LevelDataContainer newLevel)
        {
            loadingScreen.gameObject.SetActive(true);
            var scenesLoadedQty = 0;
            var totalScenesToLoadQty = newLevel.ImmediateLoadBatch.Length + oldLevel.GetTotalQuantityOfScenes();
            
            var unloadReport = $"<color=yellow>Unloaded</color> level {oldLevel.name}. Report:";
            var asyncOperations = oldLevel.GetUnloadScenes();
            foreach (var unloadOperation in asyncOperations)
            {
                var duration = Time.realtimeSinceStartupAsDouble;
                yield return UpdateLevelLoadProgress(unloadOperation, scenesLoadedQty, totalScenesToLoadQty);
                duration = Time.realtimeSinceStartupAsDouble - duration;
                unloadReport += $"\n{unloadOperation.Name} ({duration * 1000:F} ms)";
                scenesLoadedQty++;
            }
            this.Log(unloadReport, oldLevel);
            
            var loadReport = $"<color=green>Loaded</color> level {newLevel.name}. Report:";
            foreach (var loadOperation in newLevel.GetImmediateScenes())
            {
                var duration = Time.realtimeSinceStartupAsDouble;
                yield return UpdateLevelLoadProgress(loadOperation, scenesLoadedQty, totalScenesToLoadQty);
                duration = Time.realtimeSinceStartupAsDouble - duration;
                loadReport += $"\n{loadOperation.Name} ({duration * 1000:F} ms)";
                scenesLoadedQty++;
            }
            this.Log(loadReport, newLevel);

            yield return new WaitForSeconds(delayBeforeHidingLoadScreen);
            var activeSceneBuildIndex = _currentLevel.ActiveScene.BuildIndex;
            if (activeSceneBuildIndex != -1)
            {
                var activeScene = SceneManager.GetSceneByBuildIndex(activeSceneBuildIndex);
                if (activeScene.IsValid())
                    SceneManager.SetActiveScene(activeScene);
                else
                    this.LogError($"Active Scene ({activeScene.name}) is not valid!");
            }
            this.LogError($"Active scene in level ({_currentLevel.ActiveScene}) is not found in build settings!");
            
            loadingScreen.gameObject.SetActive(false);
        
            foreach (var levelBatch in newLevel.LevelBatches)
            {
                foreach (var loadOperation in levelBatch.GetLoadBatch())
                {
                    var sceneName = loadOperation.Name;
                    var asyncOperation = loadOperation.AsyncOperation;
                    asyncOperation.allowSceneActivation = false;
                    //TODO: Try to make this whole block more readable. Maybe add a report, like the ones above?
                    Debug.Log($"{name}: <color=yellow>Loading</color> {sceneName}");

                    var loadStartTime = Time.realtimeSinceStartupAsDouble;
                    yield return new WaitUntil(() => asyncOperation.progress >= 0.9f);

                    Debug.Log($"{name}: <color=green>Loaded</color> {sceneName} in <color=red>{(Time.realtimeSinceStartupAsDouble - loadStartTime) * 1000:F0}</color> ms"+
                              $"\n<color=black>Waiting {delayBeforeActivatingScene} seconds before activation</color>");
                
                    yield return new WaitForSeconds(delayBeforeActivatingScene);
                
                    var activationStartTime = Time.realtimeSinceStartupAsDouble;
                    Debug.Log($"{name}: <color=yellow>Activating</color> {sceneName}");
                    asyncOperation.allowSceneActivation = true;
                
                    Debug.Log($"{name}: <color=green>Activated</color> {sceneName} in <color=red>{(Time.realtimeSinceStartupAsDouble - activationStartTime) * 1000:F0}</color> ms" +
                              $"\n<color=black>Waiting {delayBetweenBatches * 1000} ms.</color>");
                    yield return new WaitForSeconds(delayBeforeLoadingNextScene);
                }

                yield return new WaitForSeconds(delayBetweenBatches);
            }
        }

        private IEnumerator UpdateLevelLoadProgress(SceneAsyncOperation loadOperation, int scenesAlreadyLoadedQty, int totalScenesToLoadQty)
        {
            while (!loadOperation.AsyncOperation.isDone)
            {
                var loadOperationProgress = loadOperation.AsyncOperation.progress + scenesAlreadyLoadedQty;
                UpdateLoadingBarProgress(loadOperationProgress, totalScenesToLoadQty);
                yield return null;
            }
        }

        private void UpdateLoadingBarProgress(float current, float total)
        {
            _progressBar.value = current / total;
        }

        private static void QuitGame()
        {
            Debug.Log("Quitting game...Bye!");
            Application.Quit();
        }
    }
}