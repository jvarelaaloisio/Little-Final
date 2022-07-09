using System;
using UnityEngine;

namespace Extras
{
	public class HideAndLockCursor : MonoBehaviour
	{
		private void Awake()
		{
			Cursor.lockState = CursorLockMode.Confined;
		}

		private void Update()
		{
			if (Input.GetKeyDown(KeyCode.F2)) Cursor.visible = !Cursor.visible;
		}
	}
}
