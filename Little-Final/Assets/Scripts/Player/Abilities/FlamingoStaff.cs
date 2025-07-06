using System;
using System.Collections;
using CharacterMovement;
using Core.Extensions;
using Player;
using Player.Abilities;
using Player.PlayerInput;
using Player.Properties;
using Player.States;
using UnityEngine;
using Void = Player.States.Void;

[CreateAssetMenu(menuName = "Abilities/Flamingo Staff", fileName = "Ability_FlamingoStaff")]
public class FlamingoStaff : Ability
{
	[SerializeField] private AnimationCurve lerpCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);
	[SerializeField] private Vector3 jumpForce = new(0f, 3f, 5f);
	/// <inheritdoc />
	protected override bool ValidateInternal(PlayerController controller)
	{
		return InputManager.CheckSwirlInput();
	}

	/// <inheritdoc />
	public override void Use(PlayerController controller)
	{
		var self = controller.transform;
		var destination = self.TransformPoint(new Vector3(0, -1, 2));
		Debug.DrawLine(self.position, destination, Color.cyan, 5f);
		controller.Body.Velocity = Vector3.zero;
		controller.Body.RigidBody.isKinematic = true;
		controller.ChangeState<Void>();
		controller.StartCoroutine(LerpToDestination(controller, destination));
	}

	private IEnumerator LerpToDestination(PlayerController controller, Vector3 destination)
	{
		var start = Time.time;
		var duration = lerpCurve.Duration();
		var origin = controller.transform.position;
		float now = 0;
		do
		{
			now = Time.time;
			var t = (now - start) / duration;
			controller.transform.position = Vector3.Lerp(origin, destination, lerpCurve.Evaluate(t));
			yield return null;
		} while (now < start + duration
		         && !controller.destroyCancellationToken
		                       .IsCancellationRequested);

		controller.transform.position = destination;
		Debug.Log($"{name} ({controller.name}): Lerped to destination {destination}");
		
		while (!controller.destroyCancellationToken.IsCancellationRequested)
		{
			controller.RunAbilityList(controller.AbilitiesInAir);
			Vector3 desiredDirection = MoveHelper.GetDirection(InputManager.GetHorInput());
			MoveHelper.Rotate(controller.transform,
			                  desiredDirection,
			                  desiredDirection.magnitude * PP_Walk.TurnSpeed);
			if (InputManager.CheckJumpInput())
			{
				controller.Body.RigidBody.isKinematic = false;
				var force2 = jumpForce;
				force2.z *= controller.BuffMultiplier;
				force2 = controller.transform.TransformDirection(jumpForce);
				controller.Body.Jump(force2);
				controller.OnLongJump.Invoke();
				controller.ChangeState<Jump>();
				yield break;
			}
			yield return null;
		}
	}
}