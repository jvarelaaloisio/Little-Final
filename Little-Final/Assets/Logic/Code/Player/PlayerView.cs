using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UpdateManagement;
public class PlayerView : MonoBehaviour, IUpdateable
{
	public Color maxStamina,
				midStamina,
				minStamina;
	public float staminaFadeDelay,
				staminaFadeTime,
				staminaPerCircle;
	[Range(0, 100)]
	public float staminaFollowSpeed;
	public Vector3 StaminaUIOffset;
	public List<Image> staminaUI;
	public string runningBlendTree;
	public string jumpAnimation;
	public string climbAnimation;
	public string deathAnimation;
	public string speedParameter = "Speed";
	public string cameraIsMovementParameter;
	public string isFlyingParameter = "isFlying";
	public float transitionDuration;
	public Transform playerShadow;
	public Material playerShadowMaterial;
	public Vector3 playerShadowOffset;
	public Animator animator;
	CameraView cameraView;
	ActionOverTime staminaFade;
	CountDownTimer staminaFadeTimer;
	private void Start()
	{
		staminaFade = new ActionOverTime(staminaFadeTime, ChangeStaminaMask, true);
		staminaFadeTimer = new CountDownTimer(staminaFadeDelay, staminaFade.StartAction);
		cameraView = FindObjectOfType<CameraView>();
		staminaUI.ForEach((Image ui) => ui.color = maxStamina);
		ChangeStaminaMask(1);
		UpdateManager.Subscribe(this);
	}
	public void OnUpdate()
	{
		Vector3 _StaminaPosition = Camera.main.WorldToScreenPoint(transform.position) + StaminaUIOffset;
		staminaUI.ForEach((Image ui) => ui.rectTransform.position = Vector3.Lerp(ui.rectTransform.position, _StaminaPosition, Time.deltaTime * staminaFollowSpeed));
	}
	private void ChangeStaminaMask(float lerp)
	{
		foreach (Image ui in staminaUI)
		{
			Color color = ui.color;
			color.a = 1 - lerp;
			ui.color = color;
		}
	}
	public void UpdateStamina(float value)
	{
		ChangeStaminaMask(0);
		int _circleQuantity = Mathf.FloorToInt(value / staminaPerCircle);
		for (int i = 0; i < staminaUI.Count; i++)
		{
			if (i < _circleQuantity)
			{
				staminaUI[i].fillAmount = 1;
				staminaUI[i].color = maxStamina;
			}
			else
			{
				staminaUI[i].fillAmount = 0;
			}
		}
		if (_circleQuantity < 0 || _circleQuantity >= staminaUI.Count)
			return;

		float _lastCircleFillAmount = value % staminaPerCircle;

		float _lerp = _lastCircleFillAmount / staminaPerCircle;
		staminaUI[_circleQuantity].fillAmount = _lerp;
		if (_lerp < .5f)
			staminaUI[_circleQuantity].color = Color.Lerp(minStamina, midStamina, _lerp * 2);
		else
			staminaUI[_circleQuantity].color = Color.Lerp(midStamina, maxStamina, (_lerp - .5f) * 2);
		staminaFade.StopAction();
		if (_lerp == 1) staminaFadeTimer.StartTimer();
	}
	public void SetSpeed(float value)
	{
		animator.SetFloat(speedParameter, value);
	}
	public void SetFlying(bool value)
	{
		animator.SetBool(isFlyingParameter, value);
		cameraView.IsFlying(value);
	}
	public void ShowLandFeedback()
	{
		animator.CrossFade(runningBlendTree, transitionDuration);
	}
	public void ShowJumpFeedback()
	{
		animator.Play(jumpAnimation);
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
	public void ShowPlayerShadow(Vector3 position, Quaternion rotation, float size)
	{
		playerShadow.position = position + playerShadowOffset;
		playerShadow.rotation = rotation;
		playerShadowMaterial.SetFloat("_Size", size);
	}
}