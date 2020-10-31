using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpdateManager_DEPRECATED : MonoBehaviour
{
	#region Variables

	#region Public

	#endregion

	#region Private
	List<IUpdateable_DEPRECATED> _updateables = new List<IUpdateable_DEPRECATED>();
	List<IUpdateable_DEPRECATED> _fixedUpdateables = new List<IUpdateable_DEPRECATED>();
	#endregion

	#endregion

	#region Unity
	void Update()
	{
		if (_updateables == null || _updateables.Count <= 0) return;
		var backup = _updateables.GetRange(0, _updateables.Count);
		foreach (var updateable in backup)
		{
			updateable.OnUpdate();
		}
	}

	private void FixedUpdate()
	{
		if (_updateables == null || _fixedUpdateables.Count <= 0) return;
		var fixedBackup = _fixedUpdateables.GetRange(0, _fixedUpdateables.Count);
		foreach (var fixedUpdateable in fixedBackup)
		{
			fixedUpdateable.OnUpdate();
		}
	}
	#endregion

	#region Public
	public void AddItem(IUpdateable_DEPRECATED newItem)
	{
		if (newItem == null) return;
		_updateables.Add(newItem);
	}

	public void RemoveItem(IUpdateable_DEPRECATED itemToRemove)
	{
		if (itemToRemove == null) return;
		_updateables.Remove(itemToRemove);
	}
	public void AddFixedItem(IUpdateable_DEPRECATED newItem)
	{
		if (newItem == null) return;
		_fixedUpdateables.Add(newItem);
	}

	public void RemoveFixedItem(IUpdateable_DEPRECATED itemToRemove)
	{
		if (itemToRemove == null) return;
		_fixedUpdateables.Remove(itemToRemove);
	}
	#endregion

	#region Private

	#endregion
}