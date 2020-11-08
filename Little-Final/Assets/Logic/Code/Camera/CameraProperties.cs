using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Properties/Camera")]
public class CameraProperties : ScriptableObject
{
	#region Singleton
	private static CameraProperties instance;

	public static CameraProperties Instance
	{
		get
		{
			if (!instance)
			{
				CameraProperties[] propertiesFound = Resources.LoadAll<CameraProperties>("");
				if (propertiesFound.Length >= 1) instance = propertiesFound[0];
			}
			if (!instance)
			{
				Debug.Log("No Camera Properties found in Resources folder");
				instance = CreateInstance<CameraProperties>();
			}
			return instance;
		}
	}

	#endregion

	[SerializeField]
	[Range(0, 100, step: .5f)]
	private float minSpeedToDistort;
	[SerializeField]
	[UnityEngine.Range(0, 120)]
	private int distortFov;
	[SerializeField]
	[UnityEngine.Range(0, 3)]
	private float distortTime;
	#region Getters
	public float MinSpeedToDistort => minSpeedToDistort;
	public float DistortTime => distortTime;
	public int DistortFov => distortFov;
	#endregion
}
