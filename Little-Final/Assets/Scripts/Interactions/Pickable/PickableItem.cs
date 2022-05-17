using Core.Debugging;
using Core.Interactions;
using Events.UnityEvents;
using UnityEngine;

namespace Interactables
{
	[AddComponentMenu("Interactions/Pickable")]
	[RequireComponent(typeof(Rigidbody))]
	[RequireComponent(typeof(Collider))]
	public class PickableItem : MonoBehaviour, IPickable
	{
		[Header("Setup")]
		[SerializeField]
		private Rigidbody rigidBody;

		[SerializeField]
		private Vector3 pickPositionOffset = new Vector3(0, 1, 1);

		[Header("Events")]
		[SerializeField]
		private TransformUnityEvent onPick;

		[SerializeField]
		private TransformUnityEvent onPutDown;

		[SerializeField]
		private TransformUnityEvent onThrow;

		[Header("Debug")]
		[SerializeField]
		private Debugger debugger;

		private Transform _picker;

		private void OnValidate()
		{
			if (!rigidBody)
				rigidBody = GetComponent<Rigidbody>();
		}

		public void Interact(Transform user)
		{
			debugger.Log(name, $"item picked by {user.name}", this);
			_picker = user;
			transform.SetParent(user);
			transform.position = user.position + user.TransformDirection(pickPositionOffset);
			rigidBody.isKinematic = true;
			onPick.Invoke(_picker);
		}

		public void PutDown()
		{
			debugger.Log(name, $"item put down by {_picker.name}", this);
			PutDownInternal();
			onPutDown.Invoke(_picker);
		}

		public void Throw(float force, Vector3 direction)
		{
			debugger.Log(name, $"item thrown by {_picker.name}" +
								$"\nForce: {force}; Direction: {direction} ", this);
			PutDownInternal();
			rigidBody.AddForce(direction * force, ForceMode.Impulse);
			onThrow.Invoke(_picker);
		}

		private void PutDownInternal()
		{
			if (_picker)
				transform.position = _picker.position + _picker.TransformDirection(pickPositionOffset);
			transform.SetParent(null);
			rigidBody.isKinematic = false;
		}
	}
}