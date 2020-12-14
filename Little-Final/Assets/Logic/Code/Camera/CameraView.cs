using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UpdateManagement;
public class CameraView : MonoBehaviour, IUpdateable
{
	public Animator animator;
	public string isInputParameter,
					isFlyingParameter;
	void Start()
	{
		UpdateManager.Instance.Subscribe(this);
	}

	public void OnUpdate()
	{
		animator.SetBool(isInputParameter, Mathf.Abs(Input.GetAxis("Camera X")) > 0);
	}

	public void IsFlying(bool value) => animator.SetBool(isFlyingParameter, value);
}
