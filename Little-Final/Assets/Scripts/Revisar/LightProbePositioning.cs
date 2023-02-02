using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;
public class LightProbePositioning : MonoBehaviour, IUpdateable
{
	public float period;
	public float offsetFromGround;
	public ReflectionProbe probe;
	private CountDownTimer updatePositionPeriod;

	public void OnUpdate()
	{
		UpdateProbe();
	}

	private void OnEnable()
	{
		UpdateManager.Subscribe(this);
	}

	private void OnDisable()
	{
		UpdateManager.UnSubscribe(this);
	}

	private void UpdateProbe()
	{
		if(Physics.Raycast(Camera.main.transform.position, Vector3.down, out RaycastHit hit, 100))
		{
			Vector3 _position = Camera.main.transform.position;
			_position.y = hit.point.y + offsetFromGround;
			transform.position = _position;
			Debug.Log(_position);
		}
		//probe.RenderProbe();
		//updatePositionPeriod.StartTimer();
	}
}
