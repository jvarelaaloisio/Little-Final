using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class SpecialReward : Reward_Father
{
	#region Variables

	#region Public
	public float time;
	public Text timer;
	new readonly int kindOfReward = (int)Reward.win;
	#endregion

	#region Private
	float _timer;
	bool _counting;
	#endregion
	
	#endregion

	#region Unity
    void Update()
	{
		if (!_counting) return;
		_timer += Time.deltaTime;
		if (timer)
		{
			timer.text = "Get another one! " + _timer;
		}
		if(_timer >= time)
		{
			GameObject.Find("GameManager").GetComponent<GameManager>().PlayerIsDead(false);
			_counting = false;
		}
	}
	#endregion

	#region Private
	protected override void AddReward(Player_Rewards player)
	{
		player.GetReward(kindOfReward);
		_counting = true;
	}

	protected override void Die()
	{

	}
	#endregion

	#region Public

	#endregion
}
