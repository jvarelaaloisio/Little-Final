using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IBody
{
	event BodyEvents BodyEvents;
	void Push(Vector3 direction, float force);
	void MoveHorizontally(Vector3 direction, float inputSpeed);
	void Move(Vector3 direction, float speed);
	void Climb(Vector2 Input);
	void StopJump();
	Collider GetLandCollider();
	void Jump(float jumpForce);
	bool IsInTheAir { get; }
	GameObject GameObject { get; }
	Vector3 LastFloorNormal { get; set; }
}