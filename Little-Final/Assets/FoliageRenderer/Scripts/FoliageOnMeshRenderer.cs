using System;
using FoliageRenderer.Scripts.Data.OnMesh;
using UnityEngine;

namespace FoliageRenderer.Scripts
{
    [RequireComponent(typeof(MeshFilter))]
    public class FoliageOnMeshRenderer : FoliageRenderer
    {
        private ComputeBuffer
            _parentUvBuffer,
            _parentMeshVerticesBuffer,
            _parentMeshTrianglesBuffer,
            _parentMeshNormalsBuffer;

        private const int Vector3BytesSize = sizeof(float) * 3;
        private const int Vector2BytesSize = sizeof(float) * 2;
        private const int IntBytesSize = sizeof(int);

        protected override Type GrassDataType() => typeof(GrassData);
        
        #region Unity

        protected override void OnEnable()
        {
            var sharedMesh = GetComponent<MeshFilter>().sharedMesh;
            _parentUvBuffer = GetComputeBufferFromArray(sharedMesh.uv, Vector2BytesSize);
            _parentMeshTrianglesBuffer = GetComputeBufferFromArray(sharedMesh.triangles, IntBytesSize);
            _parentMeshVerticesBuffer = GetComputeBufferFromArray(sharedMesh.vertices, Vector3BytesSize);
            _parentMeshNormalsBuffer = GetComputeBufferFromArray(sharedMesh.normals, Vector3BytesSize);
            
            computeChunkPoints.SetInt("_ParentMeshTriangleCount", sharedMesh.triangles.Length);
            computeChunkPoints.SetBuffer(0, "_ParentMeshUv", _parentUvBuffer);
            computeChunkPoints.SetBuffer(0, "_ParentMeshVertices", _parentMeshVerticesBuffer);
            computeChunkPoints.SetBuffer(0, "_ParentMeshTriangles", _parentMeshTrianglesBuffer);
            computeChunkPoints.SetBuffer(0, "_ParentMeshNormals", _parentMeshNormalsBuffer);
            
            base.OnEnable();
        }

        protected override void OnDisable()
        {
            base.OnDisable();
            _parentUvBuffer.Release();
            _parentMeshVerticesBuffer.Release();
            _parentMeshTrianglesBuffer.Release();
            _parentMeshNormalsBuffer.Release();
        }

        #endregion
        
        private static ComputeBuffer GetComputeBufferFromArray<T>(T[] items, int stride)
        {
            var computeBuffer = new ComputeBuffer(items.Length, stride);
            computeBuffer.SetData(items);
            return computeBuffer;
        }
    }
}