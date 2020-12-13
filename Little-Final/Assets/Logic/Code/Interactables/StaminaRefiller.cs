using UnityEngine;
using UpdateManagement;

[SelectionBase]
public class StaminaRefiller : MonoBehaviour
{
	public ParticleSystem particles;
	private void OnTriggerEnter(Collider other)
	{
		other.GetComponent<PlayerModel>().stamina.RefillCompletely();
		GetComponent<MeshRenderer>().enabled = false;
		particles.Play(true);
		new CountDownTimer(particles.main.startLifetime.constantMax, () => Destroy(this.gameObject));
	}
}
