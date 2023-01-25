using System;
using UnityEngine;

#if UNITY_EDITOR
using UnityEngine.SceneManagement;
#endif

namespace Scenes
{
	[Serializable]
	public struct Chunk
	{
		[SerializeField]
		public int[] sceneIndexes;
		
		public int activeScene;
	}

	[CreateAssetMenu(fileName = "Level", menuName = "Levels/Level", order = 0)]
	public class Level : ScriptableObject
	{
		[SerializeField]
		private Chunk[] chunks;

#if UNITY_EDITOR
		private void OnValidate()
		{
			foreach (Chunk chunk in chunks)
			{
				foreach (var sceneIndex in chunk.sceneIndexes)
				{
					if (!SceneManager.GetSceneByBuildIndex(sceneIndex).IsValid())
						Debug.LogError($"index {sceneIndex} is not in build");
				}
			}
		}
#endif
	}
}