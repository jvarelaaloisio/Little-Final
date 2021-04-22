using CharacterMovement;
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
		private LayerMask _interactable;

		/// <summary>
		/// Runs once when the state starts
		/// (In base, it setups the controller refference)
		/// </summary>
		/// <param name="controller"></param>
		/// <param name="sceneIndex">the index where the player lives</param>
		public virtual void OnStateEnter(PlayerController controller, int sceneIndex)
		{
			_interactable = LayerMask.GetMask("Interactable");
			Controller = controller;
			MyTransform = controller.transform;
		}

		/// <summary>
		/// Runs every update
		/// </summary>
		public abstract void OnStateUpdate();

		//----------	ESTOS METODOS SE VAN AL CONTROLLER ----------
		/// <summary>
		/// runs once when the state finishes
		/// </summary>
		public abstract void OnStateExit();
		/// <summary>
		/// Reads the input and moves the player horizontally
		/// </summary>
		protected void MoveHorizontally(IBody body, float speed, float turnSpeed)
		{
			Vector2 input = InputManager.GetHorInput();

			Vector3 desiredDirection = HorizontalMovementHelper.GetDirection(input);

			if (HorizontalMovementHelper.IsSafeAngle(
				MyTransform.position,
				desiredDirection.normalized,
				.5f,
				PP_Walk.Instance.MinSafeAngle))
				HorizontalMovementHelper.MoveWithRotation(
					MyTransform,
					body,
					desiredDirection,
					speed,
					turnSpeed);
		}
		/// <summary>
		/// Checks if the climb input and the conditions are met.
		/// If then, it changes to the Climb State.
		/// </summary>
		protected void CheckClimb()
		{
			if (InputManager.CheckClimbInput()
			    && Controller.Stamina.FillState > 0
			    && ClimbHelper.CanClimb(
				    MyTransform.position,
				    MyTransform.forward,
				    PP_Climb.MaxDistanceToTriggerClimb,
				    PP_Climb.MaxClimbAngle,
				    out _))
				Controller.ChangeState<Climb>();
		}
		protected void CheckForJumpBuffer()
		{
			if (InputManager.CheckLongJumpInput() &&
			    Physics.Raycast(
				    MyTransform.position,
				    -MyTransform.up,
				    .5f,
				    ~_interactable))
			{
				Controller.LongJumpBuffer = true;
			}
			else if (InputManager.CheckJumpInput() &&
			         Physics.Raycast(
				         MyTransform.position,
				         -MyTransform.up,
				         .5f,
				         ~_interactable))
			{
				Controller.JumpBuffer = true;
			}
		}
		//-----------------------------------------------------------
	}
}