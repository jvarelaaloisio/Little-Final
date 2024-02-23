using System;
using UnityEngine;

namespace Extras
{
	public class HideAndLockCursor : MonoBehaviour
	{
		private void Awake()
		{
#if LOCK_CURSOR
			Cursor.lockState = CursorLockMode.Confined;
#endif
		}

		private void Update()
		{
			if (Input.GetKeyDown(KeyCode.F2)) Cursor.visible = !Cursor.visible;
		}
	}
}
