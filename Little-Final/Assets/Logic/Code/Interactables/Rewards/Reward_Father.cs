using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Reward_Father : EnumeratorManager
{
	#region Variables
	public int kindOfReward;

	ParticleSystem RewardParticles;
	#endregion

	#region Unity
	protected void Awake()
	{
		RewardParticles = GetComponentInChildren<ParticleSystem>();
	}
	#endregion

	#region Private

	protected virtual void Die()
	{
		Destroy(this.gameObject);
	}

	protected virtual void AddReward(Player_Rewards player)
	{
		player.GetReward(kindOfReward);
	}
	#endregion

	#region Collisions
	private void OnTriggerEnter(Collider other)
	{
		Player_Rewards OtherScript = other.GetComponent<Player_Rewards>();
		if (OtherScript)
		{
			AddReward(OtherScript);
			RewardParticles.Play();
			GetComponent<MeshRenderer>().enabled = false;
			GetComponent<Collider>().enabled = false;
			Invoke("Die", 1);
		}
	}
	#endregion
}
