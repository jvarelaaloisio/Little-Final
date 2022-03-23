using UnityEngine;
using UnityEngine.SceneManagement;

namespace Logic.Code.Others.HardCode
{
	public class SceneLoader : MonoBehaviour
	{
		[SerializeField]
		private int[] sceneIds;

		private void Awake()
		{
			for (int id = 0; id < sceneIds.Length; id++)
			{
				SceneManager.LoadSceneAsync(sceneIds[id], LoadSceneMode.Additive);
			}
		}
	}
}
