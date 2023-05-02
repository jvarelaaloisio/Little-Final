// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LemuWater"
{
	Properties
	{
		_SmoothnessFac("SmoothnessFac", Range( 0 , 1)) = 1
		_Wind__SpeedFactor("Wind__Speed Factor", Float) = 0
		_Wind__DirectionAngle("Wind__Direction Angle", Range( 0 , 360)) = 0
		_Waves__TilingSmall("Waves__Tiling Small", Float) = 0.1
		_Waves__TilingBig("Waves__Tiling Big", Float) = 0.2
		_Waves__HeightMax("Waves__Height Max", Float) = 1
		_Waves__HeightFactorSmall("Waves__Height Factor Small", Float) = 1
		_Waves__HeightFactorBig("Waves__Height Factor Big", Float) = 1
		_Waves__CollisionlOffsetX("Waves__Collisionl Offset X", Float) = 0
		_Waves__CollisionlOffsetY("Waves__Collisionl Offset Y", Float) = 0
		_Foam__Color("Foam__Color", Color) = (1,1,1,0)
		_Foam__Scale("Foam__Scale", Float) = 0.3
		_Foam__Border("Foam__Border", Float) = 20.5
		_Foam__SpeedFactor("Foam__Speed Factor", Float) = 0
		_Foam__DefinitionFactor("Foam__DefinitionFactor", Float) = 0
		_Fog__Depth("Fog__Depth", Float) = 10
		_Fog__Factor("Fog__Factor", Range( 0 , 1)) = 1
		_Depth__DistortionFactor("Depth__DistortionFactor", Float) = 1
		_Fog_Color("Fog_Color", Color) = (0.2186721,0.370783,0.735849,0)
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_ClearWater__Factor("ClearWater__Factor", Float) = 2.42
		_ClearWater__Scale("ClearWater__Scale", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Standard alpha:fade keepalpha vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _Wind__DirectionAngle;
		uniform float _Wind__SpeedFactor;
		uniform float _Waves__TilingSmall;
		uniform float _Waves__CollisionlOffsetX;
		uniform float _Waves__CollisionlOffsetY;
		uniform float _Waves__HeightFactorSmall;
		uniform float _Waves__TilingBig;
		uniform float _Waves__HeightFactorBig;
		uniform float _Waves__HeightMax;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Foam__SpeedFactor;
		uniform float _Foam__Scale;
		uniform float _Foam__Border;
		uniform float _Foam__DefinitionFactor;
		uniform float4 _Foam__Color;
		uniform float4 _Fog_Color;
		uniform float _Fog__Depth;
		uniform float _Fog__Factor;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Depth__DistortionFactor;
		uniform float3 G_Water_ClearZone_1;
		uniform float _ClearWater__Scale;
		uniform float3 G_Water_ClearZone_2;
		uniform float _ClearWater__Factor;
		uniform float _SmoothnessFac;
		uniform float _EdgeLength;


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float VAR_AngleRotation25_g3 = _Wind__DirectionAngle;
			float2 appendResult12_g3 = (float2((0.0 + (VAR_AngleRotation25_g3 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g3 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
			float2 appendResult9_g3 = (float2((1.0 + (VAR_AngleRotation25_g3 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g3 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
			float2 appendResult7_g3 = (float2((0.0 + (VAR_AngleRotation25_g3 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g3 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
			float2 appendResult4_g3 = (float2((-1.0 + (VAR_AngleRotation25_g3 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g3 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
			float2 normalizeResult2_g3 = normalize( (( VAR_AngleRotation25_g3 >= 0.0 && VAR_AngleRotation25_g3 <= 90.0 ) ? appendResult12_g3 :  (( VAR_AngleRotation25_g3 >= 90.1 && VAR_AngleRotation25_g3 <= 180.0 ) ? appendResult9_g3 :  (( VAR_AngleRotation25_g3 >= 180.1 && VAR_AngleRotation25_g3 <= 270.0 ) ? appendResult7_g3 :  (( VAR_AngleRotation25_g3 >= 270.1 && VAR_AngleRotation25_g3 <= 360.0 ) ? appendResult4_g3 :  float2( 0,0 ) ) ) ) ) );
			float2 VAR_WindDirection237 = ( normalizeResult2_g3 * _Wind__SpeedFactor );
			float2 VAR_Direction37_g453 = VAR_WindDirection237;
			float2 INP_Direction24_g454 = VAR_Direction37_g453;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 VAR_VertexPosition159_g453 = ase_vertex3Pos;
			float3 INP_VertexPosition15_g454 = VAR_VertexPosition159_g453;
			float3 break3_g454 = INP_VertexPosition15_g454;
			float2 appendResult2_g454 = (float2(break3_g454.x , break3_g454.z));
			float VAR_WaveTiling35_g453 = _Waves__TilingSmall;
			float2 VAR_WavesCordinates20_g454 = ( appendResult2_g454 * VAR_WaveTiling35_g453 );
			float2 panner6_g454 = ( 1.0 * _Time.y * INP_Direction24_g454 + VAR_WavesCordinates20_g454);
			float simplePerlin2D9_g454 = snoise( panner6_g454 );
			simplePerlin2D9_g454 = simplePerlin2D9_g454*0.5 + 0.5;
			float2 appendResult351 = (float2(_Waves__CollisionlOffsetX , _Waves__CollisionlOffsetY));
			float2 VAR_CollisionWaveOffset208_g453 = appendResult351;
			float2 INP_CollisionlWavesOffset57_g454 = VAR_CollisionWaveOffset208_g453;
			float2 VAR_OffsetDirection62_g454 = ( INP_Direction24_g454 * INP_CollisionlWavesOffset57_g454 );
			float2 panner18_g454 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g454 + VAR_WavesCordinates20_g454);
			float simplePerlin2D19_g454 = snoise( panner18_g454 );
			simplePerlin2D19_g454 = simplePerlin2D19_g454*0.5 + 0.5;
			float VAR_SmallWavesHeightFactor255_g453 = _Waves__HeightFactorSmall;
			float VAR_SmallWavesPattern78_g454 = ( simplePerlin2D9_g454 * simplePerlin2D19_g454 * VAR_SmallWavesHeightFactor255_g453 );
			float2 temp_cast_0 = (_Waves__TilingBig).xx;
			float2 VAR_BigWaveTIle194_g453 = temp_cast_0;
			float2 VAR_BigWavesCordinates49_g454 = ( appendResult2_g454 * VAR_BigWaveTIle194_g453 );
			float2 panner42_g454 = ( 1.0 * _Time.y * INP_Direction24_g454 + VAR_BigWavesCordinates49_g454);
			float simplePerlin2D35_g454 = snoise( panner42_g454 );
			simplePerlin2D35_g454 = simplePerlin2D35_g454*0.5 + 0.5;
			float2 panner43_g454 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g454 + VAR_BigWavesCordinates49_g454);
			float simplePerlin2D36_g454 = snoise( panner43_g454 );
			simplePerlin2D36_g454 = simplePerlin2D36_g454*0.5 + 0.5;
			float VAR_BigWavesHeightFactor256_g453 = _Waves__HeightFactorBig;
			float VAR_BigWavesPattern75_g454 = ( simplePerlin2D35_g454 * simplePerlin2D36_g454 * VAR_BigWavesHeightFactor256_g453 );
			float3 appendResult10_g454 = (float3(0.0 , ( VAR_SmallWavesPattern78_g454 + VAR_BigWavesPattern75_g454 ) , 0.0));
			float3 ase_vertexNormal = v.normal.xyz;
			float VAR_Amplitude40_g453 = _Waves__HeightMax;
			float3 OUT_VertexOffset85_g454 = ( ( appendResult10_g454 * ( ase_vertexNormal * VAR_Amplitude40_g453 ) ) + INP_VertexPosition15_g454 );
			float3 VAR_VertexOffset45_g453 = OUT_VertexOffset85_g454;
			float3 OUT_VertexOffset59 = VAR_VertexOffset45_g453;
			v.vertex.xyz = OUT_VertexOffset59;
			v.vertex.w = 1;
			float2 INP_Direction24_g455 = VAR_Direction37_g453;
			float4 ase_vertexTangent = v.tangent;
			float3 ase_vertexBitangent = cross( ase_vertexNormal, ase_vertexTangent) * v.tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
			float3x3 VAR_ObjectToTangent6_g453 = float3x3(ase_vertexTangent.xyz, ase_vertexBitangent, ase_vertexNormal);
			float VAR_Deviation30_g453 = 0.05;
			float3 appendResult16_g453 = (float3(0.0 , VAR_Deviation30_g453 , 0.0));
			float3 VAR_VertexPosRecontructedY26_g453 = mul( ( mul( VAR_ObjectToTangent6_g453, VAR_VertexPosition159_g453 ) + appendResult16_g453 ), VAR_ObjectToTangent6_g453 );
			float3 INP_VertexPosition15_g455 = VAR_VertexPosRecontructedY26_g453;
			float3 break3_g455 = INP_VertexPosition15_g455;
			float2 appendResult2_g455 = (float2(break3_g455.x , break3_g455.z));
			float2 VAR_WavesCordinates20_g455 = ( appendResult2_g455 * VAR_WaveTiling35_g453 );
			float2 panner6_g455 = ( 1.0 * _Time.y * INP_Direction24_g455 + VAR_WavesCordinates20_g455);
			float simplePerlin2D9_g455 = snoise( panner6_g455 );
			simplePerlin2D9_g455 = simplePerlin2D9_g455*0.5 + 0.5;
			float2 INP_CollisionlWavesOffset57_g455 = VAR_CollisionWaveOffset208_g453;
			float2 VAR_OffsetDirection62_g455 = ( INP_Direction24_g455 * INP_CollisionlWavesOffset57_g455 );
			float2 panner18_g455 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g455 + VAR_WavesCordinates20_g455);
			float simplePerlin2D19_g455 = snoise( panner18_g455 );
			simplePerlin2D19_g455 = simplePerlin2D19_g455*0.5 + 0.5;
			float VAR_SmallWavesPattern78_g455 = ( simplePerlin2D9_g455 * simplePerlin2D19_g455 * VAR_SmallWavesHeightFactor255_g453 );
			float2 VAR_BigWavesCordinates49_g455 = ( appendResult2_g455 * VAR_BigWaveTIle194_g453 );
			float2 panner42_g455 = ( 1.0 * _Time.y * INP_Direction24_g455 + VAR_BigWavesCordinates49_g455);
			float simplePerlin2D35_g455 = snoise( panner42_g455 );
			simplePerlin2D35_g455 = simplePerlin2D35_g455*0.5 + 0.5;
			float2 panner43_g455 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g455 + VAR_BigWavesCordinates49_g455);
			float simplePerlin2D36_g455 = snoise( panner43_g455 );
			simplePerlin2D36_g455 = simplePerlin2D36_g455*0.5 + 0.5;
			float VAR_BigWavesPattern75_g455 = ( simplePerlin2D35_g455 * simplePerlin2D36_g455 * VAR_BigWavesHeightFactor256_g453 );
			float3 appendResult10_g455 = (float3(0.0 , ( VAR_SmallWavesPattern78_g455 + VAR_BigWavesPattern75_g455 ) , 0.0));
			float3 OUT_VertexOffset85_g455 = ( ( appendResult10_g455 * ( ase_vertexNormal * VAR_Amplitude40_g453 ) ) + INP_VertexPosition15_g455 );
			float3 VAR_VertexOffsetDevY58_g453 = OUT_VertexOffset85_g455;
			float2 INP_Direction24_g456 = VAR_Direction37_g453;
			float3 appendResult17_g453 = (float3(VAR_Deviation30_g453 , 0.0 , 0.0));
			float3 VAR_VertexPosRecontructedX28_g453 = mul( ( mul( VAR_ObjectToTangent6_g453, VAR_VertexPosition159_g453 ) + appendResult17_g453 ), VAR_ObjectToTangent6_g453 );
			float3 INP_VertexPosition15_g456 = VAR_VertexPosRecontructedX28_g453;
			float3 break3_g456 = INP_VertexPosition15_g456;
			float2 appendResult2_g456 = (float2(break3_g456.x , break3_g456.z));
			float2 VAR_WavesCordinates20_g456 = ( appendResult2_g456 * VAR_WaveTiling35_g453 );
			float2 panner6_g456 = ( 1.0 * _Time.y * INP_Direction24_g456 + VAR_WavesCordinates20_g456);
			float simplePerlin2D9_g456 = snoise( panner6_g456 );
			simplePerlin2D9_g456 = simplePerlin2D9_g456*0.5 + 0.5;
			float2 INP_CollisionlWavesOffset57_g456 = VAR_CollisionWaveOffset208_g453;
			float2 VAR_OffsetDirection62_g456 = ( INP_Direction24_g456 * INP_CollisionlWavesOffset57_g456 );
			float2 panner18_g456 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g456 + VAR_WavesCordinates20_g456);
			float simplePerlin2D19_g456 = snoise( panner18_g456 );
			simplePerlin2D19_g456 = simplePerlin2D19_g456*0.5 + 0.5;
			float VAR_SmallWavesPattern78_g456 = ( simplePerlin2D9_g456 * simplePerlin2D19_g456 * VAR_SmallWavesHeightFactor255_g453 );
			float2 VAR_BigWavesCordinates49_g456 = ( appendResult2_g456 * VAR_BigWaveTIle194_g453 );
			float2 panner42_g456 = ( 1.0 * _Time.y * INP_Direction24_g456 + VAR_BigWavesCordinates49_g456);
			float simplePerlin2D35_g456 = snoise( panner42_g456 );
			simplePerlin2D35_g456 = simplePerlin2D35_g456*0.5 + 0.5;
			float2 panner43_g456 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g456 + VAR_BigWavesCordinates49_g456);
			float simplePerlin2D36_g456 = snoise( panner43_g456 );
			simplePerlin2D36_g456 = simplePerlin2D36_g456*0.5 + 0.5;
			float VAR_BigWavesPattern75_g456 = ( simplePerlin2D35_g456 * simplePerlin2D36_g456 * VAR_BigWavesHeightFactor256_g453 );
			float3 appendResult10_g456 = (float3(0.0 , ( VAR_SmallWavesPattern78_g456 + VAR_BigWavesPattern75_g456 ) , 0.0));
			float3 OUT_VertexOffset85_g456 = ( ( appendResult10_g456 * ( ase_vertexNormal * VAR_Amplitude40_g453 ) ) + INP_VertexPosition15_g456 );
			float3 VAR_VertexOffsetDevX57_g453 = OUT_VertexOffset85_g456;
			float3 normalizeResult68_g453 = normalize( cross( ( VAR_VertexOffsetDevY58_g453 - VAR_VertexOffset45_g453 ) , ( VAR_VertexOffsetDevX57_g453 - VAR_VertexOffset45_g453 ) ) );
			float3 VAR_NormalReconstructed69_g453 = normalizeResult68_g453;
			float3 OUT_NormalOffset259 = VAR_NormalReconstructed69_g453;
			v.normal = OUT_NormalOffset259;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth503 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth503 = abs( ( screenDepth503 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float temp_output_504_0 = ( 1.0 - distanceDepth503 );
			float VAR_AngleRotation25_g3 = _Wind__DirectionAngle;
			float2 appendResult12_g3 = (float2((0.0 + (VAR_AngleRotation25_g3 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g3 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
			float2 appendResult9_g3 = (float2((1.0 + (VAR_AngleRotation25_g3 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g3 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
			float2 appendResult7_g3 = (float2((0.0 + (VAR_AngleRotation25_g3 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g3 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
			float2 appendResult4_g3 = (float2((-1.0 + (VAR_AngleRotation25_g3 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g3 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
			float2 normalizeResult2_g3 = normalize( (( VAR_AngleRotation25_g3 >= 0.0 && VAR_AngleRotation25_g3 <= 90.0 ) ? appendResult12_g3 :  (( VAR_AngleRotation25_g3 >= 90.1 && VAR_AngleRotation25_g3 <= 180.0 ) ? appendResult9_g3 :  (( VAR_AngleRotation25_g3 >= 180.1 && VAR_AngleRotation25_g3 <= 270.0 ) ? appendResult7_g3 :  (( VAR_AngleRotation25_g3 >= 270.1 && VAR_AngleRotation25_g3 <= 360.0 ) ? appendResult4_g3 :  float2( 0,0 ) ) ) ) ) );
			float2 VAR_WindDirection237 = ( normalizeResult2_g3 * _Wind__SpeedFactor );
			float2 temp_output_527_0 = ( VAR_WindDirection237 * _Foam__SpeedFactor );
			float3 ase_worldPos = i.worldPos;
			float2 appendResult372 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 VAR_GlobalCordinates373 = appendResult372;
			float2 panner511 = ( 1.0 * _Time.y * temp_output_527_0 + VAR_GlobalCordinates373);
			float temp_output_513_0 = ( _Foam__Scale * 10.0 );
			float simplePerlin2D509 = snoise( panner511*temp_output_513_0 );
			simplePerlin2D509 = simplePerlin2D509*0.5 + 0.5;
			float2 panner512 = ( 1.0 * _Time.y * -temp_output_527_0 + VAR_GlobalCordinates373);
			float simplePerlin2D510 = snoise( panner512*temp_output_513_0 );
			simplePerlin2D510 = simplePerlin2D510*0.5 + 0.5;
			float PATTERN__Foam556 = ( simplePerlin2D509 * simplePerlin2D510 );
			float MASK_Foam524 = saturate( (-_Foam__DefinitionFactor + (( ( temp_output_504_0 * PATTERN__Foam556 ) + ( temp_output_504_0 - _Foam__Border ) ) - 0.0) * (_Foam__DefinitionFactor - -_Foam__DefinitionFactor) / (1.0 - 0.0)) );
			float4 VAR_FoamColor578 = ( MASK_Foam524 * _Foam__Color );
			float screenDepth563 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth563 = abs( ( screenDepth563 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Fog__Depth ) );
			float4 VAR_DepthColor572 = saturate( ( _Fog_Color * saturate( ( 1.0 - distanceDepth563 ) ) * _Fog__Factor ) );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult585 = (float2(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g));
			float2 VAR_Direction37_g453 = VAR_WindDirection237;
			float2 INP_Direction24_g455 = VAR_Direction37_g453;
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float4 ase_vertexTangent = mul( unity_WorldToObject, float4( ase_worldTangent, 0 ) );
			ase_vertexTangent = normalize( ase_vertexTangent );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3 ase_vertexBitangent = mul( unity_WorldToObject, float4( ase_worldBitangent, 0 ) );
			ase_vertexBitangent = normalize( ase_vertexBitangent );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float3x3 VAR_ObjectToTangent6_g453 = float3x3(ase_vertexTangent.xyz, ase_vertexBitangent, ase_vertexNormal);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 VAR_VertexPosition159_g453 = ase_vertex3Pos;
			float VAR_Deviation30_g453 = 0.05;
			float3 appendResult16_g453 = (float3(0.0 , VAR_Deviation30_g453 , 0.0));
			float3 VAR_VertexPosRecontructedY26_g453 = mul( ( mul( VAR_ObjectToTangent6_g453, VAR_VertexPosition159_g453 ) + appendResult16_g453 ), VAR_ObjectToTangent6_g453 );
			float3 INP_VertexPosition15_g455 = VAR_VertexPosRecontructedY26_g453;
			float3 break3_g455 = INP_VertexPosition15_g455;
			float2 appendResult2_g455 = (float2(break3_g455.x , break3_g455.z));
			float VAR_WaveTiling35_g453 = _Waves__TilingSmall;
			float2 VAR_WavesCordinates20_g455 = ( appendResult2_g455 * VAR_WaveTiling35_g453 );
			float2 panner6_g455 = ( 1.0 * _Time.y * INP_Direction24_g455 + VAR_WavesCordinates20_g455);
			float simplePerlin2D9_g455 = snoise( panner6_g455 );
			simplePerlin2D9_g455 = simplePerlin2D9_g455*0.5 + 0.5;
			float2 appendResult351 = (float2(_Waves__CollisionlOffsetX , _Waves__CollisionlOffsetY));
			float2 VAR_CollisionWaveOffset208_g453 = appendResult351;
			float2 INP_CollisionlWavesOffset57_g455 = VAR_CollisionWaveOffset208_g453;
			float2 VAR_OffsetDirection62_g455 = ( INP_Direction24_g455 * INP_CollisionlWavesOffset57_g455 );
			float2 panner18_g455 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g455 + VAR_WavesCordinates20_g455);
			float simplePerlin2D19_g455 = snoise( panner18_g455 );
			simplePerlin2D19_g455 = simplePerlin2D19_g455*0.5 + 0.5;
			float VAR_SmallWavesHeightFactor255_g453 = _Waves__HeightFactorSmall;
			float VAR_SmallWavesPattern78_g455 = ( simplePerlin2D9_g455 * simplePerlin2D19_g455 * VAR_SmallWavesHeightFactor255_g453 );
			float2 temp_cast_1 = (_Waves__TilingBig).xx;
			float2 VAR_BigWaveTIle194_g453 = temp_cast_1;
			float2 VAR_BigWavesCordinates49_g455 = ( appendResult2_g455 * VAR_BigWaveTIle194_g453 );
			float2 panner42_g455 = ( 1.0 * _Time.y * INP_Direction24_g455 + VAR_BigWavesCordinates49_g455);
			float simplePerlin2D35_g455 = snoise( panner42_g455 );
			simplePerlin2D35_g455 = simplePerlin2D35_g455*0.5 + 0.5;
			float2 panner43_g455 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g455 + VAR_BigWavesCordinates49_g455);
			float simplePerlin2D36_g455 = snoise( panner43_g455 );
			simplePerlin2D36_g455 = simplePerlin2D36_g455*0.5 + 0.5;
			float VAR_BigWavesHeightFactor256_g453 = _Waves__HeightFactorBig;
			float VAR_BigWavesPattern75_g455 = ( simplePerlin2D35_g455 * simplePerlin2D36_g455 * VAR_BigWavesHeightFactor256_g453 );
			float3 appendResult10_g455 = (float3(0.0 , ( VAR_SmallWavesPattern78_g455 + VAR_BigWavesPattern75_g455 ) , 0.0));
			float VAR_Amplitude40_g453 = _Waves__HeightMax;
			float3 OUT_VertexOffset85_g455 = ( ( appendResult10_g455 * ( ase_vertexNormal * VAR_Amplitude40_g453 ) ) + INP_VertexPosition15_g455 );
			float3 VAR_VertexOffsetDevY58_g453 = OUT_VertexOffset85_g455;
			float2 INP_Direction24_g454 = VAR_Direction37_g453;
			float3 INP_VertexPosition15_g454 = VAR_VertexPosition159_g453;
			float3 break3_g454 = INP_VertexPosition15_g454;
			float2 appendResult2_g454 = (float2(break3_g454.x , break3_g454.z));
			float2 VAR_WavesCordinates20_g454 = ( appendResult2_g454 * VAR_WaveTiling35_g453 );
			float2 panner6_g454 = ( 1.0 * _Time.y * INP_Direction24_g454 + VAR_WavesCordinates20_g454);
			float simplePerlin2D9_g454 = snoise( panner6_g454 );
			simplePerlin2D9_g454 = simplePerlin2D9_g454*0.5 + 0.5;
			float2 INP_CollisionlWavesOffset57_g454 = VAR_CollisionWaveOffset208_g453;
			float2 VAR_OffsetDirection62_g454 = ( INP_Direction24_g454 * INP_CollisionlWavesOffset57_g454 );
			float2 panner18_g454 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g454 + VAR_WavesCordinates20_g454);
			float simplePerlin2D19_g454 = snoise( panner18_g454 );
			simplePerlin2D19_g454 = simplePerlin2D19_g454*0.5 + 0.5;
			float VAR_SmallWavesPattern78_g454 = ( simplePerlin2D9_g454 * simplePerlin2D19_g454 * VAR_SmallWavesHeightFactor255_g453 );
			float2 VAR_BigWavesCordinates49_g454 = ( appendResult2_g454 * VAR_BigWaveTIle194_g453 );
			float2 panner42_g454 = ( 1.0 * _Time.y * INP_Direction24_g454 + VAR_BigWavesCordinates49_g454);
			float simplePerlin2D35_g454 = snoise( panner42_g454 );
			simplePerlin2D35_g454 = simplePerlin2D35_g454*0.5 + 0.5;
			float2 panner43_g454 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g454 + VAR_BigWavesCordinates49_g454);
			float simplePerlin2D36_g454 = snoise( panner43_g454 );
			simplePerlin2D36_g454 = simplePerlin2D36_g454*0.5 + 0.5;
			float VAR_BigWavesPattern75_g454 = ( simplePerlin2D35_g454 * simplePerlin2D36_g454 * VAR_BigWavesHeightFactor256_g453 );
			float3 appendResult10_g454 = (float3(0.0 , ( VAR_SmallWavesPattern78_g454 + VAR_BigWavesPattern75_g454 ) , 0.0));
			float3 OUT_VertexOffset85_g454 = ( ( appendResult10_g454 * ( ase_vertexNormal * VAR_Amplitude40_g453 ) ) + INP_VertexPosition15_g454 );
			float3 VAR_VertexOffset45_g453 = OUT_VertexOffset85_g454;
			float2 INP_Direction24_g456 = VAR_Direction37_g453;
			float3 appendResult17_g453 = (float3(VAR_Deviation30_g453 , 0.0 , 0.0));
			float3 VAR_VertexPosRecontructedX28_g453 = mul( ( mul( VAR_ObjectToTangent6_g453, VAR_VertexPosition159_g453 ) + appendResult17_g453 ), VAR_ObjectToTangent6_g453 );
			float3 INP_VertexPosition15_g456 = VAR_VertexPosRecontructedX28_g453;
			float3 break3_g456 = INP_VertexPosition15_g456;
			float2 appendResult2_g456 = (float2(break3_g456.x , break3_g456.z));
			float2 VAR_WavesCordinates20_g456 = ( appendResult2_g456 * VAR_WaveTiling35_g453 );
			float2 panner6_g456 = ( 1.0 * _Time.y * INP_Direction24_g456 + VAR_WavesCordinates20_g456);
			float simplePerlin2D9_g456 = snoise( panner6_g456 );
			simplePerlin2D9_g456 = simplePerlin2D9_g456*0.5 + 0.5;
			float2 INP_CollisionlWavesOffset57_g456 = VAR_CollisionWaveOffset208_g453;
			float2 VAR_OffsetDirection62_g456 = ( INP_Direction24_g456 * INP_CollisionlWavesOffset57_g456 );
			float2 panner18_g456 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g456 + VAR_WavesCordinates20_g456);
			float simplePerlin2D19_g456 = snoise( panner18_g456 );
			simplePerlin2D19_g456 = simplePerlin2D19_g456*0.5 + 0.5;
			float VAR_SmallWavesPattern78_g456 = ( simplePerlin2D9_g456 * simplePerlin2D19_g456 * VAR_SmallWavesHeightFactor255_g453 );
			float2 VAR_BigWavesCordinates49_g456 = ( appendResult2_g456 * VAR_BigWaveTIle194_g453 );
			float2 panner42_g456 = ( 1.0 * _Time.y * INP_Direction24_g456 + VAR_BigWavesCordinates49_g456);
			float simplePerlin2D35_g456 = snoise( panner42_g456 );
			simplePerlin2D35_g456 = simplePerlin2D35_g456*0.5 + 0.5;
			float2 panner43_g456 = ( 1.0 * _Time.y * VAR_OffsetDirection62_g456 + VAR_BigWavesCordinates49_g456);
			float simplePerlin2D36_g456 = snoise( panner43_g456 );
			simplePerlin2D36_g456 = simplePerlin2D36_g456*0.5 + 0.5;
			float VAR_BigWavesPattern75_g456 = ( simplePerlin2D35_g456 * simplePerlin2D36_g456 * VAR_BigWavesHeightFactor256_g453 );
			float3 appendResult10_g456 = (float3(0.0 , ( VAR_SmallWavesPattern78_g456 + VAR_BigWavesPattern75_g456 ) , 0.0));
			float3 OUT_VertexOffset85_g456 = ( ( appendResult10_g456 * ( ase_vertexNormal * VAR_Amplitude40_g453 ) ) + INP_VertexPosition15_g456 );
			float3 VAR_VertexOffsetDevX57_g453 = OUT_VertexOffset85_g456;
			float3 normalizeResult68_g453 = normalize( cross( ( VAR_VertexOffsetDevY58_g453 - VAR_VertexOffset45_g453 ) , ( VAR_VertexOffsetDevX57_g453 - VAR_VertexOffset45_g453 ) ) );
			float3 VAR_NormalReconstructed69_g453 = normalizeResult68_g453;
			float3 OUT_NormalOffset259 = VAR_NormalReconstructed69_g453;
			float4 screenColor586 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float3( appendResult585 ,  0.0 ) - ( ( OUT_NormalOffset259 * ase_vertex3Pos ) * _Depth__DistortionFactor ) ).xy);
			float4 COLOR_ClearWater600 = screenColor586;
			float MASK_ClearWaterPoints673 = saturate( (0.0 + (saturate( ( saturate( ( 1.0 - ( distance( ase_worldPos , G_Water_ClearZone_1 ) * _ClearWater__Scale ) ) ) + saturate( ( 1.0 - ( distance( ase_worldPos , G_Water_ClearZone_2 ) * _ClearWater__Scale ) ) ) ) ) - 0.0) * (_ClearWater__Factor - 0.0) / (1.0 - 0.0)) );
			float4 lerpResult603 = lerp( ( VAR_FoamColor578 + VAR_DepthColor572 ) , ( COLOR_ClearWater600 + VAR_FoamColor578 ) , MASK_ClearWaterPoints673);
			float4 OUT_BaseColor689 = saturate( lerpResult603 );
			o.Albedo = OUT_BaseColor689.rgb;
			o.Smoothness = _SmoothnessFac;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.CommentaryNode;691;1456,1216;Inherit;False;1062.007;513.5159;;10;601;687;684;674;487;579;603;688;689;573;BaseColor Blend;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;683;16,2224;Inherit;False;1445;526;DEV;11;659;677;676;669;670;672;673;656;662;671;678;ClearWaterMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;653;16,1680;Inherit;False;1194;489.0001;;10;599;588;593;584;598;585;592;587;586;600;Clear Water Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;346;0,128;Inherit;False;1131;246;;5;162;208;236;207;237;Wind Direction Setup;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;162;32,192;Inherit;False;Property;_Wind__DirectionAngle;Wind__Direction Angle;2;0;Create;True;0;0;0;False;0;False;0;90;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;208;320,272;Inherit;False;Property;_Wind__SpeedFactor;Wind__Speed Factor;1;0;Create;True;0;0;0;False;0;False;0;0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;236;320,192;Inherit;False;Direction2D;-1;;3;ac70dfc8e86cbbb48941a8d7b266955a;0;1;27;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;736,192;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;374;-2304,-192;Inherit;False;651;233;;3;371;372;373;Global Cordinates;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;371;-2256,-144;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;237;880,192;Inherit;False;VAR_WindDirection;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;558;-2304,112;Inherit;False;1532;533;;13;526;516;527;515;514;517;513;511;512;510;509;519;556;Foam Pattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;516;-2256,336;Inherit;False;237;VAR_WindDirection;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;372;-2064,-144;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;527;-2032,368;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;373;-1920,-144;Inherit;False;VAR_GlobalCordinates;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;514;-2256,176;Inherit;False;Property;_Foam__Scale;Foam__Scale;11;0;Create;True;0;0;0;False;0;False;0.3;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;517;-1888,432;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;515;-2256,256;Inherit;False;373;VAR_GlobalCordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;511;-1680,176;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;512;-1680,416;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;513;-1680,304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;509;-1440,160;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;510;-1440,384;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;562;-2304,704;Inherit;False;1634;342;;13;503;504;505;557;518;506;520;523;521;525;524;560;561;Foam Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;519;-1168,256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;503;-2256,752;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;556;-1008,256;Inherit;False;PATTERN__Foam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;347;16,448;Inherit;False;1253.123;689.7618;;13;351;359;358;110;238;91;350;340;259;59;486;496;502;Water Genertor;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;504;-2000,752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;557;-1840,928;Inherit;False;556;PATTERN__Foam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;340;48,816;Inherit;False;Property;_Waves__CollisionlOffsetX;Waves__Collisionl Offset X;8;0;Create;True;0;0;0;False;0;False;0;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;505;-2256,848;Inherit;False;Property;_Foam__Border;Foam__Border;12;0;Create;True;0;0;0;False;0;False;20.5;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;350;48,896;Inherit;False;Property;_Waves__CollisionlOffsetY;Waves__Collisionl Offset Y;9;0;Create;True;0;0;0;False;0;False;0;-0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;581;16,1200;Inherit;False;1324;422;;9;564;563;571;565;570;567;566;535;572;Depth Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;506;-1840,832;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;502;48,736;Inherit;False;Property;_Waves__TilingBig;Waves__Tiling Big;4;0;Create;True;0;0;0;False;0;False;0.2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;48,656;Inherit;False;Property;_Waves__TilingSmall;Waves__Tiling Small;3;0;Create;True;0;0;0;False;0;False;0.1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;48,1056;Inherit;False;Property;_Waves__HeightMax;Waves__Height Max;5;0;Create;True;0;0;0;False;0;False;1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;48,976;Inherit;False;237;VAR_WindDirection;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;351;304,816;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;518;-1584,752;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;523;-1616,928;Inherit;False;Property;_Foam__DefinitionFactor;Foam__DefinitionFactor;14;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;561;-1248,960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;560;-1360,912;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;564;64,1424;Inherit;False;Property;_Fog__Depth;Fog__Depth;15;0;Create;True;0;0;0;False;0;False;10;5.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;520;-1424,816;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;259;1008,672;Inherit;False;OUT_NormalOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DepthFade;563;256,1424;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;521;-1200,816;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;571;496,1424;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;525;-1024,816;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;567;496,1504;Inherit;False;Property;_Fog__Factor;Fog__Factor;16;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;580;-2304,1104;Inherit;False;664;342;;4;576;575;577;578;Foam Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;524;-896,816;Inherit;False;MASK_Foam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;570;640,1424;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;575;-2256,1152;Inherit;False;524;MASK_Foam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;566;832,1392;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;535;960,1392;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;577;-2032,1152;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;578;-1872,1152;Inherit;False;VAR_FoamColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;572;1104,1392;Inherit;False;VAR_DepthColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;1008,592;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;496;1008,752;Inherit;False;MASK_BigWavesPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;486;1008,832;Inherit;False;MASK_SmallWavesPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;359;48,576;Inherit;False;Property;_Waves__HeightFactorBig;Waves__Height Factor Big;7;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;358;48,496;Inherit;False;Property;_Waves__HeightFactorSmall;Waves__Height Factor Small;6;0;Create;True;0;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;526;-2256,416;Inherit;False;Property;_Foam__SpeedFactor;Foam__Speed Factor;13;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;652;544,688;Inherit;False;WaterPattern;-1;;453;b87dec47f5fa2bb44a9a3cbd156cc501;0;8;250;FLOAT;1;False;254;FLOAT;1;False;34;FLOAT;0;False;104;FLOAT2;1,0;False;207;FLOAT2;0.5,0.5;False;36;FLOAT2;0,0;False;39;FLOAT;0;False;32;FLOAT;0.05;False;4;FLOAT3;74;FLOAT3;0;FLOAT;299;FLOAT;175
Node;AmplifyShaderEditor.PosVertexDataNode;599;64,1984;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;588;64,1904;Inherit;False;259;OUT_NormalOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;593;256,2048;Inherit;False;Property;_Depth__DistortionFactor;Depth__DistortionFactor;17;0;Create;True;0;0;0;False;0;False;1;0.0001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;584;64,1728;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;598;320,1936;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;585;320,1776;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;592;496,1936;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;587;640,1872;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenColorNode;586;784,1872;Inherit;False;Global;_GrabScreen0;Grab Screen 0;19;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;600;960,1872;Inherit;False;COLOR_ClearWater;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;659;64,2576;Inherit;False;Global;G_Water_ClearZone_2;G_Water_ClearZone_2;37;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;677;320,2576;Inherit;False;ProximityMask;-1;;457;032017421c799b24a9911b3ca1595579;0;2;7;FLOAT;0;False;8;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;676;320,2288;Inherit;False;ProximityMask;-1;;458;032017421c799b24a9911b3ca1595579;0;2;7;FLOAT;0;False;8;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;669;592,2432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;670;720,2432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;672;1056,2432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;673;1184,2432;Inherit;False;MASK_ClearWaterPoints;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;656;64,2288;Inherit;False;Global;G_Water_ClearZone_1;G_Water_ClearZone_1;20;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;662;64,2464;Inherit;False;Property;_ClearWater__Scale;ClearWater__Scale;25;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;671;848,2416;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;678;576,2576;Inherit;False;Property;_ClearWater__Factor;ClearWater__Factor;24;0;Create;True;0;0;0;False;0;False;2.42;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;687;1792,1456;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;674;1504,1616;Inherit;False;673;MASK_ClearWaterPoints;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;603;1984,1456;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;688;2144,1456;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;689;2288,1456;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3619.337,1093.253;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;LemuWater;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.45;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;-1;-1;-1;19;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;3235.337,1445.253;Inherit;False;259;OUT_NormalOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;3235.337,1365.253;Inherit;False;59;OUT_VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;579;1792,1312;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;690;3232,1088;Inherit;False;689;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;12;3232,1184;Inherit;False;Property;_SmoothnessFac;SmoothnessFac;0;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;565;496,1248;Inherit;False;Property;_Fog_Color;Fog_Color;18;0;Create;True;0;0;0;False;0;False;0.2186721,0.370783,0.735849,0;0.2186721,0.370783,0.735849,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;573;1504,1264;Inherit;False;578;VAR_FoamColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;576;-2256,1232;Inherit;False;Property;_Foam__Color;Foam__Color;10;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;601;1504,1456;Inherit;False;600;COLOR_ClearWater;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;684;1504,1536;Inherit;False;578;VAR_FoamColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;487;1502.76,1360;Inherit;False;572;VAR_DepthColor;1;0;OBJECT;;False;1;COLOR;0
WireConnection;236;27;162;0
WireConnection;207;0;236;0
WireConnection;207;1;208;0
WireConnection;237;0;207;0
WireConnection;372;0;371;1
WireConnection;372;1;371;3
WireConnection;527;0;516;0
WireConnection;527;1;526;0
WireConnection;373;0;372;0
WireConnection;517;0;527;0
WireConnection;511;0;515;0
WireConnection;511;2;527;0
WireConnection;512;0;515;0
WireConnection;512;2;517;0
WireConnection;513;0;514;0
WireConnection;509;0;511;0
WireConnection;509;1;513;0
WireConnection;510;0;512;0
WireConnection;510;1;513;0
WireConnection;519;0;509;0
WireConnection;519;1;510;0
WireConnection;556;0;519;0
WireConnection;504;0;503;0
WireConnection;506;0;504;0
WireConnection;506;1;505;0
WireConnection;351;0;340;0
WireConnection;351;1;350;0
WireConnection;518;0;504;0
WireConnection;518;1;557;0
WireConnection;561;0;523;0
WireConnection;560;0;523;0
WireConnection;520;0;518;0
WireConnection;520;1;506;0
WireConnection;259;0;652;0
WireConnection;563;0;564;0
WireConnection;521;0;520;0
WireConnection;521;3;560;0
WireConnection;521;4;561;0
WireConnection;571;0;563;0
WireConnection;525;0;521;0
WireConnection;524;0;525;0
WireConnection;570;0;571;0
WireConnection;566;0;565;0
WireConnection;566;1;570;0
WireConnection;566;2;567;0
WireConnection;535;0;566;0
WireConnection;577;0;575;0
WireConnection;577;1;576;0
WireConnection;578;0;577;0
WireConnection;572;0;535;0
WireConnection;59;0;652;74
WireConnection;496;0;652;299
WireConnection;486;0;652;175
WireConnection;652;250;358;0
WireConnection;652;254;359;0
WireConnection;652;34;91;0
WireConnection;652;104;502;0
WireConnection;652;207;351;0
WireConnection;652;36;238;0
WireConnection;652;39;110;0
WireConnection;598;0;588;0
WireConnection;598;1;599;0
WireConnection;585;0;584;1
WireConnection;585;1;584;2
WireConnection;592;0;598;0
WireConnection;592;1;593;0
WireConnection;587;0;585;0
WireConnection;587;1;592;0
WireConnection;586;0;587;0
WireConnection;600;0;586;0
WireConnection;677;7;662;0
WireConnection;677;8;659;0
WireConnection;676;7;662;0
WireConnection;676;8;656;0
WireConnection;669;0;676;0
WireConnection;669;1;677;0
WireConnection;670;0;669;0
WireConnection;672;0;671;0
WireConnection;673;0;672;0
WireConnection;671;0;670;0
WireConnection;671;4;678;0
WireConnection;687;0;601;0
WireConnection;687;1;684;0
WireConnection;603;0;579;0
WireConnection;603;1;687;0
WireConnection;603;2;674;0
WireConnection;688;0;603;0
WireConnection;689;0;688;0
WireConnection;0;0;690;0
WireConnection;0;4;12;0
WireConnection;0;11;60;0
WireConnection;0;12;148;0
WireConnection;579;0;573;0
WireConnection;579;1;487;0
ASEEND*/
//CHKSM=56E0749E67C049F1B345E8D32D98E1082DC11D7F