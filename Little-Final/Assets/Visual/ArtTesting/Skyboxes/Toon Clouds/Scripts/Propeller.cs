using UnityEngine;
using System;


public class Propeller:MonoBehaviour
{
    
    public void Update() {
    	transform.Rotate(0.0f,0.0f,UnityEngine.Random.Range(1500,2500)*Time.deltaTime);
    }
}