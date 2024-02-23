using System;
using System.Collections.Generic;
using Core.Providers;
using HealthSystem.Runtime;
using HealthSystem.Runtime.Components;
using UnityEngine;
using UnityEngine.Events;
//using UnityEngine.Rendering.PostProcessing;
using UnityEngine.UI;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player
{
	public class PlayerView : MonoBehaviour, IUpdateable
	{
		private const string PONCHO_ACTIVATE_FLOAT = "_Activate";
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

		[SerializeField]
		private Vector3 staminaUIOffset;

		[SerializeField]
		private Vector3 staminaUIOffsetWhenFlying;

		public RectTransform staminaRings;
		public float staminaRingsScaleWhenFlying;
		public float lensDistortionWhenFlying;
		private Camera _mainCamera;

		private Vector3 _lastStaminaControlledPosition,
			_staminaOriginalScale;

		public List<Image> staminaUI;
		public string runningBlendTree;
		public string jumpAnimation;
		public string longJumpAnimation;
		public string climbAnimation;
		public string deathAnimation;
		public string speedParameter = "Speed";
		public string isFlyingParameter = "isFlying";
		
		[SerializeField]
		private string pickBool = "isPicking";
		
		[SerializeField]
		private string throwTrigger = "throw";

		public float transitionDuration;
		public Transform playerShadow;
		public Material playerShadowMaterial;

		[Header("Poncho")]
		[SerializeField]
		private Renderer ponchoRenderer;

		[SerializeField]
		private Material poncho;

		public float ponchoTurnOffTime;
		private ActionOverTime ponchoTurnOff;
		public Vector3 playerShadowOffset;
		public Animator animator;
		private bool _isControllingStaminaPosition = true;
		CameraView cameraView;
		ActionOverTime staminaFade;
		CountDownTimer staminaFadeTimer;
		//private LensDistortion lensDistortionSettings;
		private float originalDistorsionIntensity;

		public TrailRenderer[] glideEffect,
			accelerationEffect;

		public bool IsFlying => glideEffect[0].emitting;

		public PlayerController Controller => controller;

		[SerializeField]
		private PlayerController controller;

		[SerializeField]
		private Image blackScreen;

		[SerializeField]
		private AnimationCurve screenFade;

		[SerializeField]
		private float deathFadeDuration;


		private int _sceneIndex;

		[SerializeField]
		private float shadowMinDot;

		[Header("Events")]
		[SerializeField]
		private UnityEvent onJump;

		[SerializeField]
		private UnityEvent onLongJump;

		private IHealthComponent _healthComponent;

		private static readonly int Activate = Shader.PropertyToID(PONCHO_ACTIVATE_FLOAT);
		private void Start()
		{
			//CREATE TEMPORAL MATERIAL INSTANCES SO WE DON'T GET UNWANTED GIT CHANGES.
#if UNITY_EDITOR
			Renderer renderer = playerShadow.GetComponent<Renderer>();
			renderer.sharedMaterial = new Material(playerShadowMaterial);
			playerShadowMaterial = renderer.sharedMaterial;
			ponchoRenderer.sharedMaterial = new Material(poncho);
			poncho = ponchoRenderer.sharedMaterial;
#endif
			controller.onStaminaChange += UpdateStamina;
			controller.OnPickCollectable += UpdatePonchoEffect;
			controller.Stamina.OnMaxStaminaUpgrade += _ => ShowStaminaUpgradeFeedback();
			controller.OnChangeSpeed += SetSpeed;
			controller.OnSpecificAction += PlaySpecificAnimation;
			controller.OnJump += ShowJumpFeedback;
			controller.OnLongJump += ShowLongJumpFeedback;
			controller.OnLand += ShowLandFeedback;
			controller.OnClimb += ShowClimbFeedback;
			controller.onPick.AddListener(ShowPickFeedback);
			controller.onPutDown.AddListener(ShowPutDownFeedback);
			controller.onThrowing.AddListener(ShowThrowingFeedback);
			controller.onThrew.AddListener(ShowThrewFeedback);
			controller.OnMount.AddListener(ShowMountingFeedback);
			controller.OnRide.AddListener(ShowRideFeedback);
			controller.OnGlideChanges += SetFlying;
			audioManager = FindObjectOfType<AudioManager>();
			_sceneIndex = gameObject.scene.buildIndex;
			staminaFade = new ActionOverTime(staminaFadeTime, SetStaminaTransparency, _sceneIndex, true);
			staminaFadeTimer = new CountDownTimer(staminaFadeDelay, staminaFade.StartAction, _sceneIndex);
			cameraView = FindObjectOfType<CameraView>();
			staminaUI.ForEach(ui => ui.color = maxStamina);
			SetStaminaTransparency(1);
			_staminaOriginalScale = staminaRings.localScale;
			//TODO: Limpiá esto, sucio de mierda
			_mainCamera = Camera.main;
			//if ((_mainCamera = Camera.main).TryGetComponent(out PostProcessVolume postProcessVolume))
			//	if (postProcessVolume.profile.TryGetSettings(out lensDistortionSettings))
			//	{
			//		originalDistorsionIntensity = lensDistortionSettings.intensity;
			//	}

			FadePoncho(0);
			ponchoTurnOff = new ActionOverTime(ponchoTurnOffTime, FadePoncho, _sceneIndex);
		}

		private void ShowMountingFeedback()
		{
			
		}

		private void ShowRideFeedback()
		{
			GetComponent<PlayerSound>().StopWalk();
		}

		private void OnValidate()
		{
			_healthComponent ??= GetComponent<IHealthComponent>();
		}

		private void OnEnable()
		{
			UpdateManager.Subscribe(this);
			if (_healthComponent is { Health: not null })
				_healthComponent.Health.OnDeath += ShowDeathFeedback;
		}

		private void OnDisable()
		{
			UpdateManager.UnSubscribe(this);
			if (_healthComponent is { Health: not null })
				_healthComponent.Health.OnDeath -= ShowDeathFeedback;
		}

		public void OnUpdate()
		{
			ShowPlayerShadow();
			if (!_isControllingStaminaPosition)
				return;
			Vector3 staminaPosition = _mainCamera.WorldToScreenPoint(transform.position) + staminaUIOffset;
			staminaRings.position = Vector3.Lerp(staminaRings.position, staminaPosition,
												Time.deltaTime * staminaFollowSpeed);
		}

		/// <summary>
		/// Sets the transparency of all the stamina circles to the given value
		/// </summary>
		/// <param name="transparencyLevel">level of transparency (0 - 1).
		/// 0: Fully visible
		/// 1: Not visible</param>
		private void SetStaminaTransparency(float transparencyLevel)
		{
			foreach (Image ui in staminaUI)
			{
				Color color = ui.color;
				color.a = 1 - transparencyLevel;
				ui.color = color;
			}
		}

		public void UpdateStamina(float newStaminaAmount)
		{
#if DISABLE_UI
			SetStaminaTransparency(1);
			return;
#endif
			SetStaminaTransparency(0);
			int circleQty = Mathf.FloorToInt(newStaminaAmount / staminaPerCircle);
			for (int i = 0; i < staminaUI.Count; i++)
			{
				if (i < circleQty)
				{
					staminaUI[i].fillAmount = 1;
					staminaUI[i].color = maxStamina;
				}
				else
					staminaUI[i].fillAmount = 0;
			}

			if (circleQty < 0
				|| circleQty >= staminaUI.Count)
				return;

			float lastCircleFillAmount = newStaminaAmount % staminaPerCircle;
			float lastCircleLerp = lastCircleFillAmount / staminaPerCircle;
			staminaUI[circleQty].fillAmount = lastCircleLerp;
			staminaUI[circleQty].color
				= lastCircleLerp < .5f
					? Color.Lerp(minStamina, midStamina, lastCircleLerp * 2)
					: Color.Lerp(midStamina, maxStamina, (lastCircleLerp - .5f) * 2);
			staminaFade.StopAction();
			//--CUIDAO
			if (Math.Abs(newStaminaAmount - controller.Stamina.MaxStamina)
				< 0.05f)
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
			// cameraView.IsFlying(value);
		}

		public void ShowLandFeedback()
		{
			animator.CrossFade(runningBlendTree, transitionDuration);
		}

		public void ShowJumpFeedback()
		{
			onJump.Invoke();
			animator.Play(jumpAnimation);
		}
		
		public void ShowLongJumpFeedback()
		{
			onLongJump.Invoke();
			animator.Play(longJumpAnimation);
		}

		public void ShowClimbFeedback()
		{
			GetComponent<PlayerSound>().StopFly();
			GetComponent<PlayerSound>().StopWalk();
			animator.CrossFade(climbAnimation, transitionDuration);
		}

		private void ShowPickFeedback()
		{
			animator.SetBool(pickBool, true);
		}

		private void ShowPutDownFeedback()
		{
			animator.SetBool(pickBool, false);
		}

		private void ShowThrowingFeedback()
		{
			animator.SetTrigger(throwTrigger);
		}
		
		private void ShowThrewFeedback()
		{
			animator.SetBool(pickBool, false);
		}
		
		public void ShowDeathFeedback()
		{
			animator.CrossFade(deathAnimation, transitionDuration);
			new ActionOverTime(deathFadeDuration,
								(lerp) => blackScreen.color = new Color(0, 0, 0, screenFade.Evaluate(lerp)),
								_sceneIndex, true)
				.StartAction();
		}

		public void SetAccelerationEffect(float lerp)
		{
			//lensDistortionSettings.intensity.value = Mathf.Lerp(originalDistorsionIntensity, lensDistortionWhenFlying,
			//													BezierHelper.GetSinBezier(lerp));
			staminaRings.localScale = Vector3.Lerp(_staminaOriginalScale, Vector3.one * staminaRingsScaleWhenFlying,
													BezierHelper.GetSinBezier(lerp));
			staminaRings.anchoredPosition = Vector3.Lerp(_lastStaminaControlledPosition, staminaUIOffsetWhenFlying,
														BezierHelper.GetSinBezier(lerp));
		}

		public void ShowAccelerationFeedback()
		{
			_isControllingStaminaPosition = false;
			foreach (TrailRenderer p in accelerationEffect)
			{
				p.emitting = true;
			}

			_lastStaminaControlledPosition = staminaRings.anchoredPosition;
		}

		public void StopAccelerationFeedback()
		{
			_isControllingStaminaPosition = true;
			foreach (TrailRenderer p in accelerationEffect)
			{
				p.emitting = false;
			}

			staminaRings.localScale = _staminaOriginalScale;
			//lensDistortionSettings.intensity.value = originalDistorsionIntensity;
		}

		public void PlaySpecificAnimation(string stateName)
		{
			animator.Play(stateName);
		}

		private void ShowPlayerShadow()
		{
			if (!Physics.Raycast(
								transform.position,
								Vector3.down,
								out RaycastHit hit,
								100,
								LayerMask.GetMask("Default", "Floor", "NonClimbable", "OnlyForShadows"),
								QueryTriggerInteraction.Collide))
				return;
			Debug.DrawLine(transform.position, hit.point, Color.white);
			float shadowSize = Mathf.Clamp(hit.distance, 0, 1);
			float absDot = Mathf.Abs(Vector3.Dot(Vector3.down, hit.normal));
			if (absDot < shadowMinDot)
				shadowSize = 0;
			playerShadow.position = hit.point + playerShadowOffset;
			playerShadow.rotation = Quaternion.FromToRotation(Vector3.up, hit.normal);
			playerShadowMaterial.SetFloat("_Size", shadowSize);
		}

		public void UpdatePonchoEffect(float collectableQuantity)
		{
			poncho.SetFloat("_Activate", collectableQuantity / PP_Stats.CollectablesForReward);
			if (collectableQuantity == PP_Stats.CollectablesForReward)
			{
				ShowStaminaUpgradeFeedback();
			}
			else if (ponchoTurnOff.IsRunning)
				ponchoTurnOff.StopAction();
		}

		private void ShowStaminaUpgradeFeedback()
		{
			audioManager.PlayCharacterSound(reward);
			ponchoTurnOff = new ActionOverTime(ponchoTurnOffTime, FadePoncho, _sceneIndex);
			ponchoTurnOff.StartAction();
		}

		private void FadePoncho(float lerp) => poncho.SetFloat(Activate, BezierHelper.GetSinBezier(lerp));

		private void OnDrawGizmos()
		{
			Gizmos.color = Color.blue;
			Gizmos.DrawLine(transform.position, controller.LastSafePosition);
		}

		private void OnGUI()
		{
#if DISABLE_UI
			return;
#endif
#if UNITY_EDITOR
			Rect rect = new Rect(10, 400, 250, 550);
			GUILayout.BeginArea(rect);
			GUI.skin.label.fontSize = 15;
			GUI.skin.label.normal.textColor = Color.white;
			GUILayout.Label("State: " + controller.State.GetType());
			GUI.skin.label.normal.textColor = controller.Stamina.IsRefillingActive ? Color.green : Color.red;

			GUILayout.Label("Stamina: " + controller.Stamina.FillState);
			GUILayout.EndArea();
#endif
		}
	}
}