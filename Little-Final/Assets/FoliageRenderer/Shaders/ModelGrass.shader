Shader "Unlit/ModelGrassTerrain"
{
    Properties
    {
        _Albedo1 ("Albedo 1", Color) = (1, 1, 1)
        _Albedo2 ("Albedo 2", Color) = (1, 1, 1)
        _AOColor ("Ambient Occlusion", Color) = (1, 1, 1)
        _TipColor ("Tip Color", Color) = (1, 1, 1)
        _Scale ("Scale", Range(0.0, 2.0)) = 0.0
        _Droop ("Droop", Range(0.0, 10.0)) = 0.0
        _FogColor ("Fog Color", Color) = (1, 1, 1)
        _FogDensity ("Fog Density", Range(0.0, 1.0)) = 0.0
        _FogOffset ("Fog Offset", Range(0.0, 10.0)) = 0.0
    }

    SubShader
    {
        Cull Off
        Zwrite On

        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma target 4.5

            #include "UnityPBSLighting.cginc"
            #include "AutoLight.cginc"
            #include "Assets/FoliageRenderer/Shaders/Compute/Random.cginc"
            #include "Assets/FoliageRenderer/Shaders/Compute/GrassData.cginc"

            struct VertexData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 worldPos : TEXCOORD1;
                float noiseVal : TEXCOORD2;
                float3 chunkNum : TEXCOORD3;
            };

            sampler2D _WindTex;
            float4 _Albedo1, _Albedo2, _AOColor, _TipColor, _FogColor;
            StructuredBuffer<GrassData> _PositionBuffer;
            uint _dynamicPositionsCount;
            StructuredBuffer<float3> _dynamicPositions;
            float _Scale, _Droop, _FogDensity, _FogOffset, _AvoidanceRadius, _AvoidanceMaxDisplacement;

            int _ChunkNum;

            float4 RotateAroundYInDegrees(float4 vertex, float degrees)
            {
                float alpha = degrees * UNITY_PI / 180.0;
                float sina, cosa;
                sincos(alpha, sina, cosa);
                float2x2 m = float2x2(cosa, -sina, sina, cosa);
                return float4(mul(m, vertex.xz), vertex.yw).xzyw;
            }

            float4 RotateAroundXInDegrees(float4 vertex, float degrees)
            {
                float alpha = degrees * UNITY_PI / 180.0;
                float sina, cosa;
                sincos(alpha, sina, cosa);
                float2x2 m = float2x2(cosa, -sina, sina, cosa);
                return float4(mul(m, vertex.yz), vertex.xw).zxyw;
            }

            v2f vert(VertexData v, uint instanceID : SV_INSTANCEID)
            {
                v2f o;
                float4 grass_position = _PositionBuffer[instanceID].position;

                float idHash = randValue(
                    abs(grass_position.x * 10000 + grass_position.y * 100 + grass_position.z * 0.05f + 2));
                idHash = randValue(idHash * 100000);

                float4 animationDirection = float4(0.0f, 0.0f, 1.0f, 0.0f);
                animationDirection = normalize(RotateAroundYInDegrees(animationDirection, idHash * 180.0f));

                float4 local_position = RotateAroundXInDegrees(v.vertex, 90.0f);
                local_position = RotateAroundYInDegrees(local_position, idHash * 180.0f);
                local_position.y += _Scale * v.uv.y * v.uv.y * v.uv.y;
                local_position.xz += _Droop * lerp(0.5f, 1.0f, idHash) * (v.uv.y * v.uv.y * _Scale) *
                    animationDirection;

                float4 worldUV = float4(_PositionBuffer[instanceID].uv, 0, 0);

                float swayVariance = lerp(0.8, 1.0, idHash);
                float movement = v.uv.y * v.uv.y * (tex2Dlod(_WindTex, worldUV).r);
                movement *= swayVariance;

                local_position.xz += movement;

                float4 world_position = float4(grass_position.xyz + local_position, 1.0f);
                
                world_position.y -= _PositionBuffer[instanceID].displacement;
                world_position.y *= 1.0f + _PositionBuffer[instanceID].position.w * lerp(0.8f, 1.0f, idHash);
                world_position.y += _PositionBuffer[instanceID].displacement;

                // if (_dynamicPositionsCount > 0)
                // {
                //     float3 displacement = float3(0, 0, 0);
                //     for (uint i = 0; i < _dynamicPositionsCount; i++)
                //     {
                //         float3 diff = _dynamicPositions[i] - grass_position.xyz;
                //         float dist = length(diff);
                //         if (dist < _AvoidanceRadius)
                //         {
                //             float t = dist / _AvoidanceRadius;
                //             displacement -= v.uv.y * normalize(diff) * _AvoidanceMaxDisplacement * (1 - t);
                //         }
                //     }
                //     local_position += float4(displacement, 1);
                //     world_position = float4(grass_position.xyz + local_position + displacement, 1.0f);
                // }
                
                o.vertex = UnityObjectToClipPos(world_position);
                o.uv = v.uv;
                o.noiseVal = tex2Dlod(_WindTex, worldUV).r;
                o.worldPos = world_position;
                o.chunkNum = float3(randValue(_ChunkNum * 20 + 1024), randValue(randValue(_ChunkNum) * 10 + 2048),
                                    randValue(_ChunkNum * 4 + 4096));

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 col = lerp(_Albedo1, _Albedo2, i.uv.y);
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float ndotl = DotClamped(lightDir, normalize(float3(0, 1, 0)));

                float4 ao = lerp(_AOColor, 1.0f, i.uv.y);
                float4 tip = lerp(0.0f, _TipColor, i.uv.y * i.uv.y * (1.0f + _Scale));
                //return fixed4(i.chunkNum, 1.0f);
                //return i.noiseVal;

                float4 grassColor = (col + tip) * ndotl * ao;

                /* Fog */
                float viewDistance = length(_WorldSpaceCameraPos - i.worldPos);
                float fogFactor = (_FogDensity / sqrt(log(2))) * (max(0.0f, viewDistance - _FogOffset));
                fogFactor = exp2(-fogFactor * fogFactor);


                return lerp(_FogColor, grassColor, fogFactor);
            }
            ENDCG
        }
    }
}