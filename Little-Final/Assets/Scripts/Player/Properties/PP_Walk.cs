using UnityEngine;

namespace Player.Properties
{
	[CreateAssetMenu(menuName = "Properties/Player/Walk", fileName = "PP_Walk")]
	public class PP_Walk : SingletonScriptable<PP_Walk>
	{
		[SerializeField]
		[Range(0, 100, step: .5f)]
		private float speed,
			turnSpeed;
		[SerializeField]
		[Range(0, 90, step: 1)]
		private float minSafeAngle;

		#region Getters
		public float Speed => speed;
		public float TurnSpeed => turnSpeed;
		public float MinSafeAngle => minSafeAngle;
		#endregion
	}
}