using System;
using FoliageRenderer.Scripts.Data;
using UnityEngine;

namespace FoliageRenderer.Scripts
{
    public class FoliageTerrainRenderer : FoliageRenderer
    {
        [Header("Terrain")] [SerializeField] private Texture heightMap;
        [SerializeField] private float displacementStrength = 20;
        
        // Terrain
        private static readonly int
        DisplacementStrengthPropID = Shader.PropertyToID("_DisplacementStrength"),
        HeightMapPropID = Shader.PropertyToID("_HeightMap");
        
        #region Unity

        protected override void OnEnable()
        {
            computeChunkPoints.SetFloat(DisplacementStrengthPropID, displacementStrength);
            computeChunkPoints.SetTexture(0, HeightMapPropID, heightMap);
            base.OnEnable();
            FieldBounds = new Bounds(
                transform.position,
                new Vector3(-fieldSize, displacementStrength * 2, fieldSize)
            );
        }

        #endregion
    }
}