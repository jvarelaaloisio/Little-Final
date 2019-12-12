/****************************************
	Copyright 2013 Unluck Software	
 	www.chemicalbliss.com	
 	
 	Calculates ParticleSystem emission rate by distance to a GameObject	by using Vector3.Distance()	
 	Used to decrease particles visible on screen to improve performance when using multple particle systems
 																						
*****************************************/

using UnityEngine;
using System;


public class DistanceEmit:MonoBehaviour{
    public GameObject target;					//Distance calculation target
    public float starEmmitDistance = 500.0f;	//At this distance the emission will start to grow, further away than this and the emission will be disabled
    public float fullEmmitDistance = 150.0f;	//At this distance or closer emission will be 100%
    public float updateTicker = 1.0f;			//How often will the script check distance (seconds)
    int fullEmission;                           //Stores max emission rate from Particle System Emit

	ParticleSystem cacheParticleSystem;
	ParticleSystem.EmissionModule emission;

	public void Start() {
		cacheParticleSystem = GetComponent<ParticleSystem>();
		emission = cacheParticleSystem.emission;
		fullEmission = (int)emission.rateOverTimeMultiplier;
    	InvokeRepeating("CheckDistance", updateTicker, updateTicker);
    	if(Vector3.Distance(transform.position, target.transform.position) < fullEmmitDistance)
			emission.rateOverTimeMultiplier = (float)fullEmission;
    	else
			emission.rateOverTimeMultiplier = 0.0f;
    }
    
    public void CheckDistance() {
    	float distance = Vector3.Distance(transform.position, target.transform.position);
    	float emitMultiplier = (float)Mathf.Clamp((int)(1 - (distance -fullEmmitDistance)/(starEmmitDistance -fullEmmitDistance)), 0, 1);
    	emission.rateOverTimeMultiplier = fullEmission * emitMultiplier;	
    }
}