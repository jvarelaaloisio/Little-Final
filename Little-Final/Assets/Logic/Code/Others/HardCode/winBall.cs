using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class winBall : MonoBehaviour
{
	public int winScene;

	private void OnTriggerEnter(Collider other)
	{
		SceneManager.LoadScene(winScene);
	}
}
