using System;
using Core.Providers;
using Events.Channels;
using Player.States;
using UnityEngine;
using UnityEngine.Events;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player
{
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


		public string isInputParameter,
			isFlyingParameter;

		private void Awake()
		{
			cameraProvider.TrySetValue(GetComponent<Camera>());
		}

		private void Start()
		{
			view.Controller.OnStateChanges += HandleStateChange;
		}

		private void OnEnable()
		{
			pauseChannel.SubscribeSafely(SetPause);
			UpdateManager.Subscribe(this);
		}

		private void OnDisable()
		{
			pauseChannel.Unsubscribe(SetPause);
			UpdateManager.UnSubscribe(this);
		}

		private void HandleStateChange(State state) =>
			animator.SetBool(
							isFlyingParameter,
							state is Fly
							);

		public void OnLateUpdate()
		{
			float cameraInput
				= Mathf.Abs(Input.GetAxis(CAMERA_X))
				+ Mathf.Abs(Input.GetAxis(CAMERA_Y));
			animator.SetBool(
							isInputParameter,
							cameraInput > 0);
		}

		private void SetPause(bool value)
			=> animator.SetBool(isPause, value);

		public void IsFlying(bool value)
			=> animator.SetBool(isFlyingParameter, value);
	}
}