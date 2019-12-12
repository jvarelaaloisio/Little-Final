using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IBody
{
	void Push(Vector3 direction, float force);
	void Walk(Vector2 Input);
	void Climb(Vector2 Input);
	void StopJump();
}