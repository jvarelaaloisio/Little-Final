using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Extensions;
using Core.Helpers;
using Core.References;
using Cysharp.Threading.Tasks;
using UnityEngine;
using UnityEngine.Serialization;

namespace Views
{
	public class PitchGlideView : CharacterView
	{
		[SerializeField] private List<InterfaceRef<IIdentifier>> actionIdsToStart = new();
		[SerializeField] private List<InterfaceRef<IIdentifier>> actionIdsToStop = new();
		[SerializeField] private float maxSpeed = 1.0f;
		[SerializeField] private AnimationCurve pitchCurve = AnimationCurve.EaseInOut(0, 0, 1, 90);
		[SerializeField] private float rotationSpeed = 10.0f;
		
		private Rigidbody _rigidbody;
		private CancellationTokenSource _controlPitchToken;
		private float _originalPitch;
		private CancellationTokenSource _resetToken;

		/// <inheritdoc />
		public override void Setup(ICharacter data)
		{
			base.Setup(data);
			if (character is not IPhysicsCharacter physicsCharacter)
				this.LogError($"character is not {nameof(IPhysicsCharacter)}.");
			else
				_rigidbody = physicsCharacter.Body;

			if (!TryAddPostBehaviour(actionIdsToStart, StartControllingPitch))
				this.LogError($"Couldn't add behaviour {nameof(StartControllingPitch)}");
			if (!TryAddPreBehaviour(actionIdsToStop, StopControllingPitch))
				this.LogError($"Couldn't add behaviour {nameof(StopControllingPitch)}");
			_originalPitch = transform.localEulerAngles.x;
		}

		private void OnDisable()
		{
			RemovePostBehaviour(actionIdsToStop, StartControllingPitch);
			RemovePostBehaviour(actionIdsToStart, StopControllingPitch);
		}

		private UniTask StartControllingPitch(IActor actor, CancellationToken token)
		{
			_resetToken?.Cancel();
			_resetToken?.Dispose();
			_resetToken = null;
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
			
			Reset();
			return UniTask.CompletedTask;

			void Reset()
			{
				_controlPitchToken?.Cancel();
				_controlPitchToken?.Dispose();
				_resetToken = CancellationTokenSource.CreateLinkedTokenSource(token, destroyCancellationToken);
				ResetPitch(_resetToken.Token).Forget();
			}
		}

		private async UniTaskVoid ResetPitch(CancellationToken token)
		{
			var euler = transform.localEulerAngles;
			var finalPitch = euler.x;
			var start = Time.time;
			float now = 0;
			do
			{
				now = Time.time;
				var lerp = (now - start) / .1f;
				
				euler.x = Mathf.Lerp(finalPitch, _originalPitch, lerp);
				transform.localEulerAngles = euler;
				await UniTask.NextFrame(token);
			} while (now < start + .1f && !token.IsCancellationRequested);
		}

		private async UniTaskVoid ControlPitch(CancellationToken token)
		{
			while (!token.IsCancellationRequested)
			{
				var speed = transform.InverseTransformDirection(_rigidbody.velocity).IgnoreY().magnitude;
				speed /= maxSpeed;
				var euler = transform.localEulerAngles;
				euler.x = Mathf.Lerp(euler.x, pitchCurve.Evaluate(speed), Time.deltaTime * rotationSpeed);
				transform.localEulerAngles = euler;
				await UniTask.NextFrame(token);
			}
		}
	}
}
