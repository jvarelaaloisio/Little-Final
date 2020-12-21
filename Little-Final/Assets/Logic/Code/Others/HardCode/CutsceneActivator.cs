using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class CutsceneActivator : MonoBehaviour
{
	public GameObject cutsceneGO,
						playerGO;

	private void OnTriggerEnter(Collider other)
	{
		cutsceneGO.SetActive(true);
		playerGO.SetActive(false);
	}
}
