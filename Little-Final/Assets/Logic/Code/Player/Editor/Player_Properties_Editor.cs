using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(Player_Properties_SO), true)]
public class Player_Properties_Editor : Editor
{
	SerializedProperty jumpForce,
		jumpSpeed,
		fallMultiplier,
		lowJumpMultiplier,
		coyoteTime,
		glidingDrag,
		climbSpeed,
		turnSpeed;
	private void OnEnable()
	{
		jumpForce = serializedObject.FindProperty("jumpForce");
		jumpSpeed = serializedObject.FindProperty("jumpSpeed");
		fallMultiplier = serializedObject.FindProperty("fallMultiplier");
		lowJumpMultiplier = serializedObject.FindProperty("lowJumpMultiplier");
		coyoteTime = serializedObject.FindProperty("coyoteTime");
		glidingDrag = serializedObject.FindProperty("glidingDrag");
		climbSpeed = serializedObject.FindProperty("climbSpeed");
		turnSpeed = serializedObject.FindProperty("turnSpeed");
	}

	public override void OnInspectorGUI()
	{
		serializedObject.Update();
		EditorGUILayout.PropertyField(jumpForce);
		EditorGUILayout.PropertyField(jumpSpeed);
		EditorGUILayout.PropertyField(fallMultiplier);
		EditorGUILayout.PropertyField(lowJumpMultiplier);
		EditorGUILayout.PropertyField(coyoteTime);
		EditorGUILayout.PropertyField(glidingDrag);
		EditorGUILayout.PropertyField(climbSpeed);
		EditorGUILayout.PropertyField(turnSpeed);
		serializedObject.ApplyModifiedProperties();
	}
}
