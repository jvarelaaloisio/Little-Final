using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
[RequireComponent(typeof(Collider))]
public class Pickable_Item : MonoBehaviour, IPickable
{
	#region Variables

	#region Constant
	const int PICKABLE_LAYER = 16;
	#endregion

	#region Private
	Rigidbody _rb;
	Transform _originalFather,
		_picker;
	#endregion

	#endregion

	#region Unity
	void Start()
    {
		this.gameObject.layer = PICKABLE_LAYER;
		_originalFather = transform.parent;
		_rb = GetComponent<Rigidbody>();
    }
	#endregion

	#region Public
	public void Pick(Transform picker)
	{
		_picker = picker;
		transform.SetParent(picker);
		transform.position = picker.position + picker.up * 1.2f;
		_rb.isKinematic = true;
	}

	public void Release()
	{
        if(_picker) transform.position = _picker.position + _picker.forward + _picker.up;
		transform.SetParent(_originalFather);
		_rb.isKinematic = false;
	}

	public void Throw(float force, Vector3 direction)
	{
		Release();
		_rb.AddForce(direction * force, ForceMode.Impulse);
	}
	#endregion

	#region Private

	#endregion
}