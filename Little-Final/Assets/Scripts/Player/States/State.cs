using System;
using CharacterMovement;
using Core.Extensions;
using Core.Helpers.Movement;
using Player.PlayerInput;
using Player.Properties;
using UnityEngine;

namespace Player.States
{
	public abstract class State
	{
		//Estas flags son para que los metodos que están de más los corra en controller
		public (bool allowsLanding,
			bool allowsJump,
			bool allowsJumpBuffer,
			bool allowsClimb) Flags;

		protected PlayerController Controller;
		protected Transform MyTransform;
		protected LayerMask Interactable;
		protected LayerMask Floor = LayerMask.GetMask("Default", "Floor", "Collider");
		protected IBody Body;

		/// <summary>
		/// Runs once when the state starts
		/// (In base, it setups the controller refference)
		/// </summary>
		/// <param name="controller"></param>
		/// <param name="sceneIndex">the index where the player lives</param>
		public virtual void OnStateEnter(PlayerController controller, int sceneIndex)
		{
			Interactable = LayerMask.GetMask("Interactable");
			Controller = controller;
			MyTransform = controller.transform;
			Body = controller.Body;
		}

		/// <summary>
		/// Runs every update
		/// </summary>
		public abstract void OnStateUpdate();

		/// <summary>
		/// runs once when the state finishes
		/// </summary>
		public abstract void OnStateExit();

		//----------	TODO:ESTOS METODOS SE VAN AL CONTROLLER ----------
		/// <summary>
		/// Reads the input and moves the player horizontally
		/// </summary>
		[Obsolete]
		protected void MoveHorizontally(IBody body, float speed, float turnSpeed)
		{
			Vector2 input = InputManager.GetHorInput();

			Vector3 desiredDirection = MoveHelper.GetDirection(input);

			if (MoveHelper.IsSafeAngle(
													MyTransform.position,
													desiredDirection.normalized,
													.5f,
													PP_Walk.MinSafeAngle))
			{
				MoveHelper.Rotate(MyTransform, desiredDirection, turnSpeed);
				MoveHelper.Move(MyTransform,
				                body,
				                desiredDirection,
				                speed,
				                speed);
			}
		}

		/// <summary>
		/// Checks if the climb input and the conditions are met.
		/// If then, it changes to the Climb State.
		/// </summary>
		protected void CheckClimb()
		{
			var climbCheckPosition = Controller.ClimbCheckPivot.position;
			if (InputManager.CheckClimbInput()
			    && Controller.Stamina.FillState > 0
			    && ClimbHelper.CanClimb(
				    climbCheckPosition,
				    GetForwardDirectionBasedOnGroundAngle(),
				    PP_Climb.MaxDistanceToTriggerClimb,
				    PP_Climb.MaxClimbAngle,
				    out var climbHit))
			{
				Controller.LastClimbHit = climbHit;
				Controller.ChangeState<Climb>();
			}

			Vector3 GetForwardDirectionBasedOnGroundAngle()
			{
				if (!Physics.Raycast(climbCheckPosition, -MyTransform.up, out var hit,
					    PP_Climb.MaxClimbDistanceFromCorners,
					    LayerMask.GetMask("Floor", "Default")))
					return MyTransform.forward;
				var newForward = Vector3.Cross(MyTransform.right, hit.normal);
				return newForward;
			}
		}

		protected void CheckForJumpBuffer()
		{
			if (InputManager.CheckLongJumpInput() &&
				Physics.Raycast(
								MyTransform.position,
								-MyTransform.up,
								PP_Jump.JumpBufferDistance,
								Floor))
			{
				Controller.LongJumpBuffer = true;
			}
			else if (InputManager.CheckJumpInput() &&
					Physics.Raycast(
									MyTransform.position,
									-MyTransform.up,
									PP_Jump.JumpBufferDistance,
									Floor))
			{
				Jump(InputManager.GetHorInput(), true);
				// Controller.JumpBuffer = true;
			}
		}
		//-----------------------------------------------------------
		protected void Jump(Vector3 direction, bool isBuffered)
		{
			var force = new Vector3(direction.x * PP_Jump.Force.x,
			                        PP_Jump.Force.y,
			                        direction.z * PP_Jump.Force.z * Controller.BuffMultiplier);
			Body.Jump(force);
			if (isBuffered)
				Controller.OnLongJump.Invoke();
			else
				Controller.OnJump.Invoke();
			Controller.ChangeState<Jump>();
		}
	}
}