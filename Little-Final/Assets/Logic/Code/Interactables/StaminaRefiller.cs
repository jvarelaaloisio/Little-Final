using UnityEngine;
using UpdateManagement;

[SelectionBase]
public class StaminaRefiller : MonoBehaviour
{
	public ParticleSystem particles;
	public float respawnTime;
	public float distanceFromGround;
	public bool isRePositioningAtStart;
	private void Start()
	{
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
		new CountDownTimer(respawnTime, Reactivate).StartTimer();
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
