using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

public class CameraView : MonoBehaviour, IUpdateable
{
	public Animator animator;
	public string isInputParameter,
					isFlyingParameter;
	void Start()
	{
		UpdateManager.Subscribe(this);
	}

	public void OnUpdate()
	{
		animator.SetBool(isInputParameter, Mathf.Abs(Input.GetAxis("Camera X")) > 0 || Mathf.Abs(Input.GetAxis("Mouse Y")) > 0);
	}

	public void IsFlying(bool value) => animator.SetBool(isFlyingParameter, value);
}
