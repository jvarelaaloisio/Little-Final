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
			//tomo la primer instancia que haya en la carpeta Resources
			if (!instance)
			{
				GameParameters[] candidates = Resources.FindObjectsOfTypeAll<GameParameters>();
				if (candidates.Length > 0)
				{
					instance = candidates[0];
				}
			}
			//si no encuentro un asset, creo uno vacío
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
