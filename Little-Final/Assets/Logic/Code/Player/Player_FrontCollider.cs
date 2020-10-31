using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player_FrontCollider : MonoBehaviour
{
	#region Variables

	#region Constant
	const int CLIMB_LAYER = 12, CLIMB_TOP_SOLID_LAYER = 18, PICKABLE_LAYER = 16;
	#endregion

	#region Public
	public IPickable PickableItem
	{
		get
		{
			return _pickableItem;
		}
	}
	#endregion

	#region Private
	Player_Body_DEPRECATED _body;
	Transform lastClimbable = null;
	IPickable _pickableItem;
	#endregion

	#endregion

	#region Unity
	void Start()
	{
		_body = GetComponentInParent<Player_Body_DEPRECATED>();
	}
	#endregion

	#region Collisions
	private void OnTriggerEnter(Collider other)
	{
		switch (other.gameObject.layer)
		{
			case CLIMB_LAYER:
			{
				lastClimbable = other.transform;
				_body.lastClimbable = other.transform;
				_body.CollidingWithClimbable = true;
				break;
			}
			case PICKABLE_LAYER:
			{
				_pickableItem = other.GetComponent<IPickable>();
				break;
			}
		}
	}
	private void OnTriggerStay(Collider other)
	{
		if(other.gameObject.layer == CLIMB_TOP_SOLID_LAYER)
		{
			_body.CollidingWithClimbableTopSolid = true;
		}
	}
	private void OnTriggerExit(Collider other)
	{
		switch (other.gameObject.layer)
		{
			case CLIMB_LAYER:
			{
				if (lastClimbable == other.transform)
				{
					_body.CollidingWithClimbable = false;
					_body.lastClimbable = null;
					lastClimbable = null;
				}
				break;
			}
			case CLIMB_TOP_SOLID_LAYER:
			{
				_body.CollidingWithClimbableTopSolid = false;
				break;
			}
			case PICKABLE_LAYER:
			{
				_pickableItem = null;
				break;
			}
		}
	}
	#endregion
}