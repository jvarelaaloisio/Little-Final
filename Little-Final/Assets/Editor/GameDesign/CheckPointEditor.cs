using System.Collections;
using System.Collections.Generic;
using Interactables;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(CheckPoint))]
public class CheckPointEditor : Editor
{
	CheckPoint _target;
	private void OnEnable()
	{
		_target = (CheckPoint)target;
		_target.safeRotation.Normalize();
	}
	private void OnSceneGUI()
	{
		_target.safePoint = Handles.PositionHandle(_target.safePoint, _target.safeRotation);
		_target.safeRotation = Handles.RotationHandle(_target.safeRotation, _target.safePoint);
		if (Physics.Raycast(_target.safePoint, Vector3.down, out RaycastHit hit, 50))
		{
			_target.safePoint.y = hit.point.y + _target.distanceFromFloor;
		}
	}
	public override void OnInspectorGUI()
	{
		base.OnInspectorGUI();
		if(GUILayout.Button("reset safe state"))
		{
			_target.safePoint = _target.transform.position;
			_target.safeRotation = _target.transform.rotation;
		}
	}
}
