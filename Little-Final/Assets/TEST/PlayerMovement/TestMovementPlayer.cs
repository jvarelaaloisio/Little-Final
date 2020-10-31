using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class TestMovementPlayer : MonoBehaviour
{
	public PP_Walk playerProperties;
	public CapsuleCollider landCollider;
	Animator myAnimator;
	TestJump script;
	public float turnSpeed = 2,
		runSpeed = 10;
	Vector3 targetDirection;
	Vector2 input;
	private void Start()
	{
		playerProperties = PP_Walk.Instance;
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
			print("jump");
			this.GetComponent<Rigidbody>().AddForce(Vector3.up * PP_Jump.Instance.JumpForce, ForceMode.Impulse);
		}

		float speed = Mathf.Abs(input.x) + Mathf.Abs(input.y);
		//		Animator
		myAnimator.SetFloat("Speed", speed);
		//		direction
		var forward = Camera.main.transform.TransformDirection(Vector3.forward);
		forward.y = 0;

		var right = Camera.main.transform.TransformDirection(Vector3.right);

		targetDirection = input.x * right + input.y * forward;
		if (input != Vector2.zero && targetDirection.magnitude > .1f)
		{
			targetDirection.Normalize();
			float differenceRotation = Vector3.Angle(transform.forward, targetDirection);

			float dot = Vector3.Dot(transform.right, targetDirection);
			var leastTravelDirection = dot < 0 ? -1 : 1;
			GetComponent<Rigidbody>().velocity = targetDirection * runSpeed + GetComponent<Rigidbody>().velocity.y * Vector3.up;
			transform.Rotate(transform.up, differenceRotation * leastTravelDirection * turnSpeed * Time.deltaTime);
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
