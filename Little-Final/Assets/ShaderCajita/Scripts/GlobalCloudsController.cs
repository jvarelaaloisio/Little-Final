using System;
using UnityEngine;
using UnityEngine.Serialization;

namespace ShaderCajita.Scripts
{
    public class GlobalCloudsController : MonoBehaviour
    {
        private const string ShadowIntensityName = "WorldClouds_ShadowIntensity";
        private const string CloudsScaleName = "WorldClouds_CloudScale";
        private const string SpeedName = "WorldClouds_Speed";
        private const string CloudLevelsName = "WorldClouds_CloudLevels";
        private const string CloudTextureName = "WorldClouds_Texture";
        
        private static readonly int WorldCloudsShadowIntensity = Shader.PropertyToID(ShadowIntensityName);
        private static readonly int WorldCloudsCloudScale = Shader.PropertyToID(CloudsScaleName);
        private static readonly int WorldCloudsSpeed = Shader.PropertyToID(SpeedName);
        private static readonly int WorldCloudsCloudLevels = Shader.PropertyToID(CloudLevelsName);
        private static readonly int CloudTexture = Shader.PropertyToID(CloudTextureName);
        
        [SerializeField, Range(0,1)] private float shadowIntensity = .5f;
        [SerializeField] private float cloudsScale = .01f;
        [SerializeField] private float speed = .1f;
        [SerializeField] private float cloudsLevelsAdjustment = 0;
        [SerializeField] private Texture cloudTexture;

        private void OnValidate()
        {
            UpdateShadowIntensity();
        }

        private void Start()
        {
            UpdateShadowIntensity();
        }

        private void UpdateShadowIntensity()
        {
            Shader.SetGlobalFloat(WorldCloudsShadowIntensity, 1f -shadowIntensity);
            Shader.SetGlobalFloat(WorldCloudsCloudScale, cloudsScale);
            Shader.SetGlobalFloat(WorldCloudsSpeed, speed);
            Shader.SetGlobalFloat(WorldCloudsCloudLevels, cloudsLevelsAdjustment);
            Shader.SetGlobalTexture(CloudTexture, cloudTexture);
        }
    }
}
