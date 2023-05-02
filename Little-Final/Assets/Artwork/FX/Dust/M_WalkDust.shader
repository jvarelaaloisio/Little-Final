// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_WalkDust"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_Inflation("Inflation", Range( 0 , 1)) = 0.1
		_NoiseScale("Noise Scale", Range( 0.1 , 100)) = 0
		_TimeScale("TimeScale", Range( 0 , 5)) = 0
		_FloorColor("Floor Color", Color) = (1,1,1,1)

	}


	Category 
	{
		SubShader
		{
		LOD 0

			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				
				#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
				#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
				#endif
				
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_instancing
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#include "UnityShaderVariables.cginc"
				#define ASE_NEEDS_FRAG_COLOR


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					float3 ase_normal : NORMAL;
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
					
				};
				
				
				#if UNITY_VERSION >= 560
				UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
				#else
				uniform sampler2D_float _CameraDepthTexture;
				#endif

				//Don't delete this comment
				// uniform sampler2D_float _CameraDepthTexture;

				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				uniform float _InvFade;
				uniform float _TimeScale;
				uniform float _NoiseScale;
				uniform float _Inflation;
				uniform float4 _FloorColor;
				inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
				inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
				inline float valueNoise (float2 uv)
				{
					float2 i = floor(uv);
					float2 f = frac( uv );
					f = f* f * (3.0 - 2.0 * f);
					uv = abs( frac(uv) - 0.5);
					float2 c0 = i + float2( 0.0, 0.0 );
					float2 c1 = i + float2( 1.0, 0.0 );
					float2 c2 = i + float2( 0.0, 1.0 );
					float2 c3 = i + float2( 1.0, 1.0 );
					float r0 = noise_randomValue( c0 );
					float r1 = noise_randomValue( c1 );
					float r2 = noise_randomValue( c2 );
					float r3 = noise_randomValue( c3 );
					float bottomOfGrid = noise_interpolate( r0, r1, f.x );
					float topOfGrid = noise_interpolate( r2, r3, f.x );
					float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
					return t;
				}
				
				float SimpleNoise(float2 UV)
				{
					float t = 0.0;
					float freq = pow( 2.0, float( 0 ) );
					float amp = pow( 0.5, float( 3 - 0 ) );
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(1));
					amp = pow(0.5, float(3-1));
					t += valueNoise( UV/freq )*amp;
					freq = pow(2.0, float(2));
					amp = pow(0.5, float(3-2));
					t += valueNoise( UV/freq )*amp;
					return t;
				}
				


				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					float2 texCoord3 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float mulTime23 = _Time.y * _TimeScale;
					float cos22 = cos( mulTime23 );
					float sin22 = sin( mulTime23 );
					float2 rotator22 = mul( texCoord3 - float2( 0,0 ) , float2x2( cos22 , -sin22 , sin22 , cos22 )) + float2( 0,0 );
					float simpleNoise2 = SimpleNoise( rotator22*_NoiseScale );
					float NoiseMask29 = simpleNoise2;
					float smoothstepResult9 = smoothstep( 0.75 , 0.25 , NoiseMask29);
					float3 VertexOffset39 = ( smoothstepResult9 * _Inflation * v.ase_normal );
					

					v.vertex.xyz += VertexOffset39;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID( i );
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( i );

					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float4 Color27 = ( _FloorColor * i.color );
					float4 break76 = Color27;
					float OriginalAlpha33 = i.color.a;
					float2 texCoord3 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
					float mulTime23 = _Time.y * _TimeScale;
					float cos22 = cos( mulTime23 );
					float sin22 = sin( mulTime23 );
					float2 rotator22 = mul( texCoord3 - float2( 0,0 ) , float2x2( cos22 , -sin22 , sin22 , cos22 )) + float2( 0,0 );
					float simpleNoise2 = SimpleNoise( rotator22*_NoiseScale );
					float NoiseMask29 = simpleNoise2;
					float Alpha36 = ( OriginalAlpha33 * step( NoiseMask29 , 0.5 ) );
					float4 appendResult77 = (float4(break76.r , break76.g , break76.b , Alpha36));
					

					fixed4 col = appendResult77;
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.CommentaryNode;42;-1273.603,-492.1537;Inherit;False;652;428;Output;6;75;77;76;40;37;28;;0.6792453,0.2274831,0.5409575,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;41;-1439.56,-46.7121;Inherit;False;796.0365;410.9949;Vertex Offset;6;39;18;17;19;9;31;;0,0.9105978,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;38;-2135.166,-493.5015;Inherit;False;851.9883;419.8782;Alpha;5;30;10;34;21;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;35;-2821.873,-494.5576;Inherit;False;661.2096;427.2285;Color Input;5;25;26;8;33;27;;1,0.3066038,0.3066038,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;32;-2819.777,-50;Inherit;False;1353.74;354.7197;Noise;7;29;2;22;3;24;23;20;;0.5660378,0.5660378,0.5660378,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2250.078,133.4004;Inherit;False;Property;_NoiseScale;Noise Scale;1;0;Create;True;0;0;0;False;0;False;0;43.1;0.1;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;23;-2487.777,126.3424;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2769.777,121.3424;Inherit;False;Property;_TimeScale;TimeScale;2;0;Create;True;0;0;0;False;0;False;0;2.26;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2528,0;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;22;-2240,0;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-1952,0;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;7.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;-2771.873,-444.5572;Inherit;False;Property;_FloorColor;Floor Color;3;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.6226414,0.4540961,0.1615342,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-2532.918,-353.5578;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;8;-2719.339,-274.3287;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;9;-1212.509,3.287864;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.75;False;2;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1318.569,129.3041;Inherit;False;Property;_Inflation;Inflation;0;0;Create;True;0;0;0;False;0;False;0.1;0.146;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;17;-1216.677,211.1;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1016.344,98.41145;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-1696,0;Inherit;False;NoiseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-1389.56,3.287864;Inherit;False;29;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-861.5593,99.28791;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1239.603,-442.1535;Inherit;False;27;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-2085.166,-347.5014;Inherit;False;29;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-1877.167,-443.5015;Inherit;False;33;OriginalAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-2384.664,-358.9008;Inherit;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-2511.374,-183.6066;Inherit;False;OriginalAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1653.166,-427.5015;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-1488,-432;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;55;-1688.524,451.5068;Inherit;False;Global;_GrabScreen0;Grab Screen 0;4;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;64;-2240.351,439.7208;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;65;-1962.681,469.1942;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;10;-1893.167,-347.5014;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-1240.603,-362.1537;Inherit;False;36;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-1255.603,-282.1538;Inherit;False;39;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;76;-1075.511,-438.5449;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;77;-943.5107,-437.5449;Inherit;False;COLOR;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;75;-754.5759,-338.2616;Float;False;True;-1;2;ASEMaterialInspector;0;11;M_WalkDust;0b6a9f8b4f707c74ca64c0be8e590de0;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;False;True;2;5;False;;10;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;True;True;True;True;False;0;False;;False;False;False;False;False;False;False;False;False;True;2;False;;True;3;False;;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;23;0;24;0
WireConnection;22;0;3;0
WireConnection;22;2;23;0
WireConnection;2;0;22;0
WireConnection;2;1;20;0
WireConnection;26;0;25;0
WireConnection;26;1;8;0
WireConnection;9;0;31;0
WireConnection;18;0;9;0
WireConnection;18;1;19;0
WireConnection;18;2;17;0
WireConnection;29;0;2;0
WireConnection;39;0;18;0
WireConnection;27;0;26;0
WireConnection;33;0;8;4
WireConnection;21;0;34;0
WireConnection;21;1;10;0
WireConnection;36;0;21;0
WireConnection;55;0;65;0
WireConnection;65;0;64;0
WireConnection;10;0;30;0
WireConnection;76;0;28;0
WireConnection;77;0;76;0
WireConnection;77;1;76;1
WireConnection;77;2;76;2
WireConnection;77;3;37;0
WireConnection;75;0;77;0
WireConnection;75;1;40;0
ASEEND*/
//CHKSM=BF33618E09475DD2E9F7D873A58CCD9B7A3ECC24