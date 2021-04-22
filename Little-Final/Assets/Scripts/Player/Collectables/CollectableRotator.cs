using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.Collectables
{
	[RequireComponent(typeof(MeshRenderer))]
	public class CollectableRotator : MonoBehaviour, IUpdateable
	{
		public ParticleSystem rewardParticles;
		public float destructionDelay;
		public Transform pivot;

		public Vector3 amplitude,
			frequency;

		private float _time;
		private bool _isRewarded;
		private int _sceneIndex;

		private void Start()
		{
			UpdateManager.Subscribe(this);
			_time = 0;
			_sceneIndex = gameObject.scene.buildIndex;
		}

		public void OnUpdate()
		{
			if (_isRewarded)
			{
				transform.position = pivot.position;
				return;
			}

			transform.position = GetPosition(_time);
			_time += Time.deltaTime;
			if (_time >= Mathf.PI * 2)
				_time = 0;
		}

		public Vector3 GetPosition(float t)
		{
			return pivot.position + (Vector3.right * Mathf.Cos(t * frequency.x) * amplitude.x)
			                      + (Vector3.up * Mathf.Sin(t * frequency.y) * amplitude.y)
			                      + (Vector3.forward * Mathf.Sin(t * frequency.z) * amplitude.z);
		}

		public void OnRewardGiven()
		{
			rewardParticles.Play();
			GetComponent<MeshRenderer>().enabled = false;
			transform.SetParent(null);
			new CountDownTimer(
				destructionDelay,
				() => Destroy(gameObject),
				_sceneIndex).StartTimer();
			_isRewarded = true;
		}

		private void OnDestroy()
		{
			UpdateManager.UnSubscribe(this);
		}
	}
}