using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
[CustomEditor(typeof(CheckPoint))]
public class CheckPointEditor : Editor
{
	private void OnSceneGUI()
	{
		CheckPoint _target = (CheckPoint)target;
		_target.safePoint = Handles.PositionHandle(_target.safePoint, _target.transform.rotation);
		if (Physics.Raycast(_target.safePoint, Vector3.down, out RaycastHit hit, 50))
		{
			_target.safePoint.y = hit.point.y + _target.distanceFromFloor;
		}
	}
}
