using Player;
using UnityEngine;

public enum BodyEvent
{
	TRIGGER,
	JUMP,
	CLIMB,
	LAND
}

public delegate void BodyEvents(BodyEvent typeOfEvent);
public interface IBody
{
	event BodyEvents BodyEvents;
	Vector3 Velocity { get; set; }
	void Push(Vector3 directionNormalized, float force);
	void RequestForce(ForceRequest request);
	void RequestMovementByForce(ForceRequest request);
	void RequestMovement(MovementRequest request);
	void Push(Vector3 direction);
	void MoveHorizontally(Vector3 direction, float inputSpeed);
	void MoveByTransform(Vector3 direction, float speed);
	void StopJump();
	Collider GetLandCollider();
	void Jump(Vector3 jumpForce);
	bool IsInTheAir { get; }
	GameObject GameObject { get; }
	Rigidbody RigidBody { get; }
	Vector3 LastFloorNormal { get; set; }
	float Drag { get; set; }

	/// <summary>
	/// Adds a request to the constant forces List
	/// </summary>
	/// <param name="request">This force will be applied in every fixed update, scaled by fixedDeltaTime</param>
	void RequestConstantForce(ForceRequest request);

	/// <summary>
	/// Removes a requests from the constant forces List
	/// </summary>
	/// <param name="request"></param>
	void CancelConstantForce(ForceRequest request);
}