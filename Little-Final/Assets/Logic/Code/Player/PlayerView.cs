using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UpdateManagement;
public class PlayerView : MonoBehaviour, IUpdateable
{
	public Color maxStamina,
				minStamina;
	public float staminaFadeDelay,
				staminaFadeTime,
				staminaPerCircle;
	public int FOV,
				FOVaccelerated;
	public Vector3 StaminaUIOffset;
	public List<Image> staminaUI;
	public Image staminaUI_;
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
	private PlayerModel model;
	private void Start()
	{
		staminaFade = new ActionOverTime(staminaFadeTime, ChangeStaminaMask, true);
		staminaFadeTimer = new CountDownTimer(staminaFadeDelay, staminaFade.StartAction);
		staminaUI_.color = maxStamina;
		ChangeStaminaMask(1);
		UpdateManager.Instance.Subscribe(this);
		model = GetComponent<PlayerModel>();
	}
	public void OnUpdate()
	{
		staminaUI_.rectTransform.position = Camera.main.WorldToScreenPoint(transform.position) + StaminaUIOffset;
	}
	private void ChangeStaminaMask(float lerp)
	{
		Color color = staminaUI_.color;
		color.a = 1 - lerp;
		staminaUI_.color = color;
	}
	public void UpdateStamina(float value)
	{
		ChangeStaminaMask(0);
		//int circleQuantity = Mathf.FloorToInt(model.stamina.MaxStamina / staminaPerCircle);
		//int circleQuantity = Mathf.FloorToInt(value / staminaPerCircle);
		//Debug.Log(circleQuantity + " circles");
		//int circlesFilled = 
		float lerp = value / model.stamina.MaxStamina;
		staminaUI_.fillAmount = lerp;
		staminaUI_.color = Color.Lerp(minStamina, maxStamina, lerp);
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