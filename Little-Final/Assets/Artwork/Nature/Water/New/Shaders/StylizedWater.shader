// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NewStylizedWater"
{
	Properties
	{
		[Header(OTHER)][Header((Parameters))]_CameraDistanceMask("Camera Distance Mask", Float) = 11
		_WetDistanceFactor("Wet Distance Factor", Range( 0 , 1)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		[Header(WAVES)][Header((Parameters))]_BigWaveScale("Big Wave Scale", Float) = 0
		_BigWaveDistortionScale("Big Wave Distortion Scale", Float) = 0
		_BigWaveDistortionStrength("Big Wave Distortion Strength", Float) = 0
		_BigWaveSmoothness("Big Wave Smoothness", Range( 0 , 1)) = 0
		[NoScaleOffset][Normal][SingleLineTexture]_WaterDeformMap("Water Deform Map", 2D) = "bump" {}
		[Header((Displacement))]_BigWaveStrength("Big Wave Strength", Range( 0 , 1)) = 0
		[Header(DETAIL)][Header((Parameters))][NoScaleOffset][Normal][SingleLineTexture][Space(10)]_WaterDetailNormal("Water Detail Normal", 2D) = "bump" {}
		_NormalScalePrimaryPattern("Normal Scale Primary Pattern", Float) = 1.2
		_NormalScaleSecondPattern("Normal Scale Second Pattern", Float) = 0.8
		_NormalDistanceBlendFactor("Normal Distance Blend Factor", Float) = 1
		[Header(WIND)][Header((Parameters))]_GravitySpeed("Gravity Speed", Float) = 1
		_DirectionSpeedFactor("Direction Speed Factor", Float) = 0.5
		_WindSpeedPerturbFactor("Wind Speed Perturb Factor", Range( 0 , 1)) = 0.5
		_WindCardinalDirection("Wind Cardinal Direction", Range( 0 , 360)) = 90
		[Header(BASE COLOR)][Space(5)]_WaterColor("Water Color", Color) = (0,0.2509804,0.6666667,0)
		_FoamColor("Foam Color", Color) = (1,1,1,0)
		_DepthColor("Depth Color", Color) = (0,0.4117647,0.6666667,1)
		[Header(LIGHTING)][Space(5)]_LightHighlightStrength("Light Highlight Strength", Float) = 0.1
		_ShadowAreasFactor("Shadow Areas Factor", Range( 0 , 1)) = 0
		[Header(DEPTH)][Space(5)]_DarkDepthDistace("Dark Depth Distace", Float) = 0
		_DepthDistortionFactor("Depth Distortion Factor", Range( 0 , 1)) = 0.091
		_ClarityDepthDistance("Clarity Depth Distance", Float) = 0
		_ClaiityIntensityRange("Claiity Intensity Range", Range( 0 , 1)) = 0
		[Header(CAUSTIC)][Header((Parameters))]_CausticDeformFactor("Caustic Deform Factor", Float) = 0
		_CausticScale("Caustic Scale", Float) = 0
		_CausticOffsetEffect("Caustic Offset Effect", Float) = 0
		_CausticSpeedFix("Caustic Speed Fix", Range( 0 , 1)) = 0.17
		[Header((Color))]_CausticLightFactor("Caustic Light Factor", Float) = 0
		[Header(FOAM)][Header((Parameters))][NoScaleOffset][SingleLineTexture][Space(10)]_FoamAlpha("Foam Alpha", 2D) = "white" {}
		_FoamNoiseTiling("Foam Noise Tiling", Float) = 1
		_FoamSmoothnessFactor("Foam Smoothness Factor", Range( 0 , 1)) = 0
		[Header((Border))]_BorderFoamRange("Border Foam Range", Float) = 0.8
		_BorderFoamDisturbScale("Border Foam Disturb Scale", Float) = 2
		[Header((Wave))]_WaveFoamFrequency("Wave Foam Frequency", Range( 0 , 1)) = 0
		[Header((Base Color))]_WaveFoamFactor("Wave Foam Factor", Range( 0 , 1)) = 0.5
		_BorderFoamFactor("Border Foam Factor", Range( 0 , 1)) = 0.5
		[Header((Displacement))]_BorderFoamHeight("Border Foam Height", Range( 0 , 1)) = 0.15
		_WavesFoamHeight("Waves Foam Height", Range( 0 , 1)) = 0.15
		[Header((Normal))]_WaveFoamNormalStrength("Wave Foam Normal Strength", Range( 0 , 1)) = 0.05
		_BorderFoamNormalStrength("Border Foam Normal Strength", Range( 0 , 1)) = 0.15
		[Header(NORMAL)]_FinalNormalStrength("Final Normal Strength", Float) = 0
		_NormalDetailVsGross("Normal Detail Vs Gross", Range( 0 , 1)) = 0
		[Header(DISPLACEMENT)]_MaxVertexOffset("Max Vertex Offset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.5
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float eyeDepth;
			float4 screenPos;
			float4 screenPosition1253;
			float2 uv_texcoord;
		};

		uniform float _BigWaveScale;
		uniform float _BigWaveSmoothness;
		uniform float _WindCardinalDirection;
		uniform float _DirectionSpeedFactor;
		uniform float _GravitySpeed;
		uniform float _BigWaveDistortionStrength;
		uniform sampler2D _WaterDeformMap;
		uniform float _BigWaveDistortionScale;
		uniform float _WindSpeedPerturbFactor;
		uniform float _BigWaveStrength;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _BorderFoamRange;
		uniform sampler2D _FoamAlpha;
		uniform float _FoamNoiseTiling;
		uniform float _BorderFoamDisturbScale;
		uniform float _BorderFoamHeight;
		uniform float _ShadowAreasFactor;
		uniform float _WaveFoamFrequency;
		uniform float _WavesFoamHeight;
		uniform float _MaxVertexOffset;
		uniform sampler2D _WaterDetailNormal;
		uniform float _NormalScalePrimaryPattern;
		uniform float _NormalDistanceBlendFactor;
		uniform float _CameraDistanceMask;
		uniform float _NormalScaleSecondPattern;
		uniform float _BorderFoamNormalStrength;
		uniform float _WaveFoamNormalStrength;
		uniform float _FinalNormalStrength;
		uniform float _NormalDetailVsGross;
		uniform float _WetDistanceFactor;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _DepthDistortionFactor;
		uniform float _CausticScale;
		uniform float _CausticSpeedFix;
		uniform float _CausticDeformFactor;
		uniform float _CausticOffsetEffect;
		uniform float _CausticLightFactor;
		uniform float4 _DepthColor;
		uniform float4 _WaterColor;
		uniform float _LightHighlightStrength;
		uniform float _DarkDepthDistace;
		uniform float _ClarityDepthDistance;
		uniform float _ClaiityIntensityRange;
		uniform float4 _FoamColor;
		uniform float _WaveFoamFactor;
		uniform float _BorderFoamFactor;
		uniform float WorldClouds_ShadowIntensity;
		uniform sampler2D WorldClouds_Texture;
		uniform float WorldClouds_Speed;
		uniform float WorldClouds_CloudScale;
		uniform float WorldClouds_CloudLevels;
		uniform float _Smoothness;
		uniform float _FoamSmoothnessFactor;


		float2 voronoihash1_g426( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi1_g426( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash1_g426( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 //		if( d<F1 ) {
			 //			F2 = F1;
			 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
			 //		} else if( d<F2 ) {
			 //			F2 = d;
			
			 //		}
			 	}
			}
			return F1;
		}


		float2 voronoihash2_g426( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g426( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash2_g426( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 //		if( d<F1 ) {
			 //			F2 = F1;
			 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
			 //		} else if( d<F2 ) {
			 //			F2 = d;
			
			 //		}
			 	}
			}
			return F1;
		}


		float2 voronoihash2132( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2132( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash2132( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 //		if( d<F1 ) {
			 //			F2 = F1;
			 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
			 //		} else if( d<F2 ) {
			 //			F2 = d;
			
			 //		}
			 	}
			}
			return F1;
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
			xNorm.xyz  = half3( UnpackScaleNormal( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz  = half3( UnpackScaleNormal( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz  = half3( UnpackScaleNormal( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
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
			xNorm.xyz  = half3( UnpackScaleNormal( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz  = half3( UnpackScaleNormal( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz  = half3( UnpackScaleNormal( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
		}


		float3 PerturbNormal107_g320( float3 surf_pos, float3 surf_norm, float height, float scale )
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


		float2 voronoihash1531( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi1531( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash1531( n + g );
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


		float2 voronoihash1568( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi1568( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash1568( n + g );
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float temp_output_12_0_g426 = _BigWaveScale;
			float time1_g426 = 0.0;
			float2 voronoiSmoothId1_g426 = 0;
			float temp_output_89_0_g426 = _BigWaveSmoothness;
			float voronoiSmooth1_g426 = temp_output_89_0_g426;
			float VAR_AngleRotation25_g300 = _WindCardinalDirection;
			float2 appendResult12_g300 = (float2((0.0 + (VAR_AngleRotation25_g300 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g300 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
			float2 appendResult9_g300 = (float2((1.0 + (VAR_AngleRotation25_g300 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g300 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
			float2 appendResult7_g300 = (float2((0.0 + (VAR_AngleRotation25_g300 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g300 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
			float2 appendResult4_g300 = (float2((-1.0 + (VAR_AngleRotation25_g300 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g300 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
			float2 normalizeResult2_g300 = normalize( (( VAR_AngleRotation25_g300 >= 0.0 && VAR_AngleRotation25_g300 <= 90.0 ) ? appendResult12_g300 :  (( VAR_AngleRotation25_g300 >= 90.1 && VAR_AngleRotation25_g300 <= 180.0 ) ? appendResult9_g300 :  (( VAR_AngleRotation25_g300 >= 180.1 && VAR_AngleRotation25_g300 <= 270.0 ) ? appendResult7_g300 :  (( VAR_AngleRotation25_g300 >= 270.1 && VAR_AngleRotation25_g300 <= 360.0 ) ? appendResult4_g300 :  float2( 0,0 ) ) ) ) ) );
			float V_DirectionSpeed1600 = _DirectionSpeedFactor;
			float2 break45 = ( normalizeResult2_g300 * V_DirectionSpeed1600 );
			float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
			float3 V3_WindDirection79 = appendResult76;
			float2 temp_output_53_0_g426 = (V3_WindDirection79).xz;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult2_g319 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_4_0_g319 = float2( 1,1 );
			float2 UV_WorldHorizontal491 = ( appendResult2_g319 * temp_output_4_0_g319 );
			float2 temp_output_44_0_g426 = UV_WorldHorizontal491;
			float2 panner47_g426 = ( 1.0 * _Time.y * temp_output_53_0_g426 + temp_output_44_0_g426);
			float temp_output_69_0_g426 = _BigWaveDistortionStrength;
			float2 _None = float2(0,0);
			float2 ifLocalVar76_g426 = 0;
			if( temp_output_69_0_g426 <= 0.0 )
				ifLocalVar76_g426 = _None;
			else
				ifLocalVar76_g426 = (UnpackScaleNormal( tex2Dlod( _WaterDeformMap, float4( ( temp_output_44_0_g426 * _BigWaveDistortionScale ), 0, 0.0) ), temp_output_69_0_g426 )).xy;
			float2 coords1_g426 = ( panner47_g426 + ifLocalVar76_g426 ) * temp_output_12_0_g426;
			float2 id1_g426 = 0;
			float2 uv1_g426 = 0;
			float voroi1_g426 = voronoi1_g426( coords1_g426, time1_g426, id1_g426, uv1_g426, voronoiSmooth1_g426, voronoiSmoothId1_g426 );
			float F_WindPerturbFactor1678 = _WindSpeedPerturbFactor;
			float temp_output_54_0_g426 = F_WindPerturbFactor1678;
			float time2_g426 = 0.0;
			float2 voronoiSmoothId2_g426 = 0;
			float voronoiSmooth2_g426 = temp_output_89_0_g426;
			float2 panner48_g426 = ( 1.0 * _Time.y * ( -temp_output_53_0_g426 * temp_output_54_0_g426 ) + temp_output_44_0_g426);
			float2 coords2_g426 = ( panner48_g426 + ifLocalVar76_g426 ) * ( temp_output_12_0_g426 * temp_output_54_0_g426 );
			float2 id2_g426 = 0;
			float2 uv2_g426 = 0;
			float voroi2_g426 = voronoi2_g426( coords2_g426, time2_g426, id2_g426, uv2_g426, voronoiSmooth2_g426, voronoiSmoothId2_g426 );
			float temp_output_5_0_g426 = ( (0.0 + (voroi1_g426 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) + (0.0 + (voroi2_g426 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) );
			float M_DisplacementWaves915 = saturate( temp_output_5_0_g426 );
			float temp_output_14_0_g429 = _BigWaveStrength;
			float temp_output_8_0_g429 = (0.0 + (M_DisplacementWaves915 - (1.0 + (temp_output_14_0_g429 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))) * (1.0 - 0.0) / (1.0 - (1.0 + (temp_output_14_0_g429 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))));
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth2_g400 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( ase_screenPosNorm.xy, 0, 0 ) ));
			float distanceDepth2_g400 = abs( ( screenDepth2_g400 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float temp_output_5_0_g400 = ( 1.0 - ( ( distanceDepth2_g400 - _BorderFoamRange ) - -1.0 ) );
			float2 appendResult2_g380 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_4_0_g380 = _FoamNoiseTiling;
			float RAW_BorderFoamGrunge1630 = tex2Dlod( _FoamAlpha, float4( ( appendResult2_g380 * temp_output_4_0_g380 ), 0, 0.0) ).r;
			float3 break2141 = V3_WindDirection79;
			float mulTime2134 = _Time.y * max( break2141.x , break2141.y );
			float time2132 = mulTime2134;
			float2 voronoiSmoothId2132 = 0;
			float voronoiSmooth2132 = 0.2;
			float2 appendResult2_g381 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_4_0_g381 = float2( 1,1 );
			float2 coords2132 = ( appendResult2_g381 * temp_output_4_0_g381 ) * _BorderFoamDisturbScale;
			float2 id2132 = 0;
			float2 uv2132 = 0;
			float fade2132 = 0.5;
			float voroi2132 = 0;
			float rest2132 = 0;
			for( int it2132 = 0; it2132 <3; it2132++ ){
			voroi2132 += fade2132 * voronoi2132( coords2132, time2132, id2132, uv2132, voronoiSmooth2132,voronoiSmoothId2132 );
			rest2132 += fade2132;
			coords2132 *= 2;
			fade2132 *= 0.5;
			}//Voronoi2132
			voroi2132 /= rest2132;
			float AM_WaterDisturb1230 = saturate( (0.1 + (voroi2132 - 0.0) * (1.0 - 0.1) / (0.7 - 0.0)) );
			float temp_output_2159_0 = ( RAW_BorderFoamGrunge1630 * AM_WaterDisturb1230 );
			float temp_output_9_0_g400 = ( temp_output_5_0_g400 + ( temp_output_5_0_g400 * temp_output_2159_0 ) );
			float temp_output_13_0_g400 = (1.0 + (0.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
			float temp_output_10_0_g400 = (-temp_output_13_0_g400 + (temp_output_9_0_g400 - 0.0) * (temp_output_13_0_g400 - -temp_output_13_0_g400) / (1.0 - 0.0));
			float AM_BorderFoamResult1076 = saturate( temp_output_10_0_g400 );
			float temp_output_4_0_g420 = _BorderFoamHeight;
			float temp_output_2_0_g420 = (0.0 + (AM_BorderFoamResult1076 - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_4_0_g420 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float temp_output_14_0_g404 = _ShadowAreasFactor;
			float temp_output_8_0_g404 = (0.0 + (M_DisplacementWaves915 - temp_output_14_0_g404) * (1.0 - 0.0) / (1.0 - temp_output_14_0_g404));
			float temp_output_2154_6 = saturate( temp_output_8_0_g404 );
			float AM_TopWaves2172 = temp_output_2154_6;
			float temp_output_14_0_g418 = _WaveFoamFrequency;
			float temp_output_8_0_g418 = (0.0 + (AM_TopWaves2172 - (1.0 + (temp_output_14_0_g418 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))) * (1.0 - 0.0) / (1.0 - (1.0 + (temp_output_14_0_g418 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))));
			float AM_WavesFoamMask1062 = ( temp_output_2159_0 * saturate( temp_output_8_0_g418 ) );
			float temp_output_4_0_g422 = _WavesFoamHeight;
			float temp_output_2_0_g422 = (0.0 + (AM_WavesFoamMask1062 - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_4_0_g422 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_1446_0 = ( saturate( ( ( saturate( temp_output_8_0_g429 ) + saturate( temp_output_2_0_g420 ) ) + saturate( temp_output_2_0_g422 ) ) ) * ase_vertexNormal );
			float M_VxColorBMask1621 = v.color.b;
			float3 lerpResult1619 = lerp( temp_output_1446_0 , float3( 0,0,0 ) , M_VxColorBMask1621);
			float3 OUT_VertexOffset275 = ( lerpResult1619 * _MaxVertexOffset );
			v.vertex.xyz += OUT_VertexOffset275;
			v.vertex.w = 1;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 break1802 = OUT_VertexOffset275;
			float3 appendResult1800 = (float3(break1802.x , ( break1802.y * 1.5 ) , break1802.z));
			float3 vertexPos1253 = ( ase_vertex3Pos + appendResult1800 );
			float4 ase_screenPos1253 = ComputeScreenPos( UnityObjectToClipPos( vertexPos1253 ) );
			o.screenPosition1253 = ase_screenPos1253;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float F_ScalePrimaryPattern124 = _NormalScalePrimaryPattern;
			float2 temp_cast_0 = (F_ScalePrimaryPattern124).xx;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float mulTime33 = _Time.y * 0.5;
			float VAR_AngleRotation25_g300 = _WindCardinalDirection;
			float2 appendResult12_g300 = (float2((0.0 + (VAR_AngleRotation25_g300 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g300 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
			float2 appendResult9_g300 = (float2((1.0 + (VAR_AngleRotation25_g300 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g300 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
			float2 appendResult7_g300 = (float2((0.0 + (VAR_AngleRotation25_g300 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g300 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
			float2 appendResult4_g300 = (float2((-1.0 + (VAR_AngleRotation25_g300 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g300 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
			float2 normalizeResult2_g300 = normalize( (( VAR_AngleRotation25_g300 >= 0.0 && VAR_AngleRotation25_g300 <= 90.0 ) ? appendResult12_g300 :  (( VAR_AngleRotation25_g300 >= 90.1 && VAR_AngleRotation25_g300 <= 180.0 ) ? appendResult9_g300 :  (( VAR_AngleRotation25_g300 >= 180.1 && VAR_AngleRotation25_g300 <= 270.0 ) ? appendResult7_g300 :  (( VAR_AngleRotation25_g300 >= 270.1 && VAR_AngleRotation25_g300 <= 360.0 ) ? appendResult4_g300 :  float2( 0,0 ) ) ) ) ) );
			float V_DirectionSpeed1600 = _DirectionSpeedFactor;
			float2 break45 = ( normalizeResult2_g300 * V_DirectionSpeed1600 );
			float3 appendResult76 = (float3(break45.x , _GravitySpeed , break45.y));
			float3 V3_WindDirection79 = appendResult76;
			float cameraDepthFade87 = (( i.eyeDepth -_ProjectionParams.y - 0.0 ) / _CameraDistanceMask);
			float F_DistanceBlendFactor108 = ( _NormalDistanceBlendFactor * ( 1.0 - saturate( cameraDepthFade87 ) ) );
			float3 triplanar18 = TriplanarSampling18( _WaterDetailNormal, ( ase_worldPos + ( mulTime33 * V3_WindDirection79 ) ), ase_worldNormal, 1.0, temp_cast_0, F_DistanceBlendFactor108, 0 );
			float3 tanTriplanarNormal18 = mul( ase_worldToTangent, triplanar18 );
			float F_ScaleSecondaryPattern127 = _NormalScaleSecondPattern;
			float2 temp_cast_1 = (F_ScaleSecondaryPattern127).xx;
			float F_WindPerturbFactor1678 = _WindSpeedPerturbFactor;
			float3 triplanar56 = TriplanarSampling56( _WaterDetailNormal, ( ase_worldPos + ( ( mulTime33 * V3_WindDirection79 ) * F_WindPerturbFactor1678 ) ), ase_worldNormal, 1.0, temp_cast_1, F_DistanceBlendFactor108, 0 );
			float3 tanTriplanarNormal56 = mul( ase_worldToTangent, triplanar56 );
			float3 AN_DetailNormalWaves2109 = BlendNormals( tanTriplanarNormal18 , tanTriplanarNormal56 );
			float3 surf_pos107_g320 = ase_worldPos;
			float3 surf_norm107_g320 = ase_worldNormal;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth2_g400 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth2_g400 = abs( ( screenDepth2_g400 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float temp_output_5_0_g400 = ( 1.0 - ( ( distanceDepth2_g400 - _BorderFoamRange ) - -1.0 ) );
			float2 appendResult2_g380 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_4_0_g380 = _FoamNoiseTiling;
			float RAW_BorderFoamGrunge1630 = tex2D( _FoamAlpha, ( appendResult2_g380 * temp_output_4_0_g380 ) ).r;
			float3 break2141 = V3_WindDirection79;
			float mulTime2134 = _Time.y * max( break2141.x , break2141.y );
			float time2132 = mulTime2134;
			float2 voronoiSmoothId2132 = 0;
			float voronoiSmooth2132 = 0.2;
			float2 appendResult2_g381 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_4_0_g381 = float2( 1,1 );
			float2 coords2132 = ( appendResult2_g381 * temp_output_4_0_g381 ) * _BorderFoamDisturbScale;
			float2 id2132 = 0;
			float2 uv2132 = 0;
			float fade2132 = 0.5;
			float voroi2132 = 0;
			float rest2132 = 0;
			for( int it2132 = 0; it2132 <3; it2132++ ){
			voroi2132 += fade2132 * voronoi2132( coords2132, time2132, id2132, uv2132, voronoiSmooth2132,voronoiSmoothId2132 );
			rest2132 += fade2132;
			coords2132 *= 2;
			fade2132 *= 0.5;
			}//Voronoi2132
			voroi2132 /= rest2132;
			float AM_WaterDisturb1230 = saturate( (0.1 + (voroi2132 - 0.0) * (1.0 - 0.1) / (0.7 - 0.0)) );
			float temp_output_2159_0 = ( RAW_BorderFoamGrunge1630 * AM_WaterDisturb1230 );
			float temp_output_9_0_g400 = ( temp_output_5_0_g400 + ( temp_output_5_0_g400 * temp_output_2159_0 ) );
			float temp_output_13_0_g400 = (1.0 + (0.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0));
			float temp_output_10_0_g400 = (-temp_output_13_0_g400 + (temp_output_9_0_g400 - 0.0) * (temp_output_13_0_g400 - -temp_output_13_0_g400) / (1.0 - 0.0));
			float AM_BorderFoamResult1076 = saturate( temp_output_10_0_g400 );
			float temp_output_4_0_g412 = _BorderFoamNormalStrength;
			float temp_output_2_0_g412 = (0.0 + (AM_BorderFoamResult1076 - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_4_0_g412 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float temp_output_12_0_g426 = _BigWaveScale;
			float time1_g426 = 0.0;
			float2 voronoiSmoothId1_g426 = 0;
			float temp_output_89_0_g426 = _BigWaveSmoothness;
			float voronoiSmooth1_g426 = temp_output_89_0_g426;
			float2 temp_output_53_0_g426 = (V3_WindDirection79).xz;
			float2 appendResult2_g319 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_4_0_g319 = float2( 1,1 );
			float2 UV_WorldHorizontal491 = ( appendResult2_g319 * temp_output_4_0_g319 );
			float2 temp_output_44_0_g426 = UV_WorldHorizontal491;
			float2 panner47_g426 = ( 1.0 * _Time.y * temp_output_53_0_g426 + temp_output_44_0_g426);
			float temp_output_69_0_g426 = _BigWaveDistortionStrength;
			float2 _None = float2(0,0);
			float2 ifLocalVar76_g426 = 0;
			if( temp_output_69_0_g426 <= 0.0 )
				ifLocalVar76_g426 = _None;
			else
				ifLocalVar76_g426 = (UnpackScaleNormal( tex2D( _WaterDeformMap, ( temp_output_44_0_g426 * _BigWaveDistortionScale ) ), temp_output_69_0_g426 )).xy;
			float2 coords1_g426 = ( panner47_g426 + ifLocalVar76_g426 ) * temp_output_12_0_g426;
			float2 id1_g426 = 0;
			float2 uv1_g426 = 0;
			float voroi1_g426 = voronoi1_g426( coords1_g426, time1_g426, id1_g426, uv1_g426, voronoiSmooth1_g426, voronoiSmoothId1_g426 );
			float temp_output_54_0_g426 = F_WindPerturbFactor1678;
			float time2_g426 = 0.0;
			float2 voronoiSmoothId2_g426 = 0;
			float voronoiSmooth2_g426 = temp_output_89_0_g426;
			float2 panner48_g426 = ( 1.0 * _Time.y * ( -temp_output_53_0_g426 * temp_output_54_0_g426 ) + temp_output_44_0_g426);
			float2 coords2_g426 = ( panner48_g426 + ifLocalVar76_g426 ) * ( temp_output_12_0_g426 * temp_output_54_0_g426 );
			float2 id2_g426 = 0;
			float2 uv2_g426 = 0;
			float voroi2_g426 = voronoi2_g426( coords2_g426, time2_g426, id2_g426, uv2_g426, voronoiSmooth2_g426, voronoiSmoothId2_g426 );
			float temp_output_5_0_g426 = ( (0.0 + (voroi1_g426 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) + (0.0 + (voroi2_g426 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) );
			float M_DisplacementWaves915 = saturate( temp_output_5_0_g426 );
			float temp_output_14_0_g404 = _ShadowAreasFactor;
			float temp_output_8_0_g404 = (0.0 + (M_DisplacementWaves915 - temp_output_14_0_g404) * (1.0 - 0.0) / (1.0 - temp_output_14_0_g404));
			float temp_output_2154_6 = saturate( temp_output_8_0_g404 );
			float AM_TopWaves2172 = temp_output_2154_6;
			float temp_output_14_0_g418 = _WaveFoamFrequency;
			float temp_output_8_0_g418 = (0.0 + (AM_TopWaves2172 - (1.0 + (temp_output_14_0_g418 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))) * (1.0 - 0.0) / (1.0 - (1.0 + (temp_output_14_0_g418 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))));
			float AM_WavesFoamMask1062 = ( temp_output_2159_0 * saturate( temp_output_8_0_g418 ) );
			float temp_output_4_0_g414 = _WaveFoamNormalStrength;
			float temp_output_2_0_g414 = (0.0 + (AM_WavesFoamMask1062 - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_4_0_g414 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float height107_g320 = saturate( ( saturate( ( ( saturate( temp_output_2_0_g412 ) * F_DistanceBlendFactor108 ) + ( F_DistanceBlendFactor108 * saturate( temp_output_2_0_g414 ) ) ) ) + M_DisplacementWaves915 ) );
			float scale107_g320 = _FinalNormalStrength;
			float3 localPerturbNormal107_g320 = PerturbNormal107_g320( surf_pos107_g320 , surf_norm107_g320 , height107_g320 , scale107_g320 );
			float3 worldToTangentDir42_g320 = mul( ase_worldToTangent, localPerturbNormal107_g320);
			float3 lerpResult1935 = lerp( AN_DetailNormalWaves2109 , worldToTangentDir42_g320 , _NormalDetailVsGross);
			float4 ase_screenPos1253 = i.screenPosition1253;
			float4 ase_screenPosNorm1253 = ase_screenPos1253 / ase_screenPos1253.w;
			ase_screenPosNorm1253.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm1253.z : ase_screenPosNorm1253.z * 0.5 + 0.5;
			float screenDepth1253 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm1253.xy ));
			float distanceDepth1253 = saturate( abs( ( screenDepth1253 - LinearEyeDepth( ase_screenPosNorm1253.z ) ) / ( 1.0 ) ) );
			float temp_output_14_0_g424 = _WetDistanceFactor;
			float temp_output_8_0_g424 = (0.0 + (distanceDepth1253 - temp_output_14_0_g424) * (1.0 - 0.0) / (1.0 - temp_output_14_0_g424));
			float M_WetSurfaceMask1282 = ( 1.0 - ceil( saturate( temp_output_8_0_g424 ) ) );
			float3 lerpResult1937 = lerp( lerpResult1935 , float3( 0,0,0.5 ) , M_WetSurfaceMask1282);
			float3 OUT_Normal273 = lerpResult1937;
			o.Normal = OUT_Normal273;
			float F_DepthDistoritonAmount2112 = _DepthDistortionFactor;
			float3 UV_DistortionedScreen1001 = ( float3( (ase_screenPosNorm).xy ,  0.0 ) + ( AN_DetailNormalWaves2109 * F_DepthDistoritonAmount2112 ) );
			float4 screenColor723 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,UV_DistortionedScreen1001.xy);
			float mulTime1534 = _Time.y * ( V_DirectionSpeed1600 * _CausticSpeedFix );
			float time1531 = mulTime1534;
			float2 voronoiSmoothId1531 = 0;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform1581 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float3 temp_output_1582_0 = (transform1581).xyz;
			float2 lerpResult1538 = lerp( (temp_output_1582_0).xz , (temp_output_1582_0).xy , float2( 0.15,0.15 ));
			float2 lerpResult1545 = lerp( lerpResult1538 , (temp_output_1582_0).yz , float2( 0.15,0.15 ));
			float simplePerlin2D1555 = snoise( i.uv_texcoord*_CausticDeformFactor );
			simplePerlin2D1555 = simplePerlin2D1555*0.5 + 0.5;
			float2 break1573 = ( lerpResult1545 + simplePerlin2D1555 );
			float screenDepth2117 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth2117 = abs( ( screenDepth2117 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float2 appendResult1574 = (float2(break1573.x , ( break1573.y + distanceDepth2117 )));
			float2 coords1531 = appendResult1574 * _CausticScale;
			float2 id1531 = 0;
			float2 uv1531 = 0;
			float voroi1531 = voronoi1531( coords1531, time1531, id1531, uv1531, 0, voronoiSmoothId1531 );
			float time1568 = mulTime1534;
			float2 voronoiSmoothId1568 = 0;
			float2 coords1568 = ( appendResult1574 + _CausticOffsetEffect ) * _CausticScale;
			float2 id1568 = 0;
			float2 uv1568 = 0;
			float voroi1568 = voronoi1568( coords1568, time1568, id1568, uv1568, 0, voronoiSmoothId1568 );
			float temp_output_1579_0 = ( ( voroi1531 + voroi1568 ) * _CausticLightFactor );
			float4 lerpResult1785 = lerp( screenColor723 , ( screenColor723 + ( screenColor723 * temp_output_1579_0 ) ) , temp_output_1579_0);
			float4 RAW_WaterColor1781 = _WaterColor;
			float3 hsvTorgb475 = RGBToHSV( RAW_WaterColor1781.rgb );
			float3 hsvTorgb477 = HSVToRGB( float3(hsvTorgb475.x,hsvTorgb475.y,( hsvTorgb475.z + _LightHighlightStrength )) );
			float3 RAW_IluminatedWaterColor1780 = hsvTorgb477;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float temp_output_14_0_g429 = _BigWaveStrength;
			float temp_output_8_0_g429 = (0.0 + (M_DisplacementWaves915 - (1.0 + (temp_output_14_0_g429 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))) * (1.0 - 0.0) / (1.0 - (1.0 + (temp_output_14_0_g429 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))));
			float temp_output_4_0_g420 = _BorderFoamHeight;
			float temp_output_2_0_g420 = (0.0 + (AM_BorderFoamResult1076 - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_4_0_g420 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float temp_output_4_0_g422 = _WavesFoamHeight;
			float temp_output_2_0_g422 = (0.0 + (AM_WavesFoamMask1062 - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_4_0_g422 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float3 temp_output_1446_0 = ( saturate( ( ( saturate( temp_output_8_0_g429 ) + saturate( temp_output_2_0_g420 ) ) + saturate( temp_output_2_0_g422 ) ) ) * ase_vertexNormal );
			float3 RAW_VertexOffset1474 = temp_output_1446_0;
			float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
			float fresnelNdotV468 = dot( mul(ase_tangentToWorldFast,RAW_VertexOffset1474), ( ase_worldViewDir * ase_worldlightDir ) );
			float fresnelNode468 = ( -5.0 + 5.0 * pow( max( 1.0 - fresnelNdotV468 , 0.0001 ), 5.0 ) );
			float lerpResult2086 = lerp( temp_output_2154_6 , M_DisplacementWaves915 , saturate( fresnelNode468 ));
			float M_HighlightColorMask2065 = lerpResult2086;
			float4 lerpResult480 = lerp( RAW_WaterColor1781 , float4( RAW_IluminatedWaterColor1780 , 0.0 ) , M_HighlightColorMask2065);
			float eyeDepth992 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, float4( UV_DistortionedScreen1001 , 0.0 ).xy ));
			float temp_output_4_0_g372 = _DarkDepthDistace;
			float temp_output_2_0_g372 = (0.0 + (eyeDepth992 - 0.0) * (1.0 - 0.0) / (temp_output_4_0_g372 - 0.0));
			float M_DephtInverseMask947 = saturate( temp_output_2_0_g372 );
			float4 lerpResult958 = lerp( _DepthColor , lerpResult480 , M_DephtInverseMask947);
			float screenDepth1518 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth1518 = abs( ( screenDepth1518 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _ClarityDepthDistance ) );
			float temp_output_14_0_g402 = _ClaiityIntensityRange;
			float temp_output_8_0_g402 = (0.0 + (saturate( distanceDepth1518 ) - temp_output_14_0_g402) * (1.0 - 0.0) / (1.0 - temp_output_14_0_g402));
			float M_ClarityDarkMask1796 = saturate( temp_output_8_0_g402 );
			float4 lerpResult1017 = lerp( saturate( lerpResult1785 ) , lerpResult958 , M_ClarityDarkMask1796);
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor1241 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,ase_grabScreenPos.xy/ase_grabScreenPos.w);
			float4 lerpResult1287 = lerp( lerpResult1017 , saturate( ( screenColor1241 * 0.5 ) ) , M_WetSurfaceMask1282);
			float4 RAW_FoamColor1815 = _FoamColor;
			float temp_output_4_0_g294 = _WaveFoamFactor;
			float temp_output_2_0_g294 = (0.0 + (AM_WavesFoamMask1062 - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_4_0_g294 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float temp_output_4_0_g385 = _BorderFoamFactor;
			float temp_output_2_0_g385 = (0.0 + (AM_BorderFoamResult1076 - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_4_0_g385 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float temp_output_1854_0 = saturate( ( ( saturate( temp_output_2_0_g294 ) + saturate( temp_output_2_0_g385 ) ) - M_WetSurfaceMask1282 ) );
			float4 lerpResult572 = lerp( lerpResult1287 , RAW_FoamColor1815 , temp_output_1854_0);
			float4 RGB_BaseColor49_g408 = lerpResult572;
			float F_Speed11_g408 = WorldClouds_Speed;
			float2 temp_cast_8 = (F_Speed11_g408).xx;
			float2 appendResult2_g409 = (float2(ase_worldPos.x , ase_worldPos.z));
			float F_CloudScale7_g408 = WorldClouds_CloudScale;
			float temp_output_4_0_g409 = F_CloudScale7_g408;
			float2 panner17_g408 = ( 1.0 * _Time.y * temp_cast_8 + ( appendResult2_g409 * temp_output_4_0_g409 ));
			float grayscale14_g408 = Luminance(tex2D( WorldClouds_Texture, panner17_g408 ).rgb);
			float F_TextureBrightness10_g408 = WorldClouds_CloudLevels;
			float simplePerlin2D15_g408 = snoise( panner17_g408 );
			simplePerlin2D15_g408 = simplePerlin2D15_g408*0.5 + 0.5;
			float M_PrimaryCloud40_g408 = saturate( ( (F_TextureBrightness10_g408 + (grayscale14_g408 - 0.0) * (1.0 - F_TextureBrightness10_g408) / (1.0 - 0.0)) - simplePerlin2D15_g408 ) );
			float2 temp_cast_10 = (( F_Speed11_g408 * 0.5 )).xx;
			float2 appendResult2_g410 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_4_0_g410 = F_CloudScale7_g408;
			float2 panner25_g408 = ( 1.0 * _Time.y * temp_cast_10 + ( appendResult2_g410 * temp_output_4_0_g410 ));
			float grayscale29_g408 = Luminance(tex2D( WorldClouds_Texture, panner25_g408 ).rgb);
			float simplePerlin2D33_g408 = snoise( panner25_g408*0.5 );
			simplePerlin2D33_g408 = simplePerlin2D33_g408*0.5 + 0.5;
			float M_SecondaryCloud41_g408 = saturate( (0.0 + (saturate( ( (F_TextureBrightness10_g408 + (grayscale29_g408 - 0.0) * (1.0 - F_TextureBrightness10_g408) / (1.0 - 0.0)) - simplePerlin2D33_g408 ) ) - 0.0) * (0.1 - 0.0) / (1.0 - 0.0)) );
			float4 lerpResult51_g408 = lerp( RGB_BaseColor49_g408 , ( RGB_BaseColor49_g408 * WorldClouds_ShadowIntensity ) , saturate( ( M_PrimaryCloud40_g408 + M_SecondaryCloud41_g408 ) ));
			float4 OUT_BaseColor410 = saturate( lerpResult51_g408 );
			o.Albedo = OUT_BaseColor410.rgb;
			float temp_output_4_0_g297 = _FoamSmoothnessFactor;
			float temp_output_2_0_g297 = (0.0 + (temp_output_1854_0 - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_4_0_g297 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float lerpResult1305 = lerp( _Smoothness , 0.5 , saturate( temp_output_2_0_g297 ));
			float OUT_Smoothness1306 = lerpResult1305;
			o.Smoothness = OUT_Smoothness1306;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.5
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 customPack1 : TEXCOORD1;
				float4 customPack2 : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float4 tSpace0 : TEXCOORD4;
				float4 tSpace1 : TEXCOORD5;
				float4 tSpace2 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.x = customInputData.eyeDepth;
				o.customPack2.xyzw = customInputData.screenPosition1253;
				o.customPack1.yz = customInputData.uv_texcoord;
				o.customPack1.yz = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.eyeDepth = IN.customPack1.x;
				surfIN.screenPosition1253 = IN.customPack2.xyzw;
				surfIN.uv_texcoord = IN.customPack1.yz;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.CommentaryNode;2184;-1760,160;Inherit;False;226.885;172.7296;Foam blended;1;1906;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1899;-3968,-128;Inherit;False;5056.994;1020.648;;11;1064;645;1943;1065;1063;165;1028;1945;1947;2183;2184;Normal Set Up;0,0.473804,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2183;-2624,320;Inherit;False;804;255;Waves Foam;0;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;2179;-2944,1760;Inherit;False;544.0078;251;Waves Foam Height Mask ;2;2177;2176;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;177;-3968,1024;Inherit;False;3264.351;1025.465;;8;849;850;1039;1821;2179;2198;2200;2202;Vertex Offset;1,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1978;-7680,-3584;Inherit;False;3523.022;2332.657;;6;1042;1304;1623;1977;1975;2089;Mask set up;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2089;-5856,-1760;Inherit;False;1663.177;479.7034;Highlights areas mask;12;2154;2065;2086;2067;471;468;2076;2079;2075;2084;474;2173;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;2173;-4480,-1472;Inherit;False;261;161;For foam waves;1;2172;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1975;-7072,-3520;Inherit;False;1601.854;700.1956;Foam mask set up;5;2166;2165;1976;2160;1850;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1850;-6496,-3456;Inherit;False;991.4165;344.7393;Waves foam mask;5;1062;615;2156;1848;617;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;2160;-7040,-3456;Inherit;False;484;253;Animated Foam Noise;3;2159;1829;2158;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1969;-3968,-1536;Inherit;False;7388.522;1214.789;;8;1968;1294;1793;1794;1817;1819;1820;1598;Base Color;0,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1598;-3936,-1472;Inherit;False;3222.448;1123.713;Caustic Base Color;6;1955;1956;1958;1959;1964;2129;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;2129;-2656,-800;Inherit;False;447;160;With this we can add profundity to the caustic UV ;1;2117;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1977;-7648,-2784;Inherit;False;1665.771;988.4246;Depth Mask;2;952;1795;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1795;-7616,-2432;Inherit;False;1602.957;608.0591;Water clarity areas mask;7;2108;1796;1520;1518;1519;2128;2155;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;2128;-7584,-2272;Inherit;False;609;415;With this can deform the mask's borders;5;2105;2114;2106;2110;2209;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1974;-7680,-1152;Inherit;False;3519.756;896.0746;;6;84;110;840;1046;1784;2115;Variables and inputs set up;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2115;-5568,-448;Inherit;False;609;162;Deformation value used in ScrenDepth and DepthFade distortion;2;2112;729;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1976;-6496,-3072;Inherit;False;830.5781;223.1343;Border foam mask;3;1076;1902;680;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1973;-6528,128;Inherit;False;2208.182;1026.197;;2;1027;1692;UVs setup;1,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1964;-1632,-1408;Inherit;False;898;321;Voronoids set up;5;1579;1569;1531;1580;1568;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1959;-2336,-1408;Inherit;False;673;226;Scale and angle voronoid set up;5;1532;1533;1534;1602;1601;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1958;-2656,-1152;Inherit;False;994;321;Apply depth and deformation to the UV;6;1566;1567;1574;1570;1573;1553;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1956;-3904,-1408;Inherit;False;1215;352;Cube UV based in vertex position;8;1545;1538;1546;1540;1536;1582;1581;1535;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1955;-3296,-1024;Inherit;False;609;288;This is the deformation noise for the final UV used in the Caustic Voronoi;3;1556;1555;1557;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1947;-832,160;Inherit;False;1377.434;464.9684;Height To Normal Map And Blend With Notmal Detail;7;1910;1310;1937;1933;1935;273;1930;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1945;-1472,160;Inherit;False;514;224;(Border Distortion) And (Big Waves Normal) Blend;2;1901;2187;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1856;3584,-1184;Inherit;False;1022;353;;5;1306;1305;1953;1954;256;Smoothness;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1821;-2656,1344;Inherit;False;416;194;Final Blend and Factor - Displacement Pattern;2;2180;2181;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1820;2880,-1248;Inherit;False;512;161;Water + Clouds;1;410;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1819;1568,-1248;Inherit;False;1283;537.9001;Water final blend + Foam;10;572;703;1516;1869;1816;1854;1450;1870;634;637;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1817;672,-1248;Inherit;False;867.4653;352.9407;(Water surface color + Water clear deep) + Wet surface;7;1894;1895;1891;1286;1797;1287;1017;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1794;-672,-1120;Inherit;False;1320;481;Dark depth, base color and fresnel;7;956;957;480;1782;1783;958;2066;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1793;-672,-1472;Inherit;False;1312.369;317.7733;Clear and caustic depth;7;1689;1967;1596;1597;723;1595;1785;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1784;-7040,-768;Inherit;False;1442.111;416.5754;Color Variables;9;1617;1815;573;478;1780;477;475;1781;334;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1692;-6496,192;Inherit;False;962.217;390.302;Screen UV Distortion;7;1001;726;728;2113;2111;727;724;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1623;-7648,-3520;Inherit;False;544.2426;640.4995;Verterx Color Masks;4;1618;1624;1626;1628;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1628;-7424,-3264;Inherit;False;259;166;For clarity zones;1;1627;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1626;-7424,-3456;Inherit;False;258;175;For WaterFall Mask;1;1625;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1624;-7424,-3072;Inherit;False;272;158;For no vertex offset mask;1;1621;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1304;-7648,-1760;Inherit;False;1760.118;463.1385;Wet Surface Mask;11;1282;1265;1253;1810;1800;1809;1807;1877;1799;1802;2153;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1294;-288,-608;Inherit;False;930;254;Wet surface color;4;1693;1288;1599;1241;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1085;1408,128;Inherit;False;639;451;;4;276;1307;274;411;Shader OUT;0,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1046;-5568,-768;Inherit;False;1125.231;258.4014;Noise For Animated Foam;5;717;736;719;721;1630;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1042;-5952,-2784;Inherit;False;1788.203;320.8479;Animated noise;11;1230;2136;2137;2135;664;2140;2134;2141;2138;2132;735;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1039;-2208,1344;Inherit;False;1408.019;349.9145;Final Vertex Offset;8;275;1468;1467;1474;1619;1622;1446;1438;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1028;-2624,-64;Inherit;False;802.3834;240.2935;Border Foam;4;644;646;1944;640;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;1027;-5504,192;Inherit;False;1152.102;924.532;Animated UVs Patterns;2;377;111;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;952;-7616,-2720;Inherit;False;1058.451;255.9478;Depth mask (distortioned);5;947;1002;1863;1871;992;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;850;-3648,1760;Inherit;False;540;252;Border Foam Height Mask ;3;2197;841;843;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;849;-3936,1088;Inherit;False;1215.738;643.0497;Waves Pattern Heigth Map Result;11;2049;2021;2019;915;1674;151;380;2048;2060;2199;2201;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;840;-7648,-768;Inherit;False;574.6606;483.423;Texture Variables;4;720;716;48;11;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;165;-3936,-64;Inherit;False;1281.572;930.9884;Normal Detail Pattern;13;58;56;18;128;57;109;125;49;127;96;124;59;2109;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;111;-5472,256;Inherit;False;1094.065;545.0594;Detail Waves Primary And Secondary Patterns UV;9;1679;83;80;77;74;78;82;19;33;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;110;-6240,-1088;Inherit;False;1312.887;287.9999;Camera Distance Factor Variable;7;87;107;1822;98;108;97;90;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;84;-7648,-1088;Inherit;False;1374.513;286.6869;Direction Forces Variables;9;79;45;46;42;1600;40;43;41;76;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;377;-5472,832;Inherit;False;571.7045;263.6762;Big Waves Primary And Secondary Patterns UV;4;1678;75;491;734;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-3904,0;Inherit;False;Property;_NormalScalePrimaryPattern;Normal Scale Primary Pattern;11;0;Create;True;0;0;0;False;0;False;1.2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-3904,96;Inherit;False;Property;_NormalScaleSecondPattern;Normal Scale Second Pattern;12;0;Create;True;0;0;0;False;0;False;0.8;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-3904,384;Inherit;False;124;F_ScalePrimaryPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-3840,480;Inherit;False;108;F_DistanceBlendFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-3904,576;Inherit;False;48;TEX_WaterNormal;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-3904,768;Inherit;False;127;F_ScaleSecondaryPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;56;-3520,576;Inherit;True;Spherical;World;True;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;1438;-2176,1536;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1446;-1888,1408;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;1619;-1440,1408;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1468;-1216,1408;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;275;-1056,1408;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-3584,96;Inherit;False;F_ScaleSecondaryPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-3584,0;Inherit;False;F_ScalePrimaryPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;273;240,336;Inherit;False;OUT_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;1935;-224,336;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;1937;64,336;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0.5;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1557;-3264,-960;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;1535;-3872,-1344;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;1581;-3680,-1344;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;1582;-3456,-1248;Inherit;False;True;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;1536;-3232,-1344;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;1540;-3232,-1248;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;1546;-3232,-1152;Inherit;False;False;True;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1538;-3008,-1296;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0.15,0.15;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1545;-2848,-1216;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0.15,0.15;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1555;-3008,-960;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1553;-2624,-1104;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1573;-2320,-1104;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;1570;-2176,-1040;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1574;-2048,-1104;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1566;-1792,-1056;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1601;-2304,-1344;Inherit;False;1600;V_DirectionSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1602;-2016,-1344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.17;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1534;-1856,-1344;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1533;-1856,-1264;Inherit;False;Property;_CausticScale;Caustic Scale;28;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1568;-1504,-1216;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleAddOpNode;1569;-1312,-1280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1531;-1504,-1344;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.ScreenColorNode;1241;-256,-544;Inherit;False;Global;_GrabScreen1;Grab Screen 1;46;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;957;192,-832;Inherit;False;947;M_DephtInverseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1782;-416,-992;Inherit;False;1781;RAW_WaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;958;448,-928;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1785;256,-1408;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;1595;416,-1408;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;410;3168,-1184;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1870;1888,-1120;Inherit;False;OverrideMaxValue;-1;;294;a223fd650b6f3ed49990d9e847af2115;2,7,1,8,1;2;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1599;96,-544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;1288;256,-544;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1017;1024,-1184;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1287;1376,-1184;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1891;1072,-1024;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1895;672,-1072;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1894;672,-1200;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;723;-352,-1408;Inherit;False;Global;_GrabScreen0;Grab Screen 0;35;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1597;-128,-1280;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1596;32,-1344;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1967;160,-1200;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;1968;816,-656;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1450;2144,-1040;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1854;2304,-992;Inherit;False;SaturateSubtract;-1;;296;7fec0e09a134197478345092e0bdc7a3;0;2;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1816;2304,-1088;Inherit;False;1815;RAW_FoamColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1954;3616,-928;Inherit;False;Property;_FoamSmoothnessFactor;Foam Smoothness Factor;34;0;Create;True;0;0;0;False;0;False;0;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1953;3936,-992;Inherit;False;OverrideMaxValue;-1;;297;a223fd650b6f3ed49990d9e847af2115;2,7,1,8,1;2;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1306;4352,-1120;Inherit;False;OUT_Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;18;-3520,288;Inherit;True;Spherical;World;True;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;33;-5440,480;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;19;-5440,320;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-4832,320;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-5184,608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;1,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-5184,480;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-5440,608;Inherit;False;79;V3_WindDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-5024,672;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1679;-5440,704;Inherit;False;1678;F_WindPerturbFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;724;-6464,256;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;727;-6176,256;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-4832,608;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-6640,-1024;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;41;-7328,-1024;Inherit;False;Direction2D;-1;;300;ac70dfc8e86cbbb48941a8d7b266955a;0;1;27;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-6944,-1024;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1600;-7328,-928;Inherit;False;V_DirectionSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;45;-6816,-1024;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-6496,-1024;Inherit;False;V3_WindDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-5696,-1024;Inherit;False;Property;_NormalDistanceBlendFactor;Normal Distance Blend Factor;13;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-5216,-1024;Inherit;False;F_DistanceBlendFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-5376,-1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1822;-5696,-928;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;107;-5568,-928;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;87;-5952,-1024;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1802;-7360,-1536;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1807;-7184,-1424;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;1809;-7008,-1696;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;1800;-7008,-1536;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1810;-6784,-1632;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1282;-6144,-1632;Inherit;False;M_WetSurfaceMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1627;-7392,-3200;Inherit;False;M_VxColorGMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1625;-7392,-3392;Inherit;False;M_VxColorRMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;480;-32,-928;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1622;-1696,1472;Inherit;False;1621;M_VxColorBMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1621;-7392,-3008;Inherit;False;M_VxColorBMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;734;-5440,896;Inherit;False;WorldPositionMaskUV;-1;;319;be38d6f93fb89284fac8bbcdf405c130;1,7,0;1;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-3904,192;Inherit;False;48;TEX_WaterNormal;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;491;-5184,896;Inherit;False;UV_WorldHorizontal;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;2048;-3904,1152;Inherit;False;491;UV_WorldHorizontal;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;380;-3904,1248;Inherit;False;79;V3_WindDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2049;-3904,1632;Inherit;False;1678;F_WindPerturbFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2019;-3904,1440;Inherit;False;Property;_BigWaveDistortionScale;Big Wave Distortion Scale;4;0;Create;True;0;0;0;False;0;False;0;0.011;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1910;-544,224;Inherit;False;Normal From Height;-1;;320;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;474;-5824,-1696;Inherit;False;1474;RAW_VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;2084;-5184,-1696;Inherit;False;Property;_ShadowAreasFactor;Shadow Areas Factor;22;0;Create;True;0;0;0;False;0;False;0;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;2075;-5824,-1600;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;2079;-5824,-1440;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2076;-5568,-1600;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;468;-5408,-1696;Inherit;False;Standard;TangentNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;-5;False;2;FLOAT;5;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;471;-5184,-1520;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2067;-5184,-1600;Inherit;False;915;M_DisplacementWaves;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2086;-4640,-1616;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2065;-4480,-1616;Inherit;False;M_HighlightColorMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1693;-96,-480;Inherit;False;Constant;_Gray;Gray;63;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1305;4192,-1120;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;992;-7296,-2656;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1871;-7072,-2656;Inherit;False;OverrideMaxValue;-1;;372;a223fd650b6f3ed49990d9e847af2115;2,7,1,8,0;2;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;956;192,-1056;Inherit;False;Property;_DepthColor;Depth Color;20;0;Create;True;0;0;0;False;0;False;0,0.4117647,0.6666667,1;0.1810229,0.2189576,0.3396201,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;58;-3136,432;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1689;-640,-1408;Inherit;False;1001;UV_DistortionedScreen;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2111;-6464,416;Inherit;False;2109;AN_DetailNormalWaves;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2113;-6464,496;Inherit;False;2112;F_DepthDistoritonAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;728;-6144,416;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;726;-5952,304;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1001;-5824,304;Inherit;False;UV_DistortionedScreen;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2112;-5248,-384;Inherit;False;F_DepthDistoritonAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1519;-7584,-2368;Inherit;False;Property;_ClarityDepthDistance;Clarity Depth Distance;25;0;Create;True;0;0;0;False;0;False;0;21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2106;-7104,-2208;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;2105;-7456,-2016;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;1520;-6656,-2368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1796;-6272,-2368;Inherit;False;M_ClarityDarkMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2108;-6912,-2272;Inherit;False;Property;_ClaiityIntensityRange;Claiity Intensity Range;26;0;Create;True;0;0;0;False;0;False;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1579;-1088,-1280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1567;-2048,-992;Inherit;False;Property;_CausticOffsetEffect;Caustic Offset Effect;29;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1532;-2304,-1264;Inherit;False;Property;_CausticSpeedFix;Caustic Speed Fix;30;0;Create;True;1;Caustic;0;0;False;0;False;0.17;0.17;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;2117;-2624,-736;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;729;-5536,-384;Inherit;False;Property;_DepthDistortionFactor;Depth Distortion Factor;24;0;Create;True;0;0;0;False;0;False;0.091;0.005;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1781;-6752,-704;Inherit;False;RAW_WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RGBToHSVNode;475;-6496,-704;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.HSVToRGBNode;477;-6144,-704;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;1780;-5920,-704;Inherit;False;RAW_IluminatedWaterColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;478;-6272,-576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;720;-7360,-512;Inherit;False;TEX_BorderFoamGrunge;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-7360,-704;Inherit;False;TEX_WaterNormal;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ColorNode;573;-7008,-512;Inherit;False;Property;_FoamColor;Foam Color;19;0;Create;True;1;Foam;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1815;-6784,-512;Inherit;False;RAW_FoamColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2114;-7552,-2112;Inherit;False;2112;F_DepthDistoritonAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;721;-5536,-704;Inherit;False;720;TEX_BorderFoamGrunge;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;719;-5536,-608;Inherit;False;Property;_FoamNoiseTiling;Foam Noise Tiling;33;0;Create;True;0;0;0;False;0;False;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;736;-5312,-608;Inherit;False;WorldPositionMaskUV;-1;;380;be38d6f93fb89284fac8bbcdf405c130;1,7,0;1;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;717;-5056,-704;Inherit;True;Property;_BorderFoamGrungeRef;Border Foam Grunge Ref;34;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;735;-5920,-2720;Inherit;False;WorldPositionMaskUV;-1;;381;be38d6f93fb89284fac8bbcdf405c130;1,7,0;1;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;2132;-5024,-2720;Inherit;True;0;0;1;0;3;False;1;False;True;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.GetLocalVarNode;2138;-5920,-2656;Inherit;False;79;V3_WindDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;2141;-5680,-2656;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleTimeNode;2134;-5408,-2656;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;2140;-5552,-2656;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2135;-5280,-2560;Inherit;False;Constant;_FVSmoothness;FVSmoothness;57;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;2137;-4736,-2720;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.7;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2136;-4560,-2720;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;664;-5920,-2544;Inherit;False;Property;_BorderFoamDisturbScale;Border Foam Disturb Scale;36;0;Create;True;0;0;0;False;0;False;2;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1230;-4416,-2720;Inherit;False;AM_WaterDisturb;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1877;-7616,-1408;Inherit;False;Constant;_OffsetInYAxis;OffsetInYAxis;60;0;Create;True;0;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;947;-6832,-2656;Inherit;False;M_DephtInverseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1869;1888,-896;Inherit;False;OverrideMaxValue;-1;;385;a223fd650b6f3ed49990d9e847af2115;2,7,1,8,1;2;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;572;2688,-1184;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;703;1600,-896;Inherit;False;1076;AM_BorderFoamResult;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;637;1600,-1120;Inherit;False;1062;AM_WavesFoamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1630;-4736,-704;Inherit;False;RAW_BorderFoamGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2159;-6688,-3392;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;617;-5920,-3392;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1902;-6208,-3008;Inherit;False;MeshesContactMask;-1;;400;6b92c3e28ec771d45a621eb97d4dc4d3;1,20,1;4;7;FLOAT;0;False;6;FLOAT;0;False;15;FLOAT;0;False;16;FLOAT;20;False;2;FLOAT;24;FLOAT;0
Node;AmplifyShaderEditor.WireNode;2165;-6544,-2992;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;2166;-6528,-2976;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1076;-5952,-3008;Inherit;False;AM_BorderFoamResult;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2155;-6496,-2368;Inherit;False;OverrideMinValue;-1;;402;452d473b2fa6fec43b0656f3f93a163f;4,11,1,12,0,18,0,23,0;2;9;FLOAT;0;False;14;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.GetLocalVarNode;276;1440,480;Inherit;False;275;OUT_VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DepthFade;1518;-6912,-2368;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2066;-416,-816;Inherit;False;2065;M_HighlightColorMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2154;-4896,-1472;Inherit;False;OverrideMinValue;-1;;404;452d473b2fa6fec43b0656f3f93a163f;4,11,1,12,0,18,0,23,0;2;9;FLOAT;0;False;14;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.RegisterLocalVarNode;2172;-4448,-1408;Inherit;False;AM_TopWaves;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;615;-6464,-3296;Inherit;False;2172;AM_TopWaves;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1829;-7008,-3392;Inherit;False;1630;RAW_BorderFoamGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2158;-7008,-3296;Inherit;False;1230;AM_WaterDisturb;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1783;-416,-912;Inherit;False;1780;RAW_IluminatedWaterColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;2174;2912,-1184;Inherit;False;WorldClouds;47;;408;fbd8b751c1f357a4a9b023b83ed35d56;1,59,1;1;46;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1516;1600,-800;Inherit;False;Property;_BorderFoamFactor;Border Foam Factor;39;0;Create;True;0;0;0;False;0;False;0.5;0.95;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1062;-5760,-3392;Inherit;False;AM_WavesFoamMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2176;-2912,1824;Inherit;False;1062;AM_WavesFoamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2181;-2624,1408;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2180;-2464,1408;Inherit;False;SaturateAdd;-1;;411;8e2aa5d5bda3f5c41bc64ee811a5f21a;0;2;1;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;843;-3616,1920;Inherit;False;Property;_BorderFoamHeight;Border Foam Height;40;1;[Header];Create;True;1;(Displacement);0;0;False;0;False;0.15;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;334;-7008,-704;Inherit;False;Property;_WaterColor;Water Color;18;1;[Header];Create;True;1;BASE COLOR;0;0;False;1;Space(5);False;0,0.2509804,0.6666667,0;0.1511592,0.745,0.737802,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1863;-7328,-2560;Inherit;False;Property;_DarkDepthDistace;Dark Depth Distace;23;1;[Header];Create;True;1;DEPTH;0;0;False;1;Space(5);False;0;150;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1556;-3264,-832;Inherit;False;Property;_CausticDeformFactor;Caustic Deform Factor;27;1;[Header];Create;True;2;CAUSTIC;(Parameters);0;0;False;0;False;0;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1580;-1312,-1184;Inherit;False;Property;_CausticLightFactor;Caustic Light Factor;31;1;[Header];Create;True;1;(Color);0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;716;-7616,-512;Inherit;True;Property;_FoamAlpha;Foam Alpha;32;3;[Header];[NoScaleOffset];[SingleLineTexture];Create;True;2;FOAM;(Parameters);0;0;False;1;Space(10);False;40a6f9413b7d0dc4fb50550456d756e6;40a6f9413b7d0dc4fb50550456d756e6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;2177;-2912,1920;Inherit;False;Property;_WavesFoamHeight;Waves Foam Height;41;0;Create;True;0;0;0;False;0;False;0.15;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-6944,-928;Inherit;False;Property;_GravitySpeed;Gravity Speed;14;1;[Header];Create;True;2;WIND;(Parameters);0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-7616,-928;Inherit;False;Property;_DirectionSpeedFactor;Direction Speed Factor;15;1;[Header];Create;True;0;0;0;False;0;False;0.5;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-7616,-1024;Inherit;False;Property;_WindCardinalDirection;Wind Cardinal Direction;17;0;Create;True;0;0;0;False;0;False;90;360;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;11;-7616,-704;Inherit;True;Property;_WaterDetailNormal;Water Detail Normal;10;4;[Header];[NoScaleOffset];[Normal];[SingleLineTexture];Create;True;2;DETAIL;(Parameters);0;0;False;1;Space(10);False;0f566727d724ace4db32225547aff60b;0f566727d724ace4db32225547aff60b;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;90;-6208,-1024;Inherit;False;Property;_CameraDistanceMask;Camera Distance Mask;0;1;[Header];Create;True;2;OTHER;(Parameters);0;0;False;0;False;11;140;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-3904,1344;Inherit;False;Property;_BigWaveScale;Big Wave Scale;3;1;[Header];Create;True;2;WAVES;(Parameters);0;0;False;0;False;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;3616,-1120;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1944;-2304,0;Inherit;False;OverrideMaxValue;-1;;412;a223fd650b6f3ed49990d9e847af2115;2,7,1,8,1;2;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;646;-2016,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;640;-2592,0;Inherit;False;1076;AM_BorderFoamResult;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1063;-2592,384;Inherit;False;1062;AM_WavesFoamMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1943;-2304,384;Inherit;False;OverrideMaxValue;-1;;414;a223fd650b6f3ed49990d9e847af2115;2,7,1,8,1;2;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;645;-2272,208;Inherit;False;108;F_DistanceBlendFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1064;-2016,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1906;-1728,208;Inherit;False;SaturateAdd;-1;;416;8e2aa5d5bda3f5c41bc64ee811a5f21a;0;2;1;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2187;-1152,224;Inherit;False;SaturateAdd;-1;;417;8e2aa5d5bda3f5c41bc64ee811a5f21a;0;2;1;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1310;-224,480;Inherit;False;1282;M_WetSurfaceMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2109;-2912,704;Inherit;False;AN_DetailNormalWaves;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1901;-1440,288;Inherit;False;915;M_DisplacementWaves;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;680;-6464,-2944;Inherit;False;Property;_BorderFoamRange;Border Foam Range;35;1;[Header];Create;True;1;(Border);0;0;False;0;False;0.8;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1848;-6464,-3200;Inherit;False;Property;_WaveFoamFrequency;Wave Foam Frequency;37;1;[Header];Create;True;1;(Wave);0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2156;-6144,-3296;Inherit;False;OverrideMinValue;-1;;418;452d473b2fa6fec43b0656f3f93a163f;4,11,1,12,1,18,0,23,0;2;9;FLOAT;0;False;14;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.GetLocalVarNode;841;-3616,1824;Inherit;False;1076;AM_BorderFoamResult;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2197;-3328,1824;Inherit;False;OverrideMaxValue;-1;;420;a223fd650b6f3ed49990d9e847af2115;2,7,1,8,1;2;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2198;-2624,1824;Inherit;False;OverrideMaxValue;-1;;422;a223fd650b6f3ed49990d9e847af2115;2,7,1,8,1;2;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1065;-2592,480;Inherit;False;Property;_WaveFoamNormalStrength;Wave Foam Normal Strength;42;1;[Header];Create;True;1;(Normal);0;0;False;0;False;0.05;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;644;-2592,96;Inherit;False;Property;_BorderFoamNormalStrength;Border Foam Normal Strength;43;0;Create;True;1;;0;0;False;0;False;0.15;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;634;1600,-1024;Inherit;False;Property;_WaveFoamFactor;Wave Foam Factor;38;1;[Header];Create;True;1;(Base Color);0;0;False;0;False;0.5;0.99;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2153;-6368,-1632;Inherit;False;OverrideMinValue;-1;;424;452d473b2fa6fec43b0656f3f93a163f;4,11,1,12,0,18,1,23,1;2;9;FLOAT;0;False;14;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.RangedFloatNode;1265;-6656,-1504;Inherit;False;Property;_WetDistanceFactor;Wet Distance Factor;1;0;Create;True;1;Wet Surface Effect;0;0;False;0;False;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1930;-800,320;Inherit;False;Property;_FinalNormalStrength;Final Normal Strength;44;1;[Header];Create;True;1;NORMAL;0;0;False;0;False;0;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1933;-544,480;Inherit;False;Property;_NormalDetailVsGross;Normal Detail Vs Gross;45;0;Create;True;0;0;0;False;0;False;0;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1467;-1440,1568;Inherit;False;Property;_MaxVertexOffset;Max Vertex Offset;46;1;[Header];Create;True;1;DISPLACEMENT;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1474;-1696,1568;Inherit;False;RAW_VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;2199;-3552,1632;Inherit;False;Property;_BigWaveSmoothness;Big Wave Smoothness;6;0;Create;True;0;0;0;False;0;False;0;0.197;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2060;-3296,1280;Inherit;False;SimpleWaterWave;7;;426;015059b614c79d64facf0c3f15bbe5b8;1,14,1;7;44;FLOAT2;0,0;False;53;FLOAT2;0,0;False;12;FLOAT;0;False;67;FLOAT;0;False;69;FLOAT;0;False;54;FLOAT;0;False;89;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2200;-2694.208,1186.565;Inherit;False;OverrideMaxValue;-1;;427;a223fd650b6f3ed49990d9e847af2115;2,7,1,8,1;2;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1307;1440,384;Inherit;False;1306;OUT_Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2201;-3017.208,1183.565;Inherit;False;Property;_BigWaveStrength;Big Wave Strength;9;1;[Header];Create;True;1;(Displacement);0;0;False;0;False;0;0.7563025;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;1674;-3680,1280;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;915;-2982,1279;Inherit;False;M_DisplacementWaves;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2202;-2693.321,1087.827;Inherit;False;OverrideMinValue;-1;;429;452d473b2fa6fec43b0656f3f93a163f;4,11,1,12,1,18,0,23,0;2;9;FLOAT;0;False;14;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.RangedFloatNode;2021;-3904,1536;Inherit;False;Property;_BigWaveDistortionStrength;Big Wave Distortion Strength;5;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1286;1104,-976;Inherit;False;1282;M_WetSurfaceMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;1253;-6656,-1632;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1799;-7616,-1536;Inherit;False;275;OUT_VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;2110;-7552,-2208;Inherit;False;2109;AN_DetailNormalWaves;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2209;-7248,-2192;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;1618;-7616,-3264;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1002;-7584,-2656;Inherit;False;1001;UV_DistortionedScreen;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1617;-6560,-512;Inherit;False;Property;_LightHighlightStrength;Light Highlight Strength;21;1;[Header];Create;True;1;LIGHTING;0;0;False;1;Space(5);False;0.1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-5440,992;Inherit;False;Property;_WindSpeedPerturbFactor;Wind Speed Perturb Factor;16;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1678;-5152,992;Inherit;False;F_WindPerturbFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2171;3040,-288;Inherit;False;2188;DEBUG;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2188;3232,-288;Inherit;False;DEBUG;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2210;1760,224;Float;False;True;-1;3;ASEMaterialInspector;0;0;Standard;NewStylizedWater;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;1440,288;Inherit;False;273;OUT_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;411;1440,192;Inherit;False;410;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1797;736,-1024;Inherit;False;1796;M_ClarityDarkMask;1;0;OBJECT;;False;1;FLOAT;0
WireConnection;56;0;57;0
WireConnection;56;9;82;0
WireConnection;56;8;109;0
WireConnection;56;3;128;0
WireConnection;1446;0;2180;0
WireConnection;1446;1;1438;0
WireConnection;1619;0;1446;0
WireConnection;1619;2;1622;0
WireConnection;1468;0;1619;0
WireConnection;1468;1;1467;0
WireConnection;275;0;1468;0
WireConnection;127;0;96;0
WireConnection;124;0;59;0
WireConnection;273;0;1937;0
WireConnection;1935;0;2109;0
WireConnection;1935;1;1910;40
WireConnection;1935;2;1933;0
WireConnection;1937;0;1935;0
WireConnection;1937;2;1310;0
WireConnection;1581;0;1535;0
WireConnection;1582;0;1581;0
WireConnection;1536;0;1582;0
WireConnection;1540;0;1582;0
WireConnection;1546;0;1582;0
WireConnection;1538;0;1536;0
WireConnection;1538;1;1540;0
WireConnection;1545;0;1538;0
WireConnection;1545;1;1546;0
WireConnection;1555;0;1557;0
WireConnection;1555;1;1556;0
WireConnection;1553;0;1545;0
WireConnection;1553;1;1555;0
WireConnection;1573;0;1553;0
WireConnection;1570;0;1573;1
WireConnection;1570;1;2117;0
WireConnection;1574;0;1573;0
WireConnection;1574;1;1570;0
WireConnection;1566;0;1574;0
WireConnection;1566;1;1567;0
WireConnection;1602;0;1601;0
WireConnection;1602;1;1532;0
WireConnection;1534;0;1602;0
WireConnection;1568;0;1566;0
WireConnection;1568;1;1534;0
WireConnection;1568;2;1533;0
WireConnection;1569;0;1531;0
WireConnection;1569;1;1568;0
WireConnection;1531;0;1574;0
WireConnection;1531;1;1534;0
WireConnection;1531;2;1533;0
WireConnection;958;0;956;0
WireConnection;958;1;480;0
WireConnection;958;2;957;0
WireConnection;1785;0;723;0
WireConnection;1785;1;1596;0
WireConnection;1785;2;1967;0
WireConnection;1595;0;1785;0
WireConnection;410;0;2174;0
WireConnection;1870;3;637;0
WireConnection;1870;4;634;0
WireConnection;1599;0;1241;0
WireConnection;1599;1;1693;0
WireConnection;1288;0;1599;0
WireConnection;1017;0;1894;0
WireConnection;1017;1;1895;0
WireConnection;1017;2;1797;0
WireConnection;1287;0;1017;0
WireConnection;1287;1;1891;0
WireConnection;1287;2;1286;0
WireConnection;1891;0;1968;0
WireConnection;1895;0;958;0
WireConnection;1894;0;1595;0
WireConnection;723;0;1689;0
WireConnection;1597;0;723;0
WireConnection;1597;1;1579;0
WireConnection;1596;0;723;0
WireConnection;1596;1;1597;0
WireConnection;1967;0;1579;0
WireConnection;1968;0;1288;0
WireConnection;1450;0;1870;0
WireConnection;1450;1;1869;0
WireConnection;1854;4;1450;0
WireConnection;1854;5;1286;0
WireConnection;1953;3;1854;0
WireConnection;1953;4;1954;0
WireConnection;1306;0;1305;0
WireConnection;18;0;49;0
WireConnection;18;9;78;0
WireConnection;18;8;109;0
WireConnection;18;3;125;0
WireConnection;78;0;19;0
WireConnection;78;1;77;0
WireConnection;74;0;33;0
WireConnection;74;1;80;0
WireConnection;77;0;33;0
WireConnection;77;1;80;0
WireConnection;83;0;74;0
WireConnection;83;1;1679;0
WireConnection;727;0;724;0
WireConnection;82;0;19;0
WireConnection;82;1;83;0
WireConnection;76;0;45;0
WireConnection;76;1;46;0
WireConnection;76;2;45;1
WireConnection;41;27;40;0
WireConnection;43;0;41;0
WireConnection;43;1;1600;0
WireConnection;1600;0;42;0
WireConnection;45;0;43;0
WireConnection;79;0;76;0
WireConnection;108;0;98;0
WireConnection;98;0;97;0
WireConnection;98;1;107;0
WireConnection;1822;0;87;0
WireConnection;107;0;1822;0
WireConnection;87;0;90;0
WireConnection;1802;0;1799;0
WireConnection;1807;0;1802;1
WireConnection;1807;1;1877;0
WireConnection;1800;0;1802;0
WireConnection;1800;1;1807;0
WireConnection;1800;2;1802;2
WireConnection;1810;0;1809;0
WireConnection;1810;1;1800;0
WireConnection;1282;0;2153;6
WireConnection;1627;0;1618;2
WireConnection;1625;0;1618;1
WireConnection;480;0;1782;0
WireConnection;480;1;1783;0
WireConnection;480;2;2066;0
WireConnection;1621;0;1618;3
WireConnection;491;0;734;0
WireConnection;1910;20;2187;0
WireConnection;1910;110;1930;0
WireConnection;2076;0;2075;0
WireConnection;2076;1;2079;0
WireConnection;468;0;474;0
WireConnection;468;4;2076;0
WireConnection;471;0;468;0
WireConnection;2086;0;2154;6
WireConnection;2086;1;2067;0
WireConnection;2086;2;471;0
WireConnection;2065;0;2086;0
WireConnection;1305;0;256;0
WireConnection;1305;2;1953;0
WireConnection;992;0;1002;0
WireConnection;1871;3;992;0
WireConnection;1871;4;1863;0
WireConnection;58;0;18;0
WireConnection;58;1;56;0
WireConnection;728;0;2111;0
WireConnection;728;1;2113;0
WireConnection;726;0;727;0
WireConnection;726;1;728;0
WireConnection;1001;0;726;0
WireConnection;2112;0;729;0
WireConnection;2106;0;2209;0
WireConnection;2106;1;2105;0
WireConnection;1520;0;1518;0
WireConnection;1796;0;2155;6
WireConnection;1579;0;1569;0
WireConnection;1579;1;1580;0
WireConnection;1781;0;334;0
WireConnection;475;0;1781;0
WireConnection;477;0;475;1
WireConnection;477;1;475;2
WireConnection;477;2;478;0
WireConnection;1780;0;477;0
WireConnection;478;0;475;3
WireConnection;478;1;1617;0
WireConnection;720;0;716;0
WireConnection;48;0;11;0
WireConnection;1815;0;573;0
WireConnection;736;4;719;0
WireConnection;717;0;721;0
WireConnection;717;1;736;0
WireConnection;2132;0;735;0
WireConnection;2132;1;2134;0
WireConnection;2132;2;664;0
WireConnection;2132;3;2135;0
WireConnection;2141;0;2138;0
WireConnection;2134;0;2140;0
WireConnection;2140;0;2141;0
WireConnection;2140;1;2141;1
WireConnection;2137;0;2132;0
WireConnection;2136;0;2137;0
WireConnection;1230;0;2136;0
WireConnection;947;0;1871;0
WireConnection;1869;3;703;0
WireConnection;1869;4;1516;0
WireConnection;572;0;1287;0
WireConnection;572;1;1816;0
WireConnection;572;2;1854;0
WireConnection;1630;0;717;1
WireConnection;2159;0;1829;0
WireConnection;2159;1;2158;0
WireConnection;617;0;2159;0
WireConnection;617;1;2156;6
WireConnection;1902;7;2166;0
WireConnection;1902;6;680;0
WireConnection;2165;0;2159;0
WireConnection;2166;0;2165;0
WireConnection;1076;0;1902;0
WireConnection;2155;9;1520;0
WireConnection;2155;14;2108;0
WireConnection;1518;0;1519;0
WireConnection;2154;9;2067;0
WireConnection;2154;14;2084;0
WireConnection;2172;0;2154;6
WireConnection;2174;46;572;0
WireConnection;1062;0;617;0
WireConnection;2181;0;2202;6
WireConnection;2181;1;2197;0
WireConnection;2180;1;2181;0
WireConnection;2180;3;2198;0
WireConnection;1944;3;640;0
WireConnection;1944;4;644;0
WireConnection;646;0;1944;0
WireConnection;646;1;645;0
WireConnection;1943;3;1063;0
WireConnection;1943;4;1065;0
WireConnection;1064;0;645;0
WireConnection;1064;1;1943;0
WireConnection;1906;1;646;0
WireConnection;1906;3;1064;0
WireConnection;2187;1;1906;0
WireConnection;2187;3;1901;0
WireConnection;2109;0;58;0
WireConnection;2156;9;615;0
WireConnection;2156;14;1848;0
WireConnection;2197;3;841;0
WireConnection;2197;4;843;0
WireConnection;2198;3;2176;0
WireConnection;2198;4;2177;0
WireConnection;2153;9;1253;0
WireConnection;2153;14;1265;0
WireConnection;1474;0;1446;0
WireConnection;2060;44;2048;0
WireConnection;2060;53;1674;0
WireConnection;2060;12;151;0
WireConnection;2060;67;2019;0
WireConnection;2060;69;2021;0
WireConnection;2060;54;2049;0
WireConnection;2060;89;2199;0
WireConnection;2200;3;915;0
WireConnection;2200;4;2201;0
WireConnection;1674;0;380;0
WireConnection;915;0;2060;0
WireConnection;2202;9;915;0
WireConnection;2202;14;2201;0
WireConnection;1253;1;1810;0
WireConnection;2209;0;2110;0
WireConnection;2209;1;2114;0
WireConnection;1678;0;75;0
WireConnection;2210;0;411;0
WireConnection;2210;1;274;0
WireConnection;2210;4;1307;0
WireConnection;2210;11;276;0
ASEEND*/
//CHKSM=BDAA968115EF93037F8B03CE482E01E6786A7B17