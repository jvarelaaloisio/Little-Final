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

#pragma warning disable 0169
#pragma warning disable 0649
	[Header("Stamina")]
	[SerializeField, Range(0, 500, step: 1)]
	private float initialStamina;
	[SerializeField, Range(0, 500, step: 1)]
	private float staminaRefillSpeed;
	[SerializeField, Range(0, 500, step: 1)]
	private float staminaUpgrade;
	[SerializeField, Range(0, 10, step: .5f)]
	private float staminaRefillDelay;
	[Space(5), Header("Collectables")]
	[SerializeField, Range(0, 15, step: 1)]
	private int collectablesForReward;
	[Space(5), Header("Life")]
	[SerializeField, Range(1, 500, step: 1)]
	private float lifePoints;
	[SerializeField, Range(1, 5, step: .01f)]
	private float inmunityTime,
		deadTime;
#pragma warning restore 0169
#pragma warning restore 0649


	#region Getters
	public static float InitialStamina => Instance.initialStamina;
	public static float StaminaRefillSpeed => Instance.staminaRefillSpeed;
	public static float StaminaUpgrade => Instance.staminaUpgrade;
	public static float StaminaRefillDelay => Instance.staminaRefillDelay;
	public static int CollectablesForReward => Instance.collectablesForReward;
	public static float ImmunityTime => Instance.inmunityTime;
	public static float LifePoints => Instance.lifePoints;
	public static float DeadTime => Instance.deadTime;
	#endregion
}