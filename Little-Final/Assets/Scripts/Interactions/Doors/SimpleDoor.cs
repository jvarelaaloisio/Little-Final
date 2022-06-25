using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;

namespace Interactions.Doors
{
	public class SimpleDoor : MonoBehaviour
	{
		[SerializeField]
		private List<string> tagsIShouldIgnore;

		[SerializeField]
		private UnityEvent onOpen;

		[SerializeField]
		private UnityEvent onClose;

		private readonly List<Transform> _guests = new List<Transform>(10);

		private bool _isOpened;

		private void OnTriggerEnter(Collider other)
		{
			if (tagsIShouldIgnore.Contains(other.tag))
				return;
			if (!_guests.Contains(other.transform))
				_guests.Add(other.transform);
			DecideIfOpenOrClose();
		}

		private void OnTriggerExit(Collider other)
		{
			if (tagsIShouldIgnore.Contains(other.tag))
				return;
			_guests.Remove(other.transform);
			DecideIfOpenOrClose();
		}

		private void DecideIfOpenOrClose()
		{
			bool hasGuests = _guests.Any();
			switch (_isOpened)
			{
				case true when !hasGuests:
					onClose.Invoke();
					_isOpened = false;
					break;
				case false when hasGuests:
					onOpen.Invoke();
					_isOpened = true;
					break;
			}
		}
	}
}