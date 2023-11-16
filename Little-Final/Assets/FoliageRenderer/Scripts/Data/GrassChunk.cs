using UnityEngine;

namespace FoliageRenderer.Scripts.Data
{
    public struct GrassChunk
    {
        public ComputeBuffer argsBuffer;
        public ComputeBuffer argsBufferLOD;
        public ComputeBuffer positionsBuffer;
        public ComputeBuffer culledPositionsBuffer;
        public Bounds bounds;
        public Material material;
    }
}