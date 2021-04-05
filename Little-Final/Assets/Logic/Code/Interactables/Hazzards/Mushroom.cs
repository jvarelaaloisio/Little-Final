using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

[RequireComponent(typeof(SphereCollider))]
public class Mushroom : Hazzard
{
	#region Variables

	#region Serialized

	[SerializeField]
	float damageTimeToOn = 3,
		damageTimeToOff = 1,
		ticTime = 0.5f;

	[SerializeField]
	ParticleSystem particles = null;

	#endregion

	#region Private

	SphereCollider _collider;

	CountDownTimer damageTurnOnDelay,
		damageTurnOffDelay,
		damageTic;

	Animation anim;

	#endregion

	#endregion

	#region Unity

	void Start()
	{
		_collider = GetComponent<SphereCollider>();
		_collider.enabled = false;
		InitializeTimers();
		damageTurnOnDelay.StartTimer();
		anim = GetComponent<Animation>();
		anim.Play("idle");
	}

	#endregion

	#region Private

	/// <summary>
	/// Setup of all the timers
	/// </summary>
	void InitializeTimers()
	{
		int sceneIndex = gameObject.scene.buildIndex;
		damageTic = new CountDownTimer(ticTime, OnTicFinish, sceneIndex);
		damageTurnOnDelay = new CountDownTimer(damageTimeToOn, TurnOnDamage, sceneIndex);
		damageTurnOffDelay = new CountDownTimer(damageTimeToOff, TurnOffDamage, sceneIndex);
	}

	private void OnTicFinish()
	{
		Attack();
		damageTic.StartTimer();
	}

	private void TurnOffDamage()
	{
		if (_damageables.Count <= 0) _collider.enabled = false;
		anim.Play("idle");
		damageTic.StartTimer();
		damageTurnOnDelay.StartTimer();
		particles.Stop();
	}

	private void TurnOnDamage()
	{
		_collider.enabled = true;
		particles.Play();
		anim.Play("hop");
		damageTic.StartTimer();
		damageTurnOffDelay.StartTimer();
	}

	#endregion
}