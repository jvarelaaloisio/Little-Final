using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IBody
{
	event BodyEvents BodyEvents;
	Vector3 Velocity { get; set; }
	void SetDrag(float value);
	float GetDrag();
	void Push(Vector3 directionNormalized, float force);
	void Push(Vector3 direction);
	void MoveHorizontally(Vector3 direction, float inputSpeed);
	void Move(Vector3 direction, float speed);
	void StopJump();
	Collider GetLandCollider();
	void Jump(float jumpForce);
	bool IsInTheAir { get; }
	GameObject GameObject { get; }
	Vector3 LastFloorNormal { get; set; }
}