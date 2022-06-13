using System;
using System.Collections;
using System.Collections.Generic;
using Core.Debugging;
using Core.Helpers;
using UnityEngine;

namespace Extras
{
	public class FloatParameterRandomizer : MonoBehaviour
	{
		[Header("Setup")]
		[SerializeField]
		private string parameterName;

		[SerializeField]
		private WeightedFloat[] values;

		[Header("\tRepeat")]
		[SerializeField]
		private bool shouldRepeat = true;

		[SerializeField]
		private float setPeriod = 1;

		[Header("\tReset")]
		[SerializeField]
		private bool shouldResetToFirstValue;

		[SerializeField]
		private float resetPeriod = 1;

		[Header("Events")]
		[SerializeField]
		private FloatParameterUnityEvent onGetValue;

		[Header("Debug")]
		[SerializeField]
		private Debugger debugger;

		private Roulette<float> _roulette;

		private string Tag => name + " (Float Anim Randomizer)";

		[Serializable]
		private struct WeightedFloat
		{
			public float value;
			public int weight;
		}

		private void Awake()
		{
			SetupRoulette();
		}

		private void Start()
		{
			if (shouldRepeat)
				StartCoroutine(RaiseRandomValueRepeatedly(setPeriod, resetPeriod));
			else
				GenerateValue();
		}

		[ContextMenu("Reset")]
		private void SetupRoulette()
		{
			if (values.Length < 1)
				debugger.LogError(Tag, "No values given!", this);
			Dictionary<float, int> weightedValues = new Dictionary<float, int>(values.Length);
			foreach (WeightedFloat weightedFloat in values)
			{
				if (weightedValues.ContainsKey(weightedFloat.value))
				{
					debugger.LogError(Tag, $"value: {weightedFloat.value} repeated", this);
					continue;
				}

				weightedValues.Add(weightedFloat.value, weightedFloat.weight);
			}

			_roulette = new Roulette<float>(weightedValues);
		}

		private IEnumerator RaiseRandomValueRepeatedly(float generatePeriod, float resetPeriod)
		{
			var waitUntilNextPeriod = new WaitForSeconds(generatePeriod);
			var waitUntilResetPeriod = new WaitForSeconds(resetPeriod);
			while (true)
			{
				GenerateValue();
				if (shouldResetToFirstValue)
				{
					yield return waitUntilResetPeriod;
					ResetValue();
				}

				yield return waitUntilNextPeriod;
			}
		}

		[ContextMenu("Generate Value")]
		private void GenerateValue()
		{
			float result = _roulette.Spin();
			onGetValue.Invoke(new FloatParameter(parameterName, result));
		}

		private void ResetValue()
			=> onGetValue.Invoke(new FloatParameter(parameterName, 0));
	}
}