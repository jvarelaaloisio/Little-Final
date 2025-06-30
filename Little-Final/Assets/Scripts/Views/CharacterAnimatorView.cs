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
			TryAddPostBehaviour(landActionIds, PlayRunningBlendTree);
		}

		private void OnDisable()
		{
			RemovePostBehaviour(jumpActionIds, PlayJumpAnimation);
			RemovePostBehaviour(landActionIds, PlayRunningBlendTree);
		}

		private UniTask PlayJumpAnimation(IActor actor, CancellationToken token)
		{
			animator.Play(jumpParameter.Hash);
			return UniTask.CompletedTask;
		}
		public UniTask PlayRunningBlendTree(IActor actor, CancellationToken token)
		{
			animator.CrossFade(runningBlendTree.Hash, transitionDuration);
			return UniTask.CompletedTask;
		}

		private void Update()
		{
			var speed = character.Velocity.IgnoreY().magnitude;
			animator.SetFloat(speedParameter.Hash, speed);
		}
	}
}