// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Drimys/Nature/TerrainMixer"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][NoScaleOffset]_BaseBaseColor("Base Base Color", 2D) = "white" {}
		[NoScaleOffset]_BaseHeight("Base Height", 2D) = "white" {}
		[NoScaleOffset]_BaseRoughness("Base Roughness", 2D) = "white" {}
		[NoScaleOffset][Normal]_BaseNormal("Base Normal", 2D) = "bump" {}
		[NoScaleOffset]_Texture_1("Texture_1", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal_1("Normal_1", 2D) = "bump" {}
		[NoScaleOffset]_Roughness_1("Roughness_1", 2D) = "white" {}
		[NoScaleOffset]_Height_1("Height_1", 2D) = "white" {}
		[NoScaleOffset]_Texture_2("Texture_2", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal_2("Normal_2", 2D) = "bump" {}
		[NoScaleOffset]_Roughness_2("Roughness_2", 2D) = "white" {}
		[NoScaleOffset]_Height_2("Height_2", 2D) = "white" {}
		[NoScaleOffset]_Texture_3("Texture_3", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal_3("Normal_3", 2D) = "bump" {}
		[NoScaleOffset]_Roughness_3("Roughness_3", 2D) = "white" {}
		[NoScaleOffset]_Height_3("Height_3", 2D) = "white" {}
		_Noseintensityval("Nose intensity val", Float) = 0
		_Noisescaleval("Noise scale val", Float) = 0
		_WhitNoiseLerpTex1("Whit Noise Lerp Tex 1", Range( 0 , 1)) = 0
		_WhitNoiseLerpTex2("Whit Noise Lerp Tex 2", Range( 0 , 1)) = 0
		_WhitNoiseLerpTex3("Whit Noise Lerp Tex 3", Range( 0 , 1)) = 0
		_WhitNoiseLerpTex4("Whit Noise Lerp Tex 3", Range( 0 , 1)) = 0
		_Tiling("Tiling", Float) = 0
		[ASEEnd]_Tesellationfactor("Tesellation factor", Float) = 0


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		[HideInInspector][ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[HideInInspector][ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0
		[HideInInspector][ToggleOff] _ReceiveShadows("Receive Shadows", Float) = 1.0

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" "UniversalMaterialType"="Lit" }

		Cull Back
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		AlphaToMask Off

		

		HLSLINCLUDE
		#pragma target 3.5
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}

		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007


			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#pragma multi_compile _ _FORWARD_PLUS
			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ DEBUG_DISPLAY
			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 screenPos : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float _Tesellationfactor;
			float _Tiling;
			float _Noseintensityval;
			float _Noisescaleval;
			float _WhitNoiseLerpTex4;
			float _WhitNoiseLerpTex1;
			float _WhitNoiseLerpTex2;
			float _WhitNoiseLerpTex3;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _BaseHeight;
			sampler2D _Height_1;
			sampler2D _Height_2;
			sampler2D _Height_3;
			sampler2D _BaseBaseColor;
			sampler2D _Texture_1;
			sampler2D _Texture_2;
			sampler2D _Texture_3;
			sampler2D _BaseNormal;
			sampler2D _Normal_1;
			sampler2D _Normal_2;
			sampler2D _Normal_3;
			sampler2D _BaseRoughness;
			sampler2D _Roughness_1;
			sampler2D _Roughness_2;
			sampler2D _Roughness_3;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

					float2 voronoihash2_g240( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g240( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g240( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
					float2 voronoihash2_g242( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g242( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g242( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g241( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g241( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g241( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g252( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g252( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g252( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g254( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g254( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g254( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g253( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g253( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g253( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g248( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g248( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g248( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g250( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g250( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g250( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g249( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g249( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g249( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g244( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g244( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g244( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g246( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g246( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g246( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g245( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g245( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g245( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = v.texcoord.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = v.ase_color;
				float3 temp_output_20_0_g239 = VertexColor_var61.rgb;
				float3 break21_g239 = temp_output_20_0_g239;
				float temp_output_9_0_g240 = break21_g239.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g239 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g239 = Noisescaleval190;
				float temp_output_11_0_g240 = temp_output_47_0_g239;
				float time2_g240 = 0.0;
				float2 voronoiSmoothId2_g240 = 0;
				float2 texCoord4_g240 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g240 = texCoord4_g240 * temp_output_11_0_g240;
				float2 id2_g240 = 0;
				float2 uv2_g240 = 0;
				float voroi2_g240 = voronoi2_g240( coords2_g240, time2_g240, id2_g240, uv2_g240, 0, voronoiSmoothId2_g240 );
				float simplePerlin2D12_g240 = snoise( texCoord4_g240*temp_output_11_0_g240 );
				simplePerlin2D12_g240 = simplePerlin2D12_g240*0.5 + 0.5;
				float temp_output_53_0_g239 = _WhitNoiseLerpTex4;
				float lerpResult52_g239 = lerp( break21_g239.x , ( (0.0 + (temp_output_9_0_g240 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g240 + ( voroi2_g240 + simplePerlin2D12_g240 ) ) ) , temp_output_53_0_g239);
				float temp_output_3_0_g239 = saturate( lerpResult52_g239 );
				float temp_output_9_0_g242 = break21_g239.y;
				float temp_output_11_0_g242 = temp_output_47_0_g239;
				float time2_g242 = 0.0;
				float2 voronoiSmoothId2_g242 = 0;
				float2 texCoord4_g242 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g242 = texCoord4_g242 * temp_output_11_0_g242;
				float2 id2_g242 = 0;
				float2 uv2_g242 = 0;
				float voroi2_g242 = voronoi2_g242( coords2_g242, time2_g242, id2_g242, uv2_g242, 0, voronoiSmoothId2_g242 );
				float simplePerlin2D12_g242 = snoise( texCoord4_g242*temp_output_11_0_g242 );
				simplePerlin2D12_g242 = simplePerlin2D12_g242*0.5 + 0.5;
				float lerpResult56_g239 = lerp( break21_g239.y , ( (0.0 + (temp_output_9_0_g242 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g242 + ( voroi2_g242 + simplePerlin2D12_g242 ) ) ) , temp_output_53_0_g239);
				float temp_output_2_0_g239 = saturate( lerpResult56_g239 );
				float temp_output_9_0_g241 = break21_g239.z;
				float temp_output_11_0_g241 = temp_output_47_0_g239;
				float time2_g241 = 0.0;
				float2 voronoiSmoothId2_g241 = 0;
				float2 texCoord4_g241 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g241 = texCoord4_g241 * temp_output_11_0_g241;
				float2 id2_g241 = 0;
				float2 uv2_g241 = 0;
				float voroi2_g241 = voronoi2_g241( coords2_g241, time2_g241, id2_g241, uv2_g241, 0, voronoiSmoothId2_g241 );
				float simplePerlin2D12_g241 = snoise( texCoord4_g241*temp_output_11_0_g241 );
				simplePerlin2D12_g241 = simplePerlin2D12_g241*0.5 + 0.5;
				float lerpResult57_g239 = lerp( break21_g239.z , ( (0.0 + (temp_output_9_0_g241 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g241 + ( voroi2_g241 + simplePerlin2D12_g241 ) ) ) , temp_output_53_0_g239);
				float temp_output_4_0_g239 = saturate( lerpResult57_g239 );
				float3 OUT_VertexOffset203 = ( ( _Tesellationfactor * ( ( tex2Dlod( _BaseHeight, float4( UV171, 0, 0.0) ).r * ( 1.0 - saturate( ( temp_output_3_0_g239 + temp_output_2_0_g239 + temp_output_4_0_g239 ) ) ) ) + ( ( ( tex2Dlod( _Height_1, float4( UV171, 0, 0.0) ).r * temp_output_3_0_g239 ) + ( tex2Dlod( _Height_2, float4( UV171, 0, 0.0) ).r * temp_output_2_0_g239 ) ) + ( tex2Dlod( _Height_3, float4( UV171, 0, 0.0) ).r * temp_output_4_0_g239 ) ) ) ) * v.vertex.xyz );
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset203;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif

				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(positionCS);
				#endif

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag ( VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 ScreenPos = IN.screenPos;
				#endif

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = IN.ase_texcoord8.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = IN.ase_color;
				float3 temp_output_20_0_g251 = VertexColor_var61.rgb;
				float3 break21_g251 = temp_output_20_0_g251;
				float temp_output_9_0_g252 = break21_g251.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g251 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g251 = Noisescaleval190;
				float temp_output_11_0_g252 = temp_output_47_0_g251;
				float time2_g252 = 0.0;
				float2 voronoiSmoothId2_g252 = 0;
				float2 texCoord4_g252 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g252 = texCoord4_g252 * temp_output_11_0_g252;
				float2 id2_g252 = 0;
				float2 uv2_g252 = 0;
				float voroi2_g252 = voronoi2_g252( coords2_g252, time2_g252, id2_g252, uv2_g252, 0, voronoiSmoothId2_g252 );
				float simplePerlin2D12_g252 = snoise( texCoord4_g252*temp_output_11_0_g252 );
				simplePerlin2D12_g252 = simplePerlin2D12_g252*0.5 + 0.5;
				float temp_output_53_0_g251 = _WhitNoiseLerpTex1;
				float lerpResult52_g251 = lerp( break21_g251.x , ( (0.0 + (temp_output_9_0_g252 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g252 + ( voroi2_g252 + simplePerlin2D12_g252 ) ) ) , temp_output_53_0_g251);
				float temp_output_3_0_g251 = saturate( lerpResult52_g251 );
				float temp_output_9_0_g254 = break21_g251.y;
				float temp_output_11_0_g254 = temp_output_47_0_g251;
				float time2_g254 = 0.0;
				float2 voronoiSmoothId2_g254 = 0;
				float2 texCoord4_g254 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g254 = texCoord4_g254 * temp_output_11_0_g254;
				float2 id2_g254 = 0;
				float2 uv2_g254 = 0;
				float voroi2_g254 = voronoi2_g254( coords2_g254, time2_g254, id2_g254, uv2_g254, 0, voronoiSmoothId2_g254 );
				float simplePerlin2D12_g254 = snoise( texCoord4_g254*temp_output_11_0_g254 );
				simplePerlin2D12_g254 = simplePerlin2D12_g254*0.5 + 0.5;
				float lerpResult56_g251 = lerp( break21_g251.y , ( (0.0 + (temp_output_9_0_g254 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g254 + ( voroi2_g254 + simplePerlin2D12_g254 ) ) ) , temp_output_53_0_g251);
				float temp_output_2_0_g251 = saturate( lerpResult56_g251 );
				float temp_output_9_0_g253 = break21_g251.z;
				float temp_output_11_0_g253 = temp_output_47_0_g251;
				float time2_g253 = 0.0;
				float2 voronoiSmoothId2_g253 = 0;
				float2 texCoord4_g253 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g253 = texCoord4_g253 * temp_output_11_0_g253;
				float2 id2_g253 = 0;
				float2 uv2_g253 = 0;
				float voroi2_g253 = voronoi2_g253( coords2_g253, time2_g253, id2_g253, uv2_g253, 0, voronoiSmoothId2_g253 );
				float simplePerlin2D12_g253 = snoise( texCoord4_g253*temp_output_11_0_g253 );
				simplePerlin2D12_g253 = simplePerlin2D12_g253*0.5 + 0.5;
				float lerpResult57_g251 = lerp( break21_g251.z , ( (0.0 + (temp_output_9_0_g253 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g253 + ( voroi2_g253 + simplePerlin2D12_g253 ) ) ) , temp_output_53_0_g251);
				float temp_output_4_0_g251 = saturate( lerpResult57_g251 );
				float4 OUT_BaseColor199 = ( ( tex2D( _BaseBaseColor, UV171 ) * ( 1.0 - saturate( ( temp_output_3_0_g251 + temp_output_2_0_g251 + temp_output_4_0_g251 ) ) ) ) + ( ( ( tex2D( _Texture_1, UV171 ) * temp_output_3_0_g251 ) + ( tex2D( _Texture_2, UV171 ) * temp_output_2_0_g251 ) ) + ( tex2D( _Texture_3, UV171 ) * temp_output_4_0_g251 ) ) );
				
				float3 temp_output_20_0_g247 = VertexColor_var61.rgb;
				float3 break21_g247 = temp_output_20_0_g247;
				float temp_output_9_0_g248 = break21_g247.x;
				float temp_output_46_0_g247 = NoiseIntensityval186;
				float temp_output_47_0_g247 = Noisescaleval190;
				float temp_output_11_0_g248 = temp_output_47_0_g247;
				float time2_g248 = 0.0;
				float2 voronoiSmoothId2_g248 = 0;
				float2 texCoord4_g248 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g248 = texCoord4_g248 * temp_output_11_0_g248;
				float2 id2_g248 = 0;
				float2 uv2_g248 = 0;
				float voroi2_g248 = voronoi2_g248( coords2_g248, time2_g248, id2_g248, uv2_g248, 0, voronoiSmoothId2_g248 );
				float simplePerlin2D12_g248 = snoise( texCoord4_g248*temp_output_11_0_g248 );
				simplePerlin2D12_g248 = simplePerlin2D12_g248*0.5 + 0.5;
				float temp_output_53_0_g247 = _WhitNoiseLerpTex2;
				float lerpResult52_g247 = lerp( break21_g247.x , ( (0.0 + (temp_output_9_0_g248 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g248 + ( voroi2_g248 + simplePerlin2D12_g248 ) ) ) , temp_output_53_0_g247);
				float temp_output_3_0_g247 = saturate( lerpResult52_g247 );
				float temp_output_9_0_g250 = break21_g247.y;
				float temp_output_11_0_g250 = temp_output_47_0_g247;
				float time2_g250 = 0.0;
				float2 voronoiSmoothId2_g250 = 0;
				float2 texCoord4_g250 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g250 = texCoord4_g250 * temp_output_11_0_g250;
				float2 id2_g250 = 0;
				float2 uv2_g250 = 0;
				float voroi2_g250 = voronoi2_g250( coords2_g250, time2_g250, id2_g250, uv2_g250, 0, voronoiSmoothId2_g250 );
				float simplePerlin2D12_g250 = snoise( texCoord4_g250*temp_output_11_0_g250 );
				simplePerlin2D12_g250 = simplePerlin2D12_g250*0.5 + 0.5;
				float lerpResult56_g247 = lerp( break21_g247.y , ( (0.0 + (temp_output_9_0_g250 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g250 + ( voroi2_g250 + simplePerlin2D12_g250 ) ) ) , temp_output_53_0_g247);
				float temp_output_2_0_g247 = saturate( lerpResult56_g247 );
				float temp_output_9_0_g249 = break21_g247.z;
				float temp_output_11_0_g249 = temp_output_47_0_g247;
				float time2_g249 = 0.0;
				float2 voronoiSmoothId2_g249 = 0;
				float2 texCoord4_g249 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g249 = texCoord4_g249 * temp_output_11_0_g249;
				float2 id2_g249 = 0;
				float2 uv2_g249 = 0;
				float voroi2_g249 = voronoi2_g249( coords2_g249, time2_g249, id2_g249, uv2_g249, 0, voronoiSmoothId2_g249 );
				float simplePerlin2D12_g249 = snoise( texCoord4_g249*temp_output_11_0_g249 );
				simplePerlin2D12_g249 = simplePerlin2D12_g249*0.5 + 0.5;
				float lerpResult57_g247 = lerp( break21_g247.z , ( (0.0 + (temp_output_9_0_g249 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g249 + ( voroi2_g249 + simplePerlin2D12_g249 ) ) ) , temp_output_53_0_g247);
				float temp_output_4_0_g247 = saturate( lerpResult57_g247 );
				float3 OUT_Normal200 = ( ( UnpackNormalScale( tex2D( _BaseNormal, UV171 ), 1.0f ) * ( 1.0 - saturate( ( temp_output_3_0_g247 + temp_output_2_0_g247 + temp_output_4_0_g247 ) ) ) ) + ( ( ( UnpackNormalScale( tex2D( _Normal_1, UV171 ), 1.0f ) * temp_output_3_0_g247 ) + ( UnpackNormalScale( tex2D( _Normal_2, UV171 ), 1.0f ) * temp_output_2_0_g247 ) ) + ( UnpackNormalScale( tex2D( _Normal_3, UV171 ), 1.0f ) * temp_output_4_0_g247 ) ) );
				
				float4 color104 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 OUT_Metallic201 = color104;
				
				float3 temp_output_20_0_g243 = VertexColor_var61.rgb;
				float3 break21_g243 = temp_output_20_0_g243;
				float temp_output_9_0_g244 = break21_g243.x;
				float temp_output_46_0_g243 = NoiseIntensityval186;
				float temp_output_47_0_g243 = Noisescaleval190;
				float temp_output_11_0_g244 = temp_output_47_0_g243;
				float time2_g244 = 0.0;
				float2 voronoiSmoothId2_g244 = 0;
				float2 texCoord4_g244 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g244 = texCoord4_g244 * temp_output_11_0_g244;
				float2 id2_g244 = 0;
				float2 uv2_g244 = 0;
				float voroi2_g244 = voronoi2_g244( coords2_g244, time2_g244, id2_g244, uv2_g244, 0, voronoiSmoothId2_g244 );
				float simplePerlin2D12_g244 = snoise( texCoord4_g244*temp_output_11_0_g244 );
				simplePerlin2D12_g244 = simplePerlin2D12_g244*0.5 + 0.5;
				float temp_output_53_0_g243 = _WhitNoiseLerpTex3;
				float lerpResult52_g243 = lerp( break21_g243.x , ( (0.0 + (temp_output_9_0_g244 - 0.0) * (temp_output_46_0_g243 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g244 + ( voroi2_g244 + simplePerlin2D12_g244 ) ) ) , temp_output_53_0_g243);
				float temp_output_3_0_g243 = saturate( lerpResult52_g243 );
				float temp_output_9_0_g246 = break21_g243.y;
				float temp_output_11_0_g246 = temp_output_47_0_g243;
				float time2_g246 = 0.0;
				float2 voronoiSmoothId2_g246 = 0;
				float2 texCoord4_g246 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g246 = texCoord4_g246 * temp_output_11_0_g246;
				float2 id2_g246 = 0;
				float2 uv2_g246 = 0;
				float voroi2_g246 = voronoi2_g246( coords2_g246, time2_g246, id2_g246, uv2_g246, 0, voronoiSmoothId2_g246 );
				float simplePerlin2D12_g246 = snoise( texCoord4_g246*temp_output_11_0_g246 );
				simplePerlin2D12_g246 = simplePerlin2D12_g246*0.5 + 0.5;
				float lerpResult56_g243 = lerp( break21_g243.y , ( (0.0 + (temp_output_9_0_g246 - 0.0) * (temp_output_46_0_g243 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g246 + ( voroi2_g246 + simplePerlin2D12_g246 ) ) ) , temp_output_53_0_g243);
				float temp_output_2_0_g243 = saturate( lerpResult56_g243 );
				float temp_output_9_0_g245 = break21_g243.z;
				float temp_output_11_0_g245 = temp_output_47_0_g243;
				float time2_g245 = 0.0;
				float2 voronoiSmoothId2_g245 = 0;
				float2 texCoord4_g245 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g245 = texCoord4_g245 * temp_output_11_0_g245;
				float2 id2_g245 = 0;
				float2 uv2_g245 = 0;
				float voroi2_g245 = voronoi2_g245( coords2_g245, time2_g245, id2_g245, uv2_g245, 0, voronoiSmoothId2_g245 );
				float simplePerlin2D12_g245 = snoise( texCoord4_g245*temp_output_11_0_g245 );
				simplePerlin2D12_g245 = simplePerlin2D12_g245*0.5 + 0.5;
				float lerpResult57_g243 = lerp( break21_g243.z , ( (0.0 + (temp_output_9_0_g245 - 0.0) * (temp_output_46_0_g243 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g245 + ( voroi2_g245 + simplePerlin2D12_g245 ) ) ) , temp_output_53_0_g243);
				float temp_output_4_0_g243 = saturate( lerpResult57_g243 );
				float3 temp_cast_6 = (( 1.0 - ( ( tex2D( _BaseRoughness, UV171 ).r * ( 1.0 - saturate( ( temp_output_3_0_g243 + temp_output_2_0_g243 + temp_output_4_0_g243 ) ) ) ) + ( ( ( tex2D( _Roughness_1, UV171 ).r * temp_output_3_0_g243 ) + ( tex2D( _Roughness_2, UV171 ).r * temp_output_2_0_g243 ) ) + ( tex2D( _Roughness_3, UV171 ).r * temp_output_4_0_g243 ) ) ) )).xxx;
				float grayscale103 = Luminance(temp_cast_6);
				float OUT_Smoothnes202 = grayscale103;
				

				float3 BaseColor = OUT_BaseColor199.rgb;
				float3 Normal = OUT_Normal200;
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = OUT_Metallic201.r;
				float Smoothness = OUT_Smoothnes202;
				float Occlusion = 1;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _CLEARCOAT
					float CoatMask = 0;
					float CoatSmoothness = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;

				#ifdef _NORMALMAP
						#if _NORMAL_DROPOFF_TS
							inputData.normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent, WorldBiTangent, WorldNormal));
						#elif _NORMAL_DROPOFF_OS
							inputData.normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							inputData.normalWS = Normal;
						#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					inputData.shadowCoord = ShadowCoords;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
				#else
					inputData.shadowCoord = float4(0, 0, 0, 0);
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif
					inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
				#else
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
					#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				SurfaceData surfaceData;
				surfaceData.albedo              = BaseColor;
				surfaceData.metallic            = saturate(Metallic);
				surfaceData.specular            = Specular;
				surfaceData.smoothness          = saturate(Smoothness),
				surfaceData.occlusion           = Occlusion,
				surfaceData.emission            = Emission,
				surfaceData.alpha               = saturate(Alpha);
				surfaceData.normalTS            = Normal;
				surfaceData.clearCoatMask       = 0;
				surfaceData.clearCoatSmoothness = 1;

				#ifdef _CLEARCOAT
					surfaceData.clearCoatMask       = saturate(CoatMask);
					surfaceData.clearCoatSmoothness = saturate(CoatSmoothness);
				#endif

				#ifdef _DBUFFER
					ApplyDecalToSurfaceData(IN.clipPos, surfaceData, inputData);
				#endif

				half4 color = UniversalFragmentPBR( inputData, surfaceData);

				#ifdef ASE_TRANSMISSION
				{
					float shadow = _TransmissionShadow;

					#define SUM_LIGHT_TRANSMISSION(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 transmission = max( 0, -dot( inputData.normalWS, Light.direction ) ) * atten * Transmission;\
						color.rgb += BaseColor * transmission;

					SUM_LIGHT_TRANSMISSION( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_FORWARD_PLUS
							for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSMISSION( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSMISSION( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_TRANSLUCENCY
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					#define SUM_LIGHT_TRANSLUCENCY(Light)\
						float3 atten = Light.color * Light.distanceAttenuation;\
						atten = lerp( atten, atten * Light.shadowAttenuation, shadow );\
						half3 lightDir = Light.direction + inputData.normalWS * normal;\
						half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );\
						half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;\
						color.rgb += BaseColor * translucency * strength;

					SUM_LIGHT_TRANSLUCENCY( GetMainLight( inputData.shadowCoord ) );

					#if defined(_ADDITIONAL_LIGHTS)
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
						#if USE_FORWARD_PLUS
							for (uint lightIndex = 0; lightIndex < min(URP_FP_DIRECTIONAL_LIGHTS_COUNT, MAX_VISIBLE_LIGHTS); lightIndex++)
							{
								FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK

								Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
								#ifdef _LIGHT_LAYERS
								if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
								#endif
								{
									SUM_LIGHT_TRANSLUCENCY( light );
								}
							}
						#endif
						LIGHT_LOOP_BEGIN( pixelLightCount )
							Light light = GetAdditionalLight(lightIndex, inputData.positionWS);
							#ifdef _LIGHT_LAYERS
							if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
							#endif
							{
								SUM_LIGHT_TRANSLUCENCY( light );
							}
						LIGHT_LOOP_END
					#endif
				}
				#endif

				#ifdef ASE_REFRACTION
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, float4( WorldNormal,0 ) ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos.xy ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off
			ColorMask 0

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float _Tesellationfactor;
			float _Tiling;
			float _Noseintensityval;
			float _Noisescaleval;
			float _WhitNoiseLerpTex4;
			float _WhitNoiseLerpTex1;
			float _WhitNoiseLerpTex2;
			float _WhitNoiseLerpTex3;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _BaseHeight;
			sampler2D _Height_1;
			sampler2D _Height_2;
			sampler2D _Height_3;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

					float2 voronoihash2_g240( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g240( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g240( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
					float2 voronoihash2_g242( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g242( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g242( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g241( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g241( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g241( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			

			float3 _LightDirection;
			float3 _LightPosition;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = v.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = v.ase_color;
				float3 temp_output_20_0_g239 = VertexColor_var61.rgb;
				float3 break21_g239 = temp_output_20_0_g239;
				float temp_output_9_0_g240 = break21_g239.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g239 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g239 = Noisescaleval190;
				float temp_output_11_0_g240 = temp_output_47_0_g239;
				float time2_g240 = 0.0;
				float2 voronoiSmoothId2_g240 = 0;
				float2 texCoord4_g240 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g240 = texCoord4_g240 * temp_output_11_0_g240;
				float2 id2_g240 = 0;
				float2 uv2_g240 = 0;
				float voroi2_g240 = voronoi2_g240( coords2_g240, time2_g240, id2_g240, uv2_g240, 0, voronoiSmoothId2_g240 );
				float simplePerlin2D12_g240 = snoise( texCoord4_g240*temp_output_11_0_g240 );
				simplePerlin2D12_g240 = simplePerlin2D12_g240*0.5 + 0.5;
				float temp_output_53_0_g239 = _WhitNoiseLerpTex4;
				float lerpResult52_g239 = lerp( break21_g239.x , ( (0.0 + (temp_output_9_0_g240 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g240 + ( voroi2_g240 + simplePerlin2D12_g240 ) ) ) , temp_output_53_0_g239);
				float temp_output_3_0_g239 = saturate( lerpResult52_g239 );
				float temp_output_9_0_g242 = break21_g239.y;
				float temp_output_11_0_g242 = temp_output_47_0_g239;
				float time2_g242 = 0.0;
				float2 voronoiSmoothId2_g242 = 0;
				float2 texCoord4_g242 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g242 = texCoord4_g242 * temp_output_11_0_g242;
				float2 id2_g242 = 0;
				float2 uv2_g242 = 0;
				float voroi2_g242 = voronoi2_g242( coords2_g242, time2_g242, id2_g242, uv2_g242, 0, voronoiSmoothId2_g242 );
				float simplePerlin2D12_g242 = snoise( texCoord4_g242*temp_output_11_0_g242 );
				simplePerlin2D12_g242 = simplePerlin2D12_g242*0.5 + 0.5;
				float lerpResult56_g239 = lerp( break21_g239.y , ( (0.0 + (temp_output_9_0_g242 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g242 + ( voroi2_g242 + simplePerlin2D12_g242 ) ) ) , temp_output_53_0_g239);
				float temp_output_2_0_g239 = saturate( lerpResult56_g239 );
				float temp_output_9_0_g241 = break21_g239.z;
				float temp_output_11_0_g241 = temp_output_47_0_g239;
				float time2_g241 = 0.0;
				float2 voronoiSmoothId2_g241 = 0;
				float2 texCoord4_g241 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g241 = texCoord4_g241 * temp_output_11_0_g241;
				float2 id2_g241 = 0;
				float2 uv2_g241 = 0;
				float voroi2_g241 = voronoi2_g241( coords2_g241, time2_g241, id2_g241, uv2_g241, 0, voronoiSmoothId2_g241 );
				float simplePerlin2D12_g241 = snoise( texCoord4_g241*temp_output_11_0_g241 );
				simplePerlin2D12_g241 = simplePerlin2D12_g241*0.5 + 0.5;
				float lerpResult57_g239 = lerp( break21_g239.z , ( (0.0 + (temp_output_9_0_g241 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g241 + ( voroi2_g241 + simplePerlin2D12_g241 ) ) ) , temp_output_53_0_g239);
				float temp_output_4_0_g239 = saturate( lerpResult57_g239 );
				float3 OUT_VertexOffset203 = ( ( _Tesellationfactor * ( ( tex2Dlod( _BaseHeight, float4( UV171, 0, 0.0) ).r * ( 1.0 - saturate( ( temp_output_3_0_g239 + temp_output_2_0_g239 + temp_output_4_0_g239 ) ) ) ) + ( ( ( tex2Dlod( _Height_1, float4( UV171, 0, 0.0) ).r * temp_output_3_0_g239 ) + ( tex2Dlod( _Height_2, float4( UV171, 0, 0.0) ).r * temp_output_2_0_g239 ) ) + ( tex2Dlod( _Height_3, float4( UV171, 0, 0.0) ).r * temp_output_4_0_g239 ) ) ) ) * v.vertex.xyz );
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset203;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				#if _CASTING_PUNCTUAL_LIGHT_SHADOW
					float3 lightDirectionWS = normalize(_LightPosition - positionWS);
				#else
					float3 lightDirectionWS = _LightDirection;
				#endif

				float4 clipPos = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = clipPos;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				

				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask R
			AlphaToMask Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
			
			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float _Tesellationfactor;
			float _Tiling;
			float _Noseintensityval;
			float _Noisescaleval;
			float _WhitNoiseLerpTex4;
			float _WhitNoiseLerpTex1;
			float _WhitNoiseLerpTex2;
			float _WhitNoiseLerpTex3;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _BaseHeight;
			sampler2D _Height_1;
			sampler2D _Height_2;
			sampler2D _Height_3;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

					float2 voronoihash2_g240( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g240( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g240( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
					float2 voronoihash2_g242( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g242( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g242( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g241( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g241( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g241( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = v.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = v.ase_color;
				float3 temp_output_20_0_g239 = VertexColor_var61.rgb;
				float3 break21_g239 = temp_output_20_0_g239;
				float temp_output_9_0_g240 = break21_g239.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g239 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g239 = Noisescaleval190;
				float temp_output_11_0_g240 = temp_output_47_0_g239;
				float time2_g240 = 0.0;
				float2 voronoiSmoothId2_g240 = 0;
				float2 texCoord4_g240 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g240 = texCoord4_g240 * temp_output_11_0_g240;
				float2 id2_g240 = 0;
				float2 uv2_g240 = 0;
				float voroi2_g240 = voronoi2_g240( coords2_g240, time2_g240, id2_g240, uv2_g240, 0, voronoiSmoothId2_g240 );
				float simplePerlin2D12_g240 = snoise( texCoord4_g240*temp_output_11_0_g240 );
				simplePerlin2D12_g240 = simplePerlin2D12_g240*0.5 + 0.5;
				float temp_output_53_0_g239 = _WhitNoiseLerpTex4;
				float lerpResult52_g239 = lerp( break21_g239.x , ( (0.0 + (temp_output_9_0_g240 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g240 + ( voroi2_g240 + simplePerlin2D12_g240 ) ) ) , temp_output_53_0_g239);
				float temp_output_3_0_g239 = saturate( lerpResult52_g239 );
				float temp_output_9_0_g242 = break21_g239.y;
				float temp_output_11_0_g242 = temp_output_47_0_g239;
				float time2_g242 = 0.0;
				float2 voronoiSmoothId2_g242 = 0;
				float2 texCoord4_g242 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g242 = texCoord4_g242 * temp_output_11_0_g242;
				float2 id2_g242 = 0;
				float2 uv2_g242 = 0;
				float voroi2_g242 = voronoi2_g242( coords2_g242, time2_g242, id2_g242, uv2_g242, 0, voronoiSmoothId2_g242 );
				float simplePerlin2D12_g242 = snoise( texCoord4_g242*temp_output_11_0_g242 );
				simplePerlin2D12_g242 = simplePerlin2D12_g242*0.5 + 0.5;
				float lerpResult56_g239 = lerp( break21_g239.y , ( (0.0 + (temp_output_9_0_g242 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g242 + ( voroi2_g242 + simplePerlin2D12_g242 ) ) ) , temp_output_53_0_g239);
				float temp_output_2_0_g239 = saturate( lerpResult56_g239 );
				float temp_output_9_0_g241 = break21_g239.z;
				float temp_output_11_0_g241 = temp_output_47_0_g239;
				float time2_g241 = 0.0;
				float2 voronoiSmoothId2_g241 = 0;
				float2 texCoord4_g241 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g241 = texCoord4_g241 * temp_output_11_0_g241;
				float2 id2_g241 = 0;
				float2 uv2_g241 = 0;
				float voroi2_g241 = voronoi2_g241( coords2_g241, time2_g241, id2_g241, uv2_g241, 0, voronoiSmoothId2_g241 );
				float simplePerlin2D12_g241 = snoise( texCoord4_g241*temp_output_11_0_g241 );
				simplePerlin2D12_g241 = simplePerlin2D12_g241*0.5 + 0.5;
				float lerpResult57_g239 = lerp( break21_g239.z , ( (0.0 + (temp_output_9_0_g241 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g241 + ( voroi2_g241 + simplePerlin2D12_g241 ) ) ) , temp_output_53_0_g239);
				float temp_output_4_0_g239 = saturate( lerpResult57_g239 );
				float3 OUT_VertexOffset203 = ( ( _Tesellationfactor * ( ( tex2Dlod( _BaseHeight, float4( UV171, 0, 0.0) ).r * ( 1.0 - saturate( ( temp_output_3_0_g239 + temp_output_2_0_g239 + temp_output_4_0_g239 ) ) ) ) + ( ( ( tex2Dlod( _Height_1, float4( UV171, 0, 0.0) ).r * temp_output_3_0_g239 ) + ( tex2Dlod( _Height_2, float4( UV171, 0, 0.0) ).r * temp_output_2_0_g239 ) ) + ( tex2Dlod( _Height_3, float4( UV171, 0, 0.0) ).r * temp_output_4_0_g239 ) ) ) ) * v.vertex.xyz );
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset203;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				

				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007


			#pragma vertex vert
			#pragma fragment frag

			#pragma shader_feature EDITOR_VISUALIZATION

			#define SHADERPASS SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef EDITOR_VISUALIZATION
					float4 VizUV : TEXCOORD2;
					float4 LightCoord : TEXCOORD3;
				#endif
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float _Tesellationfactor;
			float _Tiling;
			float _Noseintensityval;
			float _Noisescaleval;
			float _WhitNoiseLerpTex4;
			float _WhitNoiseLerpTex1;
			float _WhitNoiseLerpTex2;
			float _WhitNoiseLerpTex3;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _BaseHeight;
			sampler2D _Height_1;
			sampler2D _Height_2;
			sampler2D _Height_3;
			sampler2D _BaseBaseColor;
			sampler2D _Texture_1;
			sampler2D _Texture_2;
			sampler2D _Texture_3;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

					float2 voronoihash2_g240( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g240( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g240( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
					float2 voronoihash2_g242( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g242( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g242( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g241( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g241( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g241( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g252( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g252( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g252( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g254( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g254( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g254( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g253( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g253( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g253( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = v.texcoord0.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = v.ase_color;
				float3 temp_output_20_0_g239 = VertexColor_var61.rgb;
				float3 break21_g239 = temp_output_20_0_g239;
				float temp_output_9_0_g240 = break21_g239.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g239 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g239 = Noisescaleval190;
				float temp_output_11_0_g240 = temp_output_47_0_g239;
				float time2_g240 = 0.0;
				float2 voronoiSmoothId2_g240 = 0;
				float2 texCoord4_g240 = v.texcoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g240 = texCoord4_g240 * temp_output_11_0_g240;
				float2 id2_g240 = 0;
				float2 uv2_g240 = 0;
				float voroi2_g240 = voronoi2_g240( coords2_g240, time2_g240, id2_g240, uv2_g240, 0, voronoiSmoothId2_g240 );
				float simplePerlin2D12_g240 = snoise( texCoord4_g240*temp_output_11_0_g240 );
				simplePerlin2D12_g240 = simplePerlin2D12_g240*0.5 + 0.5;
				float temp_output_53_0_g239 = _WhitNoiseLerpTex4;
				float lerpResult52_g239 = lerp( break21_g239.x , ( (0.0 + (temp_output_9_0_g240 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g240 + ( voroi2_g240 + simplePerlin2D12_g240 ) ) ) , temp_output_53_0_g239);
				float temp_output_3_0_g239 = saturate( lerpResult52_g239 );
				float temp_output_9_0_g242 = break21_g239.y;
				float temp_output_11_0_g242 = temp_output_47_0_g239;
				float time2_g242 = 0.0;
				float2 voronoiSmoothId2_g242 = 0;
				float2 texCoord4_g242 = v.texcoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g242 = texCoord4_g242 * temp_output_11_0_g242;
				float2 id2_g242 = 0;
				float2 uv2_g242 = 0;
				float voroi2_g242 = voronoi2_g242( coords2_g242, time2_g242, id2_g242, uv2_g242, 0, voronoiSmoothId2_g242 );
				float simplePerlin2D12_g242 = snoise( texCoord4_g242*temp_output_11_0_g242 );
				simplePerlin2D12_g242 = simplePerlin2D12_g242*0.5 + 0.5;
				float lerpResult56_g239 = lerp( break21_g239.y , ( (0.0 + (temp_output_9_0_g242 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g242 + ( voroi2_g242 + simplePerlin2D12_g242 ) ) ) , temp_output_53_0_g239);
				float temp_output_2_0_g239 = saturate( lerpResult56_g239 );
				float temp_output_9_0_g241 = break21_g239.z;
				float temp_output_11_0_g241 = temp_output_47_0_g239;
				float time2_g241 = 0.0;
				float2 voronoiSmoothId2_g241 = 0;
				float2 texCoord4_g241 = v.texcoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g241 = texCoord4_g241 * temp_output_11_0_g241;
				float2 id2_g241 = 0;
				float2 uv2_g241 = 0;
				float voroi2_g241 = voronoi2_g241( coords2_g241, time2_g241, id2_g241, uv2_g241, 0, voronoiSmoothId2_g241 );
				float simplePerlin2D12_g241 = snoise( texCoord4_g241*temp_output_11_0_g241 );
				simplePerlin2D12_g241 = simplePerlin2D12_g241*0.5 + 0.5;
				float lerpResult57_g239 = lerp( break21_g239.z , ( (0.0 + (temp_output_9_0_g241 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g241 + ( voroi2_g241 + simplePerlin2D12_g241 ) ) ) , temp_output_53_0_g239);
				float temp_output_4_0_g239 = saturate( lerpResult57_g239 );
				float3 OUT_VertexOffset203 = ( ( _Tesellationfactor * ( ( tex2Dlod( _BaseHeight, float4( UV171, 0, 0.0) ).r * ( 1.0 - saturate( ( temp_output_3_0_g239 + temp_output_2_0_g239 + temp_output_4_0_g239 ) ) ) ) + ( ( ( tex2Dlod( _Height_1, float4( UV171, 0, 0.0) ).r * temp_output_3_0_g239 ) + ( tex2Dlod( _Height_2, float4( UV171, 0, 0.0) ).r * temp_output_2_0_g239 ) ) + ( tex2Dlod( _Height_3, float4( UV171, 0, 0.0) ).r * temp_output_4_0_g239 ) ) ) ) * v.vertex.xyz );
				
				o.ase_texcoord4.xy = v.texcoord0.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset203;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );

				#ifdef EDITOR_VISUALIZATION
					float2 VizUV = 0;
					float4 LightCoord = 0;
					UnityEditorVizData(v.vertex.xyz, v.texcoord0.xy, v.texcoord1.xy, v.texcoord2.xy, VizUV, LightCoord);
					o.VizUV = float4(VizUV, 0, 0);
					o.LightCoord = LightCoord;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.texcoord0 = v.texcoord0;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.texcoord0 = patch[0].texcoord0 * bary.x + patch[1].texcoord0 * bary.y + patch[2].texcoord0 * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = IN.ase_texcoord4.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = IN.ase_color;
				float3 temp_output_20_0_g251 = VertexColor_var61.rgb;
				float3 break21_g251 = temp_output_20_0_g251;
				float temp_output_9_0_g252 = break21_g251.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g251 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g251 = Noisescaleval190;
				float temp_output_11_0_g252 = temp_output_47_0_g251;
				float time2_g252 = 0.0;
				float2 voronoiSmoothId2_g252 = 0;
				float2 texCoord4_g252 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g252 = texCoord4_g252 * temp_output_11_0_g252;
				float2 id2_g252 = 0;
				float2 uv2_g252 = 0;
				float voroi2_g252 = voronoi2_g252( coords2_g252, time2_g252, id2_g252, uv2_g252, 0, voronoiSmoothId2_g252 );
				float simplePerlin2D12_g252 = snoise( texCoord4_g252*temp_output_11_0_g252 );
				simplePerlin2D12_g252 = simplePerlin2D12_g252*0.5 + 0.5;
				float temp_output_53_0_g251 = _WhitNoiseLerpTex1;
				float lerpResult52_g251 = lerp( break21_g251.x , ( (0.0 + (temp_output_9_0_g252 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g252 + ( voroi2_g252 + simplePerlin2D12_g252 ) ) ) , temp_output_53_0_g251);
				float temp_output_3_0_g251 = saturate( lerpResult52_g251 );
				float temp_output_9_0_g254 = break21_g251.y;
				float temp_output_11_0_g254 = temp_output_47_0_g251;
				float time2_g254 = 0.0;
				float2 voronoiSmoothId2_g254 = 0;
				float2 texCoord4_g254 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g254 = texCoord4_g254 * temp_output_11_0_g254;
				float2 id2_g254 = 0;
				float2 uv2_g254 = 0;
				float voroi2_g254 = voronoi2_g254( coords2_g254, time2_g254, id2_g254, uv2_g254, 0, voronoiSmoothId2_g254 );
				float simplePerlin2D12_g254 = snoise( texCoord4_g254*temp_output_11_0_g254 );
				simplePerlin2D12_g254 = simplePerlin2D12_g254*0.5 + 0.5;
				float lerpResult56_g251 = lerp( break21_g251.y , ( (0.0 + (temp_output_9_0_g254 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g254 + ( voroi2_g254 + simplePerlin2D12_g254 ) ) ) , temp_output_53_0_g251);
				float temp_output_2_0_g251 = saturate( lerpResult56_g251 );
				float temp_output_9_0_g253 = break21_g251.z;
				float temp_output_11_0_g253 = temp_output_47_0_g251;
				float time2_g253 = 0.0;
				float2 voronoiSmoothId2_g253 = 0;
				float2 texCoord4_g253 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g253 = texCoord4_g253 * temp_output_11_0_g253;
				float2 id2_g253 = 0;
				float2 uv2_g253 = 0;
				float voroi2_g253 = voronoi2_g253( coords2_g253, time2_g253, id2_g253, uv2_g253, 0, voronoiSmoothId2_g253 );
				float simplePerlin2D12_g253 = snoise( texCoord4_g253*temp_output_11_0_g253 );
				simplePerlin2D12_g253 = simplePerlin2D12_g253*0.5 + 0.5;
				float lerpResult57_g251 = lerp( break21_g251.z , ( (0.0 + (temp_output_9_0_g253 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g253 + ( voroi2_g253 + simplePerlin2D12_g253 ) ) ) , temp_output_53_0_g251);
				float temp_output_4_0_g251 = saturate( lerpResult57_g251 );
				float4 OUT_BaseColor199 = ( ( tex2D( _BaseBaseColor, UV171 ) * ( 1.0 - saturate( ( temp_output_3_0_g251 + temp_output_2_0_g251 + temp_output_4_0_g251 ) ) ) ) + ( ( ( tex2D( _Texture_1, UV171 ) * temp_output_3_0_g251 ) + ( tex2D( _Texture_2, UV171 ) * temp_output_2_0_g251 ) ) + ( tex2D( _Texture_3, UV171 ) * temp_output_4_0_g251 ) ) );
				

				float3 BaseColor = OUT_BaseColor199.rgb;
				float3 Emission = 0;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = BaseColor;
				metaInput.Emission = Emission;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = IN.VizUV.xy;
					metaInput.LightCoord = IN.LightCoord;
				#endif

				return UnityMetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float _Tesellationfactor;
			float _Tiling;
			float _Noseintensityval;
			float _Noisescaleval;
			float _WhitNoiseLerpTex4;
			float _WhitNoiseLerpTex1;
			float _WhitNoiseLerpTex2;
			float _WhitNoiseLerpTex3;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _BaseHeight;
			sampler2D _Height_1;
			sampler2D _Height_2;
			sampler2D _Height_3;
			sampler2D _BaseBaseColor;
			sampler2D _Texture_1;
			sampler2D _Texture_2;
			sampler2D _Texture_3;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

					float2 voronoihash2_g240( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g240( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g240( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
					float2 voronoihash2_g242( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g242( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g242( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g241( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g241( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g241( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g252( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g252( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g252( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g254( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g254( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g254( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g253( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g253( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g253( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = v.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = v.ase_color;
				float3 temp_output_20_0_g239 = VertexColor_var61.rgb;
				float3 break21_g239 = temp_output_20_0_g239;
				float temp_output_9_0_g240 = break21_g239.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g239 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g239 = Noisescaleval190;
				float temp_output_11_0_g240 = temp_output_47_0_g239;
				float time2_g240 = 0.0;
				float2 voronoiSmoothId2_g240 = 0;
				float2 texCoord4_g240 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g240 = texCoord4_g240 * temp_output_11_0_g240;
				float2 id2_g240 = 0;
				float2 uv2_g240 = 0;
				float voroi2_g240 = voronoi2_g240( coords2_g240, time2_g240, id2_g240, uv2_g240, 0, voronoiSmoothId2_g240 );
				float simplePerlin2D12_g240 = snoise( texCoord4_g240*temp_output_11_0_g240 );
				simplePerlin2D12_g240 = simplePerlin2D12_g240*0.5 + 0.5;
				float temp_output_53_0_g239 = _WhitNoiseLerpTex4;
				float lerpResult52_g239 = lerp( break21_g239.x , ( (0.0 + (temp_output_9_0_g240 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g240 + ( voroi2_g240 + simplePerlin2D12_g240 ) ) ) , temp_output_53_0_g239);
				float temp_output_3_0_g239 = saturate( lerpResult52_g239 );
				float temp_output_9_0_g242 = break21_g239.y;
				float temp_output_11_0_g242 = temp_output_47_0_g239;
				float time2_g242 = 0.0;
				float2 voronoiSmoothId2_g242 = 0;
				float2 texCoord4_g242 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g242 = texCoord4_g242 * temp_output_11_0_g242;
				float2 id2_g242 = 0;
				float2 uv2_g242 = 0;
				float voroi2_g242 = voronoi2_g242( coords2_g242, time2_g242, id2_g242, uv2_g242, 0, voronoiSmoothId2_g242 );
				float simplePerlin2D12_g242 = snoise( texCoord4_g242*temp_output_11_0_g242 );
				simplePerlin2D12_g242 = simplePerlin2D12_g242*0.5 + 0.5;
				float lerpResult56_g239 = lerp( break21_g239.y , ( (0.0 + (temp_output_9_0_g242 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g242 + ( voroi2_g242 + simplePerlin2D12_g242 ) ) ) , temp_output_53_0_g239);
				float temp_output_2_0_g239 = saturate( lerpResult56_g239 );
				float temp_output_9_0_g241 = break21_g239.z;
				float temp_output_11_0_g241 = temp_output_47_0_g239;
				float time2_g241 = 0.0;
				float2 voronoiSmoothId2_g241 = 0;
				float2 texCoord4_g241 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g241 = texCoord4_g241 * temp_output_11_0_g241;
				float2 id2_g241 = 0;
				float2 uv2_g241 = 0;
				float voroi2_g241 = voronoi2_g241( coords2_g241, time2_g241, id2_g241, uv2_g241, 0, voronoiSmoothId2_g241 );
				float simplePerlin2D12_g241 = snoise( texCoord4_g241*temp_output_11_0_g241 );
				simplePerlin2D12_g241 = simplePerlin2D12_g241*0.5 + 0.5;
				float lerpResult57_g239 = lerp( break21_g239.z , ( (0.0 + (temp_output_9_0_g241 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g241 + ( voroi2_g241 + simplePerlin2D12_g241 ) ) ) , temp_output_53_0_g239);
				float temp_output_4_0_g239 = saturate( lerpResult57_g239 );
				float3 OUT_VertexOffset203 = ( ( _Tesellationfactor * ( ( tex2Dlod( _BaseHeight, float4( UV171, 0, 0.0) ).r * ( 1.0 - saturate( ( temp_output_3_0_g239 + temp_output_2_0_g239 + temp_output_4_0_g239 ) ) ) ) + ( ( ( tex2Dlod( _Height_1, float4( UV171, 0, 0.0) ).r * temp_output_3_0_g239 ) + ( tex2Dlod( _Height_2, float4( UV171, 0, 0.0) ).r * temp_output_2_0_g239 ) ) + ( tex2Dlod( _Height_3, float4( UV171, 0, 0.0) ).r * temp_output_4_0_g239 ) ) ) ) * v.vertex.xyz );
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset203;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = IN.ase_texcoord2.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = IN.ase_color;
				float3 temp_output_20_0_g251 = VertexColor_var61.rgb;
				float3 break21_g251 = temp_output_20_0_g251;
				float temp_output_9_0_g252 = break21_g251.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g251 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g251 = Noisescaleval190;
				float temp_output_11_0_g252 = temp_output_47_0_g251;
				float time2_g252 = 0.0;
				float2 voronoiSmoothId2_g252 = 0;
				float2 texCoord4_g252 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g252 = texCoord4_g252 * temp_output_11_0_g252;
				float2 id2_g252 = 0;
				float2 uv2_g252 = 0;
				float voroi2_g252 = voronoi2_g252( coords2_g252, time2_g252, id2_g252, uv2_g252, 0, voronoiSmoothId2_g252 );
				float simplePerlin2D12_g252 = snoise( texCoord4_g252*temp_output_11_0_g252 );
				simplePerlin2D12_g252 = simplePerlin2D12_g252*0.5 + 0.5;
				float temp_output_53_0_g251 = _WhitNoiseLerpTex1;
				float lerpResult52_g251 = lerp( break21_g251.x , ( (0.0 + (temp_output_9_0_g252 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g252 + ( voroi2_g252 + simplePerlin2D12_g252 ) ) ) , temp_output_53_0_g251);
				float temp_output_3_0_g251 = saturate( lerpResult52_g251 );
				float temp_output_9_0_g254 = break21_g251.y;
				float temp_output_11_0_g254 = temp_output_47_0_g251;
				float time2_g254 = 0.0;
				float2 voronoiSmoothId2_g254 = 0;
				float2 texCoord4_g254 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g254 = texCoord4_g254 * temp_output_11_0_g254;
				float2 id2_g254 = 0;
				float2 uv2_g254 = 0;
				float voroi2_g254 = voronoi2_g254( coords2_g254, time2_g254, id2_g254, uv2_g254, 0, voronoiSmoothId2_g254 );
				float simplePerlin2D12_g254 = snoise( texCoord4_g254*temp_output_11_0_g254 );
				simplePerlin2D12_g254 = simplePerlin2D12_g254*0.5 + 0.5;
				float lerpResult56_g251 = lerp( break21_g251.y , ( (0.0 + (temp_output_9_0_g254 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g254 + ( voroi2_g254 + simplePerlin2D12_g254 ) ) ) , temp_output_53_0_g251);
				float temp_output_2_0_g251 = saturate( lerpResult56_g251 );
				float temp_output_9_0_g253 = break21_g251.z;
				float temp_output_11_0_g253 = temp_output_47_0_g251;
				float time2_g253 = 0.0;
				float2 voronoiSmoothId2_g253 = 0;
				float2 texCoord4_g253 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g253 = texCoord4_g253 * temp_output_11_0_g253;
				float2 id2_g253 = 0;
				float2 uv2_g253 = 0;
				float voroi2_g253 = voronoi2_g253( coords2_g253, time2_g253, id2_g253, uv2_g253, 0, voronoiSmoothId2_g253 );
				float simplePerlin2D12_g253 = snoise( texCoord4_g253*temp_output_11_0_g253 );
				simplePerlin2D12_g253 = simplePerlin2D12_g253*0.5 + 0.5;
				float lerpResult57_g251 = lerp( break21_g251.z , ( (0.0 + (temp_output_9_0_g253 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g253 + ( voroi2_g253 + simplePerlin2D12_g253 ) ) ) , temp_output_53_0_g251);
				float temp_output_4_0_g251 = saturate( lerpResult57_g251 );
				float4 OUT_BaseColor199 = ( ( tex2D( _BaseBaseColor, UV171 ) * ( 1.0 - saturate( ( temp_output_3_0_g251 + temp_output_2_0_g251 + temp_output_4_0_g251 ) ) ) ) + ( ( ( tex2D( _Texture_1, UV171 ) * temp_output_3_0_g251 ) + ( tex2D( _Texture_2, UV171 ) * temp_output_2_0_g251 ) ) + ( tex2D( _Texture_3, UV171 ) * temp_output_4_0_g251 ) ) );
				

				float3 BaseColor = OUT_BaseColor199.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				half4 color = half4(BaseColor, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormals" }

			ZWrite On
			Blend One Zero
			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				float3 worldNormal : TEXCOORD2;
				float4 worldTangent : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float _Tesellationfactor;
			float _Tiling;
			float _Noseintensityval;
			float _Noisescaleval;
			float _WhitNoiseLerpTex4;
			float _WhitNoiseLerpTex1;
			float _WhitNoiseLerpTex2;
			float _WhitNoiseLerpTex3;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _BaseHeight;
			sampler2D _Height_1;
			sampler2D _Height_2;
			sampler2D _Height_3;
			sampler2D _BaseNormal;
			sampler2D _Normal_1;
			sampler2D _Normal_2;
			sampler2D _Normal_3;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

					float2 voronoihash2_g240( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g240( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g240( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
					float2 voronoihash2_g242( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g242( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g242( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g241( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g241( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g241( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g248( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g248( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g248( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g250( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g250( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g250( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g249( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g249( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g249( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = v.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = v.ase_color;
				float3 temp_output_20_0_g239 = VertexColor_var61.rgb;
				float3 break21_g239 = temp_output_20_0_g239;
				float temp_output_9_0_g240 = break21_g239.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g239 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g239 = Noisescaleval190;
				float temp_output_11_0_g240 = temp_output_47_0_g239;
				float time2_g240 = 0.0;
				float2 voronoiSmoothId2_g240 = 0;
				float2 texCoord4_g240 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g240 = texCoord4_g240 * temp_output_11_0_g240;
				float2 id2_g240 = 0;
				float2 uv2_g240 = 0;
				float voroi2_g240 = voronoi2_g240( coords2_g240, time2_g240, id2_g240, uv2_g240, 0, voronoiSmoothId2_g240 );
				float simplePerlin2D12_g240 = snoise( texCoord4_g240*temp_output_11_0_g240 );
				simplePerlin2D12_g240 = simplePerlin2D12_g240*0.5 + 0.5;
				float temp_output_53_0_g239 = _WhitNoiseLerpTex4;
				float lerpResult52_g239 = lerp( break21_g239.x , ( (0.0 + (temp_output_9_0_g240 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g240 + ( voroi2_g240 + simplePerlin2D12_g240 ) ) ) , temp_output_53_0_g239);
				float temp_output_3_0_g239 = saturate( lerpResult52_g239 );
				float temp_output_9_0_g242 = break21_g239.y;
				float temp_output_11_0_g242 = temp_output_47_0_g239;
				float time2_g242 = 0.0;
				float2 voronoiSmoothId2_g242 = 0;
				float2 texCoord4_g242 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g242 = texCoord4_g242 * temp_output_11_0_g242;
				float2 id2_g242 = 0;
				float2 uv2_g242 = 0;
				float voroi2_g242 = voronoi2_g242( coords2_g242, time2_g242, id2_g242, uv2_g242, 0, voronoiSmoothId2_g242 );
				float simplePerlin2D12_g242 = snoise( texCoord4_g242*temp_output_11_0_g242 );
				simplePerlin2D12_g242 = simplePerlin2D12_g242*0.5 + 0.5;
				float lerpResult56_g239 = lerp( break21_g239.y , ( (0.0 + (temp_output_9_0_g242 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g242 + ( voroi2_g242 + simplePerlin2D12_g242 ) ) ) , temp_output_53_0_g239);
				float temp_output_2_0_g239 = saturate( lerpResult56_g239 );
				float temp_output_9_0_g241 = break21_g239.z;
				float temp_output_11_0_g241 = temp_output_47_0_g239;
				float time2_g241 = 0.0;
				float2 voronoiSmoothId2_g241 = 0;
				float2 texCoord4_g241 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g241 = texCoord4_g241 * temp_output_11_0_g241;
				float2 id2_g241 = 0;
				float2 uv2_g241 = 0;
				float voroi2_g241 = voronoi2_g241( coords2_g241, time2_g241, id2_g241, uv2_g241, 0, voronoiSmoothId2_g241 );
				float simplePerlin2D12_g241 = snoise( texCoord4_g241*temp_output_11_0_g241 );
				simplePerlin2D12_g241 = simplePerlin2D12_g241*0.5 + 0.5;
				float lerpResult57_g239 = lerp( break21_g239.z , ( (0.0 + (temp_output_9_0_g241 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g241 + ( voroi2_g241 + simplePerlin2D12_g241 ) ) ) , temp_output_53_0_g239);
				float temp_output_4_0_g239 = saturate( lerpResult57_g239 );
				float3 OUT_VertexOffset203 = ( ( _Tesellationfactor * ( ( tex2Dlod( _BaseHeight, float4( UV171, 0, 0.0) ).r * ( 1.0 - saturate( ( temp_output_3_0_g239 + temp_output_2_0_g239 + temp_output_4_0_g239 ) ) ) ) + ( ( ( tex2Dlod( _Height_1, float4( UV171, 0, 0.0) ).r * temp_output_3_0_g239 ) + ( tex2Dlod( _Height_2, float4( UV171, 0, 0.0) ).r * temp_output_2_0_g239 ) ) + ( tex2Dlod( _Height_3, float4( UV171, 0, 0.0) ).r * temp_output_4_0_g239 ) ) ) ) * v.vertex.xyz );
				
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset203;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 normalWS = TransformObjectToWorldNormal( v.ase_normal );
				float4 tangentWS = float4(TransformObjectToWorldDir( v.ase_tangent.xyz), v.ase_tangent.w);
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.worldNormal = normalWS;
				o.worldTangent = tangentWS;

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			void frag(	VertexOutput IN
						, out half4 outNormalWS : SV_Target0
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float3 WorldNormal = IN.worldNormal;
				float4 WorldTangent = IN.worldTangent;

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = IN.ase_texcoord4.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = IN.ase_color;
				float3 temp_output_20_0_g247 = VertexColor_var61.rgb;
				float3 break21_g247 = temp_output_20_0_g247;
				float temp_output_9_0_g248 = break21_g247.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g247 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g247 = Noisescaleval190;
				float temp_output_11_0_g248 = temp_output_47_0_g247;
				float time2_g248 = 0.0;
				float2 voronoiSmoothId2_g248 = 0;
				float2 texCoord4_g248 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g248 = texCoord4_g248 * temp_output_11_0_g248;
				float2 id2_g248 = 0;
				float2 uv2_g248 = 0;
				float voroi2_g248 = voronoi2_g248( coords2_g248, time2_g248, id2_g248, uv2_g248, 0, voronoiSmoothId2_g248 );
				float simplePerlin2D12_g248 = snoise( texCoord4_g248*temp_output_11_0_g248 );
				simplePerlin2D12_g248 = simplePerlin2D12_g248*0.5 + 0.5;
				float temp_output_53_0_g247 = _WhitNoiseLerpTex2;
				float lerpResult52_g247 = lerp( break21_g247.x , ( (0.0 + (temp_output_9_0_g248 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g248 + ( voroi2_g248 + simplePerlin2D12_g248 ) ) ) , temp_output_53_0_g247);
				float temp_output_3_0_g247 = saturate( lerpResult52_g247 );
				float temp_output_9_0_g250 = break21_g247.y;
				float temp_output_11_0_g250 = temp_output_47_0_g247;
				float time2_g250 = 0.0;
				float2 voronoiSmoothId2_g250 = 0;
				float2 texCoord4_g250 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g250 = texCoord4_g250 * temp_output_11_0_g250;
				float2 id2_g250 = 0;
				float2 uv2_g250 = 0;
				float voroi2_g250 = voronoi2_g250( coords2_g250, time2_g250, id2_g250, uv2_g250, 0, voronoiSmoothId2_g250 );
				float simplePerlin2D12_g250 = snoise( texCoord4_g250*temp_output_11_0_g250 );
				simplePerlin2D12_g250 = simplePerlin2D12_g250*0.5 + 0.5;
				float lerpResult56_g247 = lerp( break21_g247.y , ( (0.0 + (temp_output_9_0_g250 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g250 + ( voroi2_g250 + simplePerlin2D12_g250 ) ) ) , temp_output_53_0_g247);
				float temp_output_2_0_g247 = saturate( lerpResult56_g247 );
				float temp_output_9_0_g249 = break21_g247.z;
				float temp_output_11_0_g249 = temp_output_47_0_g247;
				float time2_g249 = 0.0;
				float2 voronoiSmoothId2_g249 = 0;
				float2 texCoord4_g249 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g249 = texCoord4_g249 * temp_output_11_0_g249;
				float2 id2_g249 = 0;
				float2 uv2_g249 = 0;
				float voroi2_g249 = voronoi2_g249( coords2_g249, time2_g249, id2_g249, uv2_g249, 0, voronoiSmoothId2_g249 );
				float simplePerlin2D12_g249 = snoise( texCoord4_g249*temp_output_11_0_g249 );
				simplePerlin2D12_g249 = simplePerlin2D12_g249*0.5 + 0.5;
				float lerpResult57_g247 = lerp( break21_g247.z , ( (0.0 + (temp_output_9_0_g249 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g249 + ( voroi2_g249 + simplePerlin2D12_g249 ) ) ) , temp_output_53_0_g247);
				float temp_output_4_0_g247 = saturate( lerpResult57_g247 );
				float3 OUT_Normal200 = ( ( UnpackNormalScale( tex2D( _BaseNormal, UV171 ), 1.0f ) * ( 1.0 - saturate( ( temp_output_3_0_g247 + temp_output_2_0_g247 + temp_output_4_0_g247 ) ) ) ) + ( ( ( UnpackNormalScale( tex2D( _Normal_1, UV171 ), 1.0f ) * temp_output_3_0_g247 ) + ( UnpackNormalScale( tex2D( _Normal_2, UV171 ), 1.0f ) * temp_output_2_0_g247 ) ) + ( UnpackNormalScale( tex2D( _Normal_3, UV171 ), 1.0f ) * temp_output_4_0_g247 ) ) );
				

				float3 Normal = OUT_Normal200;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(WorldNormal);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					outNormalWS = half4(packedNormalWS, 0.0);
				#else
					#if defined(_NORMALMAP)
						#if _NORMAL_DROPOFF_TS
							float crossSign = (WorldTangent.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
							float3 bitangent = crossSign * cross(WorldNormal.xyz, WorldTangent.xyz);
							float3 normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent.xyz, bitangent, WorldNormal.xyz));
						#elif _NORMAL_DROPOFF_OS
							float3 normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							float3 normalWS = Normal;
						#endif
					#else
						float3 normalWS = WorldNormal;
					#endif
					outNormalWS = half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="UniversalGBuffer" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007


			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_GBUFFER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
			
			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
				float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float _Tesellationfactor;
			float _Tiling;
			float _Noseintensityval;
			float _Noisescaleval;
			float _WhitNoiseLerpTex4;
			float _WhitNoiseLerpTex1;
			float _WhitNoiseLerpTex2;
			float _WhitNoiseLerpTex3;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _BaseHeight;
			sampler2D _Height_1;
			sampler2D _Height_2;
			sampler2D _Height_3;
			sampler2D _BaseBaseColor;
			sampler2D _Texture_1;
			sampler2D _Texture_2;
			sampler2D _Texture_3;
			sampler2D _BaseNormal;
			sampler2D _Normal_1;
			sampler2D _Normal_2;
			sampler2D _Normal_3;
			sampler2D _BaseRoughness;
			sampler2D _Roughness_1;
			sampler2D _Roughness_2;
			sampler2D _Roughness_3;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

					float2 voronoihash2_g240( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g240( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g240( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
					float2 voronoihash2_g242( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g242( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g242( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g241( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g241( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g241( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g252( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g252( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g252( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g254( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g254( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g254( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g253( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g253( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g253( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g248( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g248( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g248( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g250( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g250( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g250( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g249( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g249( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g249( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g244( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g244( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g244( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g246( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g246( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g246( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g245( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g245( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g245( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = v.texcoord.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = v.ase_color;
				float3 temp_output_20_0_g239 = VertexColor_var61.rgb;
				float3 break21_g239 = temp_output_20_0_g239;
				float temp_output_9_0_g240 = break21_g239.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g239 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g239 = Noisescaleval190;
				float temp_output_11_0_g240 = temp_output_47_0_g239;
				float time2_g240 = 0.0;
				float2 voronoiSmoothId2_g240 = 0;
				float2 texCoord4_g240 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g240 = texCoord4_g240 * temp_output_11_0_g240;
				float2 id2_g240 = 0;
				float2 uv2_g240 = 0;
				float voroi2_g240 = voronoi2_g240( coords2_g240, time2_g240, id2_g240, uv2_g240, 0, voronoiSmoothId2_g240 );
				float simplePerlin2D12_g240 = snoise( texCoord4_g240*temp_output_11_0_g240 );
				simplePerlin2D12_g240 = simplePerlin2D12_g240*0.5 + 0.5;
				float temp_output_53_0_g239 = _WhitNoiseLerpTex4;
				float lerpResult52_g239 = lerp( break21_g239.x , ( (0.0 + (temp_output_9_0_g240 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g240 + ( voroi2_g240 + simplePerlin2D12_g240 ) ) ) , temp_output_53_0_g239);
				float temp_output_3_0_g239 = saturate( lerpResult52_g239 );
				float temp_output_9_0_g242 = break21_g239.y;
				float temp_output_11_0_g242 = temp_output_47_0_g239;
				float time2_g242 = 0.0;
				float2 voronoiSmoothId2_g242 = 0;
				float2 texCoord4_g242 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g242 = texCoord4_g242 * temp_output_11_0_g242;
				float2 id2_g242 = 0;
				float2 uv2_g242 = 0;
				float voroi2_g242 = voronoi2_g242( coords2_g242, time2_g242, id2_g242, uv2_g242, 0, voronoiSmoothId2_g242 );
				float simplePerlin2D12_g242 = snoise( texCoord4_g242*temp_output_11_0_g242 );
				simplePerlin2D12_g242 = simplePerlin2D12_g242*0.5 + 0.5;
				float lerpResult56_g239 = lerp( break21_g239.y , ( (0.0 + (temp_output_9_0_g242 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g242 + ( voroi2_g242 + simplePerlin2D12_g242 ) ) ) , temp_output_53_0_g239);
				float temp_output_2_0_g239 = saturate( lerpResult56_g239 );
				float temp_output_9_0_g241 = break21_g239.z;
				float temp_output_11_0_g241 = temp_output_47_0_g239;
				float time2_g241 = 0.0;
				float2 voronoiSmoothId2_g241 = 0;
				float2 texCoord4_g241 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g241 = texCoord4_g241 * temp_output_11_0_g241;
				float2 id2_g241 = 0;
				float2 uv2_g241 = 0;
				float voroi2_g241 = voronoi2_g241( coords2_g241, time2_g241, id2_g241, uv2_g241, 0, voronoiSmoothId2_g241 );
				float simplePerlin2D12_g241 = snoise( texCoord4_g241*temp_output_11_0_g241 );
				simplePerlin2D12_g241 = simplePerlin2D12_g241*0.5 + 0.5;
				float lerpResult57_g239 = lerp( break21_g239.z , ( (0.0 + (temp_output_9_0_g241 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g241 + ( voroi2_g241 + simplePerlin2D12_g241 ) ) ) , temp_output_53_0_g239);
				float temp_output_4_0_g239 = saturate( lerpResult57_g239 );
				float3 OUT_VertexOffset203 = ( ( _Tesellationfactor * ( ( tex2Dlod( _BaseHeight, float4( UV171, 0, 0.0) ).r * ( 1.0 - saturate( ( temp_output_3_0_g239 + temp_output_2_0_g239 + temp_output_4_0_g239 ) ) ) ) + ( ( ( tex2Dlod( _Height_1, float4( UV171, 0, 0.0) ).r * temp_output_3_0_g239 ) + ( tex2Dlod( _Height_2, float4( UV171, 0, 0.0) ).r * temp_output_2_0_g239 ) ) + ( tex2Dlod( _Height_3, float4( UV171, 0, 0.0) ).r * temp_output_4_0_g239 ) ) ) ) * v.vertex.xyz );
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset203;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH(normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz);
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				o.fogFactorAndVertexLight = half4(0, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

					o.clipPos = positionCS;

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(positionCS);
				#endif

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			FragmentOutput frag ( VertexOutput IN
								#ifdef ASE_DEPTH_WRITE_ON
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 ScreenPos = IN.screenPos;
				#endif

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#else
					ShadowCoords = float4(0, 0, 0, 0);
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = IN.ase_texcoord8.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = IN.ase_color;
				float3 temp_output_20_0_g251 = VertexColor_var61.rgb;
				float3 break21_g251 = temp_output_20_0_g251;
				float temp_output_9_0_g252 = break21_g251.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g251 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g251 = Noisescaleval190;
				float temp_output_11_0_g252 = temp_output_47_0_g251;
				float time2_g252 = 0.0;
				float2 voronoiSmoothId2_g252 = 0;
				float2 texCoord4_g252 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g252 = texCoord4_g252 * temp_output_11_0_g252;
				float2 id2_g252 = 0;
				float2 uv2_g252 = 0;
				float voroi2_g252 = voronoi2_g252( coords2_g252, time2_g252, id2_g252, uv2_g252, 0, voronoiSmoothId2_g252 );
				float simplePerlin2D12_g252 = snoise( texCoord4_g252*temp_output_11_0_g252 );
				simplePerlin2D12_g252 = simplePerlin2D12_g252*0.5 + 0.5;
				float temp_output_53_0_g251 = _WhitNoiseLerpTex1;
				float lerpResult52_g251 = lerp( break21_g251.x , ( (0.0 + (temp_output_9_0_g252 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g252 + ( voroi2_g252 + simplePerlin2D12_g252 ) ) ) , temp_output_53_0_g251);
				float temp_output_3_0_g251 = saturate( lerpResult52_g251 );
				float temp_output_9_0_g254 = break21_g251.y;
				float temp_output_11_0_g254 = temp_output_47_0_g251;
				float time2_g254 = 0.0;
				float2 voronoiSmoothId2_g254 = 0;
				float2 texCoord4_g254 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g254 = texCoord4_g254 * temp_output_11_0_g254;
				float2 id2_g254 = 0;
				float2 uv2_g254 = 0;
				float voroi2_g254 = voronoi2_g254( coords2_g254, time2_g254, id2_g254, uv2_g254, 0, voronoiSmoothId2_g254 );
				float simplePerlin2D12_g254 = snoise( texCoord4_g254*temp_output_11_0_g254 );
				simplePerlin2D12_g254 = simplePerlin2D12_g254*0.5 + 0.5;
				float lerpResult56_g251 = lerp( break21_g251.y , ( (0.0 + (temp_output_9_0_g254 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g254 + ( voroi2_g254 + simplePerlin2D12_g254 ) ) ) , temp_output_53_0_g251);
				float temp_output_2_0_g251 = saturate( lerpResult56_g251 );
				float temp_output_9_0_g253 = break21_g251.z;
				float temp_output_11_0_g253 = temp_output_47_0_g251;
				float time2_g253 = 0.0;
				float2 voronoiSmoothId2_g253 = 0;
				float2 texCoord4_g253 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g253 = texCoord4_g253 * temp_output_11_0_g253;
				float2 id2_g253 = 0;
				float2 uv2_g253 = 0;
				float voroi2_g253 = voronoi2_g253( coords2_g253, time2_g253, id2_g253, uv2_g253, 0, voronoiSmoothId2_g253 );
				float simplePerlin2D12_g253 = snoise( texCoord4_g253*temp_output_11_0_g253 );
				simplePerlin2D12_g253 = simplePerlin2D12_g253*0.5 + 0.5;
				float lerpResult57_g251 = lerp( break21_g251.z , ( (0.0 + (temp_output_9_0_g253 - 0.0) * (temp_output_46_0_g251 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g253 + ( voroi2_g253 + simplePerlin2D12_g253 ) ) ) , temp_output_53_0_g251);
				float temp_output_4_0_g251 = saturate( lerpResult57_g251 );
				float4 OUT_BaseColor199 = ( ( tex2D( _BaseBaseColor, UV171 ) * ( 1.0 - saturate( ( temp_output_3_0_g251 + temp_output_2_0_g251 + temp_output_4_0_g251 ) ) ) ) + ( ( ( tex2D( _Texture_1, UV171 ) * temp_output_3_0_g251 ) + ( tex2D( _Texture_2, UV171 ) * temp_output_2_0_g251 ) ) + ( tex2D( _Texture_3, UV171 ) * temp_output_4_0_g251 ) ) );
				
				float3 temp_output_20_0_g247 = VertexColor_var61.rgb;
				float3 break21_g247 = temp_output_20_0_g247;
				float temp_output_9_0_g248 = break21_g247.x;
				float temp_output_46_0_g247 = NoiseIntensityval186;
				float temp_output_47_0_g247 = Noisescaleval190;
				float temp_output_11_0_g248 = temp_output_47_0_g247;
				float time2_g248 = 0.0;
				float2 voronoiSmoothId2_g248 = 0;
				float2 texCoord4_g248 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g248 = texCoord4_g248 * temp_output_11_0_g248;
				float2 id2_g248 = 0;
				float2 uv2_g248 = 0;
				float voroi2_g248 = voronoi2_g248( coords2_g248, time2_g248, id2_g248, uv2_g248, 0, voronoiSmoothId2_g248 );
				float simplePerlin2D12_g248 = snoise( texCoord4_g248*temp_output_11_0_g248 );
				simplePerlin2D12_g248 = simplePerlin2D12_g248*0.5 + 0.5;
				float temp_output_53_0_g247 = _WhitNoiseLerpTex2;
				float lerpResult52_g247 = lerp( break21_g247.x , ( (0.0 + (temp_output_9_0_g248 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g248 + ( voroi2_g248 + simplePerlin2D12_g248 ) ) ) , temp_output_53_0_g247);
				float temp_output_3_0_g247 = saturate( lerpResult52_g247 );
				float temp_output_9_0_g250 = break21_g247.y;
				float temp_output_11_0_g250 = temp_output_47_0_g247;
				float time2_g250 = 0.0;
				float2 voronoiSmoothId2_g250 = 0;
				float2 texCoord4_g250 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g250 = texCoord4_g250 * temp_output_11_0_g250;
				float2 id2_g250 = 0;
				float2 uv2_g250 = 0;
				float voroi2_g250 = voronoi2_g250( coords2_g250, time2_g250, id2_g250, uv2_g250, 0, voronoiSmoothId2_g250 );
				float simplePerlin2D12_g250 = snoise( texCoord4_g250*temp_output_11_0_g250 );
				simplePerlin2D12_g250 = simplePerlin2D12_g250*0.5 + 0.5;
				float lerpResult56_g247 = lerp( break21_g247.y , ( (0.0 + (temp_output_9_0_g250 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g250 + ( voroi2_g250 + simplePerlin2D12_g250 ) ) ) , temp_output_53_0_g247);
				float temp_output_2_0_g247 = saturate( lerpResult56_g247 );
				float temp_output_9_0_g249 = break21_g247.z;
				float temp_output_11_0_g249 = temp_output_47_0_g247;
				float time2_g249 = 0.0;
				float2 voronoiSmoothId2_g249 = 0;
				float2 texCoord4_g249 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g249 = texCoord4_g249 * temp_output_11_0_g249;
				float2 id2_g249 = 0;
				float2 uv2_g249 = 0;
				float voroi2_g249 = voronoi2_g249( coords2_g249, time2_g249, id2_g249, uv2_g249, 0, voronoiSmoothId2_g249 );
				float simplePerlin2D12_g249 = snoise( texCoord4_g249*temp_output_11_0_g249 );
				simplePerlin2D12_g249 = simplePerlin2D12_g249*0.5 + 0.5;
				float lerpResult57_g247 = lerp( break21_g247.z , ( (0.0 + (temp_output_9_0_g249 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g249 + ( voroi2_g249 + simplePerlin2D12_g249 ) ) ) , temp_output_53_0_g247);
				float temp_output_4_0_g247 = saturate( lerpResult57_g247 );
				float3 OUT_Normal200 = ( ( UnpackNormalScale( tex2D( _BaseNormal, UV171 ), 1.0f ) * ( 1.0 - saturate( ( temp_output_3_0_g247 + temp_output_2_0_g247 + temp_output_4_0_g247 ) ) ) ) + ( ( ( UnpackNormalScale( tex2D( _Normal_1, UV171 ), 1.0f ) * temp_output_3_0_g247 ) + ( UnpackNormalScale( tex2D( _Normal_2, UV171 ), 1.0f ) * temp_output_2_0_g247 ) ) + ( UnpackNormalScale( tex2D( _Normal_3, UV171 ), 1.0f ) * temp_output_4_0_g247 ) ) );
				
				float4 color104 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
				float4 OUT_Metallic201 = color104;
				
				float3 temp_output_20_0_g243 = VertexColor_var61.rgb;
				float3 break21_g243 = temp_output_20_0_g243;
				float temp_output_9_0_g244 = break21_g243.x;
				float temp_output_46_0_g243 = NoiseIntensityval186;
				float temp_output_47_0_g243 = Noisescaleval190;
				float temp_output_11_0_g244 = temp_output_47_0_g243;
				float time2_g244 = 0.0;
				float2 voronoiSmoothId2_g244 = 0;
				float2 texCoord4_g244 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g244 = texCoord4_g244 * temp_output_11_0_g244;
				float2 id2_g244 = 0;
				float2 uv2_g244 = 0;
				float voroi2_g244 = voronoi2_g244( coords2_g244, time2_g244, id2_g244, uv2_g244, 0, voronoiSmoothId2_g244 );
				float simplePerlin2D12_g244 = snoise( texCoord4_g244*temp_output_11_0_g244 );
				simplePerlin2D12_g244 = simplePerlin2D12_g244*0.5 + 0.5;
				float temp_output_53_0_g243 = _WhitNoiseLerpTex3;
				float lerpResult52_g243 = lerp( break21_g243.x , ( (0.0 + (temp_output_9_0_g244 - 0.0) * (temp_output_46_0_g243 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g244 + ( voroi2_g244 + simplePerlin2D12_g244 ) ) ) , temp_output_53_0_g243);
				float temp_output_3_0_g243 = saturate( lerpResult52_g243 );
				float temp_output_9_0_g246 = break21_g243.y;
				float temp_output_11_0_g246 = temp_output_47_0_g243;
				float time2_g246 = 0.0;
				float2 voronoiSmoothId2_g246 = 0;
				float2 texCoord4_g246 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g246 = texCoord4_g246 * temp_output_11_0_g246;
				float2 id2_g246 = 0;
				float2 uv2_g246 = 0;
				float voroi2_g246 = voronoi2_g246( coords2_g246, time2_g246, id2_g246, uv2_g246, 0, voronoiSmoothId2_g246 );
				float simplePerlin2D12_g246 = snoise( texCoord4_g246*temp_output_11_0_g246 );
				simplePerlin2D12_g246 = simplePerlin2D12_g246*0.5 + 0.5;
				float lerpResult56_g243 = lerp( break21_g243.y , ( (0.0 + (temp_output_9_0_g246 - 0.0) * (temp_output_46_0_g243 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g246 + ( voroi2_g246 + simplePerlin2D12_g246 ) ) ) , temp_output_53_0_g243);
				float temp_output_2_0_g243 = saturate( lerpResult56_g243 );
				float temp_output_9_0_g245 = break21_g243.z;
				float temp_output_11_0_g245 = temp_output_47_0_g243;
				float time2_g245 = 0.0;
				float2 voronoiSmoothId2_g245 = 0;
				float2 texCoord4_g245 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g245 = texCoord4_g245 * temp_output_11_0_g245;
				float2 id2_g245 = 0;
				float2 uv2_g245 = 0;
				float voroi2_g245 = voronoi2_g245( coords2_g245, time2_g245, id2_g245, uv2_g245, 0, voronoiSmoothId2_g245 );
				float simplePerlin2D12_g245 = snoise( texCoord4_g245*temp_output_11_0_g245 );
				simplePerlin2D12_g245 = simplePerlin2D12_g245*0.5 + 0.5;
				float lerpResult57_g243 = lerp( break21_g243.z , ( (0.0 + (temp_output_9_0_g245 - 0.0) * (temp_output_46_0_g243 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g245 + ( voroi2_g245 + simplePerlin2D12_g245 ) ) ) , temp_output_53_0_g243);
				float temp_output_4_0_g243 = saturate( lerpResult57_g243 );
				float3 temp_cast_6 = (( 1.0 - ( ( tex2D( _BaseRoughness, UV171 ).r * ( 1.0 - saturate( ( temp_output_3_0_g243 + temp_output_2_0_g243 + temp_output_4_0_g243 ) ) ) ) + ( ( ( tex2D( _Roughness_1, UV171 ).r * temp_output_3_0_g243 ) + ( tex2D( _Roughness_2, UV171 ).r * temp_output_2_0_g243 ) ) + ( tex2D( _Roughness_3, UV171 ).r * temp_output_4_0_g243 ) ) ) )).xxx;
				float grayscale103 = Luminance(temp_cast_6);
				float OUT_Smoothnes202 = grayscale103;
				

				float3 BaseColor = OUT_BaseColor199.rgb;
				float3 Normal = OUT_Normal200;
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = OUT_Metallic201.r;
				float Smoothness = OUT_Smoothnes202;
				float Occlusion = 1;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.positionCS = IN.clipPos;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
						inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
						inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
						inputData.normalWS = Normal;
					#endif
				#else
					inputData.normalWS = WorldNormal;
				#endif

				inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				inputData.viewDirectionWS = SafeNormalize( WorldViewDirection );

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#else
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
					#else
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
						#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				#ifdef _DBUFFER
					ApplyDecal(IN.clipPos,
						BaseColor,
						Specular,
						inputData.normalWS,
						Metallic,
						Occlusion,
						Smoothness);
				#endif

				BRDFData brdfData;
				InitializeBRDFData
				(BaseColor, Metallic, Specular, Smoothness, Alpha, brdfData);

				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				half4 color;
				MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI, inputData.shadowMask);
				color.rgb = GlobalIllumination(brdfData, inputData.bakedGI, Occlusion, inputData.positionWS, inputData.normalWS, inputData.viewDirectionWS);
				color.a = Alpha;

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return BRDFDataToGbuffer(brdfData, inputData, Smoothness, Emission + color.rgb, Occlusion);
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			Cull Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007


			#pragma vertex vert
			#pragma fragment frag

			#define SCENESELECTIONPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float _Tesellationfactor;
			float _Tiling;
			float _Noseintensityval;
			float _Noisescaleval;
			float _WhitNoiseLerpTex4;
			float _WhitNoiseLerpTex1;
			float _WhitNoiseLerpTex2;
			float _WhitNoiseLerpTex3;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _BaseHeight;
			sampler2D _Height_1;
			sampler2D _Height_2;
			sampler2D _Height_3;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

					float2 voronoihash2_g240( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g240( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g240( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
					float2 voronoihash2_g242( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g242( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g242( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g241( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g241( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g241( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = v.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = v.ase_color;
				float3 temp_output_20_0_g239 = VertexColor_var61.rgb;
				float3 break21_g239 = temp_output_20_0_g239;
				float temp_output_9_0_g240 = break21_g239.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g239 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g239 = Noisescaleval190;
				float temp_output_11_0_g240 = temp_output_47_0_g239;
				float time2_g240 = 0.0;
				float2 voronoiSmoothId2_g240 = 0;
				float2 texCoord4_g240 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g240 = texCoord4_g240 * temp_output_11_0_g240;
				float2 id2_g240 = 0;
				float2 uv2_g240 = 0;
				float voroi2_g240 = voronoi2_g240( coords2_g240, time2_g240, id2_g240, uv2_g240, 0, voronoiSmoothId2_g240 );
				float simplePerlin2D12_g240 = snoise( texCoord4_g240*temp_output_11_0_g240 );
				simplePerlin2D12_g240 = simplePerlin2D12_g240*0.5 + 0.5;
				float temp_output_53_0_g239 = _WhitNoiseLerpTex4;
				float lerpResult52_g239 = lerp( break21_g239.x , ( (0.0 + (temp_output_9_0_g240 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g240 + ( voroi2_g240 + simplePerlin2D12_g240 ) ) ) , temp_output_53_0_g239);
				float temp_output_3_0_g239 = saturate( lerpResult52_g239 );
				float temp_output_9_0_g242 = break21_g239.y;
				float temp_output_11_0_g242 = temp_output_47_0_g239;
				float time2_g242 = 0.0;
				float2 voronoiSmoothId2_g242 = 0;
				float2 texCoord4_g242 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g242 = texCoord4_g242 * temp_output_11_0_g242;
				float2 id2_g242 = 0;
				float2 uv2_g242 = 0;
				float voroi2_g242 = voronoi2_g242( coords2_g242, time2_g242, id2_g242, uv2_g242, 0, voronoiSmoothId2_g242 );
				float simplePerlin2D12_g242 = snoise( texCoord4_g242*temp_output_11_0_g242 );
				simplePerlin2D12_g242 = simplePerlin2D12_g242*0.5 + 0.5;
				float lerpResult56_g239 = lerp( break21_g239.y , ( (0.0 + (temp_output_9_0_g242 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g242 + ( voroi2_g242 + simplePerlin2D12_g242 ) ) ) , temp_output_53_0_g239);
				float temp_output_2_0_g239 = saturate( lerpResult56_g239 );
				float temp_output_9_0_g241 = break21_g239.z;
				float temp_output_11_0_g241 = temp_output_47_0_g239;
				float time2_g241 = 0.0;
				float2 voronoiSmoothId2_g241 = 0;
				float2 texCoord4_g241 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g241 = texCoord4_g241 * temp_output_11_0_g241;
				float2 id2_g241 = 0;
				float2 uv2_g241 = 0;
				float voroi2_g241 = voronoi2_g241( coords2_g241, time2_g241, id2_g241, uv2_g241, 0, voronoiSmoothId2_g241 );
				float simplePerlin2D12_g241 = snoise( texCoord4_g241*temp_output_11_0_g241 );
				simplePerlin2D12_g241 = simplePerlin2D12_g241*0.5 + 0.5;
				float lerpResult57_g239 = lerp( break21_g239.z , ( (0.0 + (temp_output_9_0_g241 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g241 + ( voroi2_g241 + simplePerlin2D12_g241 ) ) ) , temp_output_53_0_g239);
				float temp_output_4_0_g239 = saturate( lerpResult57_g239 );
				float3 OUT_VertexOffset203 = ( ( _Tesellationfactor * ( ( tex2Dlod( _BaseHeight, float4( UV171, 0, 0.0) ).r * ( 1.0 - saturate( ( temp_output_3_0_g239 + temp_output_2_0_g239 + temp_output_4_0_g239 ) ) ) ) + ( ( ( tex2Dlod( _Height_1, float4( UV171, 0, 0.0) ).r * temp_output_3_0_g239 ) + ( tex2Dlod( _Height_2, float4( UV171, 0, 0.0) ).r * temp_output_2_0_g239 ) ) + ( tex2Dlod( _Height_3, float4( UV171, 0, 0.0) ).r * temp_output_4_0_g239 ) ) ) ) * v.vertex.xyz );
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset203;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				o.clipPos = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				

				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="Picking" }

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007


			#pragma vertex vert
			#pragma fragment frag

		    #define SCENEPICKINGPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float _Tesellationfactor;
			float _Tiling;
			float _Noseintensityval;
			float _Noisescaleval;
			float _WhitNoiseLerpTex4;
			float _WhitNoiseLerpTex1;
			float _WhitNoiseLerpTex2;
			float _WhitNoiseLerpTex3;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _BaseHeight;
			sampler2D _Height_1;
			sampler2D _Height_2;
			sampler2D _Height_3;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

					float2 voronoihash2_g240( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g240( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g240( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
					float2 voronoihash2_g242( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g242( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g242( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash2_g241( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2_g241( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2_g241( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						
						 		}
						 	}
						}
						return F1;
					}
			

			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 temp_cast_0 = (_Tiling).xx;
				float2 texCoord170 = v.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
				float2 UV171 = texCoord170;
				float4 VertexColor_var61 = v.ase_color;
				float3 temp_output_20_0_g239 = VertexColor_var61.rgb;
				float3 break21_g239 = temp_output_20_0_g239;
				float temp_output_9_0_g240 = break21_g239.x;
				float NoiseIntensityval186 = _Noseintensityval;
				float temp_output_46_0_g239 = NoiseIntensityval186;
				float Noisescaleval190 = _Noisescaleval;
				float temp_output_47_0_g239 = Noisescaleval190;
				float temp_output_11_0_g240 = temp_output_47_0_g239;
				float time2_g240 = 0.0;
				float2 voronoiSmoothId2_g240 = 0;
				float2 texCoord4_g240 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g240 = texCoord4_g240 * temp_output_11_0_g240;
				float2 id2_g240 = 0;
				float2 uv2_g240 = 0;
				float voroi2_g240 = voronoi2_g240( coords2_g240, time2_g240, id2_g240, uv2_g240, 0, voronoiSmoothId2_g240 );
				float simplePerlin2D12_g240 = snoise( texCoord4_g240*temp_output_11_0_g240 );
				simplePerlin2D12_g240 = simplePerlin2D12_g240*0.5 + 0.5;
				float temp_output_53_0_g239 = _WhitNoiseLerpTex4;
				float lerpResult52_g239 = lerp( break21_g239.x , ( (0.0 + (temp_output_9_0_g240 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g240 + ( voroi2_g240 + simplePerlin2D12_g240 ) ) ) , temp_output_53_0_g239);
				float temp_output_3_0_g239 = saturate( lerpResult52_g239 );
				float temp_output_9_0_g242 = break21_g239.y;
				float temp_output_11_0_g242 = temp_output_47_0_g239;
				float time2_g242 = 0.0;
				float2 voronoiSmoothId2_g242 = 0;
				float2 texCoord4_g242 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g242 = texCoord4_g242 * temp_output_11_0_g242;
				float2 id2_g242 = 0;
				float2 uv2_g242 = 0;
				float voroi2_g242 = voronoi2_g242( coords2_g242, time2_g242, id2_g242, uv2_g242, 0, voronoiSmoothId2_g242 );
				float simplePerlin2D12_g242 = snoise( texCoord4_g242*temp_output_11_0_g242 );
				simplePerlin2D12_g242 = simplePerlin2D12_g242*0.5 + 0.5;
				float lerpResult56_g239 = lerp( break21_g239.y , ( (0.0 + (temp_output_9_0_g242 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g242 + ( voroi2_g242 + simplePerlin2D12_g242 ) ) ) , temp_output_53_0_g239);
				float temp_output_2_0_g239 = saturate( lerpResult56_g239 );
				float temp_output_9_0_g241 = break21_g239.z;
				float temp_output_11_0_g241 = temp_output_47_0_g239;
				float time2_g241 = 0.0;
				float2 voronoiSmoothId2_g241 = 0;
				float2 texCoord4_g241 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 coords2_g241 = texCoord4_g241 * temp_output_11_0_g241;
				float2 id2_g241 = 0;
				float2 uv2_g241 = 0;
				float voroi2_g241 = voronoi2_g241( coords2_g241, time2_g241, id2_g241, uv2_g241, 0, voronoiSmoothId2_g241 );
				float simplePerlin2D12_g241 = snoise( texCoord4_g241*temp_output_11_0_g241 );
				simplePerlin2D12_g241 = simplePerlin2D12_g241*0.5 + 0.5;
				float lerpResult57_g239 = lerp( break21_g239.z , ( (0.0 + (temp_output_9_0_g241 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g241 + ( voroi2_g241 + simplePerlin2D12_g241 ) ) ) , temp_output_53_0_g239);
				float temp_output_4_0_g239 = saturate( lerpResult57_g239 );
				float3 OUT_VertexOffset203 = ( ( _Tesellationfactor * ( ( tex2Dlod( _BaseHeight, float4( UV171, 0, 0.0) ).r * ( 1.0 - saturate( ( temp_output_3_0_g239 + temp_output_2_0_g239 + temp_output_4_0_g239 ) ) ) ) + ( ( ( tex2Dlod( _Height_1, float4( UV171, 0, 0.0) ).r * temp_output_3_0_g239 ) + ( tex2Dlod( _Height_2, float4( UV171, 0, 0.0) ).r * temp_output_2_0_g239 ) ) + ( tex2Dlod( _Height_3, float4( UV171, 0, 0.0) ).r * temp_output_4_0_g239 ) ) ) ) * v.vertex.xyz );
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset203;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				o.clipPos = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				

				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
						clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}
		
	}
	
	CustomEditor "UnityEditor.ShaderGraphLitGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.RangedFloatNode;175;-2043.17,-771.9156;Inherit;False;Property;_Tiling;Tiling;22;0;Create;True;0;0;0;False;0;False;0;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-1840,-780;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;108;-1863.991,286.2975;Inherit;False;Property;_Noseintensityval;Nose intensity val;16;0;Create;True;0;0;0;False;0;False;0;2.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-1865.441,368.5565;Inherit;False;Property;_Noisescaleval;Noise scale val;17;0;Create;True;0;0;0;False;0;False;0;9000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;25;-1862.368,473.0826;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;171;-1616,-780;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;174;-1448.62,1466.5;Inherit;False;171;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;186;-1557.812,274.361;Inherit;False;NoiseIntensityval;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;-1557.085,359.1781;Inherit;False;Noisescaleval;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;-1407.903,2484.216;Inherit;False;171;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-1658.809,461.2066;Inherit;False;VertexColor_var;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-1094.58,2117.69;Inherit;False;Property;_WhitNoiseLerpTex4;Whit Noise Lerp Tex 3;21;0;Create;True;0;0;0;False;0;False;0;0.541;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-1039.517,1967.243;Inherit;False;61;VertexColor_var;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-998.7996,2984.959;Inherit;False;61;VertexColor_var;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;182;-1094.799,2792.959;Inherit;True;Property;_Height_3;Height_3;15;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;180;-1094.799,2584.959;Inherit;True;Property;_Height_2;Height_2;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;188;-684.1547,1041.157;Inherit;False;186;NoiseIntensityval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;84;-1135.516,1775.243;Inherit;True;Property;_Roughness_3;Roughness_3;14;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;85;-1135.516,1567.243;Inherit;True;Property;_Roughness_2;Roughness_2;10;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;181;-1094.799,2392.958;Inherit;True;Property;_Height_1;Height_1;7;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;6a6929e18b003ae4491ee0fe1df76f1b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;194;-673.5852,2058.064;Inherit;False;190;Noisescaleval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;88;-1135.516,1375.242;Inherit;True;Property;_Roughness_1;Roughness_1;6;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;029e7b08c8ba92a40a4e11ea403bde80;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;87;-1135.516,1183.242;Inherit;True;Property;_BaseRoughness;Base Roughness;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;193;-684.8611,1121.354;Inherit;False;190;Noisescaleval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-1135.297,1099.974;Inherit;False;Property;_WhitNoiseLerpTex3;Whit Noise Lerp Tex 3;20;0;Create;True;0;0;0;False;0;False;0;0.541;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;-677.0509,1966.224;Inherit;False;186;NoiseIntensityval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;177;-1094.799,2200.958;Inherit;True;Property;_BaseHeight;Base Height;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;183;-417.1389,2294;Inherit;False;TextureBlend;-1;;239;24e89ccf6f531df44bc7fec5ad48af13;0;8;53;FLOAT;0;False;46;FLOAT;0;False;47;FLOAT;0;False;22;FLOAT;0;False;23;FLOAT;0;False;26;FLOAT;0;False;27;FLOAT;0;False;20;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;-1442.969,490.761;Inherit;False;171;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;197;396.7304,1103.074;Inherit;False;Property;_Tesellationfactor;Tesellation factor;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;166;-457.8563,1276.284;Inherit;False;TextureBlend;-1;;243;24e89ccf6f531df44bc7fec5ad48af13;0;8;53;FLOAT;0;False;46;FLOAT;0;False;47;FLOAT;0;False;22;FLOAT;0;False;23;FLOAT;0;False;26;FLOAT;0;False;27;FLOAT;0;False;20;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-1486.342,-494.417;Inherit;False;171;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-1052.425,970.0065;Inherit;False;61;VertexColor_var;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;66;-1132.331,373.1783;Inherit;True;Property;_Normal_1;Normal_1;5;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;7bb22a9c07ee6c04592d6bcf9609e938;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;64;-1132.331,773.1782;Inherit;True;Property;_Normal_3;Normal_3;13;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;192;-710.8112,-790.4068;Inherit;False;190;Noisescaleval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;67;-1132.331,181.1783;Inherit;True;Property;_BaseNormal;Base Normal;3;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;185;-582.0657,107.9874;Inherit;False;186;NoiseIntensityval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;191;-574.7206,190.1258;Inherit;False;190;Noisescaleval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-717.6057,-877.2195;Inherit;False;186;NoiseIntensityval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-1152,-592;Inherit;True;Property;_Texture_1;Texture_1;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;d7c7f73fe32c947469da8d07645ffe0b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;195;612.9168,1360.694;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;121;-1141.558,-874.7564;Inherit;False;Property;_WhitNoiseLerpTex1;Whit Noise Lerp Tex 1;18;0;Create;True;0;0;0;False;0;False;0;0.795;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-1134.277,101.5252;Inherit;False;Property;_WhitNoiseLerpTex2;Whit Noise Lerp Tex 2;19;0;Create;True;0;0;0;False;0;False;0;0.493;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-1152,-400;Inherit;True;Property;_Texture_2;Texture_2;8;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;65;-1132.331,565.1782;Inherit;True;Property;_Normal_2;Normal_2;9;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;93;-136.0642,1277.022;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;686.6303,1127.774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-1152,-192;Inherit;True;Property;_Texture_3;Texture_3;12;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;-1152,-784;Inherit;True;Property;_BaseBaseColor;Base Base Color;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1056,0;Inherit;False;61;VertexColor_var;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;843.9304,1169.374;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;167;-221.2828,381.0264;Inherit;False;TextureBlend;-1;;247;24e89ccf6f531df44bc7fec5ad48af13;0;8;53;FLOAT;0;False;46;FLOAT;0;False;47;FLOAT;0;False;22;FLOAT3;0,0,0;False;23;FLOAT3;0,0,0;False;26;FLOAT3;0,0,0;False;27;FLOAT3;0,0,0;False;20;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCGrayscale;103;66.3687,1295.067;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;168;-471.2651,-528;Inherit;False;TextureBlend;-1;;251;24e89ccf6f531df44bc7fec5ad48af13;0;8;53;FLOAT;0;False;46;FLOAT;0;False;47;FLOAT;0;False;22;COLOR;0,0,0,0;False;23;COLOR;0,0,0,0;False;26;COLOR;0,0,0,0;False;27;COLOR;0,0,0,0;False;20;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;104;384,576;Inherit;False;Constant;_Color0;Color 0;13;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;204;1408,464;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;206;1024.679,465.7168;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;207;1024.679,465.7168;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;True;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;208;1024.679,465.7168;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;209;1024.679,465.7168;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;210;1024.679,465.7168;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormals;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;211;1024.679,465.7168;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalGBuffer;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;212;1024.679,465.7168;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;213;1024.679,465.7168;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;199;1152,384;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;205;1536,480;Float;False;True;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;Drimys/Nature/TerrainMixer;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;19;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;41;Workflow;1;0;Surface;0;0;  Refraction Model;0;0;  Blend;0;0;Two Sided;1;0;Fragment Normal Space,InvertActionOnDeselection;0;0;Forward Only;0;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;_FinalColorxAlpha;0;0;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Write Depth;0;0;  Early Z;0;0;Vertex Position,InvertActionOnDeselection;1;0;Debug Display;0;0;Clear Coat;0;0;0;10;False;True;True;True;True;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;1152,480;Inherit;False;OUT_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;201;1152,576;Inherit;False;OUT_Metallic;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;1152,672;Inherit;False;OUT_Smoothnes;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;203;1152,768;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
WireConnection;170;0;175;0
WireConnection;171;0;170;0
WireConnection;186;0;108;0
WireConnection;190;0;109;0
WireConnection;61;0;25;0
WireConnection;182;1;176;0
WireConnection;180;1;176;0
WireConnection;84;1;174;0
WireConnection;85;1;174;0
WireConnection;181;1;176;0
WireConnection;88;1;174;0
WireConnection;87;1;174;0
WireConnection;177;1;176;0
WireConnection;183;53;178;0
WireConnection;183;46;189;0
WireConnection;183;47;194;0
WireConnection;183;22;177;1
WireConnection;183;23;181;1
WireConnection;183;26;180;1
WireConnection;183;27;182;1
WireConnection;183;20;179;0
WireConnection;166;53;129;0
WireConnection;166;46;188;0
WireConnection;166;47;193;0
WireConnection;166;22;87;1
WireConnection;166;23;88;1
WireConnection;166;26;85;1
WireConnection;166;27;84;1
WireConnection;166;20;86;0
WireConnection;66;1;173;0
WireConnection;64;1;173;0
WireConnection;67;1;173;0
WireConnection;7;1;172;0
WireConnection;8;1;172;0
WireConnection;65;1;173;0
WireConnection;93;0;166;0
WireConnection;198;0;197;0
WireConnection;198;1;183;0
WireConnection;26;1;172;0
WireConnection;42;1;172;0
WireConnection;196;0;198;0
WireConnection;196;1;195;0
WireConnection;167;53;128;0
WireConnection;167;46;185;0
WireConnection;167;47;191;0
WireConnection;167;22;67;0
WireConnection;167;23;66;0
WireConnection;167;26;65;0
WireConnection;167;27;64;0
WireConnection;167;20;63;0
WireConnection;103;0;93;0
WireConnection;168;53;121;0
WireConnection;168;46;187;0
WireConnection;168;47;192;0
WireConnection;168;22;42;0
WireConnection;168;23;7;0
WireConnection;168;26;8;0
WireConnection;168;27;26;0
WireConnection;168;20;62;0
WireConnection;199;0;168;0
WireConnection;205;0;199;0
WireConnection;205;1;200;0
WireConnection;205;3;201;0
WireConnection;205;4;202;0
WireConnection;205;8;203;0
WireConnection;200;0;167;0
WireConnection;201;0;104;0
WireConnection;202;0;103;0
WireConnection;203;0;196;0
ASEEND*/
//CHKSM=5363FF0BAD2DEE6C1D30A543701776B17E2FBD93