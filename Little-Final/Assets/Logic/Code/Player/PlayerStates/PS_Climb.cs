using CharacterMovement;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

public class PS_Climb : PlayerState
{
	private IBody _body;
	private bool _isInPosition;

	private Vector3 _originPosition,
		_targetPosition;

	private Quaternion _originRotation,
		_targetRotation;

	private ActionOverTime _getInPosition;
	private CountDownTimer _afterCliff;
	private Transform _myTransform;
	private Transform _currentWall;

	protected CountDownTimer consumeStaminaPeriod,
		staminaConsumingDelay;

	private bool _isClimbFinished;

	public override void OnStateEnter(PlayerModel model, int sceneIndex)
	{
		base.OnStateEnter(model, sceneIndex);
		_myTransform = model.transform;
		_body = model.Body;

		if (model.stamina.FillState < 1)
		{
			model.ChangeState<PS_Jump>();
			return;
		}

		model.stamina.StopFilling();

		model.view.ShowClimbFeedback();
		model.GetComponent<Rigidbody>().isKinematic = true;

		ClimbHelper.CanClimb(
			_myTransform.position,
			_myTransform.forward,
			PP_Climb.Instance.MaxDistanceToTriggerClimb,
			PP_Climb.Instance.MaxClimbAngle,
			out RaycastHit hit);

		_getInPosition =
			new ActionOverTime(
				PP_Climb.Instance.ClimbPositioningTime,
				GetInPosition,
				sceneIndex,
				true);
		_getInPosition.StartAction();
		ResetPosition(hit);

		_afterCliff =
			new CountDownTimer(
				PP_Climb.Instance.ClimbPositioningTime,
				model.ChangeState<PS_Jump>,
				sceneIndex);

		consumeStaminaPeriod =
			new CountDownTimer(
				1 / PP_Climb.Instance.StaminaPerSecond,
				ConsumeStamina,
				sceneIndex);
		staminaConsumingDelay =
			new CountDownTimer(
				PP_Climb.Instance.StaminaConsumingDelay,
				consumeStaminaPeriod.StartTimer,
				sceneIndex);
		staminaConsumingDelay.StartTimer();
	}

	public override void OnStateUpdate()
	{
		if (!_isInPosition)
			return;
		var myPosition = _myTransform.position;
		Vector2 input = InputManager.GetHorInput();
		Vector3 moveDirection = _myTransform.right * input.x + _myTransform.up * input.y;

		if (IsTouchingGround() && moveDirection.y < 0)
			moveDirection.y = 0;

		//Move
		if (moveDirection.magnitude != 0 && ClimbHelper.CanMove(myPosition,
			_myTransform.forward,
			moveDirection.normalized,
			PP_Climb.Instance.MaxClimbDistanceFromCorners,
			PP_Climb.Instance.MaxDistanceToTriggerClimb,
			PP_Climb.Instance.MaxClimbAngle,
			out RaycastHit hit))
		{
			if (!hit.transform.Equals(_currentWall))
			{
				ResetPosition(hit);
			}
			else
			{
				if (!consumeStaminaPeriod.IsTicking)
					consumeStaminaPeriod.StartTimer();
				_body.Move(moveDirection, PP_Climb.Instance.ClimbSpeed);
				//Rotation
				Physics.Raycast(myPosition, _myTransform.forward, out RaycastHit forwardHit,
					PP_Climb.Instance.MaxDistanceToTriggerClimb, ~LayerMask.GetMask("NonClimbable", "Interactable"));
				_myTransform.rotation = Quaternion.LookRotation(-forwardHit.normal).normalized;
				Debug.DrawLine(myPosition, hit.point, Color.yellow);
			}
		}
		//Cliff
		else if (Mathf.Approximately(Vector3.Dot(moveDirection, _myTransform.up), 1)
		         &&
		         ClimbHelper.CanClimbUp(myPosition, _myTransform.up, _myTransform.forward,
			         PP_Climb.Instance.MaxClimbDistanceFromCorners, PP_Climb.Instance.MaxDistanceToTriggerClimb,
			         out RaycastHit cliffHit))
		{
			Debug.DrawRay(cliffHit.point, cliffHit.normal / 4, Color.blue, 2);
			GetOverCliff(cliffHit);
		}
		//Stop
		else
		{
			consumeStaminaPeriod.StopTimer();
		}

		if (!InputManager.CheckClimbInput() || Model.stamina.FillState < 1)
		{
			Model.ChangeState<PS_Jump>();
			Model.view.ShowJumpFeedback();
		}

		Model.RunAbilityList(Model.AbilitiesOnWall);
	}

	public override void OnStateExit()
	{
		base.OnStateExit();
		_isClimbFinished = true;
		_getInPosition.StopAction();
		consumeStaminaPeriod.StopTimer();
		staminaConsumingDelay.StopTimer();
		Model.stamina.ResumeFilling();
		Model.GetComponent<Rigidbody>().isKinematic = false;
		Quaternion newRotation = Quaternion.identity;
		newRotation.y = _myTransform.rotation.y;
		_myTransform.rotation = newRotation;
	}

	protected void ConsumeStamina()
	{
		Model.stamina.ConsumeStamina(1);
		if (_isClimbFinished)
			return;
		consumeStaminaPeriod.StartTimer();
	}

	private void ResetPosition(RaycastHit hit)
	{
		_originPosition = _myTransform.position;
		_originRotation = _myTransform.rotation;

		_targetRotation = Quaternion.LookRotation(-hit.normal);
		_targetPosition = hit.point - _myTransform.forward * PP_Climb.Instance.ClimbingPositionOffset;

		_currentWall = hit.transform;

		_isInPosition = false;
		_getInPosition.StartAction();
	}

	private void GetOverCliff(RaycastHit hit)
	{
		_originPosition = _myTransform.position;
		_originRotation = _myTransform.rotation;
		_targetPosition = hit.point + (_myTransform.up * _myTransform.localScale.y / 5);
		_targetRotation = _myTransform.rotation;

		_isInPosition = false;
		_getInPosition.StartAction();
		_afterCliff.StartTimer();
	}

	private void GetInPosition(float bezier)
	{
		_myTransform.position = Vector3.Lerp(_originPosition, _targetPosition, bezier);
		_myTransform.rotation = Quaternion.Slerp(_originRotation, _targetRotation, bezier);
		if (bezier == 1)
		{
			_isInPosition = true;
		}
	}

	private bool IsTouchingGround()
	{
		if (Physics.Raycast(_myTransform.position,
			Vector3.down,
			PP_Climb.Instance.MaxClimbDistanceFromCorners,
			LayerMask.GetMask("default", "Floor")))
		{
			Debug.DrawRay(_myTransform.position, Vector3.down * PP_Climb.Instance.MaxClimbDistanceFromCorners,
				Color.green);
			return true;
		}

		return false;
	}
}