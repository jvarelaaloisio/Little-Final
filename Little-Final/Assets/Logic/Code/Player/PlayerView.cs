using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Rendering.PostProcessing;
using UpdateManagement;
using System.Linq;
public class PlayerView : MonoBehaviour, IUpdateable
{
	public AudioClip reward;
	private AudioManager audioManager;
	public Color maxStamina,
				midStamina,
				minStamina;
	public float staminaFadeDelay,
				staminaFadeTime,
				staminaPerCircle;
	[Range(0, 100)]
	public float staminaFollowSpeed;
	public Vector3 StaminaUIOffset,
					StaminaUIOffsetWhenFlying;
	public RectTransform staminaRings;
	public float staminaRingsScaleWhenFlying;
	public float lensDistortionWhenFlying;
	private Vector3 lastStaminaControlledPosition,
					staminaOriginalScale;
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
	public Material poncho;
	public float ponchoTurnOffTime;
	private ActionOverTime ponchoTurnOff;
	public Vector3 playerShadowOffset;
	public Animator animator;
	private bool isControllingStaminaPosition;
	CameraView cameraView;
	ActionOverTime staminaFade;
	CountDownTimer staminaFadeTimer;
	private LensDistortion lensDistortionSettings;
	private float originalDistorsionIntensity;
	public TrailRenderer[] glideEffect,
							accelerationEffect;
	public bool IsFlying => glideEffect[0].emitting;
	private PlayerModel playerModel;
	private void Start()
	{
		playerModel = GetComponent<PlayerModel>();
		audioManager = FindObjectOfType<AudioManager>();
		staminaFade = new ActionOverTime(staminaFadeTime, ChangeStaminaMask, true);
		staminaFadeTimer = new CountDownTimer(staminaFadeDelay, staminaFade.StartAction);
		cameraView = FindObjectOfType<CameraView>();
		staminaUI.ForEach((Image ui) => ui.color = maxStamina);
		ChangeStaminaMask(1);
		staminaOriginalScale = staminaRings.localScale;
		Camera.main.GetComponent<PostProcessVolume>().profile.TryGetSettings<LensDistortion>(out lensDistortionSettings);
		originalDistorsionIntensity = lensDistortionSettings.intensity;
		poncho.SetFloat("_Activate", 0);
		ponchoTurnOff = new ActionOverTime(ponchoTurnOffTime, FadePoncho);
		UpdateManager.Subscribe(this);
	}
	public void OnUpdate()
	{
		if (isControllingStaminaPosition)
		{
			Vector3 _StaminaPosition = Camera.main.WorldToScreenPoint(transform.position) + StaminaUIOffset;
			staminaRings.position = Vector3.Lerp(staminaRings.position, _StaminaPosition, Time.deltaTime * staminaFollowSpeed);
		}
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
	public void UpdateStamina(float newStaminaAmount)
	{
		ChangeStaminaMask(0);
		int _circleQuantity = Mathf.FloorToInt(newStaminaAmount / staminaPerCircle);
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

		float _lastCircleFillAmount = newStaminaAmount % staminaPerCircle;
		float _lerp = _lastCircleFillAmount / staminaPerCircle;
		staminaUI[_circleQuantity].fillAmount = _lerp;
		if (_lerp < .5f)
			staminaUI[_circleQuantity].color = Color.Lerp(minStamina, midStamina, _lerp * 2);
		else
			staminaUI[_circleQuantity].color = Color.Lerp(midStamina, maxStamina, (_lerp - .5f) * 2);
		staminaFade.StopAction();
		if(newStaminaAmount == playerModel.stamina.MaxStamina)
			staminaFadeTimer.StartTimer();
	}
	public void SetSpeed(float value)
	{
		if (value > 0)
			GetComponent<PlayerSound>().PlayWalk();
		else
			GetComponent<PlayerSound>().StopWalk();
		animator.SetFloat(speedParameter, value);
	}
	public void SetFlying(bool value)
	{
		if (value)
		{
			GetComponent<PlayerSound>().PlayFly();
		}
		else
			GetComponent<PlayerSound>().StopFly();

		foreach (TrailRenderer p in glideEffect)
		{
			p.emitting = value;
		}
		animator.SetBool(isFlyingParameter, value);
		cameraView.IsFlying(value);
	}
	public void ShowLandFeedback()
	{
		animator.CrossFade(runningBlendTree, transitionDuration);
	}
	public void ShowJumpFeedback()
	{
		//--
		GetComponent<PlayerSound>().PlayJump();
		cameraView.IsFlying(true);
		animator.Play(jumpAnimation);
	}
	public void ShowClimbFeedback()
	{
		GetComponent<PlayerSound>().StopFly();
		GetComponent<PlayerSound>().StopWalk();
		cameraView.IsFlying(false);
		animator.CrossFade(climbAnimation, transitionDuration);
	}
	public void ShowDeathFeedback()
	{
		animator.CrossFade(deathAnimation, transitionDuration);
	}
	public void SetAccelerationEffect(float lerp)
	{
		lensDistortionSettings.intensity.value = Mathf.Lerp(originalDistorsionIntensity, lensDistortionWhenFlying, BezierHelper.GetSinBezier(lerp));
		staminaRings.localScale = Vector3.Lerp(staminaOriginalScale, Vector3.one * staminaRingsScaleWhenFlying, BezierHelper.GetSinBezier(lerp));
		staminaRings.anchoredPosition = Vector3.Lerp(lastStaminaControlledPosition, StaminaUIOffsetWhenFlying, BezierHelper.GetSinBezier(lerp));
	}
	public void ShowAccelerationFeedback()
	{
		isControllingStaminaPosition = false;
		foreach (TrailRenderer p in accelerationEffect)
		{
			p.emitting = true;
		}
		lastStaminaControlledPosition = staminaRings.anchoredPosition;
	}
	public void StopAccelerationFeedback()
	{
		isControllingStaminaPosition = true;
		foreach (TrailRenderer p in accelerationEffect)
		{
			p.emitting = false;
		}
		staminaRings.localScale = staminaOriginalScale;
		lensDistortionSettings.intensity.value = originalDistorsionIntensity;
	}
	public void PlaySpecificAnimation(string stateName)
	{
		animator.Play(stateName);
	}
	public void ShowPlayerShadow(Vector3 position, Quaternion rotation, float size)
	{
		playerShadow.position = position + playerShadowOffset;
		playerShadow.rotation = rotation;
		playerShadowMaterial.SetFloat("_Size", size);
	}
	public void UpdatePonchoEffect(float collectableQuantity)
	{
		poncho.SetFloat("_Activate", collectableQuantity / PP_Stats.Instance.CollectablesForReward);
		if (collectableQuantity == PP_Stats.Instance.CollectablesForReward)
		{
			audioManager.PlayCharacterSound(reward);
			ponchoTurnOff = new ActionOverTime(ponchoTurnOffTime, FadePoncho);
			ponchoTurnOff.StartAction();
		}
		else if (ponchoTurnOff.IsRunning)
			ponchoTurnOff.StopAction();
	}
	private void FadePoncho(float lerp) => poncho.SetFloat("_Activate", BezierHelper.GetSinBezier(lerp));
}