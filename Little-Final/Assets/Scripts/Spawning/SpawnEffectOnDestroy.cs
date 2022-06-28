using UnityEngine;

namespace Spawning
{
	public class SpawnEffectOnDestroy : MonoBehaviour
	{
		[SerializeField]
		private GameObject effect;

		[SerializeField]
		private bool maintainParent;

		private bool _isQuitting;

		private void OnApplicationQuit()
		{
			_isQuitting = true;
		}

		private void OnDestroy()
		{
			if (_isQuitting)
				return;
			Transform myTransform = transform;
			if (maintainParent)
				Instantiate(effect, myTransform.parent);
			else
				Instantiate(effect, myTransform.position, myTransform.rotation);
		}
	}
}