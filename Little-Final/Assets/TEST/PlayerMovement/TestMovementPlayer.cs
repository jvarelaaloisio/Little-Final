using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestMovementPlayer : MonoBehaviour
{
	public CapsuleCollider landCollider;
	public TestJump animatorScript;
	private void Awake()
	{
		animatorScript.landCollider = landCollider;
	}
}
