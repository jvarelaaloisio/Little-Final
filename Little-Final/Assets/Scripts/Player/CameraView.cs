using System;
using Core.Providers;
using Events.Channels;
using Player.PlayerInput;
using Player.States;
using UnityEngine;
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

		private void Start()
		{
			view.Controller.OnStateChanges += HandleStateChange;
		}

		private void OnEnable()
		{
			pauseChannel.SubscribeSafely(SetPause);
			UpdateManager.Subscribe(this);
			cameraProvider.TrySetValue(GetComponent<Camera>());
		}

		private void OnDisable()
		{
			pauseChannel.Unsubscribe(SetPause);
			UpdateManager.UnSubscribe(this);
			cameraProvider.TrySetValue(null);
		}

		private void HandleStateChange(State state)
		{
			animator.SetBool(isFlyingParameter,
			                 state is Fly);
			animator.SetBool(isClimbingParameter,
			                 state is Climb);
		}

		private void Update()
		{
			// if (InputManager.CheckCameraResetInput())
			// 	animator.SetTrigger("lock");
				animator.SetBool(isLockingParameter, InputManager.CheckCameraResetInput());
		}

		public void OnLateUpdate()
		{
			float cameraInput
				= Mathf.Abs(Input.GetAxis(CAMERA_X))
				+ Mathf.Abs(Input.GetAxis(CAMERA_Y));
			animator.SetBool(isInputParameter,
			                 cameraInput > 0);
		}

		private void SetPause(bool value)
			=> animator.SetBool(isPause, value);

		public void IsFlying(bool value)
			=> animator.SetBool(isFlyingParameter, value);
	}
}