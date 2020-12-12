using UnityEngine;
[CreateAssetMenu(menuName = "Properties/Player/Stats", fileName = "PP_Stats")]
public class PP_Stats : ScriptableObject
{
	#region Singleton
	private static PP_Stats instance;

	public static PP_Stats Instance
	{
		get
		{
			if (!instance)
			{
				instance = Resources.Load<PP_Stats>("PP_Stats");
			}
			if (!instance)
			{
				Debug.Log("No Stats Properties found in Resources folder");
				instance = CreateInstance<PP_Stats>();
			}
			return instance;
		}
	}

	#endregion

	[SerializeField]
	[Range(0, 100, step: 1)]
	private float maxStamina,
		staminaRefillSpeed;
	[SerializeField]
	[Range(0, 10, step: .5f)]
	private float staminaRefillDelay;

	#region Getters
	public float MaxStamina => maxStamina;
	public float StaminaRefillSpeed => staminaRefillSpeed;
	public float StaminaRefillDelay => staminaRefillDelay;
	#endregion
}