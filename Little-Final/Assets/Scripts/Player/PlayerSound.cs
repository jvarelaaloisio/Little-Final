using System;
using System.Collections;
using Core.Debugging;
using Core.Extensions;
using Core.Providers;
using UnityEngine;
using Random = UnityEngine.Random;

namespace Player
{
	[RequireComponent(typeof(PlayerController))]
	public class PlayerSound : MonoBehaviour
	{
		[SerializeField] private DataProvider<AudioManager> audioManagerProvider;
		[SerializeField] private PlayerController playerController;
		public AudioClip walk,
		                 fly;

		[SerializeField] private AudioClip[] jumpSfx;
		[SerializeField] private AudioClip[] landSfx;
		[SerializeField] private AudioClip[] walkSfx;
		[SerializeField] private AudioClip[] mountSfx;


		public AudioSource loopingSfx;

		private bool _isWalkPlaying,
		             _isFlyPlaying;

		[Header("Debug")]
		[SerializeField]
		private Debugger debugger;


		private void OnValidate()
		{
			playerController ??= GetComponent<PlayerController>();
		}

		private void OnEnable()
		{
			if (!playerController)
			{
				this.LogWarning($"{nameof(playerController)} is null!");
				return;
			}

			playerController.OnLand += HandleLand;
			playerController.OnJump += PlayJump;
			playerController.OnMount.AddListener(HandleMount);
		}

		private void OnDisable()
		{
			if (!playerController)
				return;

			playerController.OnLand -= HandleLand;
			playerController.OnJump -= PlayJump;
			playerController.OnMount.RemoveListener(HandleMount);
		}

		private void HandleLand() => Play(landSfx);

		public void PlayJump()
		{
			loopingSfx.Stop();
			_isWalkPlaying = false;
			_isFlyPlaying = false;
			if (jumpSfx.Length < 1)
				debugger.LogError(transform.name, $"No jump sfx were supplied");
			else
				Play(jumpSfx);
		}

		private void HandleMount()
		{
			Play(mountSfx);
		}

		[Obsolete]
		public void PlayWalk()
		{
			if (_isWalkPlaying)
				return;
			_isWalkPlaying = true;
			if (walkSfx.Length < 1)
				debugger.LogError(transform.name, $"No walk sfx were supplied");
			else
				loopingSfx.clip = walkSfx[Random.Range(0, walkSfx.Length - 1)];
			loopingSfx.Play();
		}

		[Obsolete]
		public void StopWalk()
		{
			loopingSfx.Stop();
			_isWalkPlaying = false;
		}

		public void PlayFly()
		{
			if (!_isFlyPlaying)
			{
				_isFlyPlaying = true;
				loopingSfx.clip = fly;
				loopingSfx.Play();
			}
		}

		public void StopFly()
		{
			loopingSfx.Stop();
			_isFlyPlaying = false;
		}

		public void Play(AudioClip[] sfx)
		{
			if (sfx == null || sfx.Length < 1)
			{
				this.LogWarning($"No sfx provided!");
				return;
			}
			if (audioManagerProvider.TryGetValue(out var manager))
				manager.Play(sfx[Random.Range(0, sfx.Length)], AudioManager.SoundIndex.Character);
		}
	}
}