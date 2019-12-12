using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UpdateManager : MonoBehaviour
{
	#region Variables

	#region Public

	#endregion

	#region Private
	List<IUpdateable> _updateables = new List<IUpdateable>();
	List<IUpdateable> _fixedUpdateables = new List<IUpdateable>();
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
	public void AddItem(IUpdateable newItem)
	{
		if (newItem == null) return;
		_updateables.Add(newItem);
	}

	public void RemoveItem(IUpdateable itemToRemove)
	{
		if (itemToRemove == null) return;
		_updateables.Remove(itemToRemove);
	}
	public void AddFixedItem(IUpdateable newItem)
	{
		if (newItem == null) return;
		_fixedUpdateables.Add(newItem);
	}

	public void RemoveFixedItem(IUpdateable itemToRemove)
	{
		if (itemToRemove == null) return;
		_fixedUpdateables.Remove(itemToRemove);
	}
	#endregion

	#region Private

	#endregion
}