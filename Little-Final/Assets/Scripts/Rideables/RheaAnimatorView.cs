using System.Collections;
using Core.Debugging;
using Core.Extensions;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;
using Random = UnityEngine.Random;

namespace Rideables
{
	public abstract class RheaAnimatorView : MonoBehaviour, ILateUpdateable
	{
		[SerializeField]
		private Animator animator;

		[SerializeField]
		private Rhea rhea;

		[SerializeField]
		private AnimationCurve speedCurve = AnimationCurve.Linear(0, 0, 1, 1);


		[Header("Animator Parameters")]
		[SerializeField]
		private string speedParameter = "move_blend";

		[SerializeField]
		private string mountedParameter = "is_mounted";

		[Header("Debug")]
		[SerializeField]
		protected Debugger debugger;

		protected virtual void OnValidate()
		{
			if (!animator) TryGetComponent(out animator);
		}

		protected virtual void Awake()
		{
			if (!animator) debugger.LogError("Animator field not set", this);
		}

		private void Start()
		{
			rhea.OnMounted += () => SetMountedParameter(true);
			rhea.OnDismounted += () => SetMountedParameter(false);
		}

		private void OnEnable()
		{
			UpdateManager.Subscribe(this);
		}

		private void OnDisable()
		{
			UpdateManager.UnSubscribe(this);
		}

		private void SetMountedParameter(bool value)
		{
			animator.SetBool(mountedParameter, value);
		}

		public void OnLateUpdate()
		{
			float horizontalSpeed = speedCurve.Evaluate(GetSpeed().XZtoXY().magnitude / rhea.Speed);
			animator.SetFloat(speedParameter, horizontalSpeed);
		}

		protected abstract Vector3 GetSpeed();
	}
}