using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

public class MovingObject : MonoBehaviour
{
	public Vector3 origin,
					objective;
	public float period;

	private ActionOverTime move;
	private void Start()
	{
		move = new ActionOverTime(period, Move, gameObject.scene.buildIndex, true);
		move.StartAction();
	}

	private void Move(float bezier)
	{
		transform.position = Vector3.Lerp(origin, objective, BezierHelper.GetSinBezier(bezier));
		if (bezier >= 1)
		{
			Vector3 temp = objective;
			objective = origin;
			origin = temp;
			move.StartAction();
		}
	}
	private void OnDisable()
	{
		if (move.IsRunning)
			move.StopAction();
	}
	private void OnDrawGizmos()
	{
		Gizmos.color = new Color(0, 0, 0, .5f);
		Gizmos.DrawLine(transform.position, origin);
		Gizmos.DrawLine(transform.position, objective);
		Gizmos.DrawIcon(origin, "preAudioLoopOff@2x", false, Color.green);
		Gizmos.DrawIcon(objective, "preAudioLoopOff@2x", false, Color.red);
	}
}
