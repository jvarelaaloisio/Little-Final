using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player_FeetCollider : MonoBehaviour
{
	#region Variables
		Player_Body_OLD Body;
	#endregion

	#region Unity
	void Start()
    {
		Body = GetComponentInParent<Player_Body_OLD>();
    }
	#endregion

	#region Collisions
	private void OnTriggerEnter(Collider other)
	{
		Body.PlayerInTheAir = false;
	}

	private void OnTriggerExit(Collider other)
	{
		Body.PlayerInTheAir = true;
	}
	#endregion
}
