using Core.Debugging;
using Core.Interactions;
using Events.UnityEvents;
using UnityEngine;
using UnityEngine.Events;

namespace Interactions.Pickable
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
		private UnityEvent onPutDown;
		
		[SerializeField]
		private TransformUnityEvent onThrow;

		[Header("Debug")]
		[SerializeField]
		private Debugger debugger;

		private IUser _picker;

		private void OnValidate()
		{
			if (!rigidBody)
				rigidBody = GetComponent<Rigidbody>();
		}

		public void Interact(IUser user)
		{
			Transform userTransform = user.Transform;
			debugger.Log(name, $"item picked by {userTransform.name}", this);
			_picker = user;
			transform.SetParent(userTransform);
			transform.position = userTransform.position + userTransform.TransformDirection(pickPositionOffset);
			rigidBody.isKinematic = true;
			onPick.Invoke(_picker.Transform);
		}

		public void Leave()
		{
			debugger.Log(name, $"item put down by {_picker.Transform.name}", this);
			PutDownInternal();
			onPutDown.Invoke();
		}

		public void Throw(float force, Vector3 direction)
		{
			debugger.Log(name, $"item thrown by {_picker.Transform.name}" +
								$"\nForce: {force}; Direction: {direction} ", this);
			PutDownInternal();
			rigidBody.AddForce(direction * force, ForceMode.Impulse);
			onThrow.Invoke(_picker.Transform);
		}

		public void ForceLoseInteraction()
		{
			_picker?.LoseInteraction();
		}
		
		private void PutDownInternal()
		{
			Transform pickerTransform = _picker.Transform;
			if (pickerTransform)
				transform.position = pickerTransform.position + pickerTransform.TransformDirection(pickPositionOffset);
			transform.SetParent(null);
			rigidBody.isKinematic = false;
		}
	}
}