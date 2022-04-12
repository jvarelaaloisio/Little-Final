using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Platforms
{
	public class Traveler : MonoBehaviour
	{
		[SerializeField]
		private TransformData[] waypoints = new TransformData[2];

		[SerializeField]
		private bool controlPosition;

		[SerializeField]
		private bool controlRotation;

		[SerializeField]
		private bool controlScale;

		[SerializeField]
		private float travelTime = 1;

		[SerializeField]
		private AnimationCurve travelCurve = AnimationCurve.Linear(0, 0, 1, 1);

		private int _current;
		private int _next;

		private ActionOverTime travel;

		private void Awake()
		{
			if (waypoints.Length < 2)
			{
				Debug.Log($"{gameObject.name}: not enough waypoints set.");
				return;
			}

			_current = 0;
			_next = 1;
			travel = new ActionOverTime(travelTime,
										UpdatePosition,
										UpdateCurrentAndNext,
										gameObject.scene.buildIndex,
										true);
		}

		[ContextMenu("Travel")]
		public void Travel()
		{
			if (!travel.IsRunning)
				travel.StartAction();
		}

		private void UpdatePosition(float interpolation)
		{
			transform.position = Vector3.Lerp(waypoints[_current].position,
											waypoints[_next].position,
											interpolation);
		}

		private void UpdateCurrentAndNext()
		{
			if (++_next > waypoints.Length - 1)
			{
				_next = 0;
				_current++;
			}
			else if (++_current >= waypoints.Length - 1)
				_current = 0;
		}
	}
}