using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Extensions;
using Core.Helpers;
using Core.References;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Views
{
	public class PitchGlideView : CharacterView
	{
		[SerializeField] private List<InterfaceRef<IIdentifier>> actionIdsToStart = new();
		[SerializeField] private List<InterfaceRef<IIdentifier>> actionIdsToStop = new();
		[SerializeField] private float maxYSpeed;
		[SerializeField] private AnimationCurve pitchCurve = AnimationCurve.EaseInOut(0, 0, 1, 90);
		[SerializeField] private float rotationSpeed = 10.0f;
		
		private Rigidbody _rigidbody;
		private CancellationTokenSource _controlPitchToken;
		private Quaternion _originalRotation;

		/// <inheritdoc />
		public override void Setup(ICharacter data)
		{
			base.Setup(data);
			if (character is not IPhysicsCharacter physicsCharacter)
				this.LogError($"character is not {nameof(IPhysicsCharacter)}.");
			else
				_rigidbody = physicsCharacter.rigidbody;

			if (!TryAddPostBehaviour(actionIdsToStart, StartControllingYaw))
				this.LogError($"Couldn't add behaviour {nameof(StartControllingYaw)}");
			if (!TryAddPreBehaviour(actionIdsToStop, StopControllingPitch))
				this.LogError($"Couldn't add behaviour {nameof(StopControllingPitch)}");
		}

		private void OnDisable()
		{
			RemovePostBehaviour(actionIdsToStop, StartControllingYaw);
			RemovePostBehaviour(actionIdsToStart, StopControllingPitch);
		}

		private UniTask StartControllingYaw(IActor actor, CancellationToken token)
		{
			_originalRotation = transform.rotation;

			_controlPitchToken?.Cancel();
			_controlPitchToken?.Dispose();
			_controlPitchToken = new CancellationTokenSource();
			var linkedToken = CancellationTokenSource.CreateLinkedTokenSource(destroyCancellationToken, _controlPitchToken.Token);
			ControlPitch(linkedToken.Token).Forget();
			return UniTask.CompletedTask;
		}

		private UniTask StopControllingPitch(IActor actor, CancellationToken token)
		{
			_controlPitchToken?.Cancel();
			_controlPitchToken?.Dispose();
			_controlPitchToken = null;
			transform.rotation = _originalRotation;
			return UniTask.CompletedTask;
		}

		private async UniTaskVoid ControlPitch(CancellationToken token)
		{
			while (!token.IsCancellationRequested)
			{
				var ySpeed = Mathf.Abs(_rigidbody.velocity.y);
				ySpeed /= maxYSpeed;
				var euler = transform.localEulerAngles;
				euler.x = Mathf.Lerp(euler.x, pitchCurve.Evaluate(ySpeed), Time.deltaTime * rotationSpeed);
				transform.localEulerAngles = euler;
				await UniTask.Yield();
			}
		}
	}
}
