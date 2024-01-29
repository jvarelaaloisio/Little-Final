using Core.Interactions;
using UnityEngine;
using UnityEngine.Serialization;

namespace Player
{
	public class PlayerGizmos : MonoBehaviour
	{
		[SerializeField]
		private PlayerController controller;

		[Header("Interactions")]
		[SerializeField]
		private bool showInteractionBubble = true;

		[FormerlySerializedAs("interactionBubbleColor")]
		[SerializeField]
		private Color interactionBubbleColorNothing = new Color(.75f, .75f, .15f, .5f);

		[SerializeField]
		private Color interactionBubbleColorRideable = new Color(.0f, .25f, .75f, .5f);

		[SerializeField]
		private Color interactionBubbleColorPickable = new Color(.0f, .75f, .25f, .5f);

		private void OnValidate()
		{
			TryGetComponent(out controller);
		}

		private void Start()
		{
#if UNITY_EDITOR
			return;
#endif
			Destroy(this);
		}

		private void OnDrawGizmos()
		{
			if (!controller)
				return;
			if (showInteractionBubble && controller.InteractionHelper != null)
			{
				Gizmos.color = controller.CanInteract(out var interactable)
									? interactable is IRideable
										? interactionBubbleColorRideable
										: interactable is IPickable
											? interactionBubbleColorPickable
											: interactionBubbleColorNothing
									: interactionBubbleColorNothing;
				Gizmos.DrawWireSphere(controller.InteractionHelper.position, controller.InteractionCheckRadius);
				Gizmos.DrawSphere(controller.InteractionHelper.position, controller.InteractionCheckRadius);
			}
		}
	}
}