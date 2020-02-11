using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "physic layer", fileName = "_layer")]
public class Layer_SO : ScriptableObject
{
	#region Singleton
	private static Layer_SO instance;

	public static Layer_SO Instance
	{
		get
		{
			if (!instance)
			{
				instance = Resources.FindObjectsOfTypeAll<Layer_SO>()[0];
			}
			if (!instance)
			{
				instance = CreateInstance<Layer_SO>();
			}
			return instance;
		}
	}
	#endregion

	[SerializeField]
	[Range(0, 31)]
	public int layer;

	public int Layer
	{
		get
		{
			return layer;
		}
	}
}
