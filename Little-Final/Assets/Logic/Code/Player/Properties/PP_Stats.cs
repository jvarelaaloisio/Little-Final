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
	private float inmunityTime;

	#region Getters
	public float InitialStamina => initialStamina;
	public float StaminaRefillSpeed => staminaRefillSpeed;
	public float StaminaUpgrade => staminaUpgrade;
	public float StaminaRefillDelay => staminaRefillDelay;
	public int CollectablesForReward => collectablesForReward;
	public float InmunityTime => inmunityTime;
	public float LifePoints => lifePoints;
	#endregion
}