using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestMovementPlayer : MonoBehaviour
{
	public CapsuleCollider landCollider;
	public Transform myHead;
	Animator myAnimator;
	TestJump script;
	public float turnSpeed = 2,
		jumpForce = 10;
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
			float differenceRotation = Vector3.Angle(transform.forward, targetDirection.normalized);
			float dot = Vector3.Dot(transform.right, targetDirection.normalized);
			Debug.DrawRay(transform.position, targetDirection.normalized, dot > 0 ? Color.green : Color.red);
			//float dirMulti = input.x >= 0 ? 1 : -1;
			var asdf = dot < 0 ? -1 : 1;
			transform.Rotate(transform.up, differenceRotation * asdf * turnSpeed * Time.deltaTime);
			//transform.LookAt(-Camera.main.transform.position);
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
