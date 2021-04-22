using Player.Properties;
using UnityEngine;
[CreateAssetMenu(menuName = "Properties/Player/Stats", fileName = "PP_Stats")]
public class PP_Stats : SingletonScriptable<PP_Stats>
{
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