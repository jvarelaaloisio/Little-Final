using System;
using System.Collections;
using System.Collections.Generic;
using Core;
using Core.Debugging;
using Core.Helpers;
using UnityEngine;
using UnityEngine.Animations.Rigging;
using UnityEngine.Events;
using UnityEngine.Serialization;

namespace Rideables
{
	public class IkEatingHelper : MonoBehaviour
	{
		[SerializeField]
		private Awareness awareness;

		[SerializeField]
		private ChainIKConstraint constraint;

		[SerializeField]
		[Tooltip("The ik tip in the rigging.\nThe object that will follow this one")]
		private Transform ikTip;

		[FormerlySerializedAs("eatingId")] [SerializeField]
		private IdContainer eatingIdContainer;

		[SerializeField]
		private AnimationCurve headDown = AnimationCurve.Linear(0, 0, 1, 1);

		[SerializeField]
		private AnimationCurve headUp = AnimationCurve.Linear(0, 0, 1, 1);

		[Header("Debug")]
		[SerializeField]
		private Debugger debugger;

		private bool _isEating;
		private Vector3 _positionBeforeEating;
		private Transform _parent;
		private Coroutine _lerpIkWeight;
		private Coroutine _followFruit;
		private Coroutine _followIkTip;
		private Transform _followTarget;
		private string DebugTag => name + " (IK)";

		private void Awake()
		{
			_followTarget = ikTip;
		}

		private IEnumerator Start()
		{
			while (true)
			{
				if (!_followTarget)
					_followTarget = ikTip;

				transform.position = _followTarget.position;
				yield return null;
			}
		}

		public void OnDecisionTaken(IdContainer decisionIdContainer)
		{
			if (decisionIdContainer == eatingIdContainer)
			{
				if (_isEating)
					return;
				Transform fruit = awareness.Fruit;
				if (!fruit)
				{
					debugger.LogError(DebugTag, "Fruit not found when eating", this);
					return;
				}

				_followTarget = fruit;
				if (_lerpIkWeight != null)
					StopCoroutine(_lerpIkWeight);

				_lerpIkWeight = StartCoroutine(LerpIkWeight(0, 1, headDown));
				_isEating = true;
			}
			else if (_isEating)
				ResetIk();
		}

		public void ResetIk()
		{
			_isEating = false;
			if (_lerpIkWeight != null)
				StopCoroutine(_lerpIkWeight);
			_lerpIkWeight = StartCoroutine(LerpIkWeight(1, 0, headUp,
														() => _followTarget = ikTip));
		}
		
		private IEnumerator LerpIkWeight(float initIKValue,
										float endIKValue,
										AnimationCurve behaviour,
										Action onFinish = null)
		{
			float duration = behaviour[behaviour.length - 1].time - behaviour[0].time;
			float start = Time.time;
			float currentTime;
			while (start + duration > (currentTime = Time.time))
			{
				float lerpStatus = (currentTime - start) / duration;
				constraint.weight = Mathf.Lerp(initIKValue, endIKValue, behaviour.Evaluate(lerpStatus));
				yield return null;
			}

			onFinish?.Invoke();
		}
	}
}