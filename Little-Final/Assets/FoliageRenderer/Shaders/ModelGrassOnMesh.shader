Shader "Unlit/ModelGrassOnMesh"
{
    Properties
    {
        _Albedo1 ("Base Color 1", Color) = (1, 1, 1)
        _Albedo2 ("Base Color 2", Color) = (1, 1, 1)
        _OldGrass ("Old Grass Color", Color) = (1, 1, 1)
        _AOColor ("Ambient Occlusion", Color) = (1, 1, 1)
        _TipColor ("Tip Color", Color) = (1, 1, 1)
        _FogColor ("Fog Color", Color) = (1, 1, 1)
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
                float4 noise : TEXCOORD5;
            };

            sampler2D _WindTex;
            float4 _Albedo1, _Albedo2, _OldGrass, _AOColor, _TipColor, _FogColor;
            StructuredBuffer<GrassData> _PositionBuffer;
            uint _dynamicPositionsCount;
            StructuredBuffer<float3> _dynamicPositions;
            float4x4 _ObjectWorldMatrix;
            float4x4 _ObjectRotationMatrix;
            float4x4 _ObjectScaleMatrix;
            float
            _Height,
            _Droop,
            _FogDensity,
            _FogOffset,
            _AvoidanceRadius,
            _AvoidanceMaxDisplacement,
            _WildFactor,
            _WildScale,
            _OldGrassColorFactor;

            int _ChunkNum;

            float4 RotateAroundYInDegrees(float4 vertex, const float degrees)
            {
                const float alpha = degrees * UNITY_PI / 180.0;
                float sina, cos_a;
                sincos(alpha, sina, cos_a);
                const float2x2 m = float2x2(cos_a, -sina, sina, cos_a);
                return float4(mul(m, vertex.xz), vertex.yw).xzyw;
            }

            float4 RotateAroundXInDegrees(float4 vertex, const float degrees)
            {
                const float alpha = degrees * UNITY_PI / 180.0;
                float sina, cos_a;
                sincos(alpha, sina, cos_a);
                const float2x2 m = float2x2(cos_a, -sina, sina, cos_a);
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

                // Remap for better user health
                _Height -= 1;

                const float4 buffered_grass_position = _PositionBuffer[instanceID].position;
                //TODO implement height by mask flow
                const float mask_height = _PositionBuffer[instanceID].height;
                const float id_hash = HashFromVector(buffered_grass_position);
                const float4 world_uv = float4(_PositionBuffer[instanceID].uv, 0, 0);
                const float uv_mask = v.uv.y;
                const float noise = saturate(mul(snoise(world_uv * _WildScale), _WildFactor)) * uv_mask * .5f;

                // Generates animation direction
                float4 animation_direction = float4(0.0f, 0.0f, 1.0f, 0.0f);
                animation_direction = normalize(RotateAroundYInDegrees(animation_direction, id_hash * 180.0f));

                // Set random rotation
                float4 local_position = RotateAroundYInDegrees(v.vertex, id_hash * 180.0f);
                
                // Rescale, Uses the middle as pivot
                local_position.y += uv_mask * noise;

                // Apply animation direction and drop
                local_position.xz +=
                    _Droop *
                    lerp(0.5f, 1.0f, id_hash) *
                    (v.uv.y * v.uv.y) *
                    animation_direction *
                    (noise + .05);

                // Generate de movement value
                float movement = v.uv.y * v.uv.y * tex2Dlod(_WindTex, world_uv).r * (noise + .05);
                const float sway_variance = lerp(0.8, 1.0, id_hash);
                movement *= sway_variance;

                // Apply final motion
                local_position.xz += movement * animation_direction;

                // Applies a noise to the global height, *hardcoded values*
                const float random_noise_height = saturate(mul(snoise(world_uv * 30), 1)) * uv_mask * .5f; 
                local_position.y -= random_noise_height;
                local_position.y *= 1.0f + _PositionBuffer[instanceID].position.w * lerp(0.8f, 1.0f, id_hash) * uv_mask * .5f;
                local_position.y += random_noise_height;

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
                        const float3 dynamic_pos = mul(_ObjectWorldMatrix, float4(_dynamicPositions[i],1)).xyz;
                        const float3 diff = dynamic_pos - buffered_grass_position.xyz;
                        const float dist = length(diff);
                        if (dist < _AvoidanceRadius)
                        {
                            const float t = dist / _AvoidanceRadius;
                            displacement -= v.uv.y * normalize(diff) * _AvoidanceMaxDisplacement * (1 - t);
                            displacement.y = 0;
                            world_position += float4(displacement, 1);
                        }
                    }
                }
                
                o.vertex = UnityObjectToClipPos(world_position);
                o.uv = v.uv;
                o.noiseVal = tex2Dlod(_WindTex, world_uv).r;
                o.worldPos = world_position;
                o.localPos = local_position;
                o.noise = noise;
                o.chunkNum = float3(
                    randValue(_ChunkNum * 20 + 1024),
                    randValue(randValue(_ChunkNum) * 10 + 2048),
                    randValue(_ChunkNum * 4 + 4096)
                );

                return o;
            }

            fixed4 frag(v2f i, uint instanceID : SV_INSTANCEID) : SV_Target
            {
                const float4 col = lerp(lerp(_Albedo1, _OldGrass, i.noise * _OldGrassColorFactor), _Albedo2, i.uv.y);
                // const float3 light_dir = _WorldSpaceLightPos0.xyz;
                // const float ndotl = DotClamped(light_dir, normalize(float3(0, 1, 0)));

                const float4 ao = lerp(_AOColor, 1.0f, i.uv.y);
                const float4 tip = lerp(0.0f, _TipColor, i.uv.y * i.uv.y);

                //const float rand = randValue(instanceID);
                // const float4 grass_color = (col + tip) * ndotl * ao;
                const float4 grass_color = (col + tip) * ao;
                
                /* Fog */
                // const float view_distance = length(_WorldSpaceCameraPos - i.worldPos);
                // float fog_factor = (_FogDensity / sqrt(log(2))) * (max(0.0f, view_distance - _FogOffset));
                // fog_factor = exp2(-fog_factor * fog_factor);

                //fixed4 color = lerp(_FogColor, grass_color, fog_factor);

                // return color;
                return grass_color;
            }
            ENDCG
        }
    }
}