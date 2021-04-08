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

#pragma warning disable 0169
#pragma warning disable 0649
	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float drag,
					acceleratedDrag,
					acceleratedSpeed,
					staminaPerSecond,
					staminaConsumptionDelay,
					accelerationDelay,
					accelerationTime;
#pragma warning restore 0169
#pragma warning restore 0649


	#region Getters
	public static float Drag => instance.drag;
	public static float AcceleratedDrag => instance.acceleratedDrag;
	public static float AcceleratedSpeed => instance.acceleratedSpeed;
	public static float StaminaPerSecond => instance.staminaPerSecond;
	public static float StaminaConsumptionDelay => instance.staminaConsumptionDelay;
	public static float AccelerationDelay => instance.accelerationDelay;
	public static float AccelerationTime => instance.accelerationTime;
	#endregion
}
