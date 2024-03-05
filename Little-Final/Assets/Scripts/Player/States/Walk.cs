using CharacterMovement;
using Core.Extensions;
using Core.Interactions;
using Player.PlayerInput;
using Player.Properties;
using Player.Stamina;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.States
{
	public class Walk : State
	{
		private CountDownTimer coyoteEffect;
		private StaminaConsumer _runningConsumer;
		private bool isRunning;

		public override void OnStateEnter(PlayerController controller, int sceneIndex)
		{
			base.OnStateEnter(controller, sceneIndex);
			controller.OnLand.Invoke();
			Body = controller.GetComponent<PlayerBody>();
			isRunning = false;

			_runningConsumer = new StaminaConsumer(controller.Stamina,
													PP_Walk.RunStaminaPerSecond,
													sceneIndex);

			MyTransform = controller.transform;
			coyoteEffect
				= new CountDownTimer(PP_Jump.CoyoteTime,
									OnCoyoteFinished,
									sceneIndex
									);
			Physics.Raycast(MyTransform.position, -MyTransform.up, out RaycastHit hit, 10,
							~LayerMask.GetMask("Interactable"));
			Body.LastFloorNormal = hit.normal;
		}

		public override void OnStateUpdate()
		{
			//------- MOVEMENT ------- 
			Vector2 input = InputManager.GetHorInput();

			bool runInput = InputManager.CheckRunInput();

			Vector3 desiredDirection = MoveHelper.GetDirection(input);

			var floorNormal = Body.LastFloorNormal;
			if (Physics.Raycast(MyTransform.position, -MyTransform.up, out RaycastHit hit, 10,
			                    ~LayerMask.GetMask("Interactable")))
			{
				floorNormal = hit.normal;
			}
			Vector3 directionProjectedOnFloor = Vector3.ProjectOnPlane(desiredDirection, floorNormal);
			Debug.DrawRay(MyTransform.position, directionProjectedOnFloor / 3, Color.green);

			if (MoveHelper.IsSafeAngle(MyTransform.position, directionProjectedOnFloor.normalized, .3f,
										PP_Walk.MinSafeAngle))
			{
				// if (input.magnitude > .1f && runInput && Controller.Stamina.FillState > 0)
				// {
				// 	if (!_runningConsumer.IsConsuming)
				// 		_runningConsumer.Start();
				//
				// 	isRunning = true;
				// }
				// else if (_runningConsumer.IsConsuming)
				// {
				// 	_runningConsumer.Stop();
				// 	isRunning = false;
				// }

				MoveHelper.Rotate(MyTransform,
								desiredDirection,
								desiredDirection.magnitude * PP_Walk.TurnSpeed);
				MoveHelper.Move(MyTransform,
								Body,
								directionProjectedOnFloor,
								PP_Walk.Speed * Controller.BuffMultiplier,
				                PP_Walk.Acceleration);
			}

			if (input.magnitude > 0
			    && Controller.StepUp != null
			    && Controller.StepUp.Should(directionProjectedOnFloor, PP_Walk.StepUpConfig)
			    && Controller.StepUp.Can(out var stepPosition, MyTransform.forward, PP_Walk.StepUpConfig))
			{
				Controller.StepUp.StepUp(PP_Walk.StepUpConfig,
				                         stepPosition,
				                         () => Controller.ChangeState<Walk>());
				Controller.ChangeState<Void>();
			}

			float moveSpeed = Body.Velocity.IgnoreY().magnitude;
			Controller.OnChangeSpeed(moveSpeed);
			
			if (InputManager.CheckJumpInput())
				Jump(desiredDirection, false);
			
			if (Controller.ItemPicked == null)
			{
				CheckClimb();
			}

			if (InputManager.CheckInteractInput())
			{
				if (Controller.HasItem())
					Controller.ChangeState(nameof(Throw));
				else if (Controller.CanInteract(out var interactable))
				{
					switch (interactable)
					{
						case IPickable pickable:
							Controller.Pick(pickable);
							break;
						case IRideable rideable:
							Controller.Rideable = rideable;
							Controller.ChangeState<Mount>();
							break;
						default:
							interactable.Interact(Controller);
							break;
					}
				}
			}

			ValidateGround();
			Controller.RunAbilityList(Controller.AbilitiesOnLand);
		}

		public override void OnStateExit()
		{
			coyoteEffect.StopTimer();
			_runningConsumer.Stop();
		}

		private void OnCoyoteFinished()
		{
			if (FallHelper.IsGrounded)
				return;
			Controller.ChangeState<Jump>();
			Controller.OnJump.Invoke();
		}

		protected virtual void ValidateGround()
		{
			if (!FallHelper.IsGrounded && !coyoteEffect.IsTicking)
				coyoteEffect.StartTimer();
		}
	}
}