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
		
		[SerializeField]
		private new Collider collider;

		[Header("Events")]
		public TransformUnityEvent onPick;

		public SmartEvent onPutDown;
		
		public TransformUnityEvent onThrow;

		[Header("Debug")]
		[SerializeField]
		protected Debugger debugger;

		private IInteractor _picker;

		protected virtual void OnValidate()
		{
			rigidBody ??= GetComponent<Rigidbody>();
			collider ??= GetComponent<Collider>();
		}

		public virtual void Interact(IInteractor interactor)
		{
			Transform userTransform = interactor.transform;
			debugger.LogSafely(name, $"item picked by {userTransform.name}", this);
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
			if (collider)
				collider.enabled = false;
			onPick.Invoke(_picker.transform);
		}

		public virtual void Leave()
		{
			debugger.LogSafely(name, $"item put down by {_picker.transform.name}", this);
			PutDownInternal();
			onPutDown.Invoke();
		}

		public virtual void Throw(Vector3 scaledDirection)
		{
			debugger.LogSafely(name, $"item thrown by {_picker.transform.name}" +
								$"\nForce: {scaledDirection};", this);
			PutDownInternal();
			rigidBody.AddForce(scaledDirection, ForceMode.Impulse);
			if (collider)
				collider.enabled = true;
			onThrow.Invoke(_picker.transform);
		}

		public void ForceLoseInteraction()
		{
			_picker?.LoseInteraction();
		}
		
		protected virtual void PutDownInternal()
		{
			transform.SetParent(null);
			rigidBody.isKinematic = false;
			if (collider)
				collider.enabled = true;
		}
	}
}