using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestMovementPlayer : MonoBehaviour
{
	public CapsuleCollider landCollider;
	Animator myAnimator;
	TestJump script;
	public float turnSpeed = 2,
		jumpForce = 3.5f,
		runSpeed = 10;
	Vector3 targetDirection;
	Vector2 input;
	private void Start()
	{
		myAnimator = GetComponent<Animator>();
		script = myAnimator.GetBehaviour<TestJump>();
		script.landCollider = landCollider;
	}

	private void Update()
	{
		input = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
		if (Input.GetButtonDown("Jump"))
		{
			myAnimator.SetTrigger("Jump");
			this.GetComponent<Rigidbody>().AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
		}
		float speed = Mathf.Abs(input.x) + Mathf.Abs(input.y);
		myAnimator.SetFloat("SpeedY", speed);

		var forward = Camera.main.transform.TransformDirection(Vector3.forward);
		forward.y = 0;

		var right = Camera.main.transform.TransformDirection(Vector3.right);

		targetDirection = input.x * right + input.y * forward;
		if (input != Vector2.zero && targetDirection.magnitude > .1f)
		{
			targetDirection.Normalize();
			float differenceRotation = Vector3.Angle(transform.forward, targetDirection);
			float dot = Vector3.Dot(transform.right, targetDirection);
			Debug.DrawRay(transform.position, targetDirection, dot > 0 ? Color.green : Color.red);
			var leastTravelDirection = dot < 0 ? -1 : 1;
			transform.Rotate(transform.up, differenceRotation * leastTravelDirection * turnSpeed * Time.deltaTime);

			GetComponent<Rigidbody>().velocity = targetDirection * speed * runSpeed;
		}
	}

	public void TurnLandCollider(bool value)
	{
		landCollider.enabled = value;
	}

	private void OnTriggerEnter(Collider other)
	{
		landCollider.enabled = false;
		myAnimator.SetTrigger("Land");
	}
}
