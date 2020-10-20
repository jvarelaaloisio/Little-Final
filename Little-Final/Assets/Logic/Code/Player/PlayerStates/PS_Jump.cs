using UnityEngine;

public class PS_Jump : PlayerState_Ab
{
	protected Transform transform;
	protected Player_Body body;
	protected Animator animator;
	protected Collider landCollider;
	public override void OnStateEnter(Player_Brain brain)
	{
		base.OnStateEnter(brain);
		transform = brain.transform;
		
		//	Body
		body = brain.GetComponent<Player_Body>();

		landCollider = body.GetLandCollider();
		
		animator = brain.GetComponent<Animator>();
	}

	private void BodyEventsHandler(BodyEvent typeOfEvent)
	{
	}
	public override void OnStateUpdate()
	{
		//		Read Input
		Vector2 input = InputManager.ReadHorInput();

		Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);
		Debug.DrawRay(transform.position, desiredDirection, Color.green);

		HorizontalMovementHelper.moveWithRotation(transform,
											body,
											desiredDirection,
											PlayerProperties.Instance.JumpSpeed,
											PlayerProperties.Instance.TurnSpeedInTheAir);

		ReadInput();
	}

	protected virtual void ReadInput()
	{
		body.TurnGlide(InputManager.ReadGlideInput());
	}

	public override void OnStateExit()
	{
		body.BodyEvents -= BodyEventsHandler;
		body.TurnGlide(false);
	}
}
