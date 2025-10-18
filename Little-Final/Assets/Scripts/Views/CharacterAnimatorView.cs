using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Extensions;
using Core.Helpers;
using Core.References;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Views
{
	public class CharacterAnimatorView : CharacterView
	{
		[SerializeField] private Animator animator;
		[Header("Animator Parameters")]
		[SerializeField] private AnimatorParameter speedParameter = new("Speed");
		[Space]
		[SerializeField] private AnimatorParameter jumpParameter = new("Jump");
		[SerializeField] private List<InterfaceRef<IIdentifier>> jumpActionIds;
		[Space]
		[SerializeField] private List<InterfaceRef<IIdentifier>> stepActionIds;
		private bool _isStepping;
		[Space]
		[SerializeField] private AnimatorParameter fallParameter = new("Fall");
		[SerializeField] private List<InterfaceRef<IIdentifier>> fallActionIds;
		[Space]
		[SerializeField] private AnimatorParameter runningBlendTree = new ("Running BlendTree");
		[SerializeField] private List<InterfaceRef<IIdentifier>> landActionIds;
		[SerializeField] private float transitionDuration = 0.2f;
		
		protected void Reset()
		{
			animator = GetComponent<Animator>();
		}

		/// <inheritdoc />
		public override void Setup(ICharacter data)
		{
			base.Setup(data);
			TryAddPostBehaviour(jumpActionIds, PlayJumpAnimation);
			TryAddPostBehaviour(fallActionIds, PlayFallAnimation);
			TryAddPostBehaviour(landActionIds, PlayRunningBlendTree);
			TryAddPreBehaviour(stepActionIds, SetIsStepping);
			TryAddPostBehaviour(stepActionIds, UnsetIsStepping);
		}

		private UniTask UnsetIsStepping(IActor arg1, CancellationToken arg2)
		{
			_isStepping = false;
			return UniTask.CompletedTask;
		}

		private UniTask SetIsStepping(IActor arg1, CancellationToken arg2)
		{
			_isStepping = true;
			return UniTask.CompletedTask;
		}

		private void OnDisable()
		{
			RemovePostBehaviour(jumpActionIds, PlayJumpAnimation);
			RemovePostBehaviour(fallActionIds, PlayFallAnimation);
			RemovePostBehaviour(landActionIds, PlayRunningBlendTree);
		}

		private UniTask PlayJumpAnimation(IActor actor, CancellationToken token)
		{
			jumpParameter.Play(animator);
			return UniTask.CompletedTask;
		}

		private UniTask PlayFallAnimation(IActor actor, CancellationToken token)
		{
			fallParameter.Play(animator);
			return UniTask.CompletedTask;
		}

		public UniTask PlayRunningBlendTree(IActor actor, CancellationToken token)
		{
			runningBlendTree.CrossFade(animator, transitionDuration);
			return UniTask.CompletedTask;
		}

		private void Update()
		{
			var speed = character.Velocity.IgnoreY().magnitude;
			speedParameter.SetFloat(animator, speed);
		}
	}
}