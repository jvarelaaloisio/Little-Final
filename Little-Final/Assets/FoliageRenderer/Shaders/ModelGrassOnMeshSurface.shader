Shader "Lit/GrassOnMesh"
{
    Properties
    {
        _talloColor ("Tallo", Color) = (1, 1, 1)
        _oldTip ("Old Tip", Color) = (1, 1, 1)
        _TipColor ("Tip", Color) = (1, 1, 1)
        _Spots ("Spots factor", range(0,1)) = 1
    }
    SubShader
    {
        Pass
        {
            Tags
            {
                "LightMode"="ForwardBase"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            #pragma target 4.5

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #include "AutoLight.cginc"
            #include "Assets/FoliageRenderer/Shaders/Compute/Simplex.compute"
            #include "Assets/FoliageRenderer/Shaders/Compute/Random.cginc"
            #include "Assets/FoliageRenderer/Shaders/Compute/OnMeshGrassData.cginc"

            sampler2D _MainTex;

            #if SHADER_TARGET >= 45
            StructuredBuffer<GrassData> _PositionBuffer;
            StructuredBuffer<float3> _dynamicPositions;
            #endif

            sampler2D _WindTex;
            float4 _talloColor, _oldTip, _TipColor, _FogColor;
            uint _dynamicPositionsCount;
            float4x4 _ObjectWorldMatrix;
            float4x4 _ObjectRotationMatrix;
            float4x4 _ObjectScaleMatrix;
            float
            _Height,
            _Droop,
            _AvoidanceRadius,
            _AvoidanceMaxDisplacement,
            _WildFactor,
            _WildScale,
            _OldGrassColorFactor,
            _Spots;
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
            float SafeRandomRange(float2 seed, float min, float max)
            {
                const float2 vector0 = float2(12.9898, 78.233);
                const float dotProd = dot(seed, vector0);
                const float sinResult = sin(dotProd);
                const float sinProduct = mul(sinResult, 43758.55);
                return  lerp(min, max, frac(sinProduct));
            }
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 ambient : TEXCOORD1;
                float3 diffuse : TEXCOORD2;
                float3 color : TEXCOORD3;
                float2 uv_MainTex : TEXCOORD4;
                float4 worldPos : TEXCOORD5;
                float noiseVal : TEXCOORD6;
                float3 chunkNum : TEXCOORD7;
                float4 localPos : TEXCOORD8;
                float4 noise : TEXCOORD9;
                float id_hash : TEXCOORD10;
                SHADOW_COORDS(11)
            };

            void rotate2D(inout float2 v, float r)
            {
                float s, c;
                sincos(r, s, c);
                v = float2(v.x * c - v.y * s, v.x * s + v.y * c);
            }

            v2f vert(appdata_full v, uint instanceID : SV_InstanceID)
            {
                float3 worldNormal = v.normal;
                
                float3 ndotl = saturate(dot(worldNormal, _WorldSpaceLightPos0.xyz));
                float3 ambient = ShadeSH9(float4(worldNormal, 1.0f));
                float3 diffuse = (ndotl * _LightColor0.rgb);
                float3 color = v.color;

                v2f o;
                
                o.ambient = ambient;
                o.diffuse = diffuse;
                o.color = color;

                //For animation and position
                // Remap for better user health
                _Height -= 1;

                const float4 buffered_grass_position = _PositionBuffer[instanceID].position;
                float safeRand = SafeRandomRange(buffered_grass_position.xy, 0,1);
                
                //TODO implement height by mask flow
                const float mask_height = _PositionBuffer[instanceID].height;
                const float id_hash = HashFromVector(buffered_grass_position);
                const float4 world_uv = float4(_PositionBuffer[instanceID].uv, 0, 0);
                const float uv_mask = v.texcoord.y;
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
                    (v.texcoord.y * v.texcoord.y) *
                    animation_direction *
                    (noise + .05);

                // Generate de movement value
                float movement = v.texcoord.y * v.texcoord.y * tex2Dlod(_WindTex, world_uv).r * (noise + .05);
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
                world_position.xz += safeRand * .2;
                
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
                            displacement -= v.texcoord.y * normalize(diff) * _AvoidanceMaxDisplacement * (1 - t);
                            displacement.y = 0;
                            world_position += float4(displacement, 1);
                        }
                    }
                }
                
                o.pos = UnityObjectToClipPos(world_position);
                o.uv_MainTex = v.texcoord;
                o.noiseVal = tex2Dlod(_WindTex, world_uv).r;
                o.worldPos = world_position;
                o.localPos = local_position;
                o.noise = noise;
                o.chunkNum = float3(
                    randValue(_ChunkNum * 20 + 1024),
                    randValue(randValue(_ChunkNum) * 10 + 2048),
                    randValue(_ChunkNum * 4 + 4096)
                );
                o.id_hash = safeRand;
                //
                
                TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 final_tip_color = lerp(_TipColor, _oldTip, saturate(i.noise * _OldGrassColorFactor));
                final_tip_color = lerp(final_tip_color, _oldTip, saturate(i.id_hash));
                
                fixed shadow = SHADOW_ATTENUATION(i);
                
                fixed4 albedo = lerp(_talloColor, final_tip_color,  i.uv_MainTex.y);
                float3 lighting = i.diffuse * shadow + i.ambient;
                fixed4 output = fixed4(albedo.rgb * i.color * lighting, albedo.w);
                
                UNITY_APPLY_FOG(i.fogCoord, output);

                return saturate(output);
            }
            ENDCG
        }
    }
}