using System;
using System.Collections;
using System.Collections.Generic;
using Player;
using UnityEngine;

public class PlayerGizmos : MonoBehaviour
{
	[SerializeField]
	private PlayerController _controller;

	[Header("Interactions")]
	[SerializeField]
	private bool showInteractionBubble = true;

	[SerializeField]
	private Color interactionBubbleColor = new Color(.0f, .75f, .35f, .5f);

	private void OnValidate()
	{
		TryGetComponent(out _controller);
	}

	void Start()
	{
#if UNITY_EDITOR
		return;
#endif
		Destroy(gameObject);
	}

	private void OnDrawGizmos()
	{
		if(!_controller)
			return;
		if (showInteractionBubble && _controller.InteractionHelper != null)
		{
			Gizmos.color = interactionBubbleColor;
			Gizmos.DrawSphere(_controller.InteractionHelper.position, _controller.InteractionCheckRadius);
		}
	}
}