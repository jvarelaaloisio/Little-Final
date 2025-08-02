using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using Characters;
using Core.Extensions;
using Core.References;
using Cysharp.Threading.Tasks;
using DataProviders.Async;
using UnityEngine;
using UnityEngine.UI;

namespace Views
{
	public class StaminaRingsView : MonoBehaviour
	{
		[SerializeField] private InterfaceRef<IDataProviderAsync<ICharacter>> characterProvider;

		[SerializeField] private List<Image> rings;
		
		[SerializeField] private Color maxStamina = new(0.002500772f, 1, 0, 0.5882353f);
		[SerializeField] private Color midStamina = new(1, 1, 0, 0.7843137f);
		[SerializeField] private Color minStamina = Color.red;
		[SerializeField] private AnimationCurve fadeCurve = AnimationCurve.EaseInOut(0, 1, 1, 0);

		[SerializeField] private float staminaPerRing = 100;
		[SerializeField] private float fadeDelay = 1;
		[SerializeField] private float fadeDuration = 2;
		
		private CancellationTokenSource _enableToken;
		private CancellationTokenSource _fadeToken;
		private ICharacter _character;

		private void Reset()
			=> rings = new List<Image>(GetComponentsInChildren<Image>());

		private async void OnEnable()
		{
			if (characterProvider.Ref == null)
			{
				this.LogError($"{nameof(characterProvider)} is null!");
				return;
			}
			try
			{
				_enableToken = new CancellationTokenSource();
				var linkedSource = CancellationTokenSource.CreateLinkedTokenSource(destroyCancellationToken,
				                                                                   _enableToken.Token);
				_character = await characterProvider.Ref.GetValueAsync(linkedSource.Token);
				_character.Stamina.OnChange += HandleStaminaChanged;
				_character.Stamina.OnRefilled += StartFade;
				SetRingsAlpha(0);
			}
			catch (Exception e)
			{
				Debug.LogException(e, this);
			}
		}

		private void Start()
		{
			rings.ForEach(ui => ui.color = maxStamina);
		}

		private void OnDisable()
		{
			_enableToken?.Cancel();
			_enableToken?.Dispose();
			_enableToken = null;
			if (_character is not { Stamina: not null })
				return;
			_character.Stamina.OnChange -= HandleStaminaChanged;
			_character.Stamina.OnRefilled -= StartFade;
		}

		public void HandleStaminaChanged(float before, float after, float max)
		{
#if ENABLE_UI
			SetRingsAlpha(1);
			int circleQty = Mathf.FloorToInt(after / staminaPerRing);
			for (int i = 0; i < rings.Count; i++)
			{
				if (i < circleQty)
				{
					rings[i].fillAmount = 1;
					rings[i].color = maxStamina;
				}
				else
					rings[i].fillAmount = 0;
			}

			if (circleQty < 0
			    || circleQty >= rings.Count)
				return;

			float lastCircleFillAmount = after % staminaPerRing;
			float lastCircleLerp = lastCircleFillAmount / staminaPerRing;
			rings[circleQty].fillAmount = lastCircleLerp;
			rings[circleQty].color
				= lastCircleLerp < .5f
					  ? Color.Lerp(minStamina, midStamina, lastCircleLerp * 2)
					  : Color.Lerp(midStamina, maxStamina, (lastCircleLerp - .5f) * 2);
			_fadeToken?.Cancel();
			_fadeToken?.Dispose();
			_fadeToken = null;
#else
			SetRingsAlpha(0);
			return;
#endif
		}

		private void StartFade()
		{
			_fadeToken?.Cancel();
			_fadeToken?.Dispose();
			_fadeToken = new CancellationTokenSource();
			var linkedToken = CancellationTokenSource.CreateLinkedTokenSource(_enableToken.Token, _fadeToken.Token);
			Fade(fadeDelay, fadeDuration, linkedToken.Token).Forget();
		}

		private async UniTaskVoid Fade(float delay, float duration, CancellationToken token)
		{
			if (delay > 0)
				await UniTask.WaitForSeconds(delay, cancellationToken: token);
			var start = Time.time;
			float now = 0;
			do
			{
				now = Time.time;
				var lerp = (now - start) / duration;
				SetRingsAlpha(fadeCurve.Evaluate(lerp));
				await UniTask.Yield(token);
			} while (now < start + duration);
		}

		/// <summary>
		/// Sets the transparency of all the stamina circles to the given value
		/// </summary>
		/// <param name="alpha">level of transparency (0 - 1)</param>
		private void SetRingsAlpha(float alpha)
		{
			foreach (var ui in rings)
			{
				var color = ui.color;
				color.a = alpha;
				ui.color = color;
			}
		}
	}
}
