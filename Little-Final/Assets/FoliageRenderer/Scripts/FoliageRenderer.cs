using System;
using System.Collections.Generic;
using System.Linq;
using FoliageRenderer.Scripts.Data;
using FoliageRenderer.Scripts.Data.Terrain;
using UnityEngine;
using static System.Runtime.InteropServices.Marshal;

namespace FoliageRenderer.Scripts
{
    public abstract class FoliageRenderer : MonoBehaviour
    {
        [Header("Dynamic")] [SerializeField] private float avoidanceRadius;
        [SerializeField] private float avoidanceMaxDisplacement;
        public List<Transform> dynamicObjects;

        [Header("Chunks")] [SerializeField, Range(1, 100)]
        private int numChunks = 10;

        [SerializeField] private int chunkDensity = 12;
        [SerializeField, Range(1, 1000)] protected int fieldSize = 100;

        [SerializeField] protected ComputeShader
            computeChunkPoints,
            computeCullGrass;

        [Header("Grass rendering")] [SerializeField]
        private Material grassMaterial;
        [SerializeField, Range(0,1)] private float wildFactor = 1f;
        [SerializeField] private float wildScale = 1f;

        [SerializeField] private Mesh grassMesh;

        [Header("Optimization")] [SerializeField]
        private Camera currentCamera;

        [SerializeField] private Mesh grassLODMesh;
        [SerializeField, Range(0, 1000.0f)] private float lodCutoff = 20f;
        [SerializeField, Range(0, 1000.0f)] private float distanceCutoff = 200f;

        private ComputeBuffer
            _voteBuffer,
            _scanBuffer,
            _groupSumArrayBuffer,
            _scannedGroupSumBuffer,
            _dynamicPositionBuffer;

        [Header("Grass Mask")] [SerializeField]
        private Texture textureMask;

        [SerializeField] private Color targetColor;
        [SerializeField, Range(0, 1)] private float tolerance = .5f;

        [Header("Wind")] [SerializeField] private float windSpeed = 6f;
        [SerializeField] private float frequency = .2f;
        [SerializeField] private float windStrength = .1f;
        [SerializeField] private ComputeShader computeWindGenerator;

        protected virtual Type GrassDataType() => typeof(GrassData);

        private RenderTexture _wind;

        private int
            _numInstancesPerChunk,
            _chunkDimension,
            _numThreadGroups,
            _numVoteThreadGroups,
            _numGroupScanThreadGroups,
            _numWindThreadGroups,
            _numGrassInitThreadGroups;

        private GrassChunk[] _chunks;
        private uint[] _args;
        private uint[] _argsLOD;
        protected Bounds FieldBounds;

        #region Shader Ids

        private static readonly int
            // Rendering
            WildFactorPropID = Shader.PropertyToID("_WildFactor"),
            WildScalePropID = Shader.PropertyToID("_WildScale"),
            // Dynamic
            DynamicPositionCountPropID = Shader.PropertyToID("_dynamicPositionsCount"),
            DynamicPositionsBufferPropID = Shader.PropertyToID("_dynamicPositions"),
            AvoidanceMaxDisplacementPropID = Shader.PropertyToID("_AvoidanceMaxDisplacement"),
            AvoidanceRadiusPropID = Shader.PropertyToID("_AvoidanceRadius"),
            // Dependencies
            GrassDataBufferID = Shader.PropertyToID("_GrassDataBuffer"),
            PositionBufferPropID = Shader.PropertyToID("_PositionBuffer"),
            ObjectWorldMatrixPropID = Shader.PropertyToID("_ObjectWorldMatrix"),
            TimePropID = Shader.PropertyToID("_Time"),
            // Chunks
            ScalePropID = Shader.PropertyToID("_Scale"),
            DimensionPropID = Shader.PropertyToID("_Dimension"),
            ChunkNumPropID = Shader.PropertyToID("_ChunkNum"),
            XOffsetPropID = Shader.PropertyToID("_XOffset"),
            YOffsetPropID = Shader.PropertyToID("_YOffset"),
            ChunkDimensionPropID = Shader.PropertyToID("_ChunkDimension"),
            NumChunksPropID = Shader.PropertyToID("_NumChunks"),
            // Wind
            WindTexPropID = Shader.PropertyToID("_WindTex"),
            FrequencyPropID = Shader.PropertyToID("_Frequency"),
            AmplitudePropID = Shader.PropertyToID("_Amplitude"),
            WindMapPropID = Shader.PropertyToID("_WindMap"),
            // Optimization
            VoteBufferPropID = Shader.PropertyToID("_VoteBuffer"),
            // Optimization - Vote
            ViewProjectionMatrixPropID = Shader.PropertyToID("_ViewProjectionMatrix"),
            CameraPositionPropID = Shader.PropertyToID("_CameraPosition"),
            DistancePropID = Shader.PropertyToID("_Distance"),
            // Optimization - Buffers and Data
            ScanBufferPropID = Shader.PropertyToID("_ScanBuffer"),
            ArgsBufferPropID = Shader.PropertyToID("_ArgsBuffer"),
            CulledGrassOutputBufferPropID = Shader.PropertyToID("_CulledGrassOutputBuffer"),
            NumOfGroupsPropID = Shader.PropertyToID("_NumOfGroups"),
            GroupSumArrayPropID = Shader.PropertyToID("_GroupSumArray"),
            GroupSumArrayInPropID = Shader.PropertyToID("_GroupSumArrayIn"),
            GroupSumArrayOutPropID = Shader.PropertyToID("_GroupSumArrayOut"),
            //Optimization - Cull Mask
            TolerancePropID = Shader.PropertyToID("_Tolerance"),
            TargetColorPropID = Shader.PropertyToID("_TargetColor"),
            TextureMaskPropID = Shader.PropertyToID("_TextureMask");

        #endregion

        #region Unity

        protected virtual void OnEnable()
        {
            _numInstancesPerChunk = Mathf.CeilToInt((float) fieldSize / numChunks) * chunkDensity;
            _chunkDimension = _numInstancesPerChunk;
            _numInstancesPerChunk *= _numInstancesPerChunk;

            _numThreadGroups = Mathf.CeilToInt(_numInstancesPerChunk / 128.0f);
            if (_numThreadGroups > 128)
            {
                var powerOfTwo = 128;
                while (powerOfTwo < _numThreadGroups)
                    powerOfTwo *= 2;

                _numThreadGroups = powerOfTwo;
            }
            else
            {
                while (128 % _numThreadGroups != 0)
                    _numThreadGroups++;
            }

            _numVoteThreadGroups = Mathf.CeilToInt(_numInstancesPerChunk / 128.0f);
            _numGroupScanThreadGroups = Mathf.CeilToInt(_numInstancesPerChunk / 1024.0f);

            _voteBuffer = new ComputeBuffer(_numInstancesPerChunk, 4);
            _scanBuffer = new ComputeBuffer(_numInstancesPerChunk, 4);
            _groupSumArrayBuffer = new ComputeBuffer(_numThreadGroups, 4);
            _scannedGroupSumBuffer = new ComputeBuffer(_numThreadGroups, 4);
            _dynamicPositionBuffer = new ComputeBuffer(dynamicObjects.Count, sizeof(float) * 3);

            computeChunkPoints.SetInt(DimensionPropID, fieldSize);
            computeChunkPoints.SetInt(ChunkDimensionPropID, _chunkDimension);
            computeChunkPoints.SetInt(ScalePropID, chunkDensity);
            computeChunkPoints.SetInt(NumChunksPropID, numChunks);

            _wind = new RenderTexture(
                1024,
                1024,
                0,
                RenderTextureFormat.ARGBFloat,
                RenderTextureReadWrite.Linear)
            {
                enableRandomWrite = true
            };
            _wind.Create();

            _numWindThreadGroups = Mathf.CeilToInt(_wind.height / 8.0f);

            _args = new uint[] {0, 0, 0, 0, 0};
            _args[0] = grassMesh.GetIndexCount(0);
            _args[1] = 0;
            _args[2] = grassMesh.GetIndexStart(0);
            _args[3] = grassMesh.GetBaseVertex(0);

            _argsLOD = new uint[] {0, 0, 0, 0, 0};
            _argsLOD[0] = grassLODMesh.GetIndexCount(0);
            _argsLOD[1] = 0;
            _argsLOD[2] = grassLODMesh.GetIndexStart(0);
            _argsLOD[3] = grassLODMesh.GetBaseVertex(0);

            InitializeChunks();

            FieldBounds = new Bounds(
                transform.position,
                new Vector3(-fieldSize, fieldSize, fieldSize)
            );
        }

        private void Update()
        {
            var projectionMatrix = currentCamera.projectionMatrix;
            var worldToLocalMatrix = currentCamera.transform.worldToLocalMatrix;
            var viewProjectionMatrix = projectionMatrix * worldToLocalMatrix;

            GenerateWind();

            for (var i = 0; i < numChunks * numChunks; ++i)
            {
                var dist = Vector3.Distance(currentCamera.transform.position, _chunks[i].bounds.center);
                var noLOD = dist < lodCutoff;

                CullGrass(_chunks[i], viewProjectionMatrix, noLOD);
                
#if UNITY_EDITOR
                _chunks[i].material.SetFloat(AvoidanceRadiusPropID, avoidanceRadius);
                _chunks[i].material.SetFloat(AvoidanceMaxDisplacementPropID, avoidanceMaxDisplacement);
                _chunks[i].material.SetFloat(WildFactorPropID, wildFactor);
                _chunks[i].material.SetFloat(WildScalePropID, wildScale);
#endif
                //TODO Optimize this
                _dynamicPositionBuffer.SetData(dynamicObjects.Select(p => p.position).ToArray());
                _chunks[i].material.SetBuffer(DynamicPositionsBufferPropID, _dynamicPositionBuffer);
                
                if (noLOD)
                    Graphics.DrawMeshInstancedIndirect(grassMesh, 0, _chunks[i].material, FieldBounds,
                        _chunks[i].argsBuffer);
                else
                    Graphics.DrawMeshInstancedIndirect(grassLODMesh, 0, _chunks[i].material, FieldBounds,
                        _chunks[i].argsBufferLOD);
            }
        }

        protected virtual void OnDisable()
        {
            _voteBuffer.Release();
            _scanBuffer.Release();
            _groupSumArrayBuffer.Release();
            _scannedGroupSumBuffer.Release();
            _dynamicPositionBuffer.Release();
            
            _wind.Release();
            _wind = null;
            _scannedGroupSumBuffer = null;
            _voteBuffer = null;
            _scanBuffer = null;
            _groupSumArrayBuffer = null;


            for (var i = 0; i < numChunks * numChunks; ++i)
            {
                FreeChunk(_chunks[i]);
            }

            _chunks = null;
        }

        private void OnDrawGizmosSelected()
        {
            Gizmos.color = Color.blue;
            if (FieldBounds.size != Vector3.zero)
            {
                Gizmos.DrawWireCube(FieldBounds.center, FieldBounds.size);
            }

            Gizmos.color = Color.yellow;
            if (_chunks != null)
            {
                for (var i = 0; i < numChunks * numChunks; ++i)
                {
                    Gizmos.DrawWireCube(_chunks[i].bounds.center, _chunks[i].bounds.size);
                }
            }
        }

        #endregion

        private void InitializeChunks()
        {
            _chunks = new GrassChunk[numChunks * numChunks];

            for (var x = 0; x < numChunks; ++x)
            {
                for (var y = 0; y < numChunks; ++y)
                {
                    _chunks[x + y * numChunks] = InitializeGrassChunk(x, y);
                }
            }
        }

        private GrassChunk InitializeGrassChunk(int xOffset, int yOffset)
        {
            var chunk = new GrassChunk
            {
                argsBuffer = new ComputeBuffer(1, 5 * sizeof(uint), ComputeBufferType.IndirectArguments),
                argsBufferLOD = new ComputeBuffer(1, 5 * sizeof(uint), ComputeBufferType.IndirectArguments)
            };

            chunk.argsBuffer.SetData(_args);
            chunk.argsBufferLOD.SetData(_argsLOD);

            var dataType = GrassDataType();

            chunk.positionsBuffer = new ComputeBuffer(_numInstancesPerChunk, SizeOf(dataType));
            chunk.culledPositionsBuffer = new ComputeBuffer(_numInstancesPerChunk, SizeOf(dataType));

            var chunkDim = Mathf.CeilToInt((float) fieldSize / numChunks);

            var c = new Vector3(0.0f, 0.0f, 0.0f)
            {
                y = 0.0f,
                x = -(chunkDim * 0.5f * numChunks) + chunkDim * xOffset,
                z = -(chunkDim * 0.5f * numChunks) + chunkDim * yOffset
            };

            c.x += chunkDim * 0.5f;
            c.z += chunkDim * 0.5f;
            c = transform.TransformPoint(c);

            chunk.bounds = new Bounds(c, new Vector3(-chunkDim, 10.0f, chunkDim));

            computeChunkPoints.SetInt(XOffsetPropID, xOffset);
            computeChunkPoints.SetInt(YOffsetPropID, yOffset);
            computeChunkPoints.SetBuffer(0, GrassDataBufferID, chunk.positionsBuffer);
            computeChunkPoints.Dispatch(0, Mathf.CeilToInt((float) fieldSize / numChunks) * chunkDensity,
                Mathf.CeilToInt((float) fieldSize / numChunks) * chunkDensity, 1);

            chunk.material = new Material(grassMaterial);
            chunk.material.SetBuffer(PositionBufferPropID, chunk.culledPositionsBuffer);
            chunk.material.SetTexture(WindTexPropID, _wind);
            chunk.material.SetInt(ChunkNumPropID, xOffset + yOffset * numChunks);
            chunk.material.SetFloat(AvoidanceRadiusPropID, avoidanceRadius);
            chunk.material.SetFloat(AvoidanceMaxDisplacementPropID, avoidanceMaxDisplacement);
            chunk.material.SetInt(DynamicPositionCountPropID, dynamicObjects.Count);
            chunk.material.SetFloat(WildFactorPropID, wildFactor);
            chunk.material.SetFloat(WildFactorPropID, wildScale);

            return chunk;
        }

        private void CullGrass(GrassChunk chunk, Matrix4x4 viewProjectionMatrix, bool noLOD)
        {
            //Reset Args
            if (noLOD)
                chunk.argsBuffer.SetData(_args);
            else
                chunk.argsBufferLOD.SetData(_argsLOD);

            // Dependency 
            computeCullGrass.SetMatrix(ObjectWorldMatrixPropID, transform.localToWorldMatrix);
            computeCullGrass.SetBuffer(0, GrassDataBufferID, chunk.positionsBuffer);

            // Texture Mask
            computeCullGrass.SetFloat(TolerancePropID, tolerance);
            computeCullGrass.SetVector(TargetColorPropID, targetColor);
            computeCullGrass.SetTexture(0, TextureMaskPropID, textureMask);

            // Vote
            computeCullGrass.SetMatrix(ViewProjectionMatrixPropID, viewProjectionMatrix);
            computeCullGrass.SetBuffer(0, VoteBufferPropID, _voteBuffer);
            computeCullGrass.SetVector(CameraPositionPropID, currentCamera.transform.position);
            computeCullGrass.SetFloat(DistancePropID, distanceCutoff);
            computeCullGrass.Dispatch(0, _numVoteThreadGroups, 1, 1);

            // Scan Instances
            computeCullGrass.SetBuffer(1, VoteBufferPropID, _voteBuffer);
            computeCullGrass.SetBuffer(1, ScanBufferPropID, _scanBuffer);
            computeCullGrass.SetBuffer(1, GroupSumArrayPropID, _groupSumArrayBuffer);
            computeCullGrass.Dispatch(1, _numThreadGroups, 1, 1);

            // Scan Groups
            computeCullGrass.SetInt(NumOfGroupsPropID, _numThreadGroups);
            computeCullGrass.SetBuffer(2, GroupSumArrayInPropID, _groupSumArrayBuffer);
            computeCullGrass.SetBuffer(2, GroupSumArrayOutPropID, _scannedGroupSumBuffer);
            computeCullGrass.Dispatch(2, _numGroupScanThreadGroups, 1, 1);

            // Compact
            computeCullGrass.SetBuffer(3, GrassDataBufferID, chunk.positionsBuffer);
            computeCullGrass.SetBuffer(3, VoteBufferPropID, _voteBuffer);
            computeCullGrass.SetBuffer(3, ScanBufferPropID, _scanBuffer);
            computeCullGrass.SetBuffer(3, ArgsBufferPropID, noLOD ? chunk.argsBuffer : chunk.argsBufferLOD);
            computeCullGrass.SetBuffer(3, CulledGrassOutputBufferPropID, chunk.culledPositionsBuffer);
            computeCullGrass.SetBuffer(3, GroupSumArrayPropID, _scannedGroupSumBuffer);
            computeCullGrass.Dispatch(3, _numThreadGroups, 1, 1);
        }

        private void GenerateWind()
        {
            computeWindGenerator.SetFloat(TimePropID, Time.time * windSpeed);
            computeWindGenerator.SetFloat(FrequencyPropID, frequency);
            computeWindGenerator.SetFloat(AmplitudePropID, windStrength);
            computeWindGenerator.SetTexture(0, WindMapPropID, _wind);
            computeWindGenerator.Dispatch(0, _numWindThreadGroups, _numWindThreadGroups, 1);
        }

        private static void FreeChunk(GrassChunk chunk)
        {
            chunk.positionsBuffer.Release();
            chunk.positionsBuffer = null;
            chunk.culledPositionsBuffer.Release();
            chunk.culledPositionsBuffer = null;
            chunk.argsBuffer.Release();
            chunk.argsBuffer = null;
            chunk.argsBufferLOD.Release();
            chunk.argsBufferLOD = null;
        }
    }
}