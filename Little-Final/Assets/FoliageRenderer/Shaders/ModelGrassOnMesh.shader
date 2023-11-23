Shader "Unlit/ModelGrassOnMesh"
{
    Properties
    {
        _Albedo1 ("Base Color 1", Color) = (1, 1, 1)
        _Albedo2 ("Base Color 2", Color) = (1, 1, 1)
        _OldGrass ("Old Grass Color", Color) = (1, 1, 1)
        _AOColor ("Ambient Occlusion", Color) = (1, 1, 1)
        _TipColor ("Tip Color", Color) = (1, 1, 1)
        _Scale ("Scale", float) = 1.0
        _Height ("Height", float) = 1.0
        _Width ("Width", float) = 1.0
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
            #include "Assets/FoliageRenderer/Shaders/Compute/Simplex.compute"
            #include "Assets/FoliageRenderer/Shaders/Compute/Random.cginc"
            #include "Assets/FoliageRenderer/Shaders/Compute/OnMeshGrassData.cginc"

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
                float4 localPos : TEXCOORD4;
            };

            sampler2D _WindTex;
            float4 _Albedo1, _Albedo2, _OldGrass, _AOColor, _TipColor, _FogColor;
            StructuredBuffer<GrassData> _PositionBuffer;
            uint _dynamicPositionsCount;
            StructuredBuffer<float3> _dynamicPositions;
            float4x4 _ObjectRotationMatrix;
            float4x4 _ObjectScaleMatrix;
            float _Scale,
            _Width,
            _Height,
            _Droop,
            _FogDensity,
            _FogOffset,
            _AvoidanceRadius,
            _AvoidanceMaxDisplacement,
            _WildFactor,
            _WildScale;

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

            float HashFromVector(float3 input_vector)
            {
                const float id_hash = randValue(
                abs(
                    input_vector.x * 10000 +
                    input_vector.y * 100 +
                    input_vector.z * 0.05f +
                    2
                ));
                return randValue(id_hash * 100000);
            }
            
            v2f vert(VertexData v, uint instanceID : SV_INSTANCEID)
            {
                v2f o;

                const float4 buffered_grass_position = _PositionBuffer[instanceID].position;
                const float id_hash = HashFromVector(buffered_grass_position);
                const float4 world_uv = float4(_PositionBuffer[instanceID].uv, 0, 0);
                const float uv_mask = v.uv.y * .5f;

                // Generates animation direction
                float4 animation_direction = float4(0.0f, 0.0f, 1.0f, 0.0f);
                animation_direction = normalize(RotateAroundYInDegrees(animation_direction, id_hash * 180.0f));

                // Fix mesh rotation and set random rotation
                float4 local_position = RotateAroundXInDegrees(v.vertex, 90.0f);
                local_position = RotateAroundYInDegrees(local_position, id_hash * 180.0f);
                
                // Rescale, Uses the middle as pivot
                local_position.y += _Height * uv_mask;

                // Apply animation direction and drop
                local_position.xz += _Droop * lerp(0.5f, 1.0f, id_hash) * (v.uv.y * v.uv.y * _Scale) * animation_direction;

                // Generate de movement value
                float movement = v.uv.y * v.uv.y * (tex2Dlod(_WindTex, world_uv).r);
                const float sway_variance = lerp(0.8, 1.0, id_hash);
                movement *= sway_variance;

                // Apply final motion
                local_position.xz += movement * animation_direction;

                // Applies a noise to the global height
                local_position.y -= mul(snoise(world_uv * _WildScale), _WildFactor) * uv_mask;
                local_position.y *= 1.0f + _PositionBuffer[instanceID].position.w * lerp(0.8f, 1.0f, id_hash) * uv_mask;
                local_position.y += mul(snoise(world_uv * _WildScale), _WildFactor) * uv_mask;

                // Apply scale and rotation from parent mesh 
                float4 world_position = float4(local_position + buffered_grass_position.xyz, 1.0f);
                world_position = mul(_ObjectRotationMatrix, world_position);
                world_position = mul(_ObjectScaleMatrix, world_position);

                // Apply dynamic avoidance
                if (_dynamicPositionsCount > 0)
                {
                    float3 displacement = float3(0, 0, 0);
                    for (uint i = 0; i < _dynamicPositionsCount; i++)
                    {
                        const float3 diff = _dynamicPositions[i] - buffered_grass_position.xyz;
                        const float dist = length(diff);
                        if (dist < _AvoidanceRadius)
                        {
                            const float t = dist / _AvoidanceRadius;
                            displacement -= v.uv.y * normalize(diff) * _AvoidanceMaxDisplacement * (1 - t);
                            displacement.y = 0;
                        }
                    }
                    local_position += float4(displacement, 0);
                    world_position = float4(buffered_grass_position.xyz + local_position + displacement, 1.0f);
                }
                
                o.vertex = UnityObjectToClipPos(world_position);
                o.uv = v.uv;
                o.noiseVal = tex2Dlod(_WindTex, world_uv).r;
                o.worldPos = world_position;
                o.localPos = local_position;
                o.chunkNum = float3(
                    randValue(_ChunkNum * 20 + 1024),
                    randValue(randValue(_ChunkNum) * 10 + 2048),
                    randValue(_ChunkNum * 4 + 4096)
                );

                return o;
            }

            fixed4 frag(v2f i, uint instanceID : SV_INSTANCEID) : SV_Target
            {
                // TODO Refactor
                const float old_grass_flag = .3;
                const float smooth_factor = .5;
                const float height_factor = smoothstep(old_grass_flag - smooth_factor, old_grass_flag + smooth_factor, i.localPos.y);
                const float4 col = lerp(lerp(_Albedo1, _OldGrass, height_factor), _Albedo2, i.uv.y);
                const float3 light_dir = _WorldSpaceLightPos0.xyz;
                const float ndotl = DotClamped(light_dir, normalize(float3(0, 1, 0)));

                const float4 ao = lerp(_AOColor, 1.0f, i.uv.y);
                const float4 tip = lerp(0.0f, _TipColor, i.uv.y * i.uv.y * (1.0f + _Scale));

                const float4 grass_color = (col + tip) * ndotl * ao;

                /* Fog */
                const float view_distance = length(_WorldSpaceCameraPos - i.worldPos);
                float fog_factor = (_FogDensity / sqrt(log(2))) * (max(0.0f, view_distance - _FogOffset));
                fog_factor = exp2(-fog_factor * fog_factor);

                fixed4 color = lerp(_FogColor, grass_color, fog_factor);

                return color;
            }
            ENDCG
        }
    }
}