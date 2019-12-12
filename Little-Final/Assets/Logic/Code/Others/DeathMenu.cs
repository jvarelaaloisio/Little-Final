using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DeathMenu : MonoBehaviour
{
	#region Variables

	#region Public
	public Image BG;
	public Text VictoryText;
	public float time;
	public bool _counting;
	#endregion

	#region Private
	float _timer,
		_BGalpha;
	#endregion

	#endregion

	#region Unity

	void Update()
	{
		if (!_counting) return;
		_timer += Time.deltaTime;
		_BGalpha = BG.color.a;
		_BGalpha = _timer / time;
		BG.color = new Color(0, 0, 0, _BGalpha);
		if (_timer >= time)
		{
			_counting = false;
		}
	}
	#endregion

	#region Public
	public void SetVictoryText(bool Win)
	{
		VictoryText.text = Win ? "U WIN" : "U LOSE";
	}
	#endregion
}
