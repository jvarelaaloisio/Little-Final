using UnityEngine;

[CreateAssetMenu(menuName = "Game Parameters", fileName = "_GameParameters")]
public class GameParameters : ScriptableObject
{
	#region Singleton
	private static GameParameters instance;

	public static GameParameters Instance
	{
		get
		{
			if (!instance)
			{
				instance = Resources.FindObjectsOfTypeAll<GameParameters>()[0];
			}
			if (!instance)
			{
				instance = CreateInstance<GameParameters>();
			}
			return instance;
		}
	}

	#endregion

	#region Getters
	public PlayerProperties PlayerProperties { get => playerProperties; }
	#endregion

	[SerializeField]
	private PlayerProperties playerProperties;


}
