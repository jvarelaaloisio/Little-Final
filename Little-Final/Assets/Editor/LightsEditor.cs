using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Linq;
[CustomEditor(typeof(Light)), CanEditMultipleObjects]
public class LightsEditor : LightEditor
{
	Light[] lights;
	protected override void OnEnable()
	{
		base.OnEnable();
		lights = targets.Select(o => (Light)o).ToArray();
	}

	protected override void OnSceneGUI()
	{
		base.OnSceneGUI();
		foreach (Light light in lights)
		{
			if (Physics.Raycast(light.transform.position, Vector3.down, out RaycastHit hit, 100))
			{
				Handles.color = light.color;
				Handles.DrawLine(hit.point, hit.point + Vector3.right * .25f);
				Handles.DrawLine(hit.point, hit.point - Vector3.right * .25f);
				Handles.DrawLine(hit.point, hit.point + Vector3.forward * .25f);
				Handles.DrawLine(hit.point, hit.point - Vector3.forward * .25f);
				Handles.DrawLine(light.transform.position, hit.point);
				Handles.DrawWireDisc(hit.point, hit.normal, .25f);
			}
		}
	}
}