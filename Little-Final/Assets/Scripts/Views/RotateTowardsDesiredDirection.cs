using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Debugging;
using Core.Extensions;
using Core.Helpers;
using Core.References;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Views
{
	public class RotateTowardsDesiredDirection : CharacterView
	{
		[SerializeField] private float speed = 15.0f;
		[SerializeField] private InterfaceRef<IIdentifier> directionId;

		[SerializeField] private List<InterfaceRef<IIdentifier>> actionIdsToDisable = new();
		[SerializeField] private List<InterfaceRef<IIdentifier>> actionIdsToEnable = new();
		[Header("Optional")]
		[SerializeField, Tooltip("Can be null")] private InterfaceRef<IProcessor<Vector3>> directionPreprocessor;

		[Header("Debugging")]
		[SerializeField] private Debugger debugger;
		[SerializeField] private string debugTag;
		[SerializeField] private Color currentForwardColor = new(0.5f, 0.5f, 0.5f, 0.5f);
		[SerializeField] private Color desiredDirectionColor = new(1f, 1f, 1f, 0.5f);

		private ICharacter _character;
		private IActor<ReverseIndexStore> _actor;

		/// <inheritdoc />
		public override void Setup(ICharacter data)
		{
			base.Setup(data);
			character = data;
			if (character.Actor is not IActor<ReverseIndexStore> actor)
			{
				this.LogError($"character.Actor is not {nameof(IActor<ReverseIndexStore>)}.");
				enabled = false;
				return;
			}

			if (!TryAddPostBehaviour(actionIdsToDisable, DisableSelf))
				this.LogError($"Couldn't add behaviour {nameof(DisableSelf)}");
			if (!TryAddPreBehaviour(actionIdsToEnable, EnableSelf))
				this.LogError($"Couldn't add behaviour {nameof(EnableSelf)}");
			_actor = actor;
		}

		private void Update()
		{
			if (_actor.Data[typeof(Vector3), directionId.Ref] is not Vector3 direction)
			{
				debugger.LogError(debugTag, "Direction is not Vector3!");
				return;
			}

			if (direction.magnitude < 0.01f)
				return;

			if (directionPreprocessor.HasValue)
				direction = directionPreprocessor.Ref.Process(direction, character.transform);
			
			direction.Normalize();
			var targetYaw = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg;

			var currentEuler = transform.eulerAngles;
			var currentYaw = currentEuler.y;

			var newYaw = Mathf.LerpAngle(currentYaw, targetYaw, speed * Time.deltaTime);

			transform.rotation = Quaternion.Euler(currentEuler.x, newYaw, currentEuler.z);
			debugger.DrawRay(debugTag, transform.position, transform.forward, currentForwardColor);
			debugger.DrawRay(debugTag, transform.position, direction, desiredDirectionColor);
		}

		private UniTask DisableSelf(IActor actor, CancellationToken token)
        {
            enabled = false;
            return UniTask.CompletedTask;
        }

		private UniTask EnableSelf(IActor actor, CancellationToken token)
        {
            enabled = true;
            return UniTask.CompletedTask;
        }
	}
}