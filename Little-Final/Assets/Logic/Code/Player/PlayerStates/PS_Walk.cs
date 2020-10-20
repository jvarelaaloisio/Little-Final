using UnityEngine;

public class PS_Walk : PlayerState_Ab
{
	Animator animator;
	Transform transform;
	IBody body;
	Timer coyoteTimer;
	public override void OnStateEnter(Player_Brain brain)
	{
		base.OnStateEnter(brain);

		animator = brain.GetComponent<Animator>();

		body = brain.GetComponent<Player_Body>();
		body.BodyEvents += BodyEventsHandler;

		transform = brain.transform;
		coyoteTimer = TimerHelper.SetupTimer(PlayerProperties.Instance.CoyoteTime, "", brain.gameObject, FinishCoyoteTime);
	}

	private void BodyEventsHandler(BodyEvent eventType)
	{
		if (eventType == BodyEvent.JUMP)
			coyoteTimer.Play();
	}

	private void FinishCoyoteTime(string id)
	{
		if (body.IsInTheAir)
			brain.ChangeState<PS_Jump>();
	}

	public override void OnStateUpdate()
	{
		//		Read Input
		Vector2 input = InputManager.ReadHorInput();
		float speed = Mathf.Abs(input.x) + Mathf.Abs(input.y);

		//		Animator
		animator.SetFloat("Speed", speed);

		Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);
		Debug.DrawRay(transform.position, desiredDirection, Color.green);

		HorizontalMovementHelper.moveWithRotation(transform,
											body,
											desiredDirection,
											PlayerProperties.Instance.Speed,
											PlayerProperties.Instance.TurnSpeed);

		//		Picking
		if (InputManager.ReadPickInput())
		{
			brain.PickItem();
		}

		if (InputManager.ReadLongJumpInput())
		{
			body.InputJump = true;
			brain.ChangeState<PS_LongJump>();
		}
		else if (InputManager.ReadJumpInput())
		{
			body.InputJump = true;
			brain.ChangeState<PS_Jump>();
		}
	}

	public override void OnStateExit()
	{
		base.OnStateExit();
		coyoteTimer.Stop();
		GameObject.Destroy(coyoteTimer);
		brain.Body.BodyEvents -= BodyEventsHandler;
	}
}