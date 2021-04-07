using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Platforms
{
	public class WaypointMovement : MonoBehaviour, IUpdateable
	{
		[SerializeField] private TransformData[] waypoints;
		[SerializeField] private bool controlPosition;
		[SerializeField] private bool controlRotation;
		[SerializeField] private bool controlScale;
		private int _current;
		private int _next;
		[SerializeField] private int period;
		private float _currentTime;
		private Transform _myTransform;

		private void Start()
		{
			if (waypoints.Length < 2)
			{
				Debug.Log($"{gameObject.name}: not enough waypoints set");
				return;
			}

			_current = 0;
			_next = 1;
			_myTransform = transform;
			UpdateManager.Subscribe(this);
		}

		public void OnUpdate()
		{
			float lerp = _currentTime / period;
			if (controlPosition)
			{
				_myTransform.localPosition
					= Vector3.Lerp(
						waypoints[_current].position,
						waypoints[_next].position,
						lerp);
			}

			if (controlRotation)
			{
				_myTransform.rotation
					= Quaternion.Lerp(
						waypoints[_current].Rotation,
						waypoints[_next].Rotation,
						lerp);
			}

			if (controlScale)
			{
				_myTransform.localScale
					= Vector3.Lerp(
						waypoints[_current].scale,
						waypoints[_next].scale,
						lerp);
			}

			_currentTime += Time.deltaTime;
			if (!(_currentTime > period))
				return;
			_current = _next;
			_next =
				_current + 1 < waypoints.Length
					? _current + 1
					: 0;
			_currentTime = 0;
		}
	}
}