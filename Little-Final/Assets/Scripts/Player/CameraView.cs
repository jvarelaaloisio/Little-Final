using System;
using System.Collections;
using Core.Extensions;
using Core.Providers;
using Events.Channels;
using Player.PlayerInput;
using Player.States;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player
{
	[RequireComponent(typeof(Camera))]
	public class CameraView : MonoBehaviour, ILateUpdateable
	{
		private const string CAMERA_X = "Camera X";
		private const string CAMERA_Y = "Mouse Y";
		public Animator animator;

		[SerializeField] private DataProvider<Camera> cameraProvider;
		
		[SerializeField]
		private PlayerView view;

		[Header("Animator Parameters")]
		[SerializeField]
		private string isPause = "isPause";

		[SerializeField]
		[Tooltip("Can be null")]
		private BoolEventChannel pauseChannel;

		public string isInputParameter;

		public string isFlyingParameter;

		[SerializeField] private string isClimbingParameter = "isClimbing";
		[SerializeField] private string isLockingParameter = "isLocking";
		[SerializeField] private string lockParameter = "lock";
		
		[Header("PostProcesses")]
		[SerializeField] private PostProcessVolume buffVolume;
		[SerializeField] private float buffVolumeMinimum = 1.5f;
		[SerializeField] private PostProcessVolume flightVolume;
		[SerializeField] private AnimationCurve buffOnOffCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);
		private Coroutine _buffVolumeCoroutine;

		private IEnumerator Start()
		{
			SetLock(true);
			yield return null;
			while (!destroyCancellationToken.IsCancellationRequested)
			{
				SetLock(InputManager.CheckCameraResetInput());
				yield return null;
			}
		}

		private void OnEnable()
		{
			pauseChannel.SubscribeSafely(SetPause);
			UpdateManager.Subscribe(this);
			cameraProvider.TrySetValue(GetComponent<Camera>());
			if (view?.Controller)
			{
				view.Controller.OnStateChanges += HandleStateChange;
				view.Controller.onBuffed.AddListener(HandleBuffChanged);
			}
		}

		private void OnDisable()
		{
			pauseChannel.Unsubscribe(SetPause);
			UpdateManager.UnSubscribe(this);
			cameraProvider.TrySetValue(null);
			if (view?.Controller)
			{
				view.Controller.OnStateChanges -= HandleStateChange;
				view.Controller.onBuffed.RemoveListener(HandleBuffChanged);
			}
		}

		private void HandleStateChange(State state)
		{
			var isFly = state is Fly;
			animator.SetBool(isFlyingParameter,
			                 isFly);
			if (flightVolume)
				flightVolume.weight = isFly ? 1 : 0;
			animator.SetBool(isClimbingParameter,
			                 state is Climb);
		}

		private void SetLock(bool resetInput)
		{
			animator.SetBool(isLockingParameter, resetInput);
		}

		public void OnLateUpdate()
		{
			float cameraInput
				= Mathf.Abs(Input.GetAxis(CAMERA_X))
				+ Mathf.Abs(Input.GetAxis(CAMERA_Y));
			animator.SetBool(isInputParameter,
			                 cameraInput > 0);
		}

		private void HandleBuffChanged(float buffMultiplier)
		{
			buffVolume.weight = buffMultiplier >= buffVolumeMinimum ? 1 : 0;
		}

		private IEnumerator LerpVolumeWeight(PostProcessVolume volume, AnimationCurve curve, float targetValue)
		{
			var origin = volume.weight;
			var start = Time.time;
			float now = 0;
			do
			{
				now = Time.time;
				var lerp = (now - start);
				var slerp = curve.Evaluate(lerp);
				volume.weight = Mathf.Lerp(origin, targetValue, slerp);
				yield return null;
			} while (now < start + curve.Duration());
		}

		private void SetPause(bool value)
			=> animator.SetBool(isPause, value);

		public void IsFlying(bool value)
			=> animator.SetBool(isFlyingParameter, value);
	}
}