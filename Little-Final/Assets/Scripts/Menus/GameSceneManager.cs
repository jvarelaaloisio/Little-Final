using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Core.Extensions;
using Events.Channels;
using Menus.Events;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using ThreadPriority = UnityEngine.ThreadPriority;

namespace Menus
{
    public class GameSceneManager : MonobehaviourSingleton<GameSceneManager>
    {
        private class Str
        {
            public static string Activating => "Activating ".Colored(C.Yellow);
            public static string Activated => "Activated ".Colored(C.Green);
            public static string Loading => "Loading ".Colored(C.Yellow);
            public static string Loaded => "Loaded ".Colored(C.Green);
            public static string Unloading => "Unloading ".Colored(C.Red);
            public static string Unloaded => "Unloaded ".Colored(C.Green);
            public static string Waiting => "Waiting ".Colored(C.Yellow);
        }
        private class LoadingState
        {
            public List<SceneAsyncOperation> LoadingOperations = new();
            public readonly List<SceneAsyncOperation> UnloadingOperations = new ();

            /// <summary/>Unloads all scenes that were in the middle of loading when this coroutine started
            public IEnumerator Reset(Coroutine before, Action onFinish = null, UnityEngine.Object writer = null)
            {
                if (before != null)
                    yield return before;
                writer?.Log("Resetting Loading state. ".Colored(Color.yellow));
                foreach (var sceneOperation in LoadingOperations)
                {
                    if (HasUnloadOperation(sceneOperation))
                    {
                        yield return WaitForUnloadToFinish(sceneOperation);
                        continue;
                    }
                    
                    if (sceneOperation.AsyncOperation != null)
                        yield return WaitForLoadToFinish(sceneOperation);

                    writer?.Log(Str.Unloading + sceneOperation.Scene.name);
                    var unloadOperation = SceneManager.UnloadSceneAsync(sceneOperation.Scene);
                    if (unloadOperation != null)
                        yield return new WaitUntil(() => ProgressIsOver90Percent(unloadOperation));
                    else
                        writer.Log($"Unload operation for {sceneOperation.Scene.name} failed.");
                    writer?.Log(Str.Unloaded + sceneOperation.Scene.name);
                }

                writer?.Log("Reset successful. ".Colored(Color.green) + "Clearing loading state");
                Clear();
                onFinish?.Invoke();

                yield break;

                bool HasUnloadOperation(SceneAsyncOperation sceneOperation)
                    => UnloadingOperations
                                    .Exists(op => op.Scene == sceneOperation.Scene);

                IEnumerator WaitForUnloadToFinish(SceneAsyncOperation sceneOperation)
                {
                    var unloadOperation = UnloadingOperations.Find(op => op.Scene == sceneOperation.Scene);
                    writer?.Log(Str.Waiting + $"for ({unloadOperation.Scene.name}) to finish unloading");
                    yield return unloadOperation.AsyncOperation;
                }

                IEnumerator WaitForLoadToFinish(SceneAsyncOperation sceneOperation)
                {
                    sceneOperation.AsyncOperation.allowSceneActivation = true;
                    writer?.Log(Str.Waiting + $"for ({sceneOperation.Scene.name}) to finish loading"
                             + $"\nCurrent progress: {sceneOperation.AsyncOperation.progress}");
                    yield return new WaitUntil(()=> ProgressIsOver90Percent(sceneOperation.AsyncOperation));
                }
            }
            public void Clear()
            {
                LoadingOperations.Clear();
                UnloadingOperations.Clear();
            }
        }
        public GameObject loadingScreen;
        public LevelDataContainerViaBuildIndexes titleScreen;

        public LevelDataContainerChannel sceneDataChannel;
        public VoidChannelSo quitGameChannel;

        [SerializeField] private float delayBeforeHidingLoadScreen = .5f;
        [SerializeField] private float delayBetweenBatches = 1f;
        [SerializeField] private float delayBeforeLoadingNextScene = 3f;
        [SerializeField] private float delayBeforeActivatingScene = .5f;

        private ThreadPriority _defaultBackgroundLoadingPriority;
        private Slider _progressBar;
        private float _totalSceneProgress;
        private LevelDataContainerViaBuildIndexes _currentLevel;
        private Coroutine _currentLoadCoroutine;
        private Coroutine _resetLoadingStateCoroutine;
        private LoadingState _loadingState = new();
        private CancellationTokenSource _LoadTokenSource = new();

        private void Awake()
        {
            if (Instance != this)
            {
                Destroy(gameObject);
                return;
            }

            Instance = this;
            _progressBar = loadingScreen.GetComponentInChildren<Slider>();
            _defaultBackgroundLoadingPriority = Application.backgroundLoadingPriority;
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
            this.Log(Str.Loading + $"Level [{newLevel.name}]");
            if (_currentLoadCoroutine != null)
            {
                _LoadTokenSource?.Cancel();
                _LoadTokenSource?.Dispose();
                _LoadTokenSource = new();
            }
            
            loadingScreen.gameObject.SetActive(true);

            var oldLevel = _currentLevel;
            this.LogWarning($"resetting == null {_resetLoadingStateCoroutine == null}");
            _resetLoadingStateCoroutine ??= StartCoroutine(_loadingState.Reset(_currentLoadCoroutine, HandleReset, this));

            _currentLevel = newLevel;

            return;

            void HandleReset()
            {
                _resetLoadingStateCoroutine = null;
                _currentLoadCoroutine = StartCoroutine(ChangeLevelCoroutine(oldLevel,
                                                                            newLevel,
                                                                            _LoadTokenSource.Token));
            }
        }

        private IEnumerator ChangeLevelCoroutine(LevelDataContainer oldLevel,
                                                 LevelDataContainer newLevel,
                                                 CancellationToken token = default)
        {
            var scenesLoadedCount = 0;
            var scenesToLoadCount = newLevel.ImmediateLoadBatch.Length
                                       + (oldLevel ? oldLevel.GetTotalQuantityOfScenes() : 0);
            
            if (oldLevel)
                yield return UnloadOldLevel();

            var loadReport = Str.Loaded + $"level {newLevel.name}. Report:";
            Application.backgroundLoadingPriority = ThreadPriority.High;
            yield return LoadImmediate();

            this.Log(loadReport, newLevel);

            Application.backgroundLoadingPriority = ThreadPriority.Low;
            //THOUGHT: I think I added this delay because the player started in the air and Cinemachine needed to place itself.
            //We would probably benefit from adding a "Setup" system for the level
            yield return new WaitForSeconds(delayBeforeHidingLoadScreen);
            SetupActiveScene(newLevel);

            loadingScreen.gameObject.SetActive(false);

            yield return LoadBatches();

            Application.backgroundLoadingPriority = _defaultBackgroundLoadingPriority;
            
            yield break;

            IEnumerator UnloadOldLevel()
            {
                foreach (var sceneName in oldLevel.RuntimeLoadedScenes)
                {
                    if (token.IsCancellationRequested)
                    {
                        this.Log($"Unload cancelled".Colored(C.Red));
                        yield break;
                    }
                    var scene = SceneManager.GetSceneByName(sceneName);
                    if (!scene.IsValid())
                        continue;
                    
                    var unloadOperation = SceneManager.UnloadSceneAsync(sceneName);

                    var sceneOperation = new SceneAsyncOperation(scene, unloadOperation);
                    _loadingState.UnloadingOperations.Add(sceneOperation);
                    yield return unloadOperation;
                    _loadingState.UnloadingOperations.Remove(sceneOperation);
                }
                //TODO: Use StringBuilder
                var unloadReport = $"<color=yellow>Unloaded</color> level {oldLevel.name}. Report:";
                foreach (var unloadOperation in oldLevel.GetUnloadScenes())
                {
                    var duration = Time.realtimeSinceStartupAsDouble;
                    
                    _loadingState.UnloadingOperations.Add(unloadOperation);
                    if (token.IsCancellationRequested)
                    {
                        this.Log($"Unload cancelled".Colored(C.Red));
                        yield break;
                    }
                    yield return UpdateLevelLoadProgress(unloadOperation, scenesLoadedCount, scenesToLoadCount);
                    _loadingState.UnloadingOperations.Remove(unloadOperation);
                    
                    duration = Time.realtimeSinceStartupAsDouble - duration;
                    unloadReport += $"\n{unloadOperation.Path} ({duration * 1000:F} ms)";
                    scenesLoadedCount++;
                }
                this.Log(unloadReport, oldLevel);
            }

            IEnumerator LoadImmediate()
            {
                foreach (var loadOperation in newLevel.GetImmediateScenes())
                {
                    newLevel.RuntimeLoadedScenes.Add(loadOperation.Path);
                    var duration = Time.realtimeSinceStartupAsDouble;
                
                    _loadingState.LoadingOperations.Add(loadOperation);
                    if (token.IsCancellationRequested)
                    {
                        this.Log($"Immediate Load cancelled".Colored(C.Red));
                        yield break;
                    }
                    yield return UpdateLevelLoadProgress(loadOperation, scenesLoadedCount, scenesToLoadCount);
                    _loadingState.LoadingOperations.Remove(loadOperation);
                
                    duration = Time.realtimeSinceStartupAsDouble - duration;
                    loadReport += $"\n{loadOperation.Path} ({duration * 1000:F} ms)";
                    scenesLoadedCount++;
                }
            }

            IEnumerator LoadBatches()
            {
                foreach (var levelBatch in newLevel.LevelBatches)
                {
                    foreach (var loadOperation in levelBatch.GetLoadBatch())
                    {
                        var asyncOperation = loadOperation.AsyncOperation;
                        asyncOperation.allowSceneActivation = false;
                        //TODO: Try to make this whole block more readable. Maybe add a report, like the ones above?
                        var sceneName = loadOperation.Scene.name;
                        this.Log(Str.Loading + sceneName);

                        var loadStartTime = Time.realtimeSinceStartupAsDouble;
                    
                        _loadingState.LoadingOperations.Add(loadOperation);
                        if (token.IsCancellationRequested)
                        {
                            this.Log($"Batch Load cancelled".Colored(C.Red));
                            yield break;
                        }
                        yield return new WaitUntil(() => ProgressIsOver90Percent(asyncOperation));
                        _loadingState.LoadingOperations.Remove(loadOperation);

                        //TODO: Use Stopwatch in the same way as in the InterfaceRef inspector.
                        var loadMilliseconds = (int)(Time.realtimeSinceStartupAsDouble - loadStartTime) * 1000;
                        this.Log(Str.Loaded + $"{sceneName} in {loadMilliseconds.Colored(C.Red)}ms" +
                                 $"\nWaiting {delayBeforeActivatingScene} seconds before activation.".Colored(C.Black));

                        if (token.IsCancellationRequested)
                        {
                            this.Log($"Batch Load cancelled".Colored(C.Red));
                            yield break;
                        }

                        //THOUGHT: Is this really necessary?
                        yield return new WaitForSeconds(delayBeforeActivatingScene);

                        var activationStartTime = Time.realtimeSinceStartupAsDouble;
                        this.Log(Str.Activating + sceneName);
                        asyncOperation.allowSceneActivation = true;

                        var activationMilliseconds = (int)(Time.realtimeSinceStartupAsDouble - activationStartTime) * 1000;
                        this.Log(Str.Activated + $"{sceneName} in {activationMilliseconds.Colored(C.Red)}ms" +
                                 $"\nWaiting {delayBetweenBatches * 1000}ms.".Colored(C.Black));
                        
                        //THOUGHT: Is this really necessary? Maybe just yield return null?
                        yield return new WaitForSeconds(delayBeforeLoadingNextScene);
                    }

                    //THOUGHT: Again, is this really necessary? I think we should test changing all of these random delays to wait just a frame.
                    //We should also research how to slow down loading so it doesn't freeze the game at all.
                    yield return new WaitForSeconds(delayBetweenBatches);
                }
            }
        }

        private static bool ProgressIsOver90Percent(AsyncOperation asyncOperation)
            => asyncOperation.progress >= 0.89f;

        private void SetupActiveScene(LevelDataContainer level)
        {
            var activeSceneBuildIndex = level.ActiveScene.BuildIndex;
            if (activeSceneBuildIndex == -1)
            {
                this.LogError($"Active scene in level ({level.ActiveScene}[{activeSceneBuildIndex}]) is not found in build settings!");
                return;
            }

            var activeScene = SceneManager.GetSceneByBuildIndex(activeSceneBuildIndex);
            if (!activeScene.IsValid())
            {
                this.LogError($"Active Scene ({activeScene.name}) is not valid!");
                return;
            }

            SceneManager.SetActiveScene(activeScene);
            this.Log($"Setting {activeScene.name} as active scene.");
        }

        private IEnumerator UpdateLevelLoadProgress(SceneAsyncOperation loadOperation, int scenesAlreadyLoadedQty,
                                                    int totalScenesToLoadQty)
        {
            while (!loadOperation.AsyncOperation.isDone)
            {
                var loadOperationProgress = loadOperation.AsyncOperation.progress + scenesAlreadyLoadedQty;
                UpdateLoadingBarProgress(loadOperationProgress, totalScenesToLoadQty);
                yield return null;
            }
        }

        private void UpdateLoadingBarProgress(float current, float total)
            => _progressBar.value = current / total;

        private static void QuitGame()
        {
#if UNITY_EDITOR
            if (Application.isPlaying)
            {
                UnityEditor.EditorApplication.isPlaying = false;
                return;
            }
#endif
            Application.Quit();
        }
    }
}