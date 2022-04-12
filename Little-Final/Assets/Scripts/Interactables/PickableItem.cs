using Core.Interactions;
using UnityEngine;

namespace Interactables
{
	[RequireComponent(typeof(Rigidbody))]
	[RequireComponent(typeof(Collider))]
	public class PickableItem : MonoBehaviour, IPickable
	{
		[SerializeField]
		private Vector3 pickPositionOffset = new Vector3(0, 1, 1);
		
		[SerializeField]
		private Rigidbody rigidbody;

		[Header("Debug")]
		[SerializeField]
		private bool shouldLogInteractions = false;

		private Transform _picker;

		private void OnValidate()
		{
			if (!rigidbody)
				rigidbody = GetComponent<Rigidbody>();
		}

		public void Interact(Transform user)
		{
			if (shouldLogInteractions)
				Debug.Log($"{name}: item picked by {user.name}", this);
			_picker = user;
			transform.SetParent(user);
			transform.position = user.position + user.TransformDirection(pickPositionOffset);
			rigidbody.isKinematic = true;
		}

		public void Leave()
		{
			if (shouldLogInteractions)
				Debug.Log($"{name}: item released by {_picker}", this);
			if (_picker) transform.position = _picker.position + _picker.TransformDirection(pickPositionOffset);
			transform.SetParent(null);
			rigidbody.isKinematic = false;
		}

		public void Throw(float force, Vector3 direction)
		{
			Leave();
			if (shouldLogInteractions)
				Debug.Log($"{name}: the item was thrown withe force: {force} and direction: {direction}", this);
			rigidbody.AddForce(direction * force, ForceMode.Impulse);
		}
	}
}