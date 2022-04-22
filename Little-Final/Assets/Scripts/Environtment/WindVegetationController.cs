using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class WindVegetationController : MonoBehaviour
{
    [Header("Big Wind")]
    [Range(-1,1)]
    public float bigWindSpeed;
    [Range(0,5)]
    public float bigWindScale;
    [Range(0, 1)]
    public float bigWindFactor;


    [Header("TODO Rework")]
    public float windIntensity;
    [Range(0, 1)]
    public float WindGlobalDirX;
    [Range(0, 1)]
    public float WindGlobalDirY;
    [Range(0, 1)]
    public float WindSpeed;
    [Range(0,1)]
    public float WindTurbulence;
    

    private void Start()
    {
        
    }

    private void Update()
    {
        Shader.SetGlobalFloat("BigWindFactor", bigWindFactor);
        Shader.SetGlobalFloat("BigWindSpeed", bigWindSpeed);
        Shader.SetGlobalFloat("WindIntensity", windIntensity);
        Shader.SetGlobalFloat("WindDirX", WindGlobalDirX);
        Shader.SetGlobalFloat("WindDirZ", WindGlobalDirY);
        Shader.SetGlobalFloat("WindSpeed", WindSpeed);
        Shader.SetGlobalFloat("WindTurbulence", WindTurbulence);
        Shader.SetGlobalFloat("BigWindScale", bigWindScale);
    }
}
