using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IBody
{
	event BodyEvents BodyEvents;
	void Push(Vector3 direction, float force);
	void MoveHorizontally(Vector3 direction, float inputSpeed);
	void Climb(Vector2 Input);
	void StopJump();
	Collider GetLandCollider();
	bool InputJump { set; }
	bool IsInTheAir { get; }
}