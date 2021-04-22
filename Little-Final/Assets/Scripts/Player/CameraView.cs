using Player.States;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player
{
	public class CameraView : MonoBehaviour, ILateUpdateable
	{
		private const string CAMERA_X = "Camera X";
		private const string CAMERA_Y = "Mouse Y";
		public Animator animator;
		[SerializeField] private PlayerView view;

		public string isInputParameter,
			isFlyingParameter;

		private void Start()
		{
			view.Controller.OnStateChanges += HandleStateChange;
			UpdateManager.Subscribe(this);
		}

		private void HandleStateChange(State state) =>
			animator.SetBool(
				isFlyingParameter,
				state is Glide
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

		public void IsFlying(bool value)
			=> animator.SetBool(isFlyingParameter, value);
	}
}