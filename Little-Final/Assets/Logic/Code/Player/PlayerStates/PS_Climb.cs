using CharacterMovement;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

public class PS_Climb : StaminaConsumingState
{
	private IBody _body;

	private Vector3 _originPosition,
		_targetPosition;

	private Quaternion _originRotation,
		_targetRotation;

	private ActionOverTime _getInPosition;
	private CountDownTimer _afterCliff;
	private Transform _myTransform;
	private Transform _currentWall;
	private readonly int _groundMask;

	public PS_Climb()
	{
		_groundMask = LayerMask.GetMask("default", "Floor");
		StaminaPerSecond = PP_Climb.StaminaPerSecond;
		StaminaConsumptionDelay = PP_Climb.StaminaConsumingDelay;
	}

	public override void OnStateEnter(PlayerController controller, int sceneIndex)
	{
		base.OnStateEnter(controller, sceneIndex);
		_myTransform = controller.transform;
		_body = controller.Body;

		if (controller.stamina.FillState < 1)
		{
			controller.ChangeState<PS_Jump>();
			return;
		}

		controller.stamina.StopRefilling();

		controller.OnClimb();
		controller.GetComponent<Rigidbody>().isKinematic = true;

		ClimbHelper.CanClimb(
			_myTransform.position,
			_myTransform.forward,
			PP_Climb.MaxDistanceToTriggerClimb,
			PP_Climb.MaxClimbAngle,
			out var hit);

		_getInPosition =
			new ActionOverTime(
				PP_Climb.ClimbPositioningTime,
				GetInPosition,
				sceneIndex,
				true);
		ResetPosition(hit);
		_afterCliff =
			new CountDownTimer(
				PP_Climb.ClimbPositioningTime,
				controller.ChangeState<PS_Jump>,
				sceneIndex);
		WaitToConsumeStamina.StartTimer();
	}

	public override void OnStateUpdate()
	{
		if (_getInPosition.IsRunning)
			return;
		var myPosition = _myTransform.position;
		var input = InputManager.GetHorInput();
		var moveDirection = _myTransform.right * input.x + _myTransform.up * input.y;

		if (IsTouchingGround() && moveDirection.y < 0)
			moveDirection.y = 0;

		//Move
		if (moveDirection.magnitude != 0 && ClimbHelper.CanMove(myPosition,
			_myTransform.forward,
			moveDirection.normalized,
			PP_Climb.MaxClimbDistanceFromCorners,
			PP_Climb.MaxDistanceToTriggerClimb,
			PP_Climb.MaxClimbAngle,
			out var hit))
		{
			if (!hit.transform.Equals(_currentWall))
			{
				ResetPosition(hit);
			}
			else
			{
				if (!ConsumingStamina.IsRunning)
					ConsumingStamina.StartAction();
				_body.Move(moveDirection, PP_Climb.ClimbSpeed);
				//Rotation
				Physics.Raycast(myPosition, _myTransform.forward, out var forwardHit,
					PP_Climb.MaxDistanceToTriggerClimb, ~LayerMask.GetMask("NonClimbable", "Interactable"));
				_myTransform.rotation = Quaternion.LookRotation(-forwardHit.normal).normalized;
				Debug.DrawLine(myPosition, hit.point, Color.yellow);
			}
		}
		//Cliff
		else if (Mathf.Approximately(Vector3.Dot(moveDirection, _myTransform.up), 1)
		         &&
		         ClimbHelper.CanClimbUp(
			         myPosition,
			         _myTransform.up,
			         _myTransform.forward,
			         PP_Climb.MaxClimbDistanceFromCorners,
			         PP_Climb.MaxDistanceToTriggerClimb,
			         out var cliffHit))
		{
			Debug.DrawRay(cliffHit.point, cliffHit.normal / 4, Color.blue, 2);
			GetOverCliff(cliffHit);
		}
		//Stop
		else
		{
			ConsumingStamina.StopAction();
		}

		if (!InputManager.CheckClimbInput() || Controller.stamina.FillState < 1)
		{
			Controller.ChangeState<PS_Jump>();
			Controller.OnJump();
		}

		Controller.RunAbilityList(Controller.AbilitiesOnWall);
	}

	public override void OnStateExit()
	{
		base.OnStateExit();
		_getInPosition.StopAction();
		ConsumingStamina.StopAction();
		WaitToConsumeStamina.StopTimer();
		Controller.stamina.ResumeRefilling();
		Controller.GetComponent<Rigidbody>().isKinematic = false;
		var newRotation = Quaternion.identity;
		newRotation.y = _myTransform.rotation.y;
		_myTransform.rotation = newRotation;
	}

	private void ResetPosition(RaycastHit hit)
	{
		_originPosition = _myTransform.position;
		_originRotation = _myTransform.rotation;

		_targetRotation = Quaternion.LookRotation(-hit.normal);
		_targetPosition = hit.point - _myTransform.forward * PP_Climb.ClimbingPositionOffset;

		_currentWall = hit.transform;

		_getInPosition.StartAction();
	}

	private void GetOverCliff(RaycastHit hit)
	{
		_originPosition = _myTransform.position;
		var myRotation = _myTransform.rotation;
		_originRotation = myRotation;
		_targetPosition = hit.point + (_myTransform.up * _myTransform.localScale.y / 5);
		_targetRotation = myRotation;

		_getInPosition.StartAction();
		_afterCliff.StartTimer();
	}

	private void GetInPosition(float bezier)
	{
		_myTransform.position = Vector3.Lerp(_originPosition, _targetPosition, bezier);
		_myTransform.rotation = Quaternion.Slerp(_originRotation, _targetRotation, bezier);
	}

	private bool IsTouchingGround()
	{
		if (!Physics.Raycast(_myTransform.position,
				Vector3.down,
				PP_Climb.MaxClimbDistanceFromCorners,
				_groundMask
			)
		)
			return false;
		Debug.DrawRay(
			_myTransform.position,
			Vector3.down * PP_Climb.MaxClimbDistanceFromCorners,
			Color.green);
		return true;
	}
}