using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

[SelectionBase]
public class StaminaRefiller : MonoBehaviour
{
	public ParticleSystem particles;
	public float respawnTime;
	public float distanceFromGround;
	public bool isRePositioningAtStart;
	private int _sceneIndex;

	private void Start()
	{
		_sceneIndex = gameObject.scene.buildIndex;
		if (isRePositioningAtStart && Physics.Raycast(transform.position + Vector3.up / 3, Vector3.down, out RaycastHit hit, 10))
		{
			Debug.DrawLine(transform.position, hit.point, Color.green, 1);
			transform.position = hit.point + Vector3.up * distanceFromGround;
		}
	}
	private void OnTriggerEnter(Collider other)
	{
		other.GetComponent<PlayerModel>().stamina.RefillCompletely();
		GetComponent<MeshRenderer>().enabled = false;
		GetComponent<Collider>().enabled = false;
		particles.Play(true);
		new CountDownTimer(respawnTime, Reactivate, _sceneIndex).StartTimer();
	}

	private void Reactivate()
	{
		GetComponent<MeshRenderer>().enabled = true;
		GetComponent<Collider>().enabled = true;
	}

	private void OnDrawGizmos()
	{
		if (isRePositioningAtStart && Physics.Raycast(transform.position + Vector3.up / 3, Vector3.down, out RaycastHit hit, 10))
		{
			Gizmos.color = Color.green;
			Gizmos.DrawWireSphere(hit.point + Vector3.up * distanceFromGround, .2f);
		}
	}
}
