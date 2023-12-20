using System;
using System.Collections;
using Core;
using UnityEngine;

namespace Platforms
{
	public class FloatingRockEmissionScaler : MonoBehaviour
	{
		[SerializeField]
		private float minimumDistance = 1;

		[SerializeField]
		private float maximumDistance = 3;
		
		[SerializeField]
		private float ignoreDistance = 8;

		[SerializeField]
		private float periodWhenPlayerIsAway = 0.5f;

		[SerializeField]
		private float checkIfThereIsPlayerPeriod = 5;

		[Header("Shader Properties")]
		[SerializeField]
		private string emissionFactorProperty = "_EmissionFac";

		private int _emissionFactorId;

		[SerializeField]
		private GameManager gameManager;

		[Header("Setup")]
		[SerializeField]
		private Renderer renderer;

		private Material _material;
		private Transform _player;
		private WaitForSeconds waitPeriodWhenPlayerIsAway;

		private void OnValidate()
		{
			if (!renderer) TryGetComponent(out renderer);
		}

		private IEnumerator Start()
		{
			_player = gameManager.Player;
			while (!_player)
			{
				yield return new WaitForSeconds(checkIfThereIsPlayerPeriod);
				_player = gameManager.Player;
			}

			//CREATE TEMPORAL MATERIAL INSTANCES SO WE DON'T GET UNWANTED GIT CHANGES.
#if UNITY_EDITOR
				var tempMat = renderer.sharedMaterial;
				renderer.sharedMaterial = new Material(tempMat);
#endif
				_material = renderer.sharedMaterial;

			var shader = _material.shader;
			_emissionFactorId = shader.GetPropertyNameId(shader.FindPropertyIndex(emissionFactorProperty));
			waitPeriodWhenPlayerIsAway = new WaitForSeconds(periodWhenPlayerIsAway);
			while (!destroyCancellationToken.IsCancellationRequested && _player != null)
			{
				float distance = Vector3.Distance(_player.position, transform.position);
				if (distance > ignoreDistance)
				{
					yield return waitPeriodWhenPlayerIsAway;
				}
				else
				{
					float emissionValue = distance < minimumDistance
											? 1
											: Mathf.Lerp(1, 0, distance / maximumDistance);

					_material.SetFloat(_emissionFactorId, emissionValue);
					yield return null;
				}
			}
		}

		private void OnDisable()
		{
			StopCoroutine(Start());
		}

		private void OnDestroy()
		{
			OnDisable();
		}
	}
}