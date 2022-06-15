using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

public class RotateAroundSelf : MonoBehaviour, IUpdateable
{
	public float rotationSpeed;

	private void OnEnable()
	{
		UpdateManager.Subscribe(this);
	}

	private void OnDisable()
	{
		UpdateManager.UnSubscribe(this);
	}

	public void OnUpdate()
	{
		transform.Rotate(Vector3.up * Mathf.Sin(rotationSpeed * Time.deltaTime));
	}
	private void OnDestroy()
	{
		UpdateManager.UnSubscribe(this);
	}
}
