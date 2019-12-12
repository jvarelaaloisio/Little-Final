using UnityEngine;
using System;


public class CloudScapeGenerator:MonoBehaviour
{
    /****************************************
    	CloudScapeGenerator.js
    	Copyright 2013 Unluck Software	
     	www.chemicalbliss.com	
     	
     	Generates randomly placed gameObjects
     																						
    *****************************************/
    public GameObject[] cloudMeshes;
    public GameObject targetParticleSystem;
    public float areaScale = 500.0f;
    public float areaHeight = 150.0f;
    public int cloudAmount = 35;
    public bool fixedScale = true;
    public float maxScale = 1.0f;
    public float minScale = 1.0f;
    [HideInInspector]
    public bool multipleParticleSystems;
	public float _scaleMultiplier;



}