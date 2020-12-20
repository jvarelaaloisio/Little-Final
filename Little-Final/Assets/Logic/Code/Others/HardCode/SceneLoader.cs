﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
public class SceneLoader : MonoBehaviour
{
	private void Awake()
	{
		SceneManager.LoadSceneAsync(1, LoadSceneMode.Additive);
	}
}
