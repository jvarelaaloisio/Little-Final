// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "StylizedWater"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_MainColor("Main Color", Color) = (0.3921569,0.3921569,0.3921569,1)
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_Color("Color", Color) = (0,0.2509804,0.6666667,0)
		_CausticColor("Caustic Color", Color) = (0,1,0.7249274,0)
		_CausticScale("Caustic Scale", Float) = 0.5
		_CausticEmissiveFactor("Caustic Emissive Factor", Float) = 1
		_WindSpeed("Wind Speed", Float) = 2
		_WindSpeedPerturbFactor("Wind Speed Perturb Factor", Float) = 0.5
		_GravitySpeed("Gravity Speed", Range( 0 , 1)) = 1
		_HorizontalDirection("Horizontal Direction", Range( 0 , 360)) = 90
		_DirectionSpeedFactor("Direction Speed Factor", Float) = 0.5
		_BigWavePrimaryScale("Big Wave Primary Scale", Float) = 0.15
		_BigWaveSecondaryScale("Big Wave Secondary Scale", Float) = 0
		[NoScaleOffset][Normal]_WaterNormal("Water Normal", 2D) = "bump" {}
		_NormalScalePrimaryPattern("Normal Scale Primary Pattern", Float) = 1.2
		_NormalScaleSecondPattern("Normal Scale Second Pattern", Float) = 0.8
		_NormalDistanceBlendFactor("Normal Distance Blend Factor", Float) = 1
		_NormalWavesAndDetailBlend("Normal Waves And Detail Blend", Range( 0 , 1)) = 0.1
		_CameraDistanceMask("Camera Distance Mask", Float) = 11
		_FoamColor("Foam Color", Color) = (1,1,1,0)
		[NoScaleOffset]_WaveFoamGrunge("Wave Foam Grunge", 2D) = "white" {}
		_WaveFoamScale("Wave Foam Scale", Float) = 1
		_WaveFoamNormalStrength("Wave Foam Normal Strength", Range( 0 , 1)) = 0.05
		_WaveFoamFactor("Wave Foam Factor", Float) = 10
		_WaveFoamAnimationScale("Wave Foam Animation Scale", Float) = 0.5
		_WaveFoamAnimationSpeed("Wave Foam Animation Speed", Float) = 0.5
		[NoScaleOffset]_BorderFoamGrunge("Border Foam Grunge", 2D) = "white" {}
		_BorderFoamGrungeScale("Border Foam Grunge Scale", Float) = 1
		_BorderFoamRange("Border Foam Range", Float) = 0.8
		_BorderFoamMinFactor("Border Foam Min Factor", Range( 0 , 1)) = 0.5
		_BorderFoamNormalStrength("Border Foam Normal Strength", Range( 0 , 1)) = 0.15
		_BorderFoamDisturbSpeed("Border Foam Disturb Speed", Float) = 0.1
		_BorderFoamDisturbScale("Border Foam Disturb Scale", Float) = 2
		_BorderFoamSharpness("Border Foam Sharpness", Range( 0 , 1)) = 0
		_FoamHeight("Foam Height", Range( 0 , 1)) = 0.15
		_FoamObjectsFactor("Foam Objects  Factor", Float) = 0
		_NormalFoamFactor("Normal Foam Factor", Float) = 0
		[NoScaleOffset]_ObjectsRipplesTargetTexture("Objects Ripples Target Texture", 2D) = "black" {}
		_ClarityFactor("Clarity Factor", Range( 0 , 1)) = 0
		_DepthColor("Depth Color", Color) = (0,0.4117647,0.6666667,1)
		_DepthDistace("Depth Distace", Range( 0 , 1)) = 0.9
		_DepthDeformFactor("Depth Deform Factor", Range( 0 , 1)) = 0.091
		_BorderDistortionFactor("Border Distortion Factor", Float) = 1.2
		_BorderDistortionNormalStrength("Border Distortion Normal Strength", Float) = 0
		_WetDistanceFactor("Wet Distance Factor", Float) = 1
		_WetSurfaceFactor("Wet Surface Factor", Float) = 0.61
		_DisplacementFactor("Displacement Factor", Range( 0 , 1)) = 0.395


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 16
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
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

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" "UniversalMaterialType"="Lit" }

		Cull Off
		ZWrite Off
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

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007
			#define REQUIRE_DEPTH_TEXTURE 1
			#define REQUIRE_OPAQUE_TEXTURE 1


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

			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _CausticColor;
			float4 _FoamColor;
			float4 _Color;
			float4 _DepthColor;
			float4 _MainColor;
			float _WindSpeed;
			float _NormalDistanceBlendFactor;
			float _CameraDistanceMask;
			float _NormalScaleSecondPattern;
			float _NormalWavesAndDetailBlend;
			float _BorderDistortionFactor;
			float _FoamObjectsFactor;
			float _BorderDistortionNormalStrength;
			float _WaveFoamNormalStrength;
			float _WetDistanceFactor;
			float _DepthDeformFactor;
			float _DepthDistace;
			float _ClarityFactor;
			float _WetSurfaceFactor;
			float _CausticScale;
			float _CausticEmissiveFactor;
			float _BorderFoamNormalStrength;
			float _NormalScalePrimaryPattern;
			float _WaveFoamAnimationSpeed;
			float _WaveFoamAnimationScale;
			float _HorizontalDirection;
			float _DirectionSpeedFactor;
			float _GravitySpeed;
			float _BigWavePrimaryScale;
			float _WindSpeedPerturbFactor;
			float _BigWaveSecondaryScale;
			float _BorderFoamRange;
			float _WaveFoamFactor;
			float _BorderFoamMinFactor;
			float _BorderFoamDisturbScale;
			float _BorderFoamGrungeScale;
			float _NormalFoamFactor;
			float _BorderFoamSharpness;
			float _FoamHeight;
			float _DisplacementFactor;
			float _WaveFoamScale;
			float _BorderFoamDisturbSpeed;
			float _Smoothness;
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

			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _BorderFoamGrunge;
			sampler2D _ObjectsRipplesTargetTexture;
			sampler2D _WaveFoamGrunge;
			sampler2D _WaterNormal;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

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
			
			float SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD(float2 uv)
			{
				#if defined(REQUIRE_DEPTH_TEXTURE)
				#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
				 	float rawDepth = SAMPLE_TEXTURE2D_ARRAY_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, unity_StereoEyeIndex, 0).r;
				#else
				 	float rawDepth = SAMPLE_DEPTH_TEXTURE_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, 0);
				#endif
				return rawDepth;
				#endif // REQUIRE_DEPTH_TEXTURE
				return 0;
			}
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}
					float2 voronoihash599( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi599( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash599( n + g );
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
						return (F2 + F1) * 0.5;
					}
			
			float3 PerturbNormal107_g72( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			inline float3 TriplanarSampling18( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			inline float3 TriplanarSampling56( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			float3 PerturbNormal107_g71( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			float3 PerturbNormal107_g73( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			inline float4 ASE_ComputeGrabScreenPos( float4 pos )
			{
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				float4 o = pos;
				o.y = pos.w * 0.5f;
				o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
				return o;
			}
			
					float2 voronoihash467( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi467( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash467( n + g );
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
						return (F2 + F1) * 0.5;
					}
			
			float3 ASEIndirectDiffuse( float2 uvStaticLightmap, float3 normalWS )
			{
			#ifdef LIGHTMAP_ON
				return SampleLightmap( uvStaticLightmap, normalWS );
			#else
				return SampleSH(normalWS);
			#endif
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult2_g62 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_0 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_0 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_1 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_1 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(ase_worldPos.x , ase_worldPos.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2Dlod( _BorderFoamGrunge, float4( ( appendResult2_g57 * temp_output_4_0_g57 ), 0, 0.0) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2Dlod( _ObjectsRipplesTargetTexture, float4( (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5), 0, 0.0) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord8.x = eyeDepth;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.yzw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset275;

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

				float3 hsvTorgb475 = RGBToHSV( _Color.rgb );
				float3 hsvTorgb477 = HSVToRGB( float3(hsvTorgb475.x,hsvTorgb475.y,( hsvTorgb475.z + 1.0 )) );
				float2 appendResult2_g62 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_2 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_2 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_3 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_3 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(WorldPosition.x , WorldPosition.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2D( _BorderFoamGrunge, ( appendResult2_g57 * temp_output_4_0_g57 ) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2D( _ObjectsRipplesTargetTexture, (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 tanNormal468 = OUT_VertexOffset275;
				float fresnelNdotV468 = dot( float3(dot(tanToWorld0,tanNormal468), dot(tanToWorld1,tanNormal468), dot(tanToWorld2,tanNormal468)), WorldViewDirection );
				float fresnelNode468 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV468, 8.0 ) );
				float4 lerpResult480 = lerp( float4( hsvTorgb477 , 0.0 ) , _Color , saturate( fresnelNode468 ));
				float2 appendResult2_g58 = (float2(WorldPosition.x , WorldPosition.z));
				float temp_output_4_0_g58 = _WaveFoamScale;
				float mulTime601 = _TimeParameters.x * _WaveFoamAnimationSpeed;
				float time599 = mulTime601;
				float2 voronoiSmoothId599 = 0;
				float2 coords599 = UV_WorldHorizontal491 * _WaveFoamAnimationScale;
				float2 id599 = 0;
				float2 uv599 = 0;
				float voroi599 = voronoi599( coords599, time599, id599, uv599, 0, voronoiSmoothId599 );
				float M_DisplacementWaves915 = saturate( temp_output_149_0 );
				float2 _GlobalFoamSharpness = float2(-0.5,1);
				float temp_output_740_0 = saturate( (0.0 + (( saturate( ( tex2D( _WaveFoamGrunge, ( appendResult2_g58 * temp_output_4_0_g58 ) ).r - saturate( voroi599 ) ) ) * (_GlobalFoamSharpness.x + (M_DisplacementWaves915 - 0.0) * (_GlobalFoamSharpness.y - _GlobalFoamSharpness.x) / (1.0 - 0.0)) ) - 0.0) * (_WaveFoamFactor - 0.0) / (1.0 - 0.0)) );
				float M_BoredrAndWavesFoamMask636 = saturate( ( VAR_T_BorderFoamMask1076 + temp_output_740_0 ) );
				float4 lerpResult572 = lerp( lerpResult480 , _FoamColor , M_BoredrAndWavesFoamMask636);
				float3 surf_pos107_g72 = WorldPosition;
				float3 surf_norm107_g72 = WorldNormal;
				float height107_g72 = saturate( M_DisplacementWaves915 );
				float scale107_g72 = ( _DisplacementFactor * 10.0 );
				float3 localPerturbNormal107_g72 = PerturbNormal107_g72( surf_pos107_g72 , surf_norm107_g72 , height107_g72 , scale107_g72 );
				float3x3 ase_worldToTangent = float3x3(WorldTangent,WorldBiTangent,WorldNormal);
				float3 worldToTangentDir42_g72 = mul( ase_worldToTangent, localPerturbNormal107_g72);
				float3 N_DisplacementWaves1245 = worldToTangentDir42_g72;
				float F_ScalePrimaryPattern124 = _NormalScalePrimaryPattern;
				float2 temp_cast_5 = (F_ScalePrimaryPattern124).xx;
				float mulTime33 = _TimeParameters.x * ( _WindSpeed * 0.5 );
				float3 AUV_PrimaryWaterPattern50 = ( WorldPosition + ( mulTime33 * V3_WindDirection79 ) );
				float eyeDepth = IN.ase_texcoord8.x;
				float cameraDepthFade87 = (( eyeDepth -_ProjectionParams.y - 0.0 ) / _CameraDistanceMask);
				float clampResult102 = clamp( cameraDepthFade87 , 0.0 , 1.0 );
				float F_DistanceBlendFactor108 = ( _NormalDistanceBlendFactor * ( 1.0 - clampResult102 ) );
				float3 triplanar18 = TriplanarSampling18( _WaterNormal, AUV_PrimaryWaterPattern50, WorldNormal, 1.0, temp_cast_5, F_DistanceBlendFactor108, 0 );
				float3 tanTriplanarNormal18 = mul( ase_worldToTangent, triplanar18 );
				float F_ScaleSecondaryPattern127 = _NormalScaleSecondPattern;
				float2 temp_cast_6 = (F_ScaleSecondaryPattern127).xx;
				float3 AUV_SecondWaterPattern53 = ( WorldPosition + ( ( mulTime33 * V3_WindDirection79 ) * _WindSpeedPerturbFactor ) );
				float3 triplanar56 = TriplanarSampling56( _WaterNormal, AUV_SecondWaterPattern53, WorldNormal, 1.0, temp_cast_6, F_DistanceBlendFactor108, 0 );
				float3 tanTriplanarNormal56 = mul( ase_worldToTangent, triplanar56 );
				float3 N_DetailPattern163 = BlendNormal( tanTriplanarNormal18 , tanTriplanarNormal56 );
				float3 lerpResult269 = lerp( N_DisplacementWaves1245 , N_DetailPattern163 , _NormalWavesAndDetailBlend);
				float3 surf_pos107_g71 = WorldPosition;
				float3 surf_norm107_g71 = WorldNormal;
				float screenDepth2_g61 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g61 = abs( ( screenDepth2_g61 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g61 = ( 1.0 - ( ( distanceDepth2_g61 - ( F_BorderFoamRange1100 * _BorderDistortionFactor ) ) - -1.0 ) );
				float AM_WaterDisturb1230 = saturate( temp_output_698_0 );
				float temp_output_9_0_g61 = ( temp_output_5_0_g61 + ( temp_output_5_0_g61 * AM_WaterDisturb1230 ) );
				float temp_output_13_0_g61 = (1.0 + (0.0 - 0.0) * (1.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g61 = (-temp_output_13_0_g61 + (temp_output_9_0_g61 - 0.0) * (temp_output_13_0_g61 - -temp_output_13_0_g61) / (1.0 - 0.0));
				float smoothstepResult1139 = smoothstep( 0.0 , 1.0 , saturate( temp_output_10_0_g61 ));
				float F_M_BorderDistortion1125 = saturate( smoothstepResult1139 );
				float temp_output_1231_0 = ( saturate( ( F_M_BorderDistortion1125 + (0.0 + (M_RawEffectMask1193 - 0.0) * (_FoamObjectsFactor - 0.0) / (1.0 - 0.0)) ) ) * ( AM_WaterDisturb1230 * M_EffectFoamFactor1236 ) );
				float height107_g71 = temp_output_1231_0;
				float scale107_g71 = _BorderDistortionNormalStrength;
				float3 localPerturbNormal107_g71 = PerturbNormal107_g71( surf_pos107_g71 , surf_norm107_g71 , height107_g71 , scale107_g71 );
				float3 worldToTangentDir42_g71 = mul( ase_worldToTangent, localPerturbNormal107_g71);
				float3 lerpResult1142 = lerp( lerpResult269 , ( worldToTangentDir42_g71 * lerpResult269 ) , saturate( temp_output_1231_0 ));
				float3 surf_pos107_g73 = WorldPosition;
				float3 surf_norm107_g73 = WorldNormal;
				float M_WavesFoamMask1062 = temp_output_740_0;
				float height107_g73 = saturate( ( ( _BorderFoamNormalStrength * F_DistanceBlendFactor108 * VAR_T_BorderFoamMask1076 ) + ( _WaveFoamNormalStrength * F_DistanceBlendFactor108 * M_WavesFoamMask1062 ) ) );
				float scale107_g73 = 1.0;
				float3 localPerturbNormal107_g73 = PerturbNormal107_g73( surf_pos107_g73 , surf_norm107_g73 , height107_g73 , scale107_g73 );
				float3 worldToTangentDir42_g73 = mul( ase_worldToTangent, localPerturbNormal107_g73);
				float screenDepth1253 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth1253 = abs( ( screenDepth1253 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( (1.0 + (M_DisplacementWaves915 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) ) );
				float smoothstepResult1293 = smoothstep( 0.0 , 1.0 , ceil( saturate( (1.0 + (distanceDepth1253 - 0.0) * (( 1.0 - _WetDistanceFactor ) - 1.0) / (1.0 - 0.0)) ) ));
				float M_WetSurfaceMask1282 = smoothstepResult1293;
				float3 lerpResult1309 = lerp( BlendNormal( BlendNormal( N_DisplacementWaves1245 , lerpResult1142 ) , worldToTangentDir42_g73 ) , N_DisplacementWaves1245 , M_WetSurfaceMask1282);
				float3 OUT_Normal273 = lerpResult1309;
				float3 temp_output_726_0 = ( float3( (ase_screenPosNorm).xy ,  0.0 ) + ( OUT_Normal273 * _DepthDeformFactor ) );
				float3 UV_DistortionedScreen1001 = temp_output_726_0;
				float eyeDepth992 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( float4( UV_DistortionedScreen1001 , 0.0 ).xy ),_ZBufferParams);
				float M_DephtInverseMask947 = saturate( ( saturate( (0.0 + (eyeDepth992 - 0.0) * ((0.9 + (_DepthDistace - 0.0) * (0.0 - 0.9) / (1.0 - 0.0)) - 0.0) / (1.0 - 0.0)) ) + M_DisplacementWaves915 ) );
				float4 lerpResult958 = lerp( _DepthColor , lerpResult572 , M_DephtInverseMask947);
				float4 RGB_BaseColor1016 = lerpResult958;
				float4 fetchOpaqueVal723 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_726_0.xy ), 1.0 );
				float4 RGB_DepthColor731 = fetchOpaqueVal723;
				float4 lerpResult1017 = lerp( RGB_BaseColor1016 , RGB_DepthColor731 , _ClarityFactor);
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ScreenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float4 fetchOpaqueVal1241 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ase_grabScreenPosNorm ), 1.0 );
				float3 hsvTorgb1278 = RGBToHSV( fetchOpaqueVal1241.rgb );
				float3 hsvTorgb1279 = HSVToRGB( float3(hsvTorgb1278.x,( hsvTorgb1278.y + _WetSurfaceFactor ),hsvTorgb1278.z) );
				float3 RGB_WetSurface1283 = saturate( hsvTorgb1279 );
				float4 lerpResult1287 = lerp( saturate( ( lerpResult1017 + M_BoredrAndWavesFoamMask636 ) ) , float4( RGB_WetSurface1283 , 0.0 ) , M_WetSurfaceMask1282);
				float4 OUT_BaseColor410 = lerpResult1287;
				
				float time467 = _TimeParameters.x;
				float2 voronoiSmoothId467 = 0;
				float voronoiSmooth467 = 0.0;
				float2 coords467 = UV_WorldHorizontal491 * _CausticScale;
				float2 id467 = 0;
				float2 uv467 = 0;
				float fade467 = 0.5;
				float voroi467 = 0;
				float rest467 = 0;
				for( int it467 = 0; it467 <2; it467++ ){
				voroi467 += fade467 * voronoi467( coords467, time467, id467, uv467, voronoiSmooth467,voronoiSmoothId467 );
				rest467 += fade467;
				coords467 *= 2;
				fade467 *= 0.5;
				}//Voronoi467
				voroi467 /= rest467;
				float4 lerpResult1312 = lerp( ( _CausticColor * saturate( (-0.01 + (( M_DispWavesWithFoam1058 * voroi467 ) - 0.0) * (_CausticEmissiveFactor - -0.01) / (1.0 - 0.0)) ) ) , float4( 0,0,0,0 ) , M_WetSurfaceMask1282);
				float ase_lightAtten = 0;
				Light ase_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float3 tanNormal12_g70 = OUT_Normal273;
				float3 worldNormal12_g70 = float3(dot(tanToWorld0,tanNormal12_g70), dot(tanToWorld1,tanNormal12_g70), dot(tanToWorld2,tanNormal12_g70));
				float3 normalizeResult64_g70 = normalize( worldNormal12_g70 );
				float dotResult14_g70 = dot( normalizeResult64_g70 , _MainLightPosition.xyz );
				float3 bakedGI34_g70 = ASEIndirectDiffuse( IN.lightmapUVOrVertexSH.xy, normalizeResult64_g70);
				MixRealtimeAndBakedGI(ase_mainLight, normalizeResult64_g70, bakedGI34_g70, half4(0,0,0,0));
				float4 temp_output_42_0_g70 = _MainColor;
				float4 OUIT_Emissive510 = ( lerpResult1312 * saturate( (( ( ( ( _MainLightColor * ase_lightAtten ) * max( dotResult14_g70 , 0.0 ) ) + float4( bakedGI34_g70 , 0.0 ) ) * float4( (temp_output_42_0_g70).rgb , 0.0 ) )).r ) );
				
				float lerpResult1305 = lerp( _Smoothness , 0.5 , M_WetSurfaceMask1282);
				float OUT_Smoothness1306 = lerpResult1305;
				

				float3 BaseColor = OUT_BaseColor410.rgb;
				float3 Normal = OUT_Normal273;
				float3 Emission = OUIT_Emissive510.rgb;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = OUT_Smoothness1306;
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
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007
			#define REQUIRE_DEPTH_TEXTURE 1


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
			
			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
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
			float4 _CausticColor;
			float4 _FoamColor;
			float4 _Color;
			float4 _DepthColor;
			float4 _MainColor;
			float _WindSpeed;
			float _NormalDistanceBlendFactor;
			float _CameraDistanceMask;
			float _NormalScaleSecondPattern;
			float _NormalWavesAndDetailBlend;
			float _BorderDistortionFactor;
			float _FoamObjectsFactor;
			float _BorderDistortionNormalStrength;
			float _WaveFoamNormalStrength;
			float _WetDistanceFactor;
			float _DepthDeformFactor;
			float _DepthDistace;
			float _ClarityFactor;
			float _WetSurfaceFactor;
			float _CausticScale;
			float _CausticEmissiveFactor;
			float _BorderFoamNormalStrength;
			float _NormalScalePrimaryPattern;
			float _WaveFoamAnimationSpeed;
			float _WaveFoamAnimationScale;
			float _HorizontalDirection;
			float _DirectionSpeedFactor;
			float _GravitySpeed;
			float _BigWavePrimaryScale;
			float _WindSpeedPerturbFactor;
			float _BigWaveSecondaryScale;
			float _BorderFoamRange;
			float _WaveFoamFactor;
			float _BorderFoamMinFactor;
			float _BorderFoamDisturbScale;
			float _BorderFoamGrungeScale;
			float _NormalFoamFactor;
			float _BorderFoamSharpness;
			float _FoamHeight;
			float _DisplacementFactor;
			float _WaveFoamScale;
			float _BorderFoamDisturbSpeed;
			float _Smoothness;
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

			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _BorderFoamGrunge;
			sampler2D _ObjectsRipplesTargetTexture;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

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
			
			float SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD(float2 uv)
			{
				#if defined(REQUIRE_DEPTH_TEXTURE)
				#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
				 	float rawDepth = SAMPLE_TEXTURE2D_ARRAY_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, unity_StereoEyeIndex, 0).r;
				#else
				 	float rawDepth = SAMPLE_DEPTH_TEXTURE_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, 0);
				#endif
				return rawDepth;
				#endif // REQUIRE_DEPTH_TEXTURE
				return 0;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult2_g62 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_0 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_0 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_1 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_1 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(ase_worldPos.x , ase_worldPos.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2Dlod( _BorderFoamGrunge, float4( ( appendResult2_g57 * temp_output_4_0_g57 ), 0, 0.0) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2Dlod( _ObjectsRipplesTargetTexture, float4( (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5), 0, 0.0) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset275;

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
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007
			#define REQUIRE_DEPTH_TEXTURE 1
			#define REQUIRE_OPAQUE_TEXTURE 1


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

			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile _ _FORWARD_PLUS
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_tangent : TANGENT;
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
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				float4 lightmapUVOrVertexSH : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _CausticColor;
			float4 _FoamColor;
			float4 _Color;
			float4 _DepthColor;
			float4 _MainColor;
			float _WindSpeed;
			float _NormalDistanceBlendFactor;
			float _CameraDistanceMask;
			float _NormalScaleSecondPattern;
			float _NormalWavesAndDetailBlend;
			float _BorderDistortionFactor;
			float _FoamObjectsFactor;
			float _BorderDistortionNormalStrength;
			float _WaveFoamNormalStrength;
			float _WetDistanceFactor;
			float _DepthDeformFactor;
			float _DepthDistace;
			float _ClarityFactor;
			float _WetSurfaceFactor;
			float _CausticScale;
			float _CausticEmissiveFactor;
			float _BorderFoamNormalStrength;
			float _NormalScalePrimaryPattern;
			float _WaveFoamAnimationSpeed;
			float _WaveFoamAnimationScale;
			float _HorizontalDirection;
			float _DirectionSpeedFactor;
			float _GravitySpeed;
			float _BigWavePrimaryScale;
			float _WindSpeedPerturbFactor;
			float _BigWaveSecondaryScale;
			float _BorderFoamRange;
			float _WaveFoamFactor;
			float _BorderFoamMinFactor;
			float _BorderFoamDisturbScale;
			float _BorderFoamGrungeScale;
			float _NormalFoamFactor;
			float _BorderFoamSharpness;
			float _FoamHeight;
			float _DisplacementFactor;
			float _WaveFoamScale;
			float _BorderFoamDisturbSpeed;
			float _Smoothness;
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

			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _BorderFoamGrunge;
			sampler2D _ObjectsRipplesTargetTexture;
			sampler2D _WaveFoamGrunge;
			sampler2D _WaterNormal;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

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
			
			float SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD(float2 uv)
			{
				#if defined(REQUIRE_DEPTH_TEXTURE)
				#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
				 	float rawDepth = SAMPLE_TEXTURE2D_ARRAY_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, unity_StereoEyeIndex, 0).r;
				#else
				 	float rawDepth = SAMPLE_DEPTH_TEXTURE_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, 0);
				#endif
				return rawDepth;
				#endif // REQUIRE_DEPTH_TEXTURE
				return 0;
			}
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}
					float2 voronoihash599( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi599( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash599( n + g );
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
						return (F2 + F1) * 0.5;
					}
			
			float3 PerturbNormal107_g72( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			inline float3 TriplanarSampling18( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			inline float3 TriplanarSampling56( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			float3 PerturbNormal107_g71( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			float3 PerturbNormal107_g73( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			inline float4 ASE_ComputeGrabScreenPos( float4 pos )
			{
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				float4 o = pos;
				o.y = pos.w * 0.5f;
				o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
				return o;
			}
			
					float2 voronoihash467( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi467( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash467( n + g );
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
						return (F2 + F1) * 0.5;
					}
			
			float3 ASEIndirectDiffuse( float2 uvStaticLightmap, float3 normalWS )
			{
			#ifdef LIGHTMAP_ON
				return SampleLightmap( uvStaticLightmap, normalWS );
			#else
				return SampleSH(normalWS);
			#endif
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult2_g62 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_0 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_0 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_1 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_1 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(ase_worldPos.x , ase_worldPos.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2Dlod( _BorderFoamGrunge, float4( ( appendResult2_g57 * temp_output_4_0_g57 ), 0, 0.0) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2Dlod( _ObjectsRipplesTargetTexture, float4( (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5), 0, 0.0) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				
				o.ase_texcoord4 = screenPos;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord5.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord6.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord7.xyz = ase_worldBitangent;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord5.w = eyeDepth;
				
				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH( ase_worldNormal, o.lightmapUVOrVertexSH.xyz );
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset275;

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
				float4 ase_tangent : TANGENT;

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
				o.ase_tangent = v.ase_tangent;
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
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
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

				float3 hsvTorgb475 = RGBToHSV( _Color.rgb );
				float3 hsvTorgb477 = HSVToRGB( float3(hsvTorgb475.x,hsvTorgb475.y,( hsvTorgb475.z + 1.0 )) );
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float2 appendResult2_g62 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_2 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_2 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_3 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_3 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(WorldPosition.x , WorldPosition.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2D( _BorderFoamGrunge, ( appendResult2_g57 * temp_output_4_0_g57 ) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2D( _ObjectsRipplesTargetTexture, (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				float3 ase_worldTangent = IN.ase_texcoord5.xyz;
				float3 ase_worldNormal = IN.ase_texcoord6.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord7.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal468 = OUT_VertexOffset275;
				float fresnelNdotV468 = dot( float3(dot(tanToWorld0,tanNormal468), dot(tanToWorld1,tanNormal468), dot(tanToWorld2,tanNormal468)), ase_worldViewDir );
				float fresnelNode468 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV468, 8.0 ) );
				float4 lerpResult480 = lerp( float4( hsvTorgb477 , 0.0 ) , _Color , saturate( fresnelNode468 ));
				float2 appendResult2_g58 = (float2(WorldPosition.x , WorldPosition.z));
				float temp_output_4_0_g58 = _WaveFoamScale;
				float mulTime601 = _TimeParameters.x * _WaveFoamAnimationSpeed;
				float time599 = mulTime601;
				float2 voronoiSmoothId599 = 0;
				float2 coords599 = UV_WorldHorizontal491 * _WaveFoamAnimationScale;
				float2 id599 = 0;
				float2 uv599 = 0;
				float voroi599 = voronoi599( coords599, time599, id599, uv599, 0, voronoiSmoothId599 );
				float M_DisplacementWaves915 = saturate( temp_output_149_0 );
				float2 _GlobalFoamSharpness = float2(-0.5,1);
				float temp_output_740_0 = saturate( (0.0 + (( saturate( ( tex2D( _WaveFoamGrunge, ( appendResult2_g58 * temp_output_4_0_g58 ) ).r - saturate( voroi599 ) ) ) * (_GlobalFoamSharpness.x + (M_DisplacementWaves915 - 0.0) * (_GlobalFoamSharpness.y - _GlobalFoamSharpness.x) / (1.0 - 0.0)) ) - 0.0) * (_WaveFoamFactor - 0.0) / (1.0 - 0.0)) );
				float M_BoredrAndWavesFoamMask636 = saturate( ( VAR_T_BorderFoamMask1076 + temp_output_740_0 ) );
				float4 lerpResult572 = lerp( lerpResult480 , _FoamColor , M_BoredrAndWavesFoamMask636);
				float3 surf_pos107_g72 = WorldPosition;
				float3 surf_norm107_g72 = ase_worldNormal;
				float height107_g72 = saturate( M_DisplacementWaves915 );
				float scale107_g72 = ( _DisplacementFactor * 10.0 );
				float3 localPerturbNormal107_g72 = PerturbNormal107_g72( surf_pos107_g72 , surf_norm107_g72 , height107_g72 , scale107_g72 );
				float3x3 ase_worldToTangent = float3x3(ase_worldTangent,ase_worldBitangent,ase_worldNormal);
				float3 worldToTangentDir42_g72 = mul( ase_worldToTangent, localPerturbNormal107_g72);
				float3 N_DisplacementWaves1245 = worldToTangentDir42_g72;
				float F_ScalePrimaryPattern124 = _NormalScalePrimaryPattern;
				float2 temp_cast_5 = (F_ScalePrimaryPattern124).xx;
				float mulTime33 = _TimeParameters.x * ( _WindSpeed * 0.5 );
				float3 AUV_PrimaryWaterPattern50 = ( WorldPosition + ( mulTime33 * V3_WindDirection79 ) );
				float eyeDepth = IN.ase_texcoord5.w;
				float cameraDepthFade87 = (( eyeDepth -_ProjectionParams.y - 0.0 ) / _CameraDistanceMask);
				float clampResult102 = clamp( cameraDepthFade87 , 0.0 , 1.0 );
				float F_DistanceBlendFactor108 = ( _NormalDistanceBlendFactor * ( 1.0 - clampResult102 ) );
				float3 triplanar18 = TriplanarSampling18( _WaterNormal, AUV_PrimaryWaterPattern50, ase_worldNormal, 1.0, temp_cast_5, F_DistanceBlendFactor108, 0 );
				float3 tanTriplanarNormal18 = mul( ase_worldToTangent, triplanar18 );
				float F_ScaleSecondaryPattern127 = _NormalScaleSecondPattern;
				float2 temp_cast_6 = (F_ScaleSecondaryPattern127).xx;
				float3 AUV_SecondWaterPattern53 = ( WorldPosition + ( ( mulTime33 * V3_WindDirection79 ) * _WindSpeedPerturbFactor ) );
				float3 triplanar56 = TriplanarSampling56( _WaterNormal, AUV_SecondWaterPattern53, ase_worldNormal, 1.0, temp_cast_6, F_DistanceBlendFactor108, 0 );
				float3 tanTriplanarNormal56 = mul( ase_worldToTangent, triplanar56 );
				float3 N_DetailPattern163 = BlendNormal( tanTriplanarNormal18 , tanTriplanarNormal56 );
				float3 lerpResult269 = lerp( N_DisplacementWaves1245 , N_DetailPattern163 , _NormalWavesAndDetailBlend);
				float3 surf_pos107_g71 = WorldPosition;
				float3 surf_norm107_g71 = ase_worldNormal;
				float screenDepth2_g61 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g61 = abs( ( screenDepth2_g61 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g61 = ( 1.0 - ( ( distanceDepth2_g61 - ( F_BorderFoamRange1100 * _BorderDistortionFactor ) ) - -1.0 ) );
				float AM_WaterDisturb1230 = saturate( temp_output_698_0 );
				float temp_output_9_0_g61 = ( temp_output_5_0_g61 + ( temp_output_5_0_g61 * AM_WaterDisturb1230 ) );
				float temp_output_13_0_g61 = (1.0 + (0.0 - 0.0) * (1.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g61 = (-temp_output_13_0_g61 + (temp_output_9_0_g61 - 0.0) * (temp_output_13_0_g61 - -temp_output_13_0_g61) / (1.0 - 0.0));
				float smoothstepResult1139 = smoothstep( 0.0 , 1.0 , saturate( temp_output_10_0_g61 ));
				float F_M_BorderDistortion1125 = saturate( smoothstepResult1139 );
				float temp_output_1231_0 = ( saturate( ( F_M_BorderDistortion1125 + (0.0 + (M_RawEffectMask1193 - 0.0) * (_FoamObjectsFactor - 0.0) / (1.0 - 0.0)) ) ) * ( AM_WaterDisturb1230 * M_EffectFoamFactor1236 ) );
				float height107_g71 = temp_output_1231_0;
				float scale107_g71 = _BorderDistortionNormalStrength;
				float3 localPerturbNormal107_g71 = PerturbNormal107_g71( surf_pos107_g71 , surf_norm107_g71 , height107_g71 , scale107_g71 );
				float3 worldToTangentDir42_g71 = mul( ase_worldToTangent, localPerturbNormal107_g71);
				float3 lerpResult1142 = lerp( lerpResult269 , ( worldToTangentDir42_g71 * lerpResult269 ) , saturate( temp_output_1231_0 ));
				float3 surf_pos107_g73 = WorldPosition;
				float3 surf_norm107_g73 = ase_worldNormal;
				float M_WavesFoamMask1062 = temp_output_740_0;
				float height107_g73 = saturate( ( ( _BorderFoamNormalStrength * F_DistanceBlendFactor108 * VAR_T_BorderFoamMask1076 ) + ( _WaveFoamNormalStrength * F_DistanceBlendFactor108 * M_WavesFoamMask1062 ) ) );
				float scale107_g73 = 1.0;
				float3 localPerturbNormal107_g73 = PerturbNormal107_g73( surf_pos107_g73 , surf_norm107_g73 , height107_g73 , scale107_g73 );
				float3 worldToTangentDir42_g73 = mul( ase_worldToTangent, localPerturbNormal107_g73);
				float screenDepth1253 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth1253 = abs( ( screenDepth1253 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( (1.0 + (M_DisplacementWaves915 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) ) );
				float smoothstepResult1293 = smoothstep( 0.0 , 1.0 , ceil( saturate( (1.0 + (distanceDepth1253 - 0.0) * (( 1.0 - _WetDistanceFactor ) - 1.0) / (1.0 - 0.0)) ) ));
				float M_WetSurfaceMask1282 = smoothstepResult1293;
				float3 lerpResult1309 = lerp( BlendNormal( BlendNormal( N_DisplacementWaves1245 , lerpResult1142 ) , worldToTangentDir42_g73 ) , N_DisplacementWaves1245 , M_WetSurfaceMask1282);
				float3 OUT_Normal273 = lerpResult1309;
				float3 temp_output_726_0 = ( float3( (ase_screenPosNorm).xy ,  0.0 ) + ( OUT_Normal273 * _DepthDeformFactor ) );
				float3 UV_DistortionedScreen1001 = temp_output_726_0;
				float eyeDepth992 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( float4( UV_DistortionedScreen1001 , 0.0 ).xy ),_ZBufferParams);
				float M_DephtInverseMask947 = saturate( ( saturate( (0.0 + (eyeDepth992 - 0.0) * ((0.9 + (_DepthDistace - 0.0) * (0.0 - 0.9) / (1.0 - 0.0)) - 0.0) / (1.0 - 0.0)) ) + M_DisplacementWaves915 ) );
				float4 lerpResult958 = lerp( _DepthColor , lerpResult572 , M_DephtInverseMask947);
				float4 RGB_BaseColor1016 = lerpResult958;
				float4 fetchOpaqueVal723 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_726_0.xy ), 1.0 );
				float4 RGB_DepthColor731 = fetchOpaqueVal723;
				float4 lerpResult1017 = lerp( RGB_BaseColor1016 , RGB_DepthColor731 , _ClarityFactor);
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float4 fetchOpaqueVal1241 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ase_grabScreenPosNorm ), 1.0 );
				float3 hsvTorgb1278 = RGBToHSV( fetchOpaqueVal1241.rgb );
				float3 hsvTorgb1279 = HSVToRGB( float3(hsvTorgb1278.x,( hsvTorgb1278.y + _WetSurfaceFactor ),hsvTorgb1278.z) );
				float3 RGB_WetSurface1283 = saturate( hsvTorgb1279 );
				float4 lerpResult1287 = lerp( saturate( ( lerpResult1017 + M_BoredrAndWavesFoamMask636 ) ) , float4( RGB_WetSurface1283 , 0.0 ) , M_WetSurfaceMask1282);
				float4 OUT_BaseColor410 = lerpResult1287;
				
				float time467 = _TimeParameters.x;
				float2 voronoiSmoothId467 = 0;
				float voronoiSmooth467 = 0.0;
				float2 coords467 = UV_WorldHorizontal491 * _CausticScale;
				float2 id467 = 0;
				float2 uv467 = 0;
				float fade467 = 0.5;
				float voroi467 = 0;
				float rest467 = 0;
				for( int it467 = 0; it467 <2; it467++ ){
				voroi467 += fade467 * voronoi467( coords467, time467, id467, uv467, voronoiSmooth467,voronoiSmoothId467 );
				rest467 += fade467;
				coords467 *= 2;
				fade467 *= 0.5;
				}//Voronoi467
				voroi467 /= rest467;
				float4 lerpResult1312 = lerp( ( _CausticColor * saturate( (-0.01 + (( M_DispWavesWithFoam1058 * voroi467 ) - 0.0) * (_CausticEmissiveFactor - -0.01) / (1.0 - 0.0)) ) ) , float4( 0,0,0,0 ) , M_WetSurfaceMask1282);
				float ase_lightAtten = 0;
				Light ase_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float3 tanNormal12_g70 = OUT_Normal273;
				float3 worldNormal12_g70 = float3(dot(tanToWorld0,tanNormal12_g70), dot(tanToWorld1,tanNormal12_g70), dot(tanToWorld2,tanNormal12_g70));
				float3 normalizeResult64_g70 = normalize( worldNormal12_g70 );
				float dotResult14_g70 = dot( normalizeResult64_g70 , _MainLightPosition.xyz );
				float3 bakedGI34_g70 = ASEIndirectDiffuse( IN.lightmapUVOrVertexSH.xy, normalizeResult64_g70);
				MixRealtimeAndBakedGI(ase_mainLight, normalizeResult64_g70, bakedGI34_g70, half4(0,0,0,0));
				float4 temp_output_42_0_g70 = _MainColor;
				float4 OUIT_Emissive510 = ( lerpResult1312 * saturate( (( ( ( ( _MainLightColor * ase_lightAtten ) * max( dotResult14_g70 , 0.0 ) ) + float4( bakedGI34_g70 , 0.0 ) ) * float4( (temp_output_42_0_g70).rgb , 0.0 ) )).r ) );
				

				float3 BaseColor = OUT_BaseColor410.rgb;
				float3 Emission = OUIT_Emissive510.rgb;
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

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007
			#define REQUIRE_DEPTH_TEXTURE 1
			#define REQUIRE_OPAQUE_TEXTURE 1


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

			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
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
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _CausticColor;
			float4 _FoamColor;
			float4 _Color;
			float4 _DepthColor;
			float4 _MainColor;
			float _WindSpeed;
			float _NormalDistanceBlendFactor;
			float _CameraDistanceMask;
			float _NormalScaleSecondPattern;
			float _NormalWavesAndDetailBlend;
			float _BorderDistortionFactor;
			float _FoamObjectsFactor;
			float _BorderDistortionNormalStrength;
			float _WaveFoamNormalStrength;
			float _WetDistanceFactor;
			float _DepthDeformFactor;
			float _DepthDistace;
			float _ClarityFactor;
			float _WetSurfaceFactor;
			float _CausticScale;
			float _CausticEmissiveFactor;
			float _BorderFoamNormalStrength;
			float _NormalScalePrimaryPattern;
			float _WaveFoamAnimationSpeed;
			float _WaveFoamAnimationScale;
			float _HorizontalDirection;
			float _DirectionSpeedFactor;
			float _GravitySpeed;
			float _BigWavePrimaryScale;
			float _WindSpeedPerturbFactor;
			float _BigWaveSecondaryScale;
			float _BorderFoamRange;
			float _WaveFoamFactor;
			float _BorderFoamMinFactor;
			float _BorderFoamDisturbScale;
			float _BorderFoamGrungeScale;
			float _NormalFoamFactor;
			float _BorderFoamSharpness;
			float _FoamHeight;
			float _DisplacementFactor;
			float _WaveFoamScale;
			float _BorderFoamDisturbSpeed;
			float _Smoothness;
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

			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _BorderFoamGrunge;
			sampler2D _ObjectsRipplesTargetTexture;
			sampler2D _WaveFoamGrunge;
			sampler2D _WaterNormal;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

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
			
			float SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD(float2 uv)
			{
				#if defined(REQUIRE_DEPTH_TEXTURE)
				#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
				 	float rawDepth = SAMPLE_TEXTURE2D_ARRAY_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, unity_StereoEyeIndex, 0).r;
				#else
				 	float rawDepth = SAMPLE_DEPTH_TEXTURE_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, 0);
				#endif
				return rawDepth;
				#endif // REQUIRE_DEPTH_TEXTURE
				return 0;
			}
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}
					float2 voronoihash599( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi599( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash599( n + g );
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
						return (F2 + F1) * 0.5;
					}
			
			float3 PerturbNormal107_g72( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			inline float3 TriplanarSampling18( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			inline float3 TriplanarSampling56( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			float3 PerturbNormal107_g71( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			float3 PerturbNormal107_g73( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			inline float4 ASE_ComputeGrabScreenPos( float4 pos )
			{
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				float4 o = pos;
				o.y = pos.w * 0.5f;
				o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
				return o;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult2_g62 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_0 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_0 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_1 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_1 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(ase_worldPos.x , ase_worldPos.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2Dlod( _BorderFoamGrunge, float4( ( appendResult2_g57 * temp_output_4_0_g57 ), 0, 0.0) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2Dlod( _ObjectsRipplesTargetTexture, float4( (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5), 0, 0.0) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				
				o.ase_texcoord2 = screenPos;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord3.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord5.xyz = ase_worldBitangent;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord3.w = eyeDepth;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset275;

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
				float4 ase_tangent : TANGENT;

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

				float3 hsvTorgb475 = RGBToHSV( _Color.rgb );
				float3 hsvTorgb477 = HSVToRGB( float3(hsvTorgb475.x,hsvTorgb475.y,( hsvTorgb475.z + 1.0 )) );
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float2 appendResult2_g62 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_2 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_2 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_3 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_3 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(WorldPosition.x , WorldPosition.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2D( _BorderFoamGrunge, ( appendResult2_g57 * temp_output_4_0_g57 ) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2D( _ObjectsRipplesTargetTexture, (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				float3 ase_worldTangent = IN.ase_texcoord3.xyz;
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord5.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal468 = OUT_VertexOffset275;
				float fresnelNdotV468 = dot( float3(dot(tanToWorld0,tanNormal468), dot(tanToWorld1,tanNormal468), dot(tanToWorld2,tanNormal468)), ase_worldViewDir );
				float fresnelNode468 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV468, 8.0 ) );
				float4 lerpResult480 = lerp( float4( hsvTorgb477 , 0.0 ) , _Color , saturate( fresnelNode468 ));
				float2 appendResult2_g58 = (float2(WorldPosition.x , WorldPosition.z));
				float temp_output_4_0_g58 = _WaveFoamScale;
				float mulTime601 = _TimeParameters.x * _WaveFoamAnimationSpeed;
				float time599 = mulTime601;
				float2 voronoiSmoothId599 = 0;
				float2 coords599 = UV_WorldHorizontal491 * _WaveFoamAnimationScale;
				float2 id599 = 0;
				float2 uv599 = 0;
				float voroi599 = voronoi599( coords599, time599, id599, uv599, 0, voronoiSmoothId599 );
				float M_DisplacementWaves915 = saturate( temp_output_149_0 );
				float2 _GlobalFoamSharpness = float2(-0.5,1);
				float temp_output_740_0 = saturate( (0.0 + (( saturate( ( tex2D( _WaveFoamGrunge, ( appendResult2_g58 * temp_output_4_0_g58 ) ).r - saturate( voroi599 ) ) ) * (_GlobalFoamSharpness.x + (M_DisplacementWaves915 - 0.0) * (_GlobalFoamSharpness.y - _GlobalFoamSharpness.x) / (1.0 - 0.0)) ) - 0.0) * (_WaveFoamFactor - 0.0) / (1.0 - 0.0)) );
				float M_BoredrAndWavesFoamMask636 = saturate( ( VAR_T_BorderFoamMask1076 + temp_output_740_0 ) );
				float4 lerpResult572 = lerp( lerpResult480 , _FoamColor , M_BoredrAndWavesFoamMask636);
				float3 surf_pos107_g72 = WorldPosition;
				float3 surf_norm107_g72 = ase_worldNormal;
				float height107_g72 = saturate( M_DisplacementWaves915 );
				float scale107_g72 = ( _DisplacementFactor * 10.0 );
				float3 localPerturbNormal107_g72 = PerturbNormal107_g72( surf_pos107_g72 , surf_norm107_g72 , height107_g72 , scale107_g72 );
				float3x3 ase_worldToTangent = float3x3(ase_worldTangent,ase_worldBitangent,ase_worldNormal);
				float3 worldToTangentDir42_g72 = mul( ase_worldToTangent, localPerturbNormal107_g72);
				float3 N_DisplacementWaves1245 = worldToTangentDir42_g72;
				float F_ScalePrimaryPattern124 = _NormalScalePrimaryPattern;
				float2 temp_cast_5 = (F_ScalePrimaryPattern124).xx;
				float mulTime33 = _TimeParameters.x * ( _WindSpeed * 0.5 );
				float3 AUV_PrimaryWaterPattern50 = ( WorldPosition + ( mulTime33 * V3_WindDirection79 ) );
				float eyeDepth = IN.ase_texcoord3.w;
				float cameraDepthFade87 = (( eyeDepth -_ProjectionParams.y - 0.0 ) / _CameraDistanceMask);
				float clampResult102 = clamp( cameraDepthFade87 , 0.0 , 1.0 );
				float F_DistanceBlendFactor108 = ( _NormalDistanceBlendFactor * ( 1.0 - clampResult102 ) );
				float3 triplanar18 = TriplanarSampling18( _WaterNormal, AUV_PrimaryWaterPattern50, ase_worldNormal, 1.0, temp_cast_5, F_DistanceBlendFactor108, 0 );
				float3 tanTriplanarNormal18 = mul( ase_worldToTangent, triplanar18 );
				float F_ScaleSecondaryPattern127 = _NormalScaleSecondPattern;
				float2 temp_cast_6 = (F_ScaleSecondaryPattern127).xx;
				float3 AUV_SecondWaterPattern53 = ( WorldPosition + ( ( mulTime33 * V3_WindDirection79 ) * _WindSpeedPerturbFactor ) );
				float3 triplanar56 = TriplanarSampling56( _WaterNormal, AUV_SecondWaterPattern53, ase_worldNormal, 1.0, temp_cast_6, F_DistanceBlendFactor108, 0 );
				float3 tanTriplanarNormal56 = mul( ase_worldToTangent, triplanar56 );
				float3 N_DetailPattern163 = BlendNormal( tanTriplanarNormal18 , tanTriplanarNormal56 );
				float3 lerpResult269 = lerp( N_DisplacementWaves1245 , N_DetailPattern163 , _NormalWavesAndDetailBlend);
				float3 surf_pos107_g71 = WorldPosition;
				float3 surf_norm107_g71 = ase_worldNormal;
				float screenDepth2_g61 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g61 = abs( ( screenDepth2_g61 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g61 = ( 1.0 - ( ( distanceDepth2_g61 - ( F_BorderFoamRange1100 * _BorderDistortionFactor ) ) - -1.0 ) );
				float AM_WaterDisturb1230 = saturate( temp_output_698_0 );
				float temp_output_9_0_g61 = ( temp_output_5_0_g61 + ( temp_output_5_0_g61 * AM_WaterDisturb1230 ) );
				float temp_output_13_0_g61 = (1.0 + (0.0 - 0.0) * (1.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g61 = (-temp_output_13_0_g61 + (temp_output_9_0_g61 - 0.0) * (temp_output_13_0_g61 - -temp_output_13_0_g61) / (1.0 - 0.0));
				float smoothstepResult1139 = smoothstep( 0.0 , 1.0 , saturate( temp_output_10_0_g61 ));
				float F_M_BorderDistortion1125 = saturate( smoothstepResult1139 );
				float temp_output_1231_0 = ( saturate( ( F_M_BorderDistortion1125 + (0.0 + (M_RawEffectMask1193 - 0.0) * (_FoamObjectsFactor - 0.0) / (1.0 - 0.0)) ) ) * ( AM_WaterDisturb1230 * M_EffectFoamFactor1236 ) );
				float height107_g71 = temp_output_1231_0;
				float scale107_g71 = _BorderDistortionNormalStrength;
				float3 localPerturbNormal107_g71 = PerturbNormal107_g71( surf_pos107_g71 , surf_norm107_g71 , height107_g71 , scale107_g71 );
				float3 worldToTangentDir42_g71 = mul( ase_worldToTangent, localPerturbNormal107_g71);
				float3 lerpResult1142 = lerp( lerpResult269 , ( worldToTangentDir42_g71 * lerpResult269 ) , saturate( temp_output_1231_0 ));
				float3 surf_pos107_g73 = WorldPosition;
				float3 surf_norm107_g73 = ase_worldNormal;
				float M_WavesFoamMask1062 = temp_output_740_0;
				float height107_g73 = saturate( ( ( _BorderFoamNormalStrength * F_DistanceBlendFactor108 * VAR_T_BorderFoamMask1076 ) + ( _WaveFoamNormalStrength * F_DistanceBlendFactor108 * M_WavesFoamMask1062 ) ) );
				float scale107_g73 = 1.0;
				float3 localPerturbNormal107_g73 = PerturbNormal107_g73( surf_pos107_g73 , surf_norm107_g73 , height107_g73 , scale107_g73 );
				float3 worldToTangentDir42_g73 = mul( ase_worldToTangent, localPerturbNormal107_g73);
				float screenDepth1253 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth1253 = abs( ( screenDepth1253 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( (1.0 + (M_DisplacementWaves915 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) ) );
				float smoothstepResult1293 = smoothstep( 0.0 , 1.0 , ceil( saturate( (1.0 + (distanceDepth1253 - 0.0) * (( 1.0 - _WetDistanceFactor ) - 1.0) / (1.0 - 0.0)) ) ));
				float M_WetSurfaceMask1282 = smoothstepResult1293;
				float3 lerpResult1309 = lerp( BlendNormal( BlendNormal( N_DisplacementWaves1245 , lerpResult1142 ) , worldToTangentDir42_g73 ) , N_DisplacementWaves1245 , M_WetSurfaceMask1282);
				float3 OUT_Normal273 = lerpResult1309;
				float3 temp_output_726_0 = ( float3( (ase_screenPosNorm).xy ,  0.0 ) + ( OUT_Normal273 * _DepthDeformFactor ) );
				float3 UV_DistortionedScreen1001 = temp_output_726_0;
				float eyeDepth992 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( float4( UV_DistortionedScreen1001 , 0.0 ).xy ),_ZBufferParams);
				float M_DephtInverseMask947 = saturate( ( saturate( (0.0 + (eyeDepth992 - 0.0) * ((0.9 + (_DepthDistace - 0.0) * (0.0 - 0.9) / (1.0 - 0.0)) - 0.0) / (1.0 - 0.0)) ) + M_DisplacementWaves915 ) );
				float4 lerpResult958 = lerp( _DepthColor , lerpResult572 , M_DephtInverseMask947);
				float4 RGB_BaseColor1016 = lerpResult958;
				float4 fetchOpaqueVal723 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_726_0.xy ), 1.0 );
				float4 RGB_DepthColor731 = fetchOpaqueVal723;
				float4 lerpResult1017 = lerp( RGB_BaseColor1016 , RGB_DepthColor731 , _ClarityFactor);
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float4 fetchOpaqueVal1241 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ase_grabScreenPosNorm ), 1.0 );
				float3 hsvTorgb1278 = RGBToHSV( fetchOpaqueVal1241.rgb );
				float3 hsvTorgb1279 = HSVToRGB( float3(hsvTorgb1278.x,( hsvTorgb1278.y + _WetSurfaceFactor ),hsvTorgb1278.z) );
				float3 RGB_WetSurface1283 = saturate( hsvTorgb1279 );
				float4 lerpResult1287 = lerp( saturate( ( lerpResult1017 + M_BoredrAndWavesFoamMask636 ) ) , float4( RGB_WetSurface1283 , 0.0 ) , M_WetSurfaceMask1282);
				float4 OUT_BaseColor410 = lerpResult1287;
				

				float3 BaseColor = OUT_BaseColor410.rgb;
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
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007
			#define REQUIRE_DEPTH_TEXTURE 1


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

			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT
			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				
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
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _CausticColor;
			float4 _FoamColor;
			float4 _Color;
			float4 _DepthColor;
			float4 _MainColor;
			float _WindSpeed;
			float _NormalDistanceBlendFactor;
			float _CameraDistanceMask;
			float _NormalScaleSecondPattern;
			float _NormalWavesAndDetailBlend;
			float _BorderDistortionFactor;
			float _FoamObjectsFactor;
			float _BorderDistortionNormalStrength;
			float _WaveFoamNormalStrength;
			float _WetDistanceFactor;
			float _DepthDeformFactor;
			float _DepthDistace;
			float _ClarityFactor;
			float _WetSurfaceFactor;
			float _CausticScale;
			float _CausticEmissiveFactor;
			float _BorderFoamNormalStrength;
			float _NormalScalePrimaryPattern;
			float _WaveFoamAnimationSpeed;
			float _WaveFoamAnimationScale;
			float _HorizontalDirection;
			float _DirectionSpeedFactor;
			float _GravitySpeed;
			float _BigWavePrimaryScale;
			float _WindSpeedPerturbFactor;
			float _BigWaveSecondaryScale;
			float _BorderFoamRange;
			float _WaveFoamFactor;
			float _BorderFoamMinFactor;
			float _BorderFoamDisturbScale;
			float _BorderFoamGrungeScale;
			float _NormalFoamFactor;
			float _BorderFoamSharpness;
			float _FoamHeight;
			float _DisplacementFactor;
			float _WaveFoamScale;
			float _BorderFoamDisturbSpeed;
			float _Smoothness;
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

			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _BorderFoamGrunge;
			sampler2D _ObjectsRipplesTargetTexture;
			sampler2D _WaterNormal;
			sampler2D _WaveFoamGrunge;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

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
			
			float SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD(float2 uv)
			{
				#if defined(REQUIRE_DEPTH_TEXTURE)
				#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
				 	float rawDepth = SAMPLE_TEXTURE2D_ARRAY_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, unity_StereoEyeIndex, 0).r;
				#else
				 	float rawDepth = SAMPLE_DEPTH_TEXTURE_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, 0);
				#endif
				return rawDepth;
				#endif // REQUIRE_DEPTH_TEXTURE
				return 0;
			}
			
			float3 PerturbNormal107_g72( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			inline float3 TriplanarSampling18( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			inline float3 TriplanarSampling56( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			float3 PerturbNormal107_g71( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
					float2 voronoihash599( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi599( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash599( n + g );
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
						return (F2 + F1) * 0.5;
					}
			
			float3 PerturbNormal107_g73( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult2_g62 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_0 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_0 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_1 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_1 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(ase_worldPos.x , ase_worldPos.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2Dlod( _BorderFoamGrunge, float4( ( appendResult2_g57 * temp_output_4_0_g57 ), 0, 0.0) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2Dlod( _ObjectsRipplesTargetTexture, float4( (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5), 0, 0.0) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord4.xyz = ase_worldBitangent;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord4.w = eyeDepth;
				o.ase_texcoord5 = screenPos;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset275;

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

				float3 surf_pos107_g72 = WorldPosition;
				float3 surf_norm107_g72 = WorldNormal;
				float2 appendResult2_g62 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float M_DisplacementWaves915 = saturate( temp_output_149_0 );
				float height107_g72 = saturate( M_DisplacementWaves915 );
				float scale107_g72 = ( _DisplacementFactor * 10.0 );
				float3 localPerturbNormal107_g72 = PerturbNormal107_g72( surf_pos107_g72 , surf_norm107_g72 , height107_g72 , scale107_g72 );
				float3 ase_worldBitangent = IN.ase_texcoord4.xyz;
				float3x3 ase_worldToTangent = float3x3(WorldTangent.xyz,ase_worldBitangent,WorldNormal);
				float3 worldToTangentDir42_g72 = mul( ase_worldToTangent, localPerturbNormal107_g72);
				float3 N_DisplacementWaves1245 = worldToTangentDir42_g72;
				float F_ScalePrimaryPattern124 = _NormalScalePrimaryPattern;
				float2 temp_cast_0 = (F_ScalePrimaryPattern124).xx;
				float mulTime33 = _TimeParameters.x * ( _WindSpeed * 0.5 );
				float3 AUV_PrimaryWaterPattern50 = ( WorldPosition + ( mulTime33 * V3_WindDirection79 ) );
				float eyeDepth = IN.ase_texcoord4.w;
				float cameraDepthFade87 = (( eyeDepth -_ProjectionParams.y - 0.0 ) / _CameraDistanceMask);
				float clampResult102 = clamp( cameraDepthFade87 , 0.0 , 1.0 );
				float F_DistanceBlendFactor108 = ( _NormalDistanceBlendFactor * ( 1.0 - clampResult102 ) );
				float3 triplanar18 = TriplanarSampling18( _WaterNormal, AUV_PrimaryWaterPattern50, WorldNormal, 1.0, temp_cast_0, F_DistanceBlendFactor108, 0 );
				float3 tanTriplanarNormal18 = mul( ase_worldToTangent, triplanar18 );
				float F_ScaleSecondaryPattern127 = _NormalScaleSecondPattern;
				float2 temp_cast_1 = (F_ScaleSecondaryPattern127).xx;
				float3 AUV_SecondWaterPattern53 = ( WorldPosition + ( ( mulTime33 * V3_WindDirection79 ) * _WindSpeedPerturbFactor ) );
				float3 triplanar56 = TriplanarSampling56( _WaterNormal, AUV_SecondWaterPattern53, WorldNormal, 1.0, temp_cast_1, F_DistanceBlendFactor108, 0 );
				float3 tanTriplanarNormal56 = mul( ase_worldToTangent, triplanar56 );
				float3 N_DetailPattern163 = BlendNormal( tanTriplanarNormal18 , tanTriplanarNormal56 );
				float3 lerpResult269 = lerp( N_DisplacementWaves1245 , N_DetailPattern163 , _NormalWavesAndDetailBlend);
				float3 surf_pos107_g71 = WorldPosition;
				float3 surf_norm107_g71 = WorldNormal;
				float4 screenPos = IN.ase_texcoord5;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g61 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g61 = abs( ( screenDepth2_g61 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g61 = ( 1.0 - ( ( distanceDepth2_g61 - ( F_BorderFoamRange1100 * _BorderDistortionFactor ) ) - -1.0 ) );
				float2 temp_cast_2 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_2 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_3 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_3 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float AM_WaterDisturb1230 = saturate( temp_output_698_0 );
				float temp_output_9_0_g61 = ( temp_output_5_0_g61 + ( temp_output_5_0_g61 * AM_WaterDisturb1230 ) );
				float temp_output_13_0_g61 = (1.0 + (0.0 - 0.0) * (1.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g61 = (-temp_output_13_0_g61 + (temp_output_9_0_g61 - 0.0) * (temp_output_13_0_g61 - -temp_output_13_0_g61) / (1.0 - 0.0));
				float smoothstepResult1139 = smoothstep( 0.0 , 1.0 , saturate( temp_output_10_0_g61 ));
				float F_M_BorderDistortion1125 = saturate( smoothstepResult1139 );
				float2 appendResult2_g64 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2D( _ObjectsRipplesTargetTexture, (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float temp_output_1231_0 = ( saturate( ( F_M_BorderDistortion1125 + (0.0 + (M_RawEffectMask1193 - 0.0) * (_FoamObjectsFactor - 0.0) / (1.0 - 0.0)) ) ) * ( AM_WaterDisturb1230 * M_EffectFoamFactor1236 ) );
				float height107_g71 = temp_output_1231_0;
				float scale107_g71 = _BorderDistortionNormalStrength;
				float3 localPerturbNormal107_g71 = PerturbNormal107_g71( surf_pos107_g71 , surf_norm107_g71 , height107_g71 , scale107_g71 );
				float3 worldToTangentDir42_g71 = mul( ase_worldToTangent, localPerturbNormal107_g71);
				float3 lerpResult1142 = lerp( lerpResult269 , ( worldToTangentDir42_g71 * lerpResult269 ) , saturate( temp_output_1231_0 ));
				float3 surf_pos107_g73 = WorldPosition;
				float3 surf_norm107_g73 = WorldNormal;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 appendResult2_g57 = (float2(WorldPosition.x , WorldPosition.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2D( _BorderFoamGrunge, ( appendResult2_g57 * temp_output_4_0_g57 ) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float2 appendResult2_g58 = (float2(WorldPosition.x , WorldPosition.z));
				float temp_output_4_0_g58 = _WaveFoamScale;
				float mulTime601 = _TimeParameters.x * _WaveFoamAnimationSpeed;
				float time599 = mulTime601;
				float2 voronoiSmoothId599 = 0;
				float2 coords599 = UV_WorldHorizontal491 * _WaveFoamAnimationScale;
				float2 id599 = 0;
				float2 uv599 = 0;
				float voroi599 = voronoi599( coords599, time599, id599, uv599, 0, voronoiSmoothId599 );
				float2 _GlobalFoamSharpness = float2(-0.5,1);
				float temp_output_740_0 = saturate( (0.0 + (( saturate( ( tex2D( _WaveFoamGrunge, ( appendResult2_g58 * temp_output_4_0_g58 ) ).r - saturate( voroi599 ) ) ) * (_GlobalFoamSharpness.x + (M_DisplacementWaves915 - 0.0) * (_GlobalFoamSharpness.y - _GlobalFoamSharpness.x) / (1.0 - 0.0)) ) - 0.0) * (_WaveFoamFactor - 0.0) / (1.0 - 0.0)) );
				float M_WavesFoamMask1062 = temp_output_740_0;
				float height107_g73 = saturate( ( ( _BorderFoamNormalStrength * F_DistanceBlendFactor108 * VAR_T_BorderFoamMask1076 ) + ( _WaveFoamNormalStrength * F_DistanceBlendFactor108 * M_WavesFoamMask1062 ) ) );
				float scale107_g73 = 1.0;
				float3 localPerturbNormal107_g73 = PerturbNormal107_g73( surf_pos107_g73 , surf_norm107_g73 , height107_g73 , scale107_g73 );
				float3 worldToTangentDir42_g73 = mul( ase_worldToTangent, localPerturbNormal107_g73);
				float screenDepth1253 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth1253 = abs( ( screenDepth1253 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( (1.0 + (M_DisplacementWaves915 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) ) );
				float smoothstepResult1293 = smoothstep( 0.0 , 1.0 , ceil( saturate( (1.0 + (distanceDepth1253 - 0.0) * (( 1.0 - _WetDistanceFactor ) - 1.0) / (1.0 - 0.0)) ) ));
				float M_WetSurfaceMask1282 = smoothstepResult1293;
				float3 lerpResult1309 = lerp( BlendNormal( BlendNormal( N_DisplacementWaves1245 , lerpResult1142 ) , worldToTangentDir42_g73 ) , N_DisplacementWaves1245 , M_WetSurfaceMask1282);
				float3 OUT_Normal273 = lerpResult1309;
				

				float3 Normal = OUT_Normal273;
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

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
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
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007
			#define REQUIRE_DEPTH_TEXTURE 1
			#define REQUIRE_OPAQUE_TEXTURE 1


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

			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#define ASE_NEEDS_VERT_TEXTURE_COORDINATES1
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _FORWARD_PLUS


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _CausticColor;
			float4 _FoamColor;
			float4 _Color;
			float4 _DepthColor;
			float4 _MainColor;
			float _WindSpeed;
			float _NormalDistanceBlendFactor;
			float _CameraDistanceMask;
			float _NormalScaleSecondPattern;
			float _NormalWavesAndDetailBlend;
			float _BorderDistortionFactor;
			float _FoamObjectsFactor;
			float _BorderDistortionNormalStrength;
			float _WaveFoamNormalStrength;
			float _WetDistanceFactor;
			float _DepthDeformFactor;
			float _DepthDistace;
			float _ClarityFactor;
			float _WetSurfaceFactor;
			float _CausticScale;
			float _CausticEmissiveFactor;
			float _BorderFoamNormalStrength;
			float _NormalScalePrimaryPattern;
			float _WaveFoamAnimationSpeed;
			float _WaveFoamAnimationScale;
			float _HorizontalDirection;
			float _DirectionSpeedFactor;
			float _GravitySpeed;
			float _BigWavePrimaryScale;
			float _WindSpeedPerturbFactor;
			float _BigWaveSecondaryScale;
			float _BorderFoamRange;
			float _WaveFoamFactor;
			float _BorderFoamMinFactor;
			float _BorderFoamDisturbScale;
			float _BorderFoamGrungeScale;
			float _NormalFoamFactor;
			float _BorderFoamSharpness;
			float _FoamHeight;
			float _DisplacementFactor;
			float _WaveFoamScale;
			float _BorderFoamDisturbSpeed;
			float _Smoothness;
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

			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _BorderFoamGrunge;
			sampler2D _ObjectsRipplesTargetTexture;
			sampler2D _WaveFoamGrunge;
			sampler2D _WaterNormal;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

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
			
			float SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD(float2 uv)
			{
				#if defined(REQUIRE_DEPTH_TEXTURE)
				#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
				 	float rawDepth = SAMPLE_TEXTURE2D_ARRAY_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, unity_StereoEyeIndex, 0).r;
				#else
				 	float rawDepth = SAMPLE_DEPTH_TEXTURE_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, 0);
				#endif
				return rawDepth;
				#endif // REQUIRE_DEPTH_TEXTURE
				return 0;
			}
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}
					float2 voronoihash599( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi599( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash599( n + g );
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
						return (F2 + F1) * 0.5;
					}
			
			float3 PerturbNormal107_g72( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			inline float3 TriplanarSampling18( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			inline float3 TriplanarSampling56( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				xNorm.xyz  = half3( UnpackNormalScale( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
				yNorm.xyz  = half3( UnpackNormalScale( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
				zNorm.xyz  = half3( UnpackNormalScale( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
				return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
			}
			
			float3 PerturbNormal107_g71( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			float3 PerturbNormal107_g73( float3 surf_pos, float3 surf_norm, float height, float scale )
			{
				// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
				float3 vSigmaS = ddx( surf_pos );
				float3 vSigmaT = ddy( surf_pos );
				float3 vN = surf_norm;
				float3 vR1 = cross( vSigmaT , vN );
				float3 vR2 = cross( vN , vSigmaS );
				float fDet = dot( vSigmaS , vR1 );
				float dBs = ddx( height );
				float dBt = ddy( height );
				float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
				return normalize ( abs( fDet ) * vN - vSurfGrad );
			}
			
			inline float4 ASE_ComputeGrabScreenPos( float4 pos )
			{
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				float4 o = pos;
				o.y = pos.w * 0.5f;
				o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
				return o;
			}
			
					float2 voronoihash467( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi467( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
						 		float2 o = voronoihash467( n + g );
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
						return (F2 + F1) * 0.5;
					}
			
			float3 ASEIndirectDiffuse( float2 uvStaticLightmap, float3 normalWS )
			{
			#ifdef LIGHTMAP_ON
				return SampleLightmap( uvStaticLightmap, normalWS );
			#else
				return SampleSH(normalWS);
			#endif
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult2_g62 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_0 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_0 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_1 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_1 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(ase_worldPos.x , ase_worldPos.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2Dlod( _BorderFoamGrunge, float4( ( appendResult2_g57 * temp_output_4_0_g57 ), 0, 0.0) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2Dlod( _ObjectsRipplesTargetTexture, float4( (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5), 0, 0.0) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord8.x = eyeDepth;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.yzw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset275;

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

				float3 hsvTorgb475 = RGBToHSV( _Color.rgb );
				float3 hsvTorgb477 = HSVToRGB( float3(hsvTorgb475.x,hsvTorgb475.y,( hsvTorgb475.z + 1.0 )) );
				float2 appendResult2_g62 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_2 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_2 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_3 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_3 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(WorldPosition.x , WorldPosition.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2D( _BorderFoamGrunge, ( appendResult2_g57 * temp_output_4_0_g57 ) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(WorldPosition.x , WorldPosition.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2D( _ObjectsRipplesTargetTexture, (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 tanNormal468 = OUT_VertexOffset275;
				float fresnelNdotV468 = dot( float3(dot(tanToWorld0,tanNormal468), dot(tanToWorld1,tanNormal468), dot(tanToWorld2,tanNormal468)), WorldViewDirection );
				float fresnelNode468 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV468, 8.0 ) );
				float4 lerpResult480 = lerp( float4( hsvTorgb477 , 0.0 ) , _Color , saturate( fresnelNode468 ));
				float2 appendResult2_g58 = (float2(WorldPosition.x , WorldPosition.z));
				float temp_output_4_0_g58 = _WaveFoamScale;
				float mulTime601 = _TimeParameters.x * _WaveFoamAnimationSpeed;
				float time599 = mulTime601;
				float2 voronoiSmoothId599 = 0;
				float2 coords599 = UV_WorldHorizontal491 * _WaveFoamAnimationScale;
				float2 id599 = 0;
				float2 uv599 = 0;
				float voroi599 = voronoi599( coords599, time599, id599, uv599, 0, voronoiSmoothId599 );
				float M_DisplacementWaves915 = saturate( temp_output_149_0 );
				float2 _GlobalFoamSharpness = float2(-0.5,1);
				float temp_output_740_0 = saturate( (0.0 + (( saturate( ( tex2D( _WaveFoamGrunge, ( appendResult2_g58 * temp_output_4_0_g58 ) ).r - saturate( voroi599 ) ) ) * (_GlobalFoamSharpness.x + (M_DisplacementWaves915 - 0.0) * (_GlobalFoamSharpness.y - _GlobalFoamSharpness.x) / (1.0 - 0.0)) ) - 0.0) * (_WaveFoamFactor - 0.0) / (1.0 - 0.0)) );
				float M_BoredrAndWavesFoamMask636 = saturate( ( VAR_T_BorderFoamMask1076 + temp_output_740_0 ) );
				float4 lerpResult572 = lerp( lerpResult480 , _FoamColor , M_BoredrAndWavesFoamMask636);
				float3 surf_pos107_g72 = WorldPosition;
				float3 surf_norm107_g72 = WorldNormal;
				float height107_g72 = saturate( M_DisplacementWaves915 );
				float scale107_g72 = ( _DisplacementFactor * 10.0 );
				float3 localPerturbNormal107_g72 = PerturbNormal107_g72( surf_pos107_g72 , surf_norm107_g72 , height107_g72 , scale107_g72 );
				float3x3 ase_worldToTangent = float3x3(WorldTangent,WorldBiTangent,WorldNormal);
				float3 worldToTangentDir42_g72 = mul( ase_worldToTangent, localPerturbNormal107_g72);
				float3 N_DisplacementWaves1245 = worldToTangentDir42_g72;
				float F_ScalePrimaryPattern124 = _NormalScalePrimaryPattern;
				float2 temp_cast_5 = (F_ScalePrimaryPattern124).xx;
				float mulTime33 = _TimeParameters.x * ( _WindSpeed * 0.5 );
				float3 AUV_PrimaryWaterPattern50 = ( WorldPosition + ( mulTime33 * V3_WindDirection79 ) );
				float eyeDepth = IN.ase_texcoord8.x;
				float cameraDepthFade87 = (( eyeDepth -_ProjectionParams.y - 0.0 ) / _CameraDistanceMask);
				float clampResult102 = clamp( cameraDepthFade87 , 0.0 , 1.0 );
				float F_DistanceBlendFactor108 = ( _NormalDistanceBlendFactor * ( 1.0 - clampResult102 ) );
				float3 triplanar18 = TriplanarSampling18( _WaterNormal, AUV_PrimaryWaterPattern50, WorldNormal, 1.0, temp_cast_5, F_DistanceBlendFactor108, 0 );
				float3 tanTriplanarNormal18 = mul( ase_worldToTangent, triplanar18 );
				float F_ScaleSecondaryPattern127 = _NormalScaleSecondPattern;
				float2 temp_cast_6 = (F_ScaleSecondaryPattern127).xx;
				float3 AUV_SecondWaterPattern53 = ( WorldPosition + ( ( mulTime33 * V3_WindDirection79 ) * _WindSpeedPerturbFactor ) );
				float3 triplanar56 = TriplanarSampling56( _WaterNormal, AUV_SecondWaterPattern53, WorldNormal, 1.0, temp_cast_6, F_DistanceBlendFactor108, 0 );
				float3 tanTriplanarNormal56 = mul( ase_worldToTangent, triplanar56 );
				float3 N_DetailPattern163 = BlendNormal( tanTriplanarNormal18 , tanTriplanarNormal56 );
				float3 lerpResult269 = lerp( N_DisplacementWaves1245 , N_DetailPattern163 , _NormalWavesAndDetailBlend);
				float3 surf_pos107_g71 = WorldPosition;
				float3 surf_norm107_g71 = WorldNormal;
				float screenDepth2_g61 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g61 = abs( ( screenDepth2_g61 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g61 = ( 1.0 - ( ( distanceDepth2_g61 - ( F_BorderFoamRange1100 * _BorderDistortionFactor ) ) - -1.0 ) );
				float AM_WaterDisturb1230 = saturate( temp_output_698_0 );
				float temp_output_9_0_g61 = ( temp_output_5_0_g61 + ( temp_output_5_0_g61 * AM_WaterDisturb1230 ) );
				float temp_output_13_0_g61 = (1.0 + (0.0 - 0.0) * (1.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g61 = (-temp_output_13_0_g61 + (temp_output_9_0_g61 - 0.0) * (temp_output_13_0_g61 - -temp_output_13_0_g61) / (1.0 - 0.0));
				float smoothstepResult1139 = smoothstep( 0.0 , 1.0 , saturate( temp_output_10_0_g61 ));
				float F_M_BorderDistortion1125 = saturate( smoothstepResult1139 );
				float temp_output_1231_0 = ( saturate( ( F_M_BorderDistortion1125 + (0.0 + (M_RawEffectMask1193 - 0.0) * (_FoamObjectsFactor - 0.0) / (1.0 - 0.0)) ) ) * ( AM_WaterDisturb1230 * M_EffectFoamFactor1236 ) );
				float height107_g71 = temp_output_1231_0;
				float scale107_g71 = _BorderDistortionNormalStrength;
				float3 localPerturbNormal107_g71 = PerturbNormal107_g71( surf_pos107_g71 , surf_norm107_g71 , height107_g71 , scale107_g71 );
				float3 worldToTangentDir42_g71 = mul( ase_worldToTangent, localPerturbNormal107_g71);
				float3 lerpResult1142 = lerp( lerpResult269 , ( worldToTangentDir42_g71 * lerpResult269 ) , saturate( temp_output_1231_0 ));
				float3 surf_pos107_g73 = WorldPosition;
				float3 surf_norm107_g73 = WorldNormal;
				float M_WavesFoamMask1062 = temp_output_740_0;
				float height107_g73 = saturate( ( ( _BorderFoamNormalStrength * F_DistanceBlendFactor108 * VAR_T_BorderFoamMask1076 ) + ( _WaveFoamNormalStrength * F_DistanceBlendFactor108 * M_WavesFoamMask1062 ) ) );
				float scale107_g73 = 1.0;
				float3 localPerturbNormal107_g73 = PerturbNormal107_g73( surf_pos107_g73 , surf_norm107_g73 , height107_g73 , scale107_g73 );
				float3 worldToTangentDir42_g73 = mul( ase_worldToTangent, localPerturbNormal107_g73);
				float screenDepth1253 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth1253 = abs( ( screenDepth1253 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( (1.0 + (M_DisplacementWaves915 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) ) );
				float smoothstepResult1293 = smoothstep( 0.0 , 1.0 , ceil( saturate( (1.0 + (distanceDepth1253 - 0.0) * (( 1.0 - _WetDistanceFactor ) - 1.0) / (1.0 - 0.0)) ) ));
				float M_WetSurfaceMask1282 = smoothstepResult1293;
				float3 lerpResult1309 = lerp( BlendNormal( BlendNormal( N_DisplacementWaves1245 , lerpResult1142 ) , worldToTangentDir42_g73 ) , N_DisplacementWaves1245 , M_WetSurfaceMask1282);
				float3 OUT_Normal273 = lerpResult1309;
				float3 temp_output_726_0 = ( float3( (ase_screenPosNorm).xy ,  0.0 ) + ( OUT_Normal273 * _DepthDeformFactor ) );
				float3 UV_DistortionedScreen1001 = temp_output_726_0;
				float eyeDepth992 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( float4( UV_DistortionedScreen1001 , 0.0 ).xy ),_ZBufferParams);
				float M_DephtInverseMask947 = saturate( ( saturate( (0.0 + (eyeDepth992 - 0.0) * ((0.9 + (_DepthDistace - 0.0) * (0.0 - 0.9) / (1.0 - 0.0)) - 0.0) / (1.0 - 0.0)) ) + M_DisplacementWaves915 ) );
				float4 lerpResult958 = lerp( _DepthColor , lerpResult572 , M_DephtInverseMask947);
				float4 RGB_BaseColor1016 = lerpResult958;
				float4 fetchOpaqueVal723 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_726_0.xy ), 1.0 );
				float4 RGB_DepthColor731 = fetchOpaqueVal723;
				float4 lerpResult1017 = lerp( RGB_BaseColor1016 , RGB_DepthColor731 , _ClarityFactor);
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ScreenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float4 fetchOpaqueVal1241 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( ase_grabScreenPosNorm ), 1.0 );
				float3 hsvTorgb1278 = RGBToHSV( fetchOpaqueVal1241.rgb );
				float3 hsvTorgb1279 = HSVToRGB( float3(hsvTorgb1278.x,( hsvTorgb1278.y + _WetSurfaceFactor ),hsvTorgb1278.z) );
				float3 RGB_WetSurface1283 = saturate( hsvTorgb1279 );
				float4 lerpResult1287 = lerp( saturate( ( lerpResult1017 + M_BoredrAndWavesFoamMask636 ) ) , float4( RGB_WetSurface1283 , 0.0 ) , M_WetSurfaceMask1282);
				float4 OUT_BaseColor410 = lerpResult1287;
				
				float time467 = _TimeParameters.x;
				float2 voronoiSmoothId467 = 0;
				float voronoiSmooth467 = 0.0;
				float2 coords467 = UV_WorldHorizontal491 * _CausticScale;
				float2 id467 = 0;
				float2 uv467 = 0;
				float fade467 = 0.5;
				float voroi467 = 0;
				float rest467 = 0;
				for( int it467 = 0; it467 <2; it467++ ){
				voroi467 += fade467 * voronoi467( coords467, time467, id467, uv467, voronoiSmooth467,voronoiSmoothId467 );
				rest467 += fade467;
				coords467 *= 2;
				fade467 *= 0.5;
				}//Voronoi467
				voroi467 /= rest467;
				float4 lerpResult1312 = lerp( ( _CausticColor * saturate( (-0.01 + (( M_DispWavesWithFoam1058 * voroi467 ) - 0.0) * (_CausticEmissiveFactor - -0.01) / (1.0 - 0.0)) ) ) , float4( 0,0,0,0 ) , M_WetSurfaceMask1282);
				float ase_lightAtten = 0;
				Light ase_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float3 tanNormal12_g70 = OUT_Normal273;
				float3 worldNormal12_g70 = float3(dot(tanToWorld0,tanNormal12_g70), dot(tanToWorld1,tanNormal12_g70), dot(tanToWorld2,tanNormal12_g70));
				float3 normalizeResult64_g70 = normalize( worldNormal12_g70 );
				float dotResult14_g70 = dot( normalizeResult64_g70 , _MainLightPosition.xyz );
				float3 bakedGI34_g70 = ASEIndirectDiffuse( IN.lightmapUVOrVertexSH.xy, normalizeResult64_g70);
				MixRealtimeAndBakedGI(ase_mainLight, normalizeResult64_g70, bakedGI34_g70, half4(0,0,0,0));
				float4 temp_output_42_0_g70 = _MainColor;
				float4 OUIT_Emissive510 = ( lerpResult1312 * saturate( (( ( ( ( _MainLightColor * ase_lightAtten ) * max( dotResult14_g70 , 0.0 ) ) + float4( bakedGI34_g70 , 0.0 ) ) * float4( (temp_output_42_0_g70).rgb , 0.0 ) )).r ) );
				
				float lerpResult1305 = lerp( _Smoothness , 0.5 , M_WetSurfaceMask1282);
				float OUT_Smoothness1306 = lerpResult1305;
				

				float3 BaseColor = OUT_BaseColor410.rgb;
				float3 Normal = OUT_Normal273;
				float3 Emission = OUIT_Emissive510.rgb;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = OUT_Smoothness1306;
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
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007
			#define REQUIRE_DEPTH_TEXTURE 1


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

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _CausticColor;
			float4 _FoamColor;
			float4 _Color;
			float4 _DepthColor;
			float4 _MainColor;
			float _WindSpeed;
			float _NormalDistanceBlendFactor;
			float _CameraDistanceMask;
			float _NormalScaleSecondPattern;
			float _NormalWavesAndDetailBlend;
			float _BorderDistortionFactor;
			float _FoamObjectsFactor;
			float _BorderDistortionNormalStrength;
			float _WaveFoamNormalStrength;
			float _WetDistanceFactor;
			float _DepthDeformFactor;
			float _DepthDistace;
			float _ClarityFactor;
			float _WetSurfaceFactor;
			float _CausticScale;
			float _CausticEmissiveFactor;
			float _BorderFoamNormalStrength;
			float _NormalScalePrimaryPattern;
			float _WaveFoamAnimationSpeed;
			float _WaveFoamAnimationScale;
			float _HorizontalDirection;
			float _DirectionSpeedFactor;
			float _GravitySpeed;
			float _BigWavePrimaryScale;
			float _WindSpeedPerturbFactor;
			float _BigWaveSecondaryScale;
			float _BorderFoamRange;
			float _WaveFoamFactor;
			float _BorderFoamMinFactor;
			float _BorderFoamDisturbScale;
			float _BorderFoamGrungeScale;
			float _NormalFoamFactor;
			float _BorderFoamSharpness;
			float _FoamHeight;
			float _DisplacementFactor;
			float _WaveFoamScale;
			float _BorderFoamDisturbSpeed;
			float _Smoothness;
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

			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _BorderFoamGrunge;
			sampler2D _ObjectsRipplesTargetTexture;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

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
			
			float SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD(float2 uv)
			{
				#if defined(REQUIRE_DEPTH_TEXTURE)
				#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
				 	float rawDepth = SAMPLE_TEXTURE2D_ARRAY_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, unity_StereoEyeIndex, 0).r;
				#else
				 	float rawDepth = SAMPLE_DEPTH_TEXTURE_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, 0);
				#endif
				return rawDepth;
				#endif // REQUIRE_DEPTH_TEXTURE
				return 0;
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

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult2_g62 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_0 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_0 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_1 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_1 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(ase_worldPos.x , ase_worldPos.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2Dlod( _BorderFoamGrunge, float4( ( appendResult2_g57 * temp_output_4_0_g57 ), 0, 0.0) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2Dlod( _ObjectsRipplesTargetTexture, float4( (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5), 0, 0.0) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset275;

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
			#define ASE_TESSELLATION 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define ASE_DISTANCE_TESSELLATION
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 140007
			#define REQUIRE_DEPTH_TEXTURE 1


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

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _CausticColor;
			float4 _FoamColor;
			float4 _Color;
			float4 _DepthColor;
			float4 _MainColor;
			float _WindSpeed;
			float _NormalDistanceBlendFactor;
			float _CameraDistanceMask;
			float _NormalScaleSecondPattern;
			float _NormalWavesAndDetailBlend;
			float _BorderDistortionFactor;
			float _FoamObjectsFactor;
			float _BorderDistortionNormalStrength;
			float _WaveFoamNormalStrength;
			float _WetDistanceFactor;
			float _DepthDeformFactor;
			float _DepthDistace;
			float _ClarityFactor;
			float _WetSurfaceFactor;
			float _CausticScale;
			float _CausticEmissiveFactor;
			float _BorderFoamNormalStrength;
			float _NormalScalePrimaryPattern;
			float _WaveFoamAnimationSpeed;
			float _WaveFoamAnimationScale;
			float _HorizontalDirection;
			float _DirectionSpeedFactor;
			float _GravitySpeed;
			float _BigWavePrimaryScale;
			float _WindSpeedPerturbFactor;
			float _BigWaveSecondaryScale;
			float _BorderFoamRange;
			float _WaveFoamFactor;
			float _BorderFoamMinFactor;
			float _BorderFoamDisturbScale;
			float _BorderFoamGrungeScale;
			float _NormalFoamFactor;
			float _BorderFoamSharpness;
			float _FoamHeight;
			float _DisplacementFactor;
			float _WaveFoamScale;
			float _BorderFoamDisturbSpeed;
			float _Smoothness;
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

			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _BorderFoamGrunge;
			sampler2D _ObjectsRipplesTargetTexture;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

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
			
			float SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD(float2 uv)
			{
				#if defined(REQUIRE_DEPTH_TEXTURE)
				#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
				 	float rawDepth = SAMPLE_TEXTURE2D_ARRAY_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, unity_StereoEyeIndex, 0).r;
				#else
				 	float rawDepth = SAMPLE_DEPTH_TEXTURE_LOD(_CameraDepthTexture, sampler_CameraDepthTexture, uv, 0);
				#endif
				return rawDepth;
				#endif // REQUIRE_DEPTH_TEXTURE
				return 0;
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

				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult2_g62 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g62 = float2( 1,1 );
				float2 temp_output_734_0 = ( appendResult2_g62 * temp_output_4_0_g62 );
				float2 UV_WorldHorizontal491 = temp_output_734_0;
				float mulTime379 = _TimeParameters.x * _WindSpeed;
				float VAR_AngleRotation25_g63 = _HorizontalDirection;
				float2 appendResult12_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g63 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
				float2 appendResult9_g63 = (float2((1.0 + (VAR_AngleRotation25_g63 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g63 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
				float2 appendResult7_g63 = (float2((0.0 + (VAR_AngleRotation25_g63 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g63 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
				float2 appendResult4_g63 = (float2((-1.0 + (VAR_AngleRotation25_g63 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g63 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
				float2 normalizeResult2_g63 = normalize( (( VAR_AngleRotation25_g63 >= 0.0 && VAR_AngleRotation25_g63 <= 90.0 ) ? appendResult12_g63 :  (( VAR_AngleRotation25_g63 >= 90.1 && VAR_AngleRotation25_g63 <= 180.0 ) ? appendResult9_g63 :  (( VAR_AngleRotation25_g63 >= 180.1 && VAR_AngleRotation25_g63 <= 270.0 ) ? appendResult7_g63 :  (( VAR_AngleRotation25_g63 >= 270.1 && VAR_AngleRotation25_g63 <= 360.0 ) ? appendResult4_g63 :  float2( 0,0 ) ) ) ) ) );
				float2 break45 = ( normalizeResult2_g63 * _DirectionSpeedFactor );
				float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
				float3 V3_WindDirection79 = appendResult76;
				float3 break393 = V3_WindDirection79;
				float2 appendResult394 = (float2(break393.x , break393.z));
				float2 AUV_PrimaryBigWaterPatter389 = ( UV_WorldHorizontal491 + ( mulTime379 * appendResult394 ) );
				float simplePerlin2D141 = snoise( AUV_PrimaryBigWaterPatter389*_BigWavePrimaryScale );
				simplePerlin2D141 = simplePerlin2D141*0.5 + 0.5;
				float2 AUV_SecondBigWaterPattern388 = ( temp_output_734_0 + ( ( -mulTime379 * appendResult394 ) * _WindSpeedPerturbFactor ) );
				float simplePerlin2D145 = snoise( AUV_SecondBigWaterPattern388*_BigWaveSecondaryScale );
				simplePerlin2D145 = simplePerlin2D145*0.5 + 0.5;
				float temp_output_149_0 = ( simplePerlin2D141 * simplePerlin2D145 );
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g59 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g59 = abs( ( screenDepth2_g59 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float F_BorderFoamRange1100 = _BorderFoamRange;
				float temp_output_5_0_g59 = ( 1.0 - ( ( distanceDepth2_g59 - ( F_BorderFoamRange1100 * _BorderFoamMinFactor ) ) - -1.0 ) );
				float2 temp_cast_0 = (_BorderFoamDisturbSpeed).xx;
				float2 appendResult2_g56 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g56 = float2( 1,1 );
				float2 temp_output_735_0 = ( appendResult2_g56 * temp_output_4_0_g56 );
				float2 panner692 = ( 1.0 * _Time.y * temp_cast_0 + temp_output_735_0);
				float simplePerlin2D661 = snoise( panner692*_BorderFoamDisturbScale );
				simplePerlin2D661 = simplePerlin2D661*0.5 + 0.5;
				float2 temp_cast_1 = (-_BorderFoamDisturbSpeed).xx;
				float2 panner695 = ( 1.0 * _Time.y * temp_cast_1 + temp_output_735_0);
				float simplePerlin2D694 = snoise( panner695*_BorderFoamDisturbScale );
				simplePerlin2D694 = simplePerlin2D694*0.5 + 0.5;
				float temp_output_698_0 = ( simplePerlin2D661 * simplePerlin2D694 );
				float2 appendResult2_g57 = (float2(ase_worldPos.x , ase_worldPos.z));
				float temp_output_4_0_g57 = _BorderFoamGrungeScale;
				float F_BorderFoamGrunge1105 = ( temp_output_698_0 - tex2Dlod( _BorderFoamGrunge, float4( ( appendResult2_g57 * temp_output_4_0_g57 ), 0, 0.0) ).r );
				float temp_output_9_0_g59 = ( temp_output_5_0_g59 + ( temp_output_5_0_g59 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g59 = (1.0 + (1.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g59 = (-temp_output_13_0_g59 + (temp_output_9_0_g59 - 0.0) * (temp_output_13_0_g59 - -temp_output_13_0_g59) / (1.0 - 0.0));
				float2 appendResult2_g64 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_4_0_g64 = float2( 1,1 );
				float M_RawEffectMask1193 = tex2Dlod( _ObjectsRipplesTargetTexture, float4( (( appendResult2_g64 * temp_output_4_0_g64 )*0.05 + 0.5), 0, 0.0) ).r;
				float M_EffectFoamFactor1236 = _NormalFoamFactor;
				float screenDepth2_g60 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH_LOD( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth2_g60 = abs( ( screenDepth2_g60 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float temp_output_5_0_g60 = ( 1.0 - ( ( distanceDepth2_g60 - F_BorderFoamRange1100 ) - -1.0 ) );
				float temp_output_9_0_g60 = ( temp_output_5_0_g60 + ( temp_output_5_0_g60 * F_BorderFoamGrunge1105 ) );
				float temp_output_13_0_g60 = (1.0 + (_BorderFoamSharpness - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
				float temp_output_10_0_g60 = (-temp_output_13_0_g60 + (temp_output_9_0_g60 - 0.0) * (temp_output_13_0_g60 - -temp_output_13_0_g60) / (1.0 - 0.0));
				float VAR_T_BorderFoamMask1076 = saturate( ( sqrt( saturate( temp_output_10_0_g59 ) ) + ( F_BorderFoamGrunge1105 * saturate( ( M_RawEffectMask1193 * M_EffectFoamFactor1236 ) ) ) + saturate( temp_output_10_0_g60 ) ) );
				float M_DispWavesWithFoam1058 = saturate( ( temp_output_149_0 + ( VAR_T_BorderFoamMask1076 * _FoamHeight ) ) );
				float F_BigWavesPattern1037 = ( M_DispWavesWithFoam1058 * _DisplacementFactor );
				float smoothstepResult1152 = smoothstep( 0.0 , 1.0 , F_BigWavesPattern1037);
				float3 appendResult464 = (float3(0.0 , smoothstepResult1152 , 0.0));
				float3 OUT_VertexOffset275 = appendResult464;
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = OUT_VertexOffset275;

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
	
	CustomEditor "ASEMaterialInspector"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.CommentaryNode;1368;-7680,-2816;Inherit;False;3493.474;2083.202;;4;84;840;177;1027;Variables SetUp;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1367;-736,-2816;Inherit;False;2595.577;2078;;3;531;1023;1294;Base Color And Emissive;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1366;-4096,-4352;Inherit;False;3330.024;3649.16;;6;110;952;638;1192;1304;702;Masks;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;702;-4064,-3872;Inherit;False;3235.691;1507.712;Border Foam Mask;5;1100;680;1042;1043;1044;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1044;-2496,-3808;Inherit;False;1629.937;1405.519;Apply Animated Foam To Border Foam Mask;7;1363;1076;799;837;1088;1091;1365;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1365;-2464,-2784;Inherit;False;1346;352;Comment;8;1125;1113;1139;1086;1111;1364;1103;1124;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1040;-4096,-672;Inherit;False;5377.876;1307.534;;2;165;278;Normal SetUp;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;278;-2784,-608;Inherit;False;4002.961;1214.943;Blend Detailed Normal;9;1310;273;1309;1355;643;265;1028;1036;1356;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1356;-2752,-64;Inherit;False;1708.264;644.9323;Smail Detail Waves Normal;23;1369;1141;1361;1142;269;164;1358;270;1128;1239;1231;1238;1232;1237;1228;1225;1226;1227;1222;1126;1370;1371;1373;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1304;-4065,-1405;Inherit;False;2368.157;353.7247;Wet  Surface Mask;14;1346;1303;1265;1306;1305;256;1282;1293;1292;1266;1264;1253;1353;1352;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1294;-704,-2752;Inherit;False;1228;326;Wet Surface Color;7;1241;1278;1279;1280;1275;1288;1283;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1192;-4064,-4288;Inherit;False;1083.673;290.3472;Effect Mask;4;1193;1154;1190;1175;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1091;-2464,-3168;Inherit;False;898.807;354.1819;Border Animated;4;682;1106;833;1104;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1088;-2464,-3744;Inherit;False;992.1451;557.8857;Min Border Animated;13;1216;1234;1236;1194;1235;1233;1362;1115;836;834;835;1102;1107;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1085;-3232,736;Inherit;False;690;534;;6;276;1307;274;1;511;411;Shader OUT;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;638;-4064,-2304;Inherit;False;2721.231;835.2621;Global Foam Mask;6;1050;1052;1045;1046;1047;1049;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1049;-3008,-2240;Inherit;False;1634;357;Comment;12;636;634;1051;605;708;703;740;635;617;618;613;1062;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1047;-3008,-1856;Inherit;False;543;320;Top Waves Foam;3;615;628;627;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1046;-4032,-2240;Inherit;False;850;280;Gunge For Animated Noise;4;624;733;622;621;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1045;-4032,-1856;Inherit;False;961;349;Animated Noise;6;612;599;614;601;632;600;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1043;-3808,-3328;Inherit;False;1283;257;Grunge For Animated Noise;6;1105;761;719;736;721;717;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1042;-4032,-3808;Inherit;False;1501.926;449.6814;Animated Noise;11;1230;1229;698;664;690;694;697;661;695;692;735;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1039;-736,-4352;Inherit;False;961.0001;196;;4;1152;275;464;1038;Vertex Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1036;-2752,-544;Inherit;False;1094.003;449.7809;Big Waves Normal;10;1245;1037;341;461;398;241;1060;155;178;462;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1028;-1024,-64;Inherit;False;1540;501;Waves Foam;19;642;1066;1067;1068;1064;1063;640;645;646;1065;644;9;8;7;6;5;4;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1027;-7072,-2400;Inherit;False;2849.043;731.9135;Animated UVs Patterns;2;377;111;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1023;-704,-2400;Inherit;False;2512.577;1124.681;Base Color;3;421;732;1022;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1022;480,-1760;Inherit;False;1287.943;379.2346;BaseColor Blend;11;410;1286;1285;1287;1026;1079;1078;1017;1020;1019;1018;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;952;-2816,-4288;Inherit;False;1431.451;367.3477;Depth No Color Mask;10;857;947;946;948;1011;1002;992;896;1008;1005;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;177;-7072,-1632;Inherit;False;1408.713;867.4395;Displacement Pattern;7;1058;846;845;915;914;849;850;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;850;-6768,-1056;Inherit;False;468;264;Border Foam;3;842;843;841;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;849;-7040,-1568;Inherit;False;739.9985;486;Waves Pattern;7;150;149;390;145;141;151;391;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;840;-7648,-2752;Inherit;False;548.7529;732.9399;Texture Objects;6;720;716;620;619;48;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;732;-672,-1760;Inherit;False;1120;453;Depth Color Setup;10;731;1001;723;726;728;954;729;730;727;724;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;531;-704,-1248;Inherit;False;2530.596;481.9362;Caustic Emissive;19;1313;510;1312;529;487;508;467;500;509;498;518;501;488;490;1380;1386;1387;1382;1389;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;421;-672,-2336;Inherit;False;2303.076;547.5235;Opaque Color;22;1016;961;957;958;956;572;637;573;485;474;468;471;532;481;483;533;480;477;478;475;334;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;165;-4064,-608;Inherit;False;1250.572;932.9884;Normal Detail Pattern;15;58;18;56;128;57;55;109;125;51;96;49;124;59;127;163;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;111;-5408,-2336;Inherit;False;1120.065;608.0594;Primary And Secondary Patterns UV;12;50;78;53;82;397;420;83;74;77;19;33;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;110;-4064,-1024;Inherit;False;1405.887;286.9999;Camera Distance Mask;7;108;98;97;107;102;87;90;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;84;-7072,-2752;Inherit;False;1405.513;322.6869;Wind Direction;8;42;40;46;45;43;41;79;76;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;377;-7040,-2336;Inherit;False;1600.079;638.9671;Primary And Secondary Patterns UV;23;418;416;388;389;386;378;491;657;659;660;656;385;384;381;75;394;393;466;379;413;734;414;380;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CameraDepthFade;87;-3744,-960;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;102;-3456,-864;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;107;-3296,-864;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-3072,-928;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-2912,-928;Inherit;False;F_DistanceBlendFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-4032,-352;Inherit;False;48;TEX_WaterNormal;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-4032,-256;Inherit;False;50;AUV_PrimaryWaterPattern;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-4032,-160;Inherit;False;124;F_ScalePrimaryPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-4032,-64;Inherit;False;108;F_DistanceBlendFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-4032,128;Inherit;False;53;AUV_SecondWaterPattern;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-4032,32;Inherit;False;48;TEX_WaterNormal;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-4032,224;Inherit;False;127;F_ScaleSecondaryPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;56;-3680,32;Inherit;True;Spherical;World;True;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;18;-3680,-256;Inherit;True;Spherical;World;True;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;58;-3264,-96;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;6;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormals;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;7;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalGBuffer;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;8;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;9;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-3744,-448;Inherit;False;F_ScaleSecondaryPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-3744,-544;Inherit;False;F_ScalePrimaryPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;-3040,-96;Inherit;False;N_DetailPattern;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;462;-2720,-192;Inherit;False;Constant;_MaxNormalValue;MaxNormalValue;18;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-2720,-384;Inherit;False;915;M_DisplacementWaves;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;411;-3184,784;Inherit;False;410;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-4032,-544;Inherit;False;Property;_NormalScalePrimaryPattern;Normal Scale Primary Pattern;15;0;Create;True;0;0;0;False;0;False;1.2;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-4032,-448;Inherit;False;Property;_NormalScaleSecondPattern;Normal Scale Second Pattern;16;0;Create;True;0;0;0;False;0;False;0.8;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-3456,-960;Inherit;False;Property;_NormalDistanceBlendFactor;Normal Distance Blend Factor;17;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-4032,-960;Inherit;False;Property;_CameraDistanceMask;Camera Distance Mask;19;0;Create;True;0;0;0;False;0;False;11;14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-2720,-288;Inherit;False;Property;_DisplacementFactor;Displacement Factor;47;0;Create;True;0;0;0;False;0;False;0.395;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-2800,912;Float;False;True;-1;2;ASEMaterialInspector;0;12;StylizedWater;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;19;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;41;Workflow;1;0;Surface;1;638153762996622178;  Refraction Model;0;0;  Blend;0;0;Two Sided;0;638192597516883256;Fragment Normal Space,InvertActionOnDeselection;0;0;Forward Only;0;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;0;638192610948229476;  Use Shadow Threshold;0;0;Receive Shadows;1;638192610537823068;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;_FinalColorxAlpha;0;0;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;0;0;Tessellation;1;638153147705293465;  Phong;0;0;  Strength;0.5,False,;0;  Type;1;638209859307384668;  Tess;25,False,;638209859867807658;  Min;5,False,;638158814678151295;  Max;25,False,;638209859921347231;  Edge Length;50,False,;638209856912756403;  Max Displacement;25,False,;0;Write Depth;0;0;  Early Z;0;0;Vertex Position,InvertActionOnDeselection;1;638207533427157763;Debug Display;0;0;Clear Coat;0;0;0;10;False;True;False;True;True;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-3184,880;Inherit;False;273;OUT_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;464;-176,-4288;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;275;-16,-4288;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1152;-448,-4288;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;646;-672,96;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;645;-992,192;Inherit;False;108;F_DistanceBlendFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1063;-672,288;Inherit;False;1062;M_WavesFoamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1064;-320,96;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1068;-512,224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1067;-32,0;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1066;-160,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1065;-672,0;Inherit;False;Property;_WaveFoamNormalStrength;Wave Foam Normal Strength;23;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;644;-992,0;Inherit;False;Property;_BorderFoamNormalStrength;Border Foam Normal Strength;31;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1307;-3184,1072;Inherit;False;1306;OUT_Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1038;-704,-4288;Inherit;False;1037;F_BigWavesPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1060;-2720,-480;Inherit;False;1058;M_DispWavesWithFoam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;640;-992,288;Inherit;False;1076;VAR_T_BorderFoamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;-2400,-480;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;398;-2400,-288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;461;-2400,-208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1037;-2240,-480;Inherit;False;F_BigWavesPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1126;-2720,0;Inherit;False;1125;F_M_BorderDistortion;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1222;-2720,96;Inherit;False;1193;M_RawEffectMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1227;-2720,192;Inherit;False;Property;_FoamObjectsFactor;Foam Objects  Factor;36;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1226;-2464,96;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1225;-2272,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1228;-2144,0;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1237;-2176,288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1232;-2464,288;Inherit;False;1230;AM_WaterDisturb;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1238;-2464,384;Inherit;False;1236;M_EffectFoamFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1231;-1984,128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1239;-1792,80;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;270;-1792,480;Inherit;False;Property;_NormalWavesAndDetailBlend;Normal Waves And Detail Blend;18;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1358;-1792,320;Inherit;False;1245;N_DisplacementWaves;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;-1792,400;Inherit;False;163;N_DetailPattern;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;269;-1504,368;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1245;-1952,-256;Inherit;False;N_DisplacementWaves;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;265;-1056,-256;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;643;448,-256;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1355;544,-64;Inherit;False;1245;N_DisplacementWaves;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;1309;832,-96;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;273;992,-96;Inherit;False;OUT_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1310;544,16;Inherit;False;1282;M_WetSurfaceMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;947;-1632,-4240;Inherit;False;M_DephtInverseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;735;-4000,-3744;Inherit;False;WorldPositionMaskUV;-1;;56;be38d6f93fb89284fac8bbcdf405c130;1,7,0;1;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;692;-3520,-3744;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;695;-3520,-3488;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;661;-3264,-3680;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;697;-3712,-3488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;717;-3232,-3264;Inherit;True;Property;_BorderFoamGrungeRef;Border Foam Grunge Ref;34;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;721;-3520,-3264;Inherit;False;720;TEX_BorderFoamGrunge;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.FunctionNode;736;-3520,-3168;Inherit;False;WorldPositionMaskUV;-1;;57;be38d6f93fb89284fac8bbcdf405c130;1,7,0;1;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;600;-3712,-1792;Inherit;False;491;UV_WorldHorizontal;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;601;-3712,-1696;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;599;-3424,-1728;Inherit;False;0;0;1;3;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SaturateNode;612;-3232,-1728;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;733;-3776,-2080;Inherit;False;WorldPositionMaskUV;-1;;58;be38d6f93fb89284fac8bbcdf405c130;1,7,0;1;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;622;-3776,-2176;Inherit;False;620;TEX_FoamGrunge;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;621;-3520,-2176;Inherit;True;Property;_FoamGlobalGrungeRef;Foam Global Grunge Ref;29;0;Create;True;0;0;0;False;0;False;-1;4d2a803842cc1dd4a8eb0ffff2ea3fca;4d2a803842cc1dd4a8eb0ffff2ea3fca;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;627;-2656,-1792;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;628;-2976,-1696;Inherit;False;Constant;_GlobalFoamSharpness;Global Foam Sharpness;30;0;Create;True;0;0;0;False;0;False;-0.5,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;613;-2976,-2080;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;618;-2816,-2080;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;617;-2656,-2080;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;635;-2400,-2176;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;740;-2208,-2080;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;708;-1952,-2144;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;605;-1824,-2144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1052;-3136,-2016;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1050;-2432,-1888;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1051;-2720,-1920;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;615;-2976,-1792;Inherit;False;915;M_DisplacementWaves;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;636;-1664,-2144;Inherit;False;M_BoredrAndWavesFoamMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;694;-3264,-3520;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1062;-1952,-2016;Inherit;False;M_WavesFoamMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;703;-2208,-2176;Inherit;False;1076;VAR_T_BorderFoamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;624;-4000,-2080;Inherit;False;Property;_WaveFoamScale;Wave Foam Scale;22;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;634;-2656,-1984;Inherit;False;Property;_WaveFoamFactor;Wave Foam Factor;24;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;632;-4000,-1696;Inherit;False;Property;_WaveFoamAnimationSpeed;Wave Foam Animation Speed;26;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;614;-3712,-1600;Inherit;False;Property;_WaveFoamAnimationScale;Wave Foam Animation Scale;25;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;719;-3776,-3168;Inherit;False;Property;_BorderFoamGrungeScale;Border Foam Grunge Scale;28;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;690;-4000,-3520;Inherit;False;Property;_BorderFoamDisturbSpeed;Border Foam Disturb Speed;32;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;664;-3520,-3584;Inherit;False;Property;_BorderFoamDisturbScale;Border Foam Disturb Scale;33;0;Create;True;0;0;0;False;0;False;2;1.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1107;-2432,-3680;Inherit;False;1105;F_BorderFoamGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1102;-2432,-3584;Inherit;False;1100;F_BorderFoamRange;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;835;-2144,-3584;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;834;-1920,-3680;Inherit;False;MeshesContactMask;-1;;59;6b92c3e28ec771d45a621eb97d4dc4d3;1,20,1;4;7;FLOAT;0;False;6;FLOAT;0;False;15;FLOAT;1;False;16;FLOAT;20;False;2;FLOAT;24;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1104;-2432,-3008;Inherit;False;1100;F_BorderFoamRange;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;833;-1920,-3104;Inherit;False;MeshesContactMask;-1;;60;6b92c3e28ec771d45a621eb97d4dc4d3;1,20,1;4;7;FLOAT;0;False;6;FLOAT;0;False;15;FLOAT;0;False;16;FLOAT;20;False;2;FLOAT;24;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;836;-2432,-3488;Inherit;False;Property;_BorderFoamMinFactor;Border Foam Min Factor;30;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1005;-2240,-4208;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;992;-2496,-4208;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;946;-1760,-4208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1011;-2496,-4112;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.9;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1002;-2784,-4224;Inherit;False;1001;UV_DistortionedScreen;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;948;-1920,-4208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1008;-2080,-4208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;857;-2240,-4016;Inherit;False;915;M_DisplacementWaves;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;896;-2784,-4128;Inherit;False;Property;_DepthDistace;Depth Distace;41;0;Create;True;0;0;0;False;0;False;0.9;0.97;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1352;-4033,-1341;Inherit;False;915;M_DisplacementWaves;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1353;-3777,-1341;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;1253;-3553,-1341;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1264;-3297,-1341;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1266;-3105,-1341;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;1292;-2945,-1341;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1293;-2785,-1341;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1282;-2625,-1341;Inherit;False;M_WetSurfaceMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-2369,-1341;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1305;-2081,-1341;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1306;-1921,-1341;Inherit;False;OUT_Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1265;-3777,-1149;Inherit;False;Property;_WetDistanceFactor;Wet Distance Factor;45;0;Create;True;0;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1303;-3553,-1149;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1346;-2401,-1245;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;1115;-1600,-3680;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1106;-2432,-3104;Inherit;False;1105;F_BorderFoamGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1362;-1952,-3456;Inherit;False;1105;F_BorderFoamGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1233;-1952,-3360;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1235;-1824,-3360;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1194;-2208,-3360;Inherit;False;1193;M_RawEffectMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1236;-2208,-3280;Inherit;False;M_EffectFoamFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1234;-2432,-3280;Inherit;False;Property;_NormalFoamFactor;Normal Foam Factor;37;0;Create;True;0;0;0;False;0;False;0;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1216;-1664,-3456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;682;-2432,-2912;Inherit;False;Property;_BorderFoamSharpness;Border Foam Sharpness;34;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1124;-2432,-2528;Inherit;False;Property;_BorderDistortionFactor;Border Distortion Factor;43;0;Create;True;0;0;0;False;0;False;1.2;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1103;-2432,-2624;Inherit;False;1100;F_BorderFoamRange;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1364;-2432,-2720;Inherit;False;1230;AM_WaterDisturb;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1111;-2176,-2592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1086;-2016,-2720;Inherit;False;MeshesContactMask;-1;;61;6b92c3e28ec771d45a621eb97d4dc4d3;1,20,1;4;7;FLOAT;1;False;6;FLOAT;0;False;15;FLOAT;0;False;16;FLOAT;1;False;2;FLOAT;24;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1139;-1664,-2720;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1113;-1504,-2720;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1125;-1360,-2720;Inherit;False;F_M_BorderDistortion;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;698;-3040,-3600;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1229;-2896,-3600;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1230;-2752,-3600;Inherit;False;AM_WaterDisturb;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;761;-2912,-3264;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1105;-2752,-3264;Inherit;False;F_BorderFoamGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;680;-3808,-3040;Inherit;False;Property;_BorderFoamRange;Border Foam Range;29;0;Create;True;0;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1100;-3584,-3040;Inherit;False;F_BorderFoamRange;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;837;-1376,-3472;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;799;-1248,-3472;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1076;-1120,-3472;Inherit;False;VAR_T_BorderFoamMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1363;-1440,-3168;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;475;-384,-2272;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;478;-128,-2160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;477;0,-2272;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;480;320,-2160;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;533;-416,-2128;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;483;-32,-1984;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;481;192,-1984;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;532;224,-1968;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;471;-224,-1968;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;468;-416,-1968;Inherit;False;Standard;TangentNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;474;-640,-1952;Inherit;False;275;OUT_VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;485;-640,-1872;Inherit;False;Constant;_FresnelPower;Fresnel Power;18;0;Create;True;0;0;0;False;0;False;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;572;736,-2160;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;958;1248,-2096;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;957;992,-1968;Inherit;False;947;M_DephtInverseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;961;960,-2048;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1016;1408,-2048;Inherit;False;RGB_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;730;-640,-1504;Inherit;False;273;OUT_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;954;-288,-1408;Inherit;False;F_DepthDeformFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;728;-288,-1504;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;726;-128,-1632;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenColorNode;723;32,-1632;Inherit;False;Global;_GrabScreen0;Grab Screen 0;35;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1001;32,-1408;Inherit;False;UV_DistortionedScreen;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;731;224,-1632;Inherit;False;RGB_DepthColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;490;-672,-1184;Inherit;False;491;UV_WorldHorizontal;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;488;-672,-1088;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;637;512,-1904;Inherit;False;636;M_BoredrAndWavesFoamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;501;-416,-1184;Inherit;False;1058;M_DispWavesWithFoam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;518;96,-960;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.01;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;498;288,-960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;509;448,-1088;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;500;-128,-1056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;467;-416,-1056;Inherit;False;0;0;4.31;3;2;False;1;False;True;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.GetLocalVarNode;1018;512,-1696;Inherit;False;1016;RGB_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;334;-640,-2272;Inherit;False;Property;_Color;Color;3;0;Create;True;0;0;0;False;0;False;0,0.2509804,0.6666667,0;0,0.2501368,0.6669999,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;508;96,-1152;Inherit;False;Property;_CausticColor;Caustic Color;4;0;Create;True;0;0;0;False;0;False;0,1,0.7249274,0;0,1,0.7249274,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;487;-672,-992;Inherit;False;Property;_CausticScale;Caustic Scale;5;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;529;-224,-864;Inherit;False;Property;_CausticEmissiveFactor;Caustic Emissive Factor;6;0;Create;True;0;0;0;False;0;False;1;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;573;320,-2000;Inherit;False;Property;_FoamColor;Foam Color;20;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;956;992,-2256;Inherit;False;Property;_DepthColor;Depth Color;40;0;Create;True;0;0;0;False;0;False;0,0.4117647,0.6666667,1;0,0.4115579,0.6666667,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;729;-640,-1408;Inherit;False;Property;_DepthDeformFactor;Depth Deform Factor;42;0;Create;True;0;0;0;False;0;False;0.091;0.091;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;724;-640,-1696;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;727;-416,-1696;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenColorNode;1241;-672,-2688;Inherit;False;Global;_GrabScreen1;Grab Screen 1;46;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RGBToHSVNode;1278;-480,-2688;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.HSVToRGBNode;1279;-96,-2688;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;1280;-256,-2560;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1275;-480,-2528;Inherit;False;Property;_WetSurfaceFactor;Wet Surface Factor;46;0;Create;True;0;0;0;False;0;False;0.61;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1288;128,-2688;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1283;272,-2688;Inherit;False;RGB_WetSurface;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1019;512,-1600;Inherit;False;731;RGB_DepthColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1020;512,-1504;Inherit;False;Property;_ClarityFactor;Clarity Factor;39;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1017;832,-1696;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1078;1056,-1696;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;1079;1184,-1696;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1026;832,-1504;Inherit;False;636;M_BoredrAndWavesFoamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1287;1408,-1632;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1285;1152,-1568;Inherit;False;1283;RGB_WetSurface;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1286;1152,-1472;Inherit;False;1282;M_WetSurfaceMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;410;1568,-1632;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1312;784,-1088;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1313;448,-960;Inherit;False;1282;M_WetSurfaceMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-6064,-2688;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;380;-6816,-1952;Inherit;False;79;V3_WindDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;414;-6816,-1824;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;734;-6816,-2272;Inherit;False;WorldPositionMaskUV;-1;;62;be38d6f93fb89284fac8bbcdf405c130;1,7,0;1;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;379;-6816,-2112;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;466;-6592,-2048;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;393;-6592,-1952;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;394;-6432,-1952;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;381;-6208,-2016;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;384;-6048,-2016;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;385;-5888,-2048;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;659;-6560,-2144;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;657;-6576,-2160;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;491;-6464,-2272;Inherit;False;UV_WorldHorizontal;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;378;-6208,-2208;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;386;-6048,-2272;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;416;-5520,-1792;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;418;-5504,-1808;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-5376,-2016;Inherit;False;79;V3_WindDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;33;-5376,-2112;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;19;-5120,-2272;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-5120,-2112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-5120,-1984;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;1,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-4960,-1984;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;420;-5024,-1840;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;397;-5008,-1856;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-4736,-1984;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-4800,-2192;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;388;-5728,-2048;Inherit;False;AUV_SecondBigWaterPattern;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;389;-5728,-2272;Inherit;False;AUV_PrimaryBigWaterPatter;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-5920,-2688;Inherit;False;V3_WindDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;620;-7360,-2464;Inherit;False;TEX_FoamGrunge;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;720;-7360,-2240;Inherit;False;TEX_BorderFoamGrunge;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-4576,-2192;Inherit;False;AUV_PrimaryWaterPattern;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-4576,-1984;Inherit;False;AUV_SecondWaterPattern;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-7360,-2688;Inherit;False;TEX_WaterNormal;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.FunctionNode;41;-6752,-2688;Inherit;False;Direction2D;-1;;63;ac70dfc8e86cbbb48941a8d7b266955a;0;1;27;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-6368,-2688;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;45;-6208,-2688;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;656;-5968,-2080;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;660;-5952,-2064;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;413;-7008,-2112;Inherit;False;Property;_WindSpeed;Wind Speed;7;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-6272,-1888;Inherit;False;Property;_WindSpeedPerturbFactor;Wind Speed Perturb Factor;8;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-6400,-2528;Inherit;False;Property;_GravitySpeed;Gravity Speed;9;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-7040,-2688;Inherit;False;Property;_HorizontalDirection;Horizontal Direction;10;0;Create;True;0;0;0;False;0;False;90;90;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-6752,-2528;Inherit;False;Property;_DirectionSpeedFactor;Direction Speed Factor;11;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;11;-7616,-2688;Inherit;True;Property;_WaterNormal;Water Normal;14;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;0f566727d724ace4db32225547aff60b;0f566727d724ace4db32225547aff60b;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;619;-7616,-2464;Inherit;True;Property;_WaveFoamGrunge;Wave Foam Grunge;21;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;4d2a803842cc1dd4a8eb0ffff2ea3fca;4d2a803842cc1dd4a8eb0ffff2ea3fca;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;716;-7616,-2240;Inherit;True;Property;_BorderFoamGrunge;Border Foam Grunge;27;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;40a6f9413b7d0dc4fb50550456d756e6;40a6f9413b7d0dc4fb50550456d756e6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;842;-6448,-976;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;841;-6736,-992;Inherit;False;1076;VAR_T_BorderFoamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;843;-6736,-896;Inherit;False;Property;_FoamHeight;Foam Height;35;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;390;-7008,-1504;Inherit;False;389;AUV_PrimaryBigWaterPatter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-7008,-1408;Inherit;False;Property;_BigWavePrimaryScale;Big Wave Primary Scale;12;0;Create;True;0;0;0;False;0;False;0.15;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;141;-6688,-1504;Inherit;False;Simplex2D;True;True;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;391;-7008,-1280;Inherit;False;388;AUV_SecondBigWaterPattern;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-7008,-1184;Inherit;False;Property;_BigWaveSecondaryScale;Big Wave Secondary Scale;13;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;145;-6688,-1280;Inherit;False;Simplex2D;True;True;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;-6464,-1392;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;914;-6272,-1504;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;915;-6112,-1504;Inherit;False;M_DisplacementWaves;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;845;-6208,-1184;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;846;-6080,-1184;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1058;-5920,-1184;Inherit;False;M_DispWavesWithFoam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1175;-4032,-4224;Inherit;False;WorldPositionMaskUV;-1;;64;be38d6f93fb89284fac8bbcdf405c130;1,7,0;1;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;1190;-3744,-4224;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0.05;False;2;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1193;-3200,-4224;Inherit;False;M_RawEffectMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1141;-2176,416;Inherit;False;Property;_BorderDistortionNormalStrength;Border Distortion Normal Strength;44;0;Create;True;0;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1361;-1088,0;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;1142;-1216,0;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;1371;-1504,288;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;1370;-1344,320;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;1373;-1296,224;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1369;-1440,176;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1154;-3520,-4224;Inherit;True;Property;_ObjectsRipplesTargetTexture;Objects Ripples Target Texture;38;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;e5a153644d8fb094aafd53504da1bb1f;e5a153644d8fb094aafd53504da1bb1f;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1264,-1856;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;511;-3165.998,985.0003;Inherit;False;510;OUIT_Emissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;510;1586,-1083;Inherit;False;OUIT_Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1382;1408,-1088;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1380;784,-960;Inherit;False;Lambert Light;0;;70;9be9b95d80559e74dac059ac0a4060cf;0;2;42;COLOR;0,0,0,0;False;52;FLOAT3;0,0,0;False;2;COLOR;0;FLOAT;57
Node;AmplifyShaderEditor.ComponentMaskNode;1386;1008,-960;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1387;1200,-960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1389;448,-864;Inherit;False;273;OUT_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;1128;-1792,176;Inherit;False;Normal From Height;-1;;71;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;341;-2240,-256;Inherit;False;Normal From Height;-1;;72;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;642;128,0;Inherit;False;Normal From Height;-1;;73;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;276;-3184,1168;Inherit;False;275;OUT_VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
WireConnection;87;0;90;0
WireConnection;102;0;87;0
WireConnection;107;0;102;0
WireConnection;98;0;97;0
WireConnection;98;1;107;0
WireConnection;108;0;98;0
WireConnection;56;0;57;0
WireConnection;56;9;55;0
WireConnection;56;8;109;0
WireConnection;56;3;128;0
WireConnection;18;0;49;0
WireConnection;18;9;51;0
WireConnection;18;8;109;0
WireConnection;18;3;125;0
WireConnection;58;0;18;0
WireConnection;58;1;56;0
WireConnection;127;0;96;0
WireConnection;124;0;59;0
WireConnection;163;0;58;0
WireConnection;1;0;411;0
WireConnection;1;1;274;0
WireConnection;1;2;511;0
WireConnection;1;4;1307;0
WireConnection;1;8;276;0
WireConnection;464;1;1152;0
WireConnection;275;0;464;0
WireConnection;1152;0;1038;0
WireConnection;646;0;644;0
WireConnection;646;1;645;0
WireConnection;646;2;640;0
WireConnection;1064;0;1065;0
WireConnection;1064;1;1068;0
WireConnection;1064;2;1063;0
WireConnection;1068;0;645;0
WireConnection;1067;0;1066;0
WireConnection;1066;0;646;0
WireConnection;1066;1;1064;0
WireConnection;241;0;1060;0
WireConnection;241;1;155;0
WireConnection;398;0;178;0
WireConnection;461;0;155;0
WireConnection;461;1;462;0
WireConnection;1037;0;241;0
WireConnection;1226;0;1222;0
WireConnection;1226;4;1227;0
WireConnection;1225;0;1126;0
WireConnection;1225;1;1226;0
WireConnection;1228;0;1225;0
WireConnection;1237;0;1232;0
WireConnection;1237;1;1238;0
WireConnection;1231;0;1228;0
WireConnection;1231;1;1237;0
WireConnection;1239;0;1231;0
WireConnection;269;0;1358;0
WireConnection;269;1;164;0
WireConnection;269;2;270;0
WireConnection;1245;0;341;40
WireConnection;265;0;1245;0
WireConnection;265;1;1361;0
WireConnection;643;0;265;0
WireConnection;643;1;642;40
WireConnection;1309;0;643;0
WireConnection;1309;1;1355;0
WireConnection;1309;2;1310;0
WireConnection;273;0;1309;0
WireConnection;947;0;946;0
WireConnection;692;0;735;0
WireConnection;692;2;690;0
WireConnection;695;0;735;0
WireConnection;695;2;697;0
WireConnection;661;0;692;0
WireConnection;661;1;664;0
WireConnection;697;0;690;0
WireConnection;717;0;721;0
WireConnection;717;1;736;0
WireConnection;736;4;719;0
WireConnection;601;0;632;0
WireConnection;599;0;600;0
WireConnection;599;1;601;0
WireConnection;599;2;614;0
WireConnection;612;0;599;0
WireConnection;733;4;624;0
WireConnection;621;0;622;0
WireConnection;621;1;733;0
WireConnection;627;0;615;0
WireConnection;627;3;628;1
WireConnection;627;4;628;2
WireConnection;613;0;621;1
WireConnection;613;1;1052;0
WireConnection;618;0;613;0
WireConnection;617;0;618;0
WireConnection;617;1;1051;0
WireConnection;635;0;617;0
WireConnection;635;4;634;0
WireConnection;740;0;635;0
WireConnection;708;0;703;0
WireConnection;708;1;740;0
WireConnection;605;0;708;0
WireConnection;1052;0;612;0
WireConnection;1050;0;627;0
WireConnection;1051;0;1050;0
WireConnection;636;0;605;0
WireConnection;694;0;695;0
WireConnection;694;1;664;0
WireConnection;1062;0;740;0
WireConnection;835;0;1102;0
WireConnection;835;1;836;0
WireConnection;834;7;1107;0
WireConnection;834;6;835;0
WireConnection;833;7;1106;0
WireConnection;833;6;1104;0
WireConnection;833;15;682;0
WireConnection;1005;0;992;0
WireConnection;1005;4;1011;0
WireConnection;992;0;1002;0
WireConnection;946;0;948;0
WireConnection;1011;0;896;0
WireConnection;948;0;1008;0
WireConnection;948;1;857;0
WireConnection;1008;0;1005;0
WireConnection;1353;0;1352;0
WireConnection;1253;0;1353;0
WireConnection;1264;0;1253;0
WireConnection;1264;4;1303;0
WireConnection;1266;0;1264;0
WireConnection;1292;0;1266;0
WireConnection;1293;0;1292;0
WireConnection;1282;0;1293;0
WireConnection;1305;0;256;0
WireConnection;1305;2;1346;0
WireConnection;1306;0;1305;0
WireConnection;1303;0;1265;0
WireConnection;1346;0;1282;0
WireConnection;1115;0;834;0
WireConnection;1233;0;1194;0
WireConnection;1233;1;1236;0
WireConnection;1235;0;1233;0
WireConnection;1236;0;1234;0
WireConnection;1216;0;1362;0
WireConnection;1216;1;1235;0
WireConnection;1111;0;1103;0
WireConnection;1111;1;1124;0
WireConnection;1086;7;1364;0
WireConnection;1086;6;1111;0
WireConnection;1139;0;1086;0
WireConnection;1113;0;1139;0
WireConnection;1125;0;1113;0
WireConnection;698;0;661;0
WireConnection;698;1;694;0
WireConnection;1229;0;698;0
WireConnection;1230;0;1229;0
WireConnection;761;0;698;0
WireConnection;761;1;717;1
WireConnection;1105;0;761;0
WireConnection;1100;0;680;0
WireConnection;837;0;1115;0
WireConnection;837;1;1216;0
WireConnection;837;2;1363;0
WireConnection;799;0;837;0
WireConnection;1076;0;799;0
WireConnection;1363;0;833;0
WireConnection;475;0;334;0
WireConnection;478;0;475;3
WireConnection;477;0;475;1
WireConnection;477;1;475;2
WireConnection;477;2;478;0
WireConnection;480;0;477;0
WireConnection;480;1;481;0
WireConnection;480;2;532;0
WireConnection;533;0;334;0
WireConnection;483;0;533;0
WireConnection;481;0;483;0
WireConnection;532;0;471;0
WireConnection;471;0;468;0
WireConnection;468;0;474;0
WireConnection;468;3;485;0
WireConnection;572;0;480;0
WireConnection;572;1;573;0
WireConnection;572;2;637;0
WireConnection;958;0;956;0
WireConnection;958;1;961;0
WireConnection;958;2;957;0
WireConnection;961;0;572;0
WireConnection;1016;0;958;0
WireConnection;954;0;729;0
WireConnection;728;0;730;0
WireConnection;728;1;729;0
WireConnection;726;0;727;0
WireConnection;726;1;728;0
WireConnection;723;0;726;0
WireConnection;1001;0;726;0
WireConnection;731;0;723;0
WireConnection;518;0;500;0
WireConnection;518;4;529;0
WireConnection;498;0;518;0
WireConnection;509;0;508;0
WireConnection;509;1;498;0
WireConnection;500;0;501;0
WireConnection;500;1;467;0
WireConnection;467;0;490;0
WireConnection;467;1;488;0
WireConnection;467;2;487;0
WireConnection;727;0;724;0
WireConnection;1278;0;1241;0
WireConnection;1279;0;1278;1
WireConnection;1279;1;1280;0
WireConnection;1279;2;1278;3
WireConnection;1280;0;1278;2
WireConnection;1280;1;1275;0
WireConnection;1288;0;1279;0
WireConnection;1283;0;1288;0
WireConnection;1017;0;1018;0
WireConnection;1017;1;1019;0
WireConnection;1017;2;1020;0
WireConnection;1078;0;1017;0
WireConnection;1078;1;1026;0
WireConnection;1079;0;1078;0
WireConnection;1287;0;1079;0
WireConnection;1287;1;1285;0
WireConnection;1287;2;1286;0
WireConnection;410;0;1287;0
WireConnection;1312;0;509;0
WireConnection;1312;2;1313;0
WireConnection;76;0;45;0
WireConnection;76;1;46;0
WireConnection;76;2;45;1
WireConnection;414;0;413;0
WireConnection;379;0;413;0
WireConnection;466;0;379;0
WireConnection;393;0;380;0
WireConnection;394;0;393;0
WireConnection;394;1;393;2
WireConnection;381;0;466;0
WireConnection;381;1;394;0
WireConnection;384;0;381;0
WireConnection;384;1;75;0
WireConnection;385;0;660;0
WireConnection;385;1;384;0
WireConnection;659;0;657;0
WireConnection;657;0;734;0
WireConnection;491;0;734;0
WireConnection;378;0;379;0
WireConnection;378;1;394;0
WireConnection;386;0;491;0
WireConnection;386;1;378;0
WireConnection;416;0;414;0
WireConnection;418;0;416;0
WireConnection;33;0;418;0
WireConnection;77;0;33;0
WireConnection;77;1;80;0
WireConnection;74;0;33;0
WireConnection;74;1;80;0
WireConnection;83;0;74;0
WireConnection;83;1;397;0
WireConnection;420;0;75;0
WireConnection;397;0;420;0
WireConnection;82;0;19;0
WireConnection;82;1;83;0
WireConnection;78;0;19;0
WireConnection;78;1;77;0
WireConnection;388;0;385;0
WireConnection;389;0;386;0
WireConnection;79;0;76;0
WireConnection;620;0;619;0
WireConnection;720;0;716;0
WireConnection;50;0;78;0
WireConnection;53;0;82;0
WireConnection;48;0;11;0
WireConnection;41;27;40;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;45;0;43;0
WireConnection;656;0;659;0
WireConnection;660;0;656;0
WireConnection;842;0;841;0
WireConnection;842;1;843;0
WireConnection;141;0;390;0
WireConnection;141;1;150;0
WireConnection;145;0;391;0
WireConnection;145;1;151;0
WireConnection;149;0;141;0
WireConnection;149;1;145;0
WireConnection;914;0;149;0
WireConnection;915;0;914;0
WireConnection;845;0;149;0
WireConnection;845;1;842;0
WireConnection;846;0;845;0
WireConnection;1058;0;846;0
WireConnection;1190;0;1175;0
WireConnection;1193;0;1154;1
WireConnection;1361;0;1142;0
WireConnection;1142;0;1373;0
WireConnection;1142;1;1369;0
WireConnection;1142;2;1239;0
WireConnection;1371;0;1370;0
WireConnection;1370;0;269;0
WireConnection;1373;0;1370;0
WireConnection;1369;0;1128;40
WireConnection;1369;1;1371;0
WireConnection;1154;1;1190;0
WireConnection;510;0;1382;0
WireConnection;1382;0;1312;0
WireConnection;1382;1;1387;0
WireConnection;1380;52;1389;0
WireConnection;1386;0;1380;0
WireConnection;1387;0;1386;0
WireConnection;1128;20;1231;0
WireConnection;1128;110;1141;0
WireConnection;341;20;398;0
WireConnection;341;110;461;0
WireConnection;642;20;1067;0
ASEEND*/
//CHKSM=CC5294C1B95D3659913C1383B22BE8C68B5D7837