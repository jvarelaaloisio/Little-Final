using UnityEngine;
[CreateAssetMenu(menuName = "Properties/Player/Walk", fileName = "PP_Walk")]
public class PP_Walk : ScriptableObject
{
	#region Singleton
	private static PP_Walk instance;

	public static PP_Walk Instance
	{
		get
		{
			if (!instance)
			{
				instance = Resources.Load<PP_Walk>("PP_Walk");
			}
			if (!instance)
			{
				Debug.Log("No Walk Properties found in Resources folder");
				instance = CreateInstance<PP_Walk>();
			}
			return instance;
		}
	}

	#endregion

	[SerializeField]
	[Range(0, 10, step: .5f)]
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