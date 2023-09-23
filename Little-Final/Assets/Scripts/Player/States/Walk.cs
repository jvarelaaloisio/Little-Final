using CharacterMovement;
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
		private IBody body;
		private CountDownTimer coyoteEffect;
		private StaminaConsumer _runningConsumer;
		private bool isRunning;

		public override void OnStateEnter(PlayerController controller, int sceneIndex)
		{
			base.OnStateEnter(controller, sceneIndex);
			controller.OnLand.Invoke();
			body = controller.GetComponent<PlayerBody>();
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
			body.LastFloorNormal = hit.normal;
			if (controller.LongJumpBuffer)
			{
				controller.ResetJumpBuffers();
				isRunning = true;
				Jump();
			}
			else if (controller.JumpBuffer)
			{
				controller.ResetJumpBuffers();
				Jump();
			}
		}

		public override void OnStateUpdate()
		{
			//------- MOVEMENT ------- 
			Vector2 input = InputManager.GetHorInput();

			bool runInput = InputManager.CheckRunInput();
			//Speed is halved when walking 
			float moveSpeed = Mathf.Abs(input.normalized.magnitude * (runInput ? 1 : 0.5f));
			Controller.OnChangeSpeed(moveSpeed);

			Vector3 desiredDirection = MoveHelper.GetDirection(input);
			Debug.DrawRay(MyTransform.position, desiredDirection.normalized / 3, Color.green);

			if (MoveHelper.IsSafeAngle(MyTransform.position, desiredDirection.normalized, .3f,
										PP_Walk.MinSafeAngle))
			{
				if (input.magnitude > .1f && runInput && Controller.Stamina.FillState > 0)
				{
					if (!_runningConsumer.IsConsuming)
						_runningConsumer.Start();

					isRunning = true;
				}
				else if (_runningConsumer.IsConsuming)
				{
					_runningConsumer.Stop();
					isRunning = false;
				}

				MoveHelper.Rotate(MyTransform,
								desiredDirection,
								desiredDirection.magnitude * PP_Walk.TurnSpeed);
				MoveHelper.Move(MyTransform,
								body,
								desiredDirection,
								isRunning ? PP_Walk.RunSpeed : PP_Walk.Speed);
			}

			if (InputManager.CheckJumpInput())
				Jump();
			if (Controller.ItemPicked == null)
			{
				CheckClimb();
			}

			if (InputManager.CheckInteractInput())
			{
				if (Controller.HasItem())
				{
					if (isRunning)
						Controller.ThrowItem(PP_Walk.ThrowForce);
					else
						Controller.PutDownItem();
				}
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

		private void Jump()
		{
			body.Jump(Vector3.up * (isRunning ? PP_Jump.LongJumpForce : PP_Jump.JumpForce));
			if (isRunning)
			{
				Controller.Stamina.ConsumeStamina(PP_Jump.LongJumpStaminaCost);
				Controller.OnLongJump.Invoke();
				Controller.ChangeState<LongJump>();
			}
			else
			{
				Controller.OnJump.Invoke();
				Controller.ChangeState<Jump>();
			}
		}

		public override void OnStateExit()
		{
			coyoteEffect.StopTimer();
			_runningConsumer.Stop();
			if (Controller.HasItem())
				Controller.PutDownItem();
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