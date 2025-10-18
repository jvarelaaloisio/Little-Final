using System;
using System.Collections;
using UnityEngine;

namespace Core.Movement
{
	public interface IStepDown
	{
		/// <summary>
		/// If the transform is not blocked by a wall that would result in the transform passing through when stepping up.
		/// <remarks>Meant to prevent stepping down through walls.</remarks>
		/// </summary>
		/// <param name="stepPosition">Out variable set to a valid step-down position.</param>
		/// <param name="direction">The direction the transform wants to move towards</param>
		bool Can(out Vector3 stepPosition, Vector3 direction, Config configOverride = null);

		/// <summary/> The actual process of stepping down
		/// <param name="point">Where to land</param>
		/// <param name="configOverride"></param>
		/// <param name="callback">Called when finished</param>
		void Do(Vector3 point, Config configOverride = null, Action callback = null);
		IEnumerator DoCoroutine(Vector3 destination, Config configOverride = null, Action callback = null);
        
		[Serializable]
		public class Config
		{
			[field: SerializeField]
			[field: Range(0, 2, .05f)]
			public float MaxDepth { get; set; } = .05f;

			[field: SerializeField]
			[field: Range(0, 5, .05f)]
			public float StepDistance { get; set; } = .2f;

			[field: SerializeField]
			[field: Range(0, 2, .05f)]
			public float Duration { get; set; } = .1f;

			[field: SerializeField]
			public LayerMask StepMask { get; set; }
        
			[field: SerializeField]
			public AnimationCurve StepCurve { get; set; } = AnimationCurve.EaseInOut(0, 0, 1, 1);
		}
	}
}