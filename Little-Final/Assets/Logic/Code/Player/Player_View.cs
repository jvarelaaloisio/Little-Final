using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player_View : MonoBehaviour
{
	public string runningBlendTree;
	public string jumpAnimation;
	public string jumpAndFlyAnimation;
	public string climbAnimation;
	public string deathAnimation;
	public string speedParameter= "Speed";
	public string flyingParameter= "Flying";
	public float transitionDuration;
	public Animator animator;
	public void SetSpeed(float value) => animator.SetFloat(speedParameter, value);
	public void SetFlying(bool value) => animator.SetBool(flyingParameter, value);
	public void ShowLandFeedback()
	{
		animator.CrossFade(runningBlendTree, transitionDuration);
	}
	public void ShowJumpFeedback()
	{
		animator.CrossFade(jumpAnimation, transitionDuration);
	}
	public void ShowJumpAndFlyFeedback()
	{
		animator.CrossFade(jumpAndFlyAnimation, transitionDuration);
	}
	public void ShowClimbFeedback()
	{
		animator.CrossFade(climbAnimation, transitionDuration);
	}
	public void ShowDeathFeedback()
	{
		animator.CrossFade(deathAnimation, transitionDuration);
	}
}