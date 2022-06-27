using Core.Debugging;
using Core.Interactions;
using Events.UnityEvents;
using UnityEngine;

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

		[Header("Events")]
		public TransformUnityEvent onPick;

		public SmartEvent onPutDown;
		
		public TransformUnityEvent onThrow;

		[Header("Debug")]
		[SerializeField]
		protected Debugger debugger;

		private IInteractor _picker;

		private void OnValidate()
		{
			if (!rigidBody)
				rigidBody = GetComponent<Rigidbody>();
		}

		public virtual void Interact(IInteractor interactor)
		{
			Transform userTransform = interactor.Transform;
			debugger.Log(name, $"item picked by {userTransform.name}", this);
			_picker = interactor;
			if (userTransform.TryGetComponent(out HandContainer handContainer))
			{
				Transform userHand = handContainer.Hand;
				transform.SetParent(userHand);
				transform.localPosition = Vector3.zero;
				transform.localRotation = Quaternion.identity;
				
			}
			else
			{
				debugger.LogError(name, $"No hand container found on user.\nuser: {userTransform.name}", this);
			}
			rigidBody.isKinematic = true;
			onPick.Invoke(_picker.Transform);
		}

		public virtual void Leave()
		{
			debugger.Log(name, $"item put down by {_picker.Transform.name}", this);
			PutDownInternal();
			onPutDown.Invoke();
		}

		public virtual void Throw(float force, Vector3 direction)
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
		
		protected virtual void PutDownInternal()
		{
			transform.SetParent(null);
			rigidBody.isKinematic = false;
		}
	}
}