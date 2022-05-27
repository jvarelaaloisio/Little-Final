using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Interactions
{
	public class MovingBlock : MonoBehaviour
	{
		public Vector3 finalPosition;
		public float movingTime;
		private Vector3 originalPosition;
		private ActionOverTime movingAction;

		private void Start()
		{
			originalPosition = transform.position;
			movingAction = new ActionOverTime(movingTime, Move, gameObject.scene.buildIndex, true);
			movingAction.StartAction();
		}

		private void Move(float bezier)
		{
			transform.position = Vector3.Lerp(originalPosition, finalPosition, BezierHelper.GetSinBezier(bezier));
			if (bezier >= 1)
			{
				(finalPosition, originalPosition) = (originalPosition, finalPosition);
				movingAction.StartAction();
			}
		}
	}
}