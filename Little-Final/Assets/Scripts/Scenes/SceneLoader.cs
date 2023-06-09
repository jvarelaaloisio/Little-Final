using System.Collections;
using System.Linq;
using Core.Debugging;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;

namespace Scenes
{
    [AddComponentMenu("Scene Loader")]
    public class SceneLoader : MonoBehaviour
    {
        [Tooltip("The Scene loader will set active one parent each frame")]
        [SerializeField] private GameObject[] sceneParents;

        [SerializeField] private GameObject grassParent;
        [SerializeField] private int grassBatchSize = 50;
        
        [SerializeField] private Debugger debugger;
        [SerializeField] private string debugTag = "SceneLoader";

        private void Start()
        {
            StartCoroutine(LoadScene());
        }

        private IEnumerator LoadScene()
        {
            var start = Time.realtimeSinceStartupAsDouble;
            debugger.LogSafely(debugTag, $"Starting GO loading for {gameObject.scene.name.Colored("blue")}", this);
            foreach (var parent in sceneParents.Where(go => !go.activeSelf))
            {
                parent.SetActive(true);
                yield return null;
            }

            if (grassParent)
            {
                var batchCounter = 0;
                foreach (Transform child in grassParent.transform)
                {
                    child.gameObject.SetActive(true);
                    if (++batchCounter % grassBatchSize == 0)
                        yield return null;
                }
                debugger.LogSafely(debugTag, $"{batchCounter} grass GOs were activated in the {gameObject.scene.name} scene" +
                                             $"\nin a span of {(batchCounter / grassBatchSize).Colored("red")} frames", this);
            }
            
            debugger.LogSafely(debugTag, $"{gameObject.scene.name} activated in {(Time.realtimeSinceStartupAsDouble - start).Colored("green")} seconds", this);
            gameObject.SetActive(false);
        }
        
#if UNITY_EDITOR
        [MenuItem("GameObject/Scene Control/Scene Loader", false, 10)]
        private static void CreateCustomItem()
        {
            GameObject newObject = new GameObject("Scene Loader"); // Example: Create a sphere

            newObject.AddComponent<SceneLoader>();

            Selection.activeGameObject = newObject;
            SceneView.lastActiveSceneView.FrameSelected();
        }
#endif
    }
}
