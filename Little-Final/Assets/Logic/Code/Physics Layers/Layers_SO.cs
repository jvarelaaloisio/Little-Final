using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "physic layers/layer SO", fileName = "_layer_SO")]
public class Layers_SO : ScriptableObject
{
	private static Layers_SO instance;

	public static Layers_SO Instance
	{
		get
		{
			if (!instance)
			{
				instance = Resources.FindObjectsOfTypeAll<Layers_SO>()[0];
			}
			if (!instance)
			{
				instance = CreateInstance<Layers_SO>();
			}
			return instance;
		}
	}

	public LayerMask layer;

	public float LayerNumber
	{
		get
		{
			return LayerMask.NameToLayer(layer.ToString());
		}
	}
}
