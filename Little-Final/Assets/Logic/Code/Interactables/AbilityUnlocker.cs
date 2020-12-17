using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UpdateManagement;
public class AbilityUnlocker : MonoBehaviour
{
	public Ability ability;
	public bool isAir,
				isLand,
				isWall;

	public ParticleSystem particles;
	public float distanceFromGround;
	public bool isRePositioningAtStart;
	private void Start()
	{
		if (isRePositioningAtStart && Physics.Raycast(transform.position + Vector3.up / 3, Vector3.down, out RaycastHit hit, 10))
		{
			Debug.DrawLine(transform.position, hit.point, Color.magenta, 1);
			transform.position = hit.point + Vector3.up * distanceFromGround;
		}
	}
	private void OnTriggerEnter(Collider other)
	{
		PlayerModel player = other.GetComponent<PlayerModel>();
		if (isAir)
			player.AbilitiesInAir.Add(ability);
		if (isLand)
			player.AbilitiesOnLand.Add(ability);
		if (isWall)
			player.AbilitiesOnWall.Add(ability);
		GetComponent<MeshRenderer>().enabled = false;
		GetComponent<Collider>().enabled = false;
		particles.Play(true);
		new CountDownTimer(particles.main.startLifetime.constantMax, () => Destroy(this.gameObject)).StartTimer();
	}
	private void OnDrawGizmos()
	{
		if (isRePositioningAtStart && Physics.Raycast(transform.position + Vector3.up / 3, Vector3.down, out RaycastHit hit, 10))
		{
			Gizmos.color = Color.magenta;
			Gizmos.DrawWireSphere(hit.point + Vector3.up * distanceFromGround, .2f);
		}
	}
}
