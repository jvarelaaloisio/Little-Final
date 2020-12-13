using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Properties/Player/Glide", fileName = "PP_Glide")]
public class PP_Glide : ScriptableObject
{
	#region Singleton
	private static PP_Glide instance;

	public static PP_Glide Instance
	{
		get
		{
			if (!instance)
			{
				instance = Resources.Load<PP_Glide>("PP_Glide");
			}
			if (!instance)
			{
				Debug.Log("No Glide Properties found in Resources folder");
				instance = CreateInstance<PP_Glide>();
			}
			return instance;
		}
	}

	#endregion

	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float drag,
					acceleratedDrag,
					acceleratedSpeed,
					staminaPerSecond,
					staminaConsumptionDelay,
					//Unused
					turnSpeed,
					accelerationDelay,
					accelerationTime;

	#region Getters
	public float Drag => drag;
	public float AcceleratedDrag => acceleratedDrag;
	public float AcceleratedSpeed => acceleratedSpeed;
	public float StaminaPerSecond => staminaPerSecond;
	public float StaminaConsumptionDelay => staminaConsumptionDelay;
	public float TurnSpeed => turnSpeed;
	public float AccelerationDelay => accelerationDelay;
	public float AccelerationTime => accelerationTime;
	#endregion
}
