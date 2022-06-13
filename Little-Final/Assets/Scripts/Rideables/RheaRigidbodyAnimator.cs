using UnityEngine;

namespace Rideables
{
	public class RheaRigidbodyAnimator : RheaAnimatorView
	{
		[SerializeField]
		private Rigidbody rigidBody;
		
		[Tooltip("Modify this value to get a more consistent representation between rigidBody and NavMesh view")]
		[SerializeField]
		private float speedModifier = 1;

		protected override void OnValidate()
		{
			base.OnValidate();
			if (!rigidBody)
				TryGetComponent(out rigidBody);
			if (!rigidBody)
				transform.parent.TryGetComponent(out rigidBody);
		}

		protected override Vector3 GetSpeed() => rigidBody.velocity * speedModifier;
		protected override void Awake()
		{
			base.Awake();
			if (!rigidBody)
				Debug.LogError("Rigidbody field not set", this);
		}
	}
}