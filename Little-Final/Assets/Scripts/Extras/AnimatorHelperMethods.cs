using UnityEngine;

namespace Extras
{
	public class AnimatorHelperMethods : MonoBehaviour
	{
		[SerializeField]
		private Animator animator;

		private void OnValidate()
		{
			if (!animator) TryGetComponent(out animator);
		}

		public void SetFloat(FloatParameter floatParameter)
		{
			animator.SetFloat(floatParameter.Name, floatParameter.Value);
		}
	}
}
