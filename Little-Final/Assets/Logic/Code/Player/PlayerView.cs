using UnityEngine;
using UnityEngine.UI;
using UpdateManagement;
using Cinemachine;
public class PlayerView : MonoBehaviour, IUpdateable
{
	public Color maxStamina,
				minStamina;
	public float staminaFadeDelay,
				staminaFadeTime;
	public int FOV,
				FOVaccelerated;
	public Vector3 StaminaUIOffset;
	public Image staminaUI;
	public string runningBlendTree;
	public string jumpAnimation;
	public string jumpAndFlyAnimation;
	public string climbAnimation;
	public string deathAnimation;
	public string speedParameter = "Speed";
	public string flyingParameter = "Flying";
	public float transitionDuration;
	public Animator animator;
	ActionOverTime staminaFade;
	CountDownTimer staminaFadeTimer;
	private void Start()
	{
		staminaFade = new ActionOverTime(staminaFadeTime, ChangeStaminaMask, true);
		staminaFadeTimer = new CountDownTimer(staminaFadeDelay, staminaFade.StartAction);
		staminaUI.color = maxStamina;
		ChangeStaminaMask(1);
		UpdateManager.Instance.Subscribe(this);
	}
	public void OnUpdate()
	{
		staminaUI.rectTransform.position = Camera.main.WorldToScreenPoint(transform.position) + StaminaUIOffset;
	}
	private void ChangeStaminaMask(float lerp)
	{
		Color color = staminaUI.color;
		color.a = 1 - lerp;
		staminaUI.color = color;
	}
	public void UpdateStamina(float value)
	{
		ChangeStaminaMask(0);
		float lerp = value / PP_Stats.Instance.MaxStamina;
		staminaUI.fillAmount = lerp;
		staminaUI.color = Color.Lerp(minStamina, maxStamina, lerp);
		staminaFade.StopAction();
		if (lerp == 1) staminaFadeTimer.StartTimer();
	}
	public void SetSpeed(float value) => animator.SetFloat(speedParameter, value);
	public void SetFlying(bool value) => animator.SetBool(flyingParameter, value);
	public void ShowLandFeedback()
	{
		animator.CrossFade(runningBlendTree, transitionDuration);
	}
	public void ShowJumpFeedback()
	{
		//animator.CrossFade(jumpAnimation, transitionDuration);
		animator.Play(jumpAnimation);
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
	public void SetAccelerationEffect(float lerp)
	{

	}
	public void ShowAccelerationFeedback()
	{

	}
	public void StopAccelerationFeedback()
	{

	}
	public void PlaySpecificAnimation(string stateName)
	{
		//animator.CrossFade(stateName, transitionDuration);
		animator.Play(stateName);
	}
}