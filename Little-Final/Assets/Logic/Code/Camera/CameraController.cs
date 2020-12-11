using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UpdateManagement;
public class CameraController : MonoBehaviour, IUpdateable
{
	public Animator animator;
	void Start()
	{
		UpdateManager.Instance.Subscribe(this);
	}

	public void OnUpdate()
	{
		animator.SetBool("Input X", Mathf.Abs(Input.GetAxis("Camera X")) > 0);
	}
}
