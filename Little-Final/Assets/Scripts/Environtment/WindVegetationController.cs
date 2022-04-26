using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class WindVegetationController : MonoBehaviour
{
    [Header("Big Wind")]
    [Range(-1,1)]
    public float bigWindSpeed = 0.35f;
    [Range(0,5)]
    public float bigWindScale= 0.2f;
    [Range(0, 1)]
    public float bigWindFactor = 0.8f;


    [Header("TODO Rework")]
    public float windIntensity = 0.8f;
    [Range(0, 1)]
    public float windGlobalDirX = 0.1f;
    [Range(0, 1)]
    public float windGlobalDirY = 0.1f;
    [Range(0, 1)]
    public float windSpeed = 1;
    [Range(0,1)]
    public float windTurbulence = 1;

    private static readonly int BigWindFactor = Shader.PropertyToID("BigWindFactor");
    private static readonly int BigWindSpeed = Shader.PropertyToID("BigWindSpeed");
    private static readonly int WindIntensity = Shader.PropertyToID("WindIntensity");
    private static readonly int WindDirX = Shader.PropertyToID("WindDirX");
    private static readonly int WindDirZ = Shader.PropertyToID("WindDirZ");
    private static readonly int WindSpeed = Shader.PropertyToID("WindSpeed");
    private static readonly int WindTurbulence = Shader.PropertyToID("WindTurbulence");
    private static readonly int BigWindScale = Shader.PropertyToID("BigWindScale");
    
    private void Update()
    {
        Shader.SetGlobalFloat(BigWindFactor, bigWindFactor);
        Shader.SetGlobalFloat(BigWindSpeed, bigWindSpeed);
        Shader.SetGlobalFloat(WindIntensity, windIntensity);
        Shader.SetGlobalFloat(WindDirX, windGlobalDirX);
        Shader.SetGlobalFloat(WindDirZ, windGlobalDirY);
        Shader.SetGlobalFloat(WindSpeed, windSpeed);
        Shader.SetGlobalFloat(WindTurbulence, windTurbulence);
        Shader.SetGlobalFloat(BigWindScale, bigWindScale);
    }
}
