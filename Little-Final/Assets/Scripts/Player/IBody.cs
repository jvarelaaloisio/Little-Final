using System.Collections;
using System.Collections.Generic;
using Player;
using UnityEngine;

public interface IBody
{
	event BodyEvents BodyEvents;
	Vector3 Velocity { get; set; }
	void SetDrag(float value);
	float GetDrag();
	void Push(Vector3 directionNormalized, float force);
	void RequestForce(ForceRequest request);
	void RequestMovementByForce(ForceRequest request);
	void Push(Vector3 direction);
	void MoveHorizontally(Vector3 direction, float inputSpeed);
	void MoveByTransform(Vector3 direction, float speed);
	void StopJump();
	Collider GetLandCollider();
	void Jump(Vector3 jumpForce);
	bool IsInTheAir { get; }
	GameObject GameObject { get; }
	Vector3 LastFloorNormal { get; set; }
}