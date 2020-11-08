using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UpdateManagement;

public class MovingBlock : MonoBehaviour
{
	public Vector3 finalPosition;
	public float movingTime;
	private Vector3 originalPosition;
	private ActionOverTime movingAction;
	private void Start()
	{
		originalPosition = transform.position;
		movingAction = new ActionOverTime(movingTime, Move, true);
		movingAction.StartAction();
	}

	private void Move(float bezier)
	{
		transform.position = Vector3.Lerp(originalPosition, finalPosition, BezierHelper.GetSinBezier(bezier));
		if(bezier >= 1)
		{
			Vector3 temp = finalPosition;
			finalPosition = originalPosition;
			originalPosition = temp;
			movingAction.StartAction();
		}
	}
}
