using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "physic layer", fileName = "_layer")]
public class SO_Layer : ScriptableObject
{
	#region Singleton
	private static SO_Layer instance;

	public static SO_Layer Instance
	{
		get
		{
			if (!instance)
			{
				instance = Resources.FindObjectsOfTypeAll<SO_Layer>()[0];
			}
			if (!instance)
			{
				instance = CreateInstance<SO_Layer>();
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
