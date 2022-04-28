using System;
using System.Collections;
using UnityEngine;
using Player.PlayerInput;

namespace Player.Abilities
{
	[CreateAssetMenu(menuName = "Abilities/Push", fileName = "Ability_Push")]
	public class Push : Ability
	{
		[SerializeField]
		private Vector3 direction;
		
		[SerializeField]
		private AnimationCurve forceDecay = AnimationCurve.Linear(0, 1, 1, 0);

		protected override bool ValidateInternal(PlayerController controller)
		{
			return InputManager.CheckSwirlInput();
		}

		public override void Use(PlayerController controller)
		{
			// controller.Body.RequestForce(new ForceRequest(controller.transform.TransformDirection(direction),
			// 											ForceMode.Impulse));
			float duration = forceDecay.keys[forceDecay.keys.Length - 1].time - forceDecay.keys[0].time;
			controller.StartCoroutine(AddForceOverTime(controller, direction, duration, forceDecay.Evaluate));
		}

		private IEnumerator AddForceOverTime(PlayerController controller,
											Vector3 direction,
											float duration,
											Func<float, float> evlauate)
		{
			Vector3 normalDirection = direction.normalized;
			float force = direction.magnitude;
			float start = Time.time;
			float now;
			while ((now = Time.time - start) <= duration)
			{
				float currentForce = force * evlauate(now);
				Vector3 scaledDir = controller.transform.TransformDirection(normalDirection) * currentForce * Time.deltaTime;
				controller.Body.RequestForce(new ForceRequest(scaledDir, ForceMode.Force));
				yield return null;
			}
		}
	}
}