// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Nature/Water"
{
	Properties
	{
		_Waves__ColorPrimary("Waves__Color Primary", Color) = (0.510235,0.8939884,0.9245283,0)
		_Waves__ColorSecondary("Waves__Color Secondary", Color) = (0.510235,0.8939884,0.9245283,0)
		_Waves__ScaleX("Waves__Scale  X", Range( 0 , 1)) = 0.368
		_Waves__ScaleY("Waves__Scale Y", Range( 0 , 1)) = 0.372
		_Waves__SpeedDirX("Waves__Speed Dir X", Range( 0 , 1)) = 0
		_Waves__SpeedDirY("Waves__Speed Dir Y", Range( 0 , 1)) = 0
		_Waves__SpeedFactor("Waves__Speed Factor", Range( 0 , 2)) = 0
		_Waves__NormalFactor("Waves__Normal Factor", Float) = 0
		_BigWaves__Scale("Big Waves__Scale", Float) = 0.2
		_BigWaves__Speed("Big Waves__Speed", Float) = 3
		_BigWaves__LevelsMin("Big Waves__Levels Min", Float) = 0.89
		_BigWaves__LevelsMax("Big Waves__Levels Max", Float) = 0.89
		_Depth__Color("Depth__Color", Color) = (0.990566,0.1170263,0,0)
		_Depth__Distance("Depth__Distance", Range( 0 , 1)) = 0
		_Foam__Border("Foam__Border", Range( 0 , 1)) = 0
		_Foam__Distance("Foam__Distance", Range( 0 , 1)) = 0
		_Foam__Scale("Foam__Scale", Range( 0 , 1)) = 0
		_Foam__Color("Foam__Color", Color) = (0.990566,0.1170263,0,0)
		_Foam__BorderBlend("Foam__Border Blend", Range( 0 , 1)) = 0
		_Foam__RangeMin("Foam__Range Min", Range( 0 , 1)) = 0
		_Foam__RangeMax("Foam__Range Max", Range( 0 , 1)) = 0
		_Water__PatternScale("Water__Pattern Scale", Float) = 7.37
		_Water__PatternDetailSpeed("Water__Pattern Detail Speed", Float) = 1
		_Water__DetailPatternFactor("Water__Detail Pattern Factor", Range( 0 , 1)) = 0
		_Float0("Float 0", Float) = 0
		_Water__Pattern_OffsetScale("Water__Pattern_Offset Scale", Float) = 0
		_Float1("Float 1", Float) = 0
		_Float5("Float 5", Float) = 0.1
		_Float3("Float 3", Float) = 0.1
		_Float2("Float 2", Float) = 0
		_Float8("Float 8", Float) = 0
		_Float4("Float 4", Float) = 0
		_Water__TransparentFac("Water__TransparentFac", Range( 0 , 1)) = 0
		_Float7("Float 7", Float) = 0
		_Water__Smoothness("Water__Smoothness", Range( 0 , 1)) = 1
		_Water__OpacityFactor("Water__Opacity Factor", Range( 0 , 1)) = 0
		_ClearWaterFac("ClearWaterFac", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
		#pragma target 4.6
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Standard alpha:fade keepalpha vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float4 screenPos;
			float eyeDepth;
		};

		uniform float _Waves__SpeedFactor;
		uniform float _Waves__SpeedDirX;
		uniform float _Waves__SpeedDirY;
		uniform float _Waves__ScaleX;
		uniform float _Waves__ScaleY;
		uniform float _BigWaves__Speed;
		uniform float _BigWaves__Scale;
		uniform float _BigWaves__LevelsMin;
		uniform float _BigWaves__LevelsMax;
		uniform float _Waves__NormalFactor;
		uniform float _Water__PatternScale;
		uniform float _Water__PatternDetailSpeed;
		uniform float _Water__Pattern_OffsetScale;
		uniform float4 _Depth__Color;
		uniform float _Water__DetailPatternFactor;
		uniform float4 _Waves__ColorPrimary;
		uniform float4 _Waves__ColorSecondary;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth__Distance;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float3 ClearWater_1;
		uniform float _ClearWaterFac;
		uniform float3 ClearWater_2;
		uniform float _Water__TransparentFac;
		uniform float4 _Foam__Color;
		uniform float3 Cascade_1;
		uniform float _Float0;
		uniform float _Float3;
		uniform float _Float4;
		uniform float3 Cascade_2;
		uniform float _Float1;
		uniform float _Float5;
		uniform float _Float7;
		uniform float3 Cascade_3;
		uniform float _Float2;
		uniform float _Float8;
		uniform float _Foam__Distance;
		uniform float _Foam__Border;
		uniform float _Foam__Scale;
		uniform float _Foam__RangeMin;
		uniform float _Foam__RangeMax;
		uniform float _Water__Smoothness;
		uniform float _Water__OpacityFactor;
		uniform float _Foam__BorderBlend;


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


		float3 PerturbNormal107_g34( float3 surf_pos, float3 surf_norm, float height, float scale )
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


		float2 voronoihash385( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi385( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash385( n + g );
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


		float2 voronoihash405( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi405( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash405( n + g );
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
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 surf_pos107_g34 = ase_worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 surf_norm107_g34 = ase_worldNormal;
			float2 appendResult186 = (float2(( _Waves__SpeedFactor * _Waves__SpeedDirX ) , ( _Waves__SpeedDirY * _Waves__SpeedFactor )));
			float2 SpeedDirWaves158 = appendResult186;
			float2 appendResult15 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 WorldSpaceUV16 = appendResult15;
			float2 appendResult178 = (float2(( _Waves__ScaleX * 0.4 ) , ( _Waves__ScaleY * 0.4 )));
			float2 temp_output_24_0 = ( ( WorldSpaceUV16 * appendResult178 ) * 1.0 );
			float2 panner11 = ( 1.0 * _Time.y * SpeedDirWaves158 + temp_output_24_0);
			float simplePerlin2D9 = snoise( panner11 );
			simplePerlin2D9 = simplePerlin2D9*0.5 + 0.5;
			float2 temp_output_192_0 = ( ( 1.0 - SpeedDirWaves158 ) * _Waves__SpeedFactor );
			float2 panner49 = ( 1.0 * _Time.y * temp_output_192_0 + temp_output_24_0);
			float simplePerlin2D48 = snoise( panner49 );
			simplePerlin2D48 = simplePerlin2D48*0.5 + 0.5;
			float2 panner265 = ( 1.0 * _Time.y * ( temp_output_192_0 * _BigWaves__Speed ) + temp_output_24_0);
			float simplePerlin2D250 = snoise( panner265*_BigWaves__Scale );
			simplePerlin2D250 = simplePerlin2D250*0.5 + 0.5;
			float2 panner267 = ( 1.0 * _Time.y * ( ( SpeedDirWaves158 * 1.0 ) * _BigWaves__Speed ) + temp_output_24_0);
			float simplePerlin2D268 = snoise( panner267*_BigWaves__Scale );
			simplePerlin2D268 = simplePerlin2D268*0.5 + 0.5;
			float WavesPattern66 = ( simplePerlin2D9 + simplePerlin2D48 + (_BigWaves__LevelsMin + (simplePerlin2D250 - 0.0) * (_BigWaves__LevelsMax - _BigWaves__LevelsMin) / (1.0 - 0.0)) + (_BigWaves__LevelsMin + (simplePerlin2D268 - 0.0) * (_BigWaves__LevelsMax - _BigWaves__LevelsMin) / (1.0 - 0.0)) );
			float height107_g34 = ( WavesPattern66 * _Waves__NormalFactor );
			float scale107_g34 = 1.0;
			float3 localPerturbNormal107_g34 = PerturbNormal107_g34( surf_pos107_g34 , surf_norm107_g34 , height107_g34 , scale107_g34 );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g34 = mul( ase_worldToTangent, localPerturbNormal107_g34);
			float3 NormalOutput300 = worldToTangentDir42_g34;
			o.Normal = NormalOutput300;
			float mulTime399 = _Time.y * _Water__PatternDetailSpeed;
			float time385 = mulTime399;
			float2 voronoiSmoothId385 = 0;
			float2 coords385 = i.uv_texcoord * _Water__PatternScale;
			float2 id385 = 0;
			float2 uv385 = 0;
			float voroi385 = voronoi385( coords385, time385, id385, uv385, 0, voronoiSmoothId385 );
			float mulTime404 = _Time.y * -_Water__PatternDetailSpeed;
			float time405 = mulTime404;
			float2 voronoiSmoothId405 = 0;
			float2 coords405 = i.uv_texcoord * ( _Water__PatternScale - _Water__Pattern_OffsetScale );
			float2 id405 = 0;
			float2 uv405 = 0;
			float voroi405 = voronoi405( coords405, time405, id405, uv405, 0, voronoiSmoothId405 );
			float4 lerpResult58 = lerp( _Waves__ColorPrimary , _Waves__ColorSecondary , saturate( WavesPattern66 ));
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth60 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth60 = abs( ( screenDepth60 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( ( _Depth__Distance * 10.0 ) ) );
			float DepthWaterMask94 = saturate( ( 1.0 - distanceDepth60 ) );
			float cameraDepthFade338 = (( i.eyeDepth -_ProjectionParams.y - 10.0 ) / -22.2);
			float4 lerpResult77 = lerp( lerpResult58 , _Depth__Color , ( DepthWaterMask94 - saturate( cameraDepthFade338 ) ));
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult563 = (float2(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g));
			float4 screenColor427 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float3( appendResult563 ,  0.0 ) - ( NormalOutput300 * 0.1 ) ).xy);
			float4 DepthWavesEffect568 = screenColor427;
			float ClearWaterPointsMask605 = saturate( (0.0 + (saturate( ( saturate( ( 1.0 - ( distance( ase_worldPos , ClearWater_1 ) * _ClearWaterFac ) ) ) + saturate( ( 1.0 - ( distance( ase_worldPos , ClearWater_2 ) * _ClearWaterFac ) ) ) ) ) - 0.0) * (4.0 - 0.0) / (1.0 - 0.0)) );
			float4 lerpResult573 = lerp( ( ( ( ( voroi385 * voroi405 ) * _Depth__Color ) * _Water__DetailPatternFactor ) + saturate( lerpResult77 ) ) , DepthWavesEffect568 , ClearWaterPointsMask605);
			float temp_output_452_0 = distance( ase_worldPos , Cascade_1 );
			float2 temp_cast_2 = (_Float3).xx;
			float3 temp_cast_3 = (temp_output_452_0).xxx;
			float3 break496 = ( ase_worldPos - temp_cast_3 );
			float4 appendResult495 = (float4(break496.y , break496.x , break496.z , 0.0));
			float2 panner488 = ( 1.0 * _Time.y * temp_cast_2 + appendResult495.xy);
			float simplePerlin2D489 = snoise( panner488*_Float4 );
			simplePerlin2D489 = simplePerlin2D489*0.5 + 0.5;
			float2 temp_cast_5 = (( _Float3 + 0.5 )).xx;
			float2 panner501 = ( 1.0 * _Time.y * temp_cast_5 + appendResult495.xy);
			float simplePerlin2D502 = snoise( panner501*( _Float4 + 0.5 ) );
			simplePerlin2D502 = simplePerlin2D502*0.5 + 0.5;
			float temp_output_464_0 = distance( ase_worldPos , Cascade_2 );
			float2 temp_cast_7 = (_Float5).xx;
			float3 temp_cast_8 = (temp_output_464_0).xxx;
			float3 break511 = ( ase_worldPos - temp_cast_8 );
			float4 appendResult515 = (float4(break511.y , break511.x , break511.z , 0.0));
			float2 panner517 = ( 1.0 * _Time.y * temp_cast_7 + appendResult515.xy);
			float simplePerlin2D519 = snoise( panner517*_Float7 );
			simplePerlin2D519 = simplePerlin2D519*0.5 + 0.5;
			float2 temp_cast_10 = (( _Float5 + 0.5 )).xx;
			float2 panner518 = ( 1.0 * _Time.y * temp_cast_10 + appendResult515.xy);
			float simplePerlin2D520 = snoise( panner518*( _Float7 + 0.5 ) );
			simplePerlin2D520 = simplePerlin2D520*0.5 + 0.5;
			float temp_output_468_0 = distance( ase_worldPos , Cascade_3 );
			float2 temp_cast_12 = (0.1).xx;
			float3 temp_cast_13 = (temp_output_468_0).xxx;
			float3 break527 = ( ase_worldPos - temp_cast_13 );
			float4 appendResult531 = (float4(break527.y , break527.x , break527.z , 0.0));
			float2 panner533 = ( 1.0 * _Time.y * temp_cast_12 + appendResult531.xy);
			float simplePerlin2D535 = snoise( panner533*_Float8 );
			simplePerlin2D535 = simplePerlin2D535*0.5 + 0.5;
			float2 temp_cast_15 = (( 0.1 + 0.5 )).xx;
			float2 panner534 = ( 1.0 * _Time.y * temp_cast_15 + appendResult531.xy);
			float simplePerlin2D536 = snoise( panner534*( _Float8 + 0.5 ) );
			simplePerlin2D536 = simplePerlin2D536*0.5 + 0.5;
			float Cascade_Mask542 = saturate( ( saturate( ( saturate( ( 1.0 - ( temp_output_452_0 * _Float0 ) ) ) - saturate( ( (0.0 + (simplePerlin2D489 - 0.44) * (1.0 - 0.0) / (1.0 - 0.44)) + (0.0 + (simplePerlin2D502 - 0.44) * (1.0 - 0.0) / (1.0 - 0.44)) ) ) ) ) + saturate( ( saturate( ( 1.0 - ( temp_output_464_0 * _Float1 ) ) ) - saturate( ( (0.0 + (simplePerlin2D519 - 0.44) * (1.0 - 0.0) / (1.0 - 0.44)) + (0.0 + (simplePerlin2D520 - 0.44) * (1.0 - 0.0) / (1.0 - 0.44)) ) ) ) ) + saturate( ( saturate( ( 1.0 - ( temp_output_468_0 * _Float2 ) ) ) - saturate( ( (0.0 + (simplePerlin2D535 - 0.44) * (1.0 - 0.0) / (1.0 - 0.44)) + (0.0 + (simplePerlin2D536 - 0.44) * (1.0 - 0.0) / (1.0 - 0.44)) ) ) ) ) ) );
			float screenDepth70 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth70 = abs( ( screenDepth70 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( ( _Foam__Distance * 10.0 ) ) );
			float temp_output_71_0 = ( 1.0 - distanceDepth70 );
			float2 panner102 = ( 1.0 * _Time.y * SpeedDirWaves158 + WorldSpaceUV16);
			float temp_output_205_0 = ( _Foam__Scale * 10.0 );
			float simplePerlin2D98 = snoise( panner102*temp_output_205_0 );
			simplePerlin2D98 = simplePerlin2D98*0.5 + 0.5;
			float2 panner105 = ( 1.0 * _Time.y * ( ( 1.0 - SpeedDirWaves158 ) * _Waves__SpeedFactor ) + WorldSpaceUV16);
			float simplePerlin2D104 = snoise( panner105*temp_output_205_0 );
			simplePerlin2D104 = simplePerlin2D104*0.5 + 0.5;
			float BorderWatherMask91 = saturate( (0.0 + (( ( temp_output_71_0 - _Foam__Border ) + ( temp_output_71_0 * ( simplePerlin2D98 * simplePerlin2D104 ) ) ) - _Foam__RangeMin) * (1.0 - 0.0) / (_Foam__RangeMax - _Foam__RangeMin)) );
			float4 lerpResult79 = lerp( saturate( ( lerpResult573 * _Water__TransparentFac ) ) , _Foam__Color , saturate( ( Cascade_Mask542 + BorderWatherMask91 ) ));
			float4 temp_output_21_0_g35 = saturate( lerpResult79 );
			float4 color20_g35 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_17 = (0.1).xx;
			float2 appendResult5_g35 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g35 = ( 0.01 * 1.5 );
			float2 panner10_g36 = ( 1.0 * _Time.y * temp_cast_17 + ( appendResult5_g35 * temp_output_2_0_g35 ));
			float simplePerlin2D11_g36 = snoise( panner10_g36 );
			simplePerlin2D11_g36 = simplePerlin2D11_g36*0.5 + 0.5;
			float temp_output_8_0_g35 = simplePerlin2D11_g36;
			float2 temp_cast_18 = (0.1).xx;
			float2 panner10_g38 = ( 1.0 * _Time.y * temp_cast_18 + ( appendResult5_g35 * 0.01 ));
			float simplePerlin2D11_g38 = snoise( panner10_g38 );
			simplePerlin2D11_g38 = simplePerlin2D11_g38*0.5 + 0.5;
			float2 temp_cast_19 = (0.1).xx;
			float2 panner10_g37 = ( 1.0 * _Time.y * temp_cast_19 + ( appendResult5_g35 * ( temp_output_2_0_g35 * 4.0 ) ));
			float simplePerlin2D11_g37 = snoise( panner10_g37 );
			simplePerlin2D11_g37 = simplePerlin2D11_g37*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g35 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g35 * simplePerlin2D11_g38 ) + ( 1.0 - simplePerlin2D11_g37 ) ) * temp_output_8_0_g35 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g35 = lerp( temp_output_21_0_g35 , saturate( ( temp_output_21_0_g35 * color20_g35 ) ) , ( temp_output_16_0_g35 * 1.0 ));
			float4 BaseColorOutput302 = lerpResult24_g35;
			o.Albedo = BaseColorOutput302.rgb;
			o.Smoothness = _Water__Smoothness;
			float temp_output_90_0 = ( DepthWaterMask94 + BorderWatherMask91 );
			float screenDepth307 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth307 = abs( ( screenDepth307 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Foam__BorderBlend ) );
			float OpacityOutput312 = ( saturate( ( temp_output_90_0 + ( ( 1.0 - temp_output_90_0 ) * _Water__OpacityFactor ) + Cascade_Mask542 ) ) - saturate( ( 1.0 - distanceDepth307 ) ) );
			o.Alpha = OpacityOutput312;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
1166;1266;1515;726;71.79565;1710.06;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;163;-3566.45,-1046.791;Inherit;False;1002.902;2299.046;Variables;18;203;69;202;201;200;199;181;180;158;179;186;182;187;188;87;183;184;185;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-3536,-896;Inherit;False;Property;_Waves__SpeedDirY;Waves__Speed Dir Y;5;0;Create;True;0;0;0;False;0;False;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;183;-3517.823,-116.426;Inherit;False;Property;_Waves__SpeedFactor;Waves__Speed Factor;6;0;Create;True;0;0;0;False;0;False;0;0.8;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;87;-3427.739,912.4824;Inherit;False;700.8978;243.0804;WordSpaceUV;3;14;15;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-3536,-992;Inherit;False;Property;_Waves__SpeedDirX;Waves__Speed Dir X;4;0;Create;True;0;0;0;False;0;False;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-3200,-864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;14;-3377.739,962.4822;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-3200,-992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-3548.823,491.574;Inherit;False;Property;_Waves__ScaleX;Waves__Scale  X;2;0;Create;True;0;0;0;False;0;False;0.368;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;186;-3040,-928;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-3136.688,965.5623;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-3549.823,635.5737;Inherit;False;Property;_Waves__ScaleY;Waves__Scale Y;3;0;Create;True;0;0;0;False;0;False;0.372;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-2848,-928;Inherit;False;SpeedDirWaves;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-2951.841,988.9434;Inherit;False;WorldSpaceUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;-3165.823,619.5737;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;86;-2505.23,355.7284;Inherit;False;2697.585;1213.271;Waves patern;42;66;38;273;9;257;48;49;276;11;250;268;275;292;265;281;288;251;267;289;285;283;271;266;287;282;286;272;192;270;284;290;291;278;24;121;18;25;277;178;17;161;425;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;-3165.823,523.5739;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-2464,414;Inherit;False;16;WorldSpaceUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;178;-2464,526;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;-2464,702;Inherit;False;158;SpeedDirWaves;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2208,414;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;199;-3227.11,812.9337;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2208,590;Inherit;False;Constant;_AuxEx_1;AuxEx_1;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;277;-2256,974;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;291;-1744,734;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2048,414;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;200;-3207.395,834.6201;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;278;-2240,990;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;121;-2192,766;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;272;-2017,1166;Inherit;False;Property;_BigWaves__Speed;Big Waves__Speed;9;0;Create;True;0;0;0;False;0;False;3;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;270;-2016,958;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-2016,766;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;286;-1648,414;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;284;-1648,414;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;290;-1728,718;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;434;1373.012,1179.741;Inherit;False;Global;Cascade_1;Cascade_1;30;0;Create;True;0;0;0;False;0;False;0,0,0;25.91,1.11,21.15;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;-1776,1310;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;289;-1728,510;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;282;-1632,430;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;285;-1632,430;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;-1792,1006;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;287;-1648,414;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;283;-1648,414;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;436;1370.758,1869.604;Inherit;False;Global;Cascade_3;Cascade_3;30;0;Create;True;0;0;0;False;0;False;0,0,0;39.72,0.91,24.5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;457;1381.727,762.6758;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;435;1385.182,1420.164;Inherit;False;Global;Cascade_2;Cascade_2;30;0;Create;True;0;0;0;False;0;False;0,0,0;33.34,0.91,23.05;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;292;-1712,494;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;267;-1536,1294;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;251;-1280,1134;Inherit;False;Property;_BigWaves__Scale;Big Waves__Scale;8;0;Create;True;0;0;0;False;0;False;0.2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;288;-1632,430;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;265;-1536,1006;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;281;-1632,430;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;464;1982.623,1470.851;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;452;1959.411,1146.539;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;468;1982.146,1797.008;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;510;3177.507,910.3454;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-768,1454;Inherit;False;Property;_BigWaves__LevelsMax;Big Waves__Levels Max;11;0;Create;True;0;0;0;False;0;False;0.89;-1.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;11;-1536,430;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;49;-1536,718;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;494;3243.861,206.7744;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;250;-1024,1006;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;275;-768,1374;Inherit;False;Property;_BigWaves__LevelsMin;Big Waves__Levels Min;10;0;Create;True;0;0;0;False;0;False;0.89;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;526;3174.163,1521.333;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;85;-2483.979,-744.7645;Inherit;False;2090.815;1029.931;Foam;27;91;81;110;72;119;112;113;115;97;71;106;116;70;98;104;205;102;105;101;189;100;160;159;545;543;546;547;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;268;-1024,1294;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;273;-400,1294;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;257;-416,1022;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;48;-1024,718;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;512;3487.814,1062.859;Inherit;False;Property;_Float5;Float 5;27;0;Create;True;0;0;0;False;0;False;0.1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;9;-1024,430;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;-2451.696,-37.19388;Inherit;False;158;SpeedDirWaves;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;496;3400.466,206.2589;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;528;3411.469,1690.847;Inherit;False;Constant;_Float6;Float 6;33;0;Create;True;0;0;0;False;0;False;0.1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;527;3330.768,1520.817;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;201;-3181.192,129.2375;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;490;3554.167,359.2883;Inherit;False;Property;_Float3;Float 3;28;0;Create;True;0;0;0;False;0;False;0.1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;511;3334.113,909.8299;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;84;-1776,-1360;Inherit;False;1362.402;543.1866;Depth Water;11;63;94;82;65;60;197;61;341;343;423;424;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;590;3419.592,-641.2767;Inherit;False;Global;ClearWater_1;ClearWater_1;37;0;Create;True;0;0;0;False;0;False;0,0,0;250.3,2.78,72.7;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;591;3404.592,-269.2759;Inherit;False;Global;ClearWater_2;ClearWater_2;37;0;Create;True;0;0;0;False;0;False;0,0,0;247,2.78,227.2;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;593;3299.789,-459.8232;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;513;3663.814,1094.859;Inherit;False;Property;_Float7;Float 7;34;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;202;-3163.622,138.0228;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;160;-2400,48;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;495;3552.466,207.2589;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;514;3426.627,1231.843;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;531;3482.768,1521.817;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;497;3730.167,391.2883;Inherit;False;Property;_Float4;Float 4;32;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;530;3423.282,1842.831;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;515;3486.113,910.8299;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;504;3492.98,528.2723;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;529;3660.469,1705.847;Inherit;False;Property;_Float8;Float 8;31;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-128,958;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;299;189.9106,-736.2684;Inherit;False;933.308;253.9423;Normal;5;172;164;171;168;300;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;0,958;Inherit;False;WavesPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;505;3698.98,638.2724;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1744,-1296;Inherit;False;Property;_Depth__Distance;Depth__Distance;13;0;Create;True;0;0;0;False;0;False;0;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;598;3667.415,-313.1901;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;592;3664.625,-624.7122;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;595;3646.076,-485.1624;Inherit;False;Property;_ClearWaterFac;ClearWaterFac;37;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;532;3629.282,1952.831;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-3536,-448;Inherit;False;Property;_Foam__Distance;Foam__Distance;15;0;Create;True;0;0;0;False;0;False;0;0.314;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;516;3632.627,1341.843;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;501;3640.78,499.2723;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-2240,80;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;488;3698.167,215.2883;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;533;3628.469,1529.847;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;518;3574.427,1202.843;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;534;3571.083,1813.831;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;517;3631.814,918.8592;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-2455.898,-119.8135;Inherit;False;16;WorldSpaceUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-2464,-208;Inherit;False;Property;_Foam__Scale;Foam__Scale;16;0;Create;True;0;0;0;False;0;False;0;0.287;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;221.9106,-672.2685;Inherit;False;66;WavesPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;-1488,-1296;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;416;-1888,-2592;Inherit;False;1476;608;Pattern Detail;12;386;399;400;406;387;414;404;405;385;407;411;430;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;594;3813.315,-557.3109;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;599;3839.275,-379.1048;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;536;3779.083,1813.831;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;465;2016.256,1695.787;Inherit;False;Property;_Float1;Float 1;26;0;Create;True;0;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;535;3836.469,1529.847;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;221.9106,-576.2685;Inherit;False;Property;_Waves__NormalFactor;Waves__Normal Factor;7;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;520;3782.427,1202.843;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;489;3906.167,215.2883;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;102;-2084.534,-262.6619;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;502;3848.78,499.2723;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;519;3839.814,918.8592;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;469;2015.779,2021.943;Inherit;False;Property;_Float2;Float 2;29;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;-3184,-448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;105;-2063.131,2.691421;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;462;1993.045,1371.475;Inherit;False;Property;_Float0;Float 0;24;0;Create;True;0;0;0;False;0;False;0;0.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;-2048,-128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;400;-1840,-2416;Inherit;False;Property;_Water__PatternDetailSpeed;Water__Pattern Detail Speed;22;0;Create;True;0;0;0;False;0;False;1;2.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;98;-1751.119,-259.3956;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;60;-1328,-1296;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;600;3986.275,-374.1048;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;522;4111.814,918.8592;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;461.9104,-672.2685;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;467;2189.778,1933.943;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;596;3953.482,-555.2183;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;537;4051.083,1813.831;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;503;4120.781,499.2723;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;521;4054.427,1202.843;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;2190.255,1607.787;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;498;4178.168,215.2883;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;104;-1740.538,-18.2953;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;461;2167.045,1283.475;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;70;-2432.623,-483.3344;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;538;4108.47,1529.847;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;343;-1093,-1040;Inherit;False;524;207;Le resto el Depth que genera la camara;2;338;342;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;406;-1552,-2256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;430;-1584,-2144;Inherit;False;Property;_Water__Pattern_OffsetScale;Water__Pattern_Offset Scale;25;0;Create;True;0;0;0;False;0;False;0;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;83;-1536,-1952;Inherit;False;886.8557;570.4091;WavesBaseColor;5;68;59;56;57;58;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;387;-1552,-2336;Inherit;False;Property;_Water__PatternScale;Water__Pattern Scale;21;0;Create;True;0;0;0;False;0;False;7.37;28.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;65;-1104,-1296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;603;4092.535,-485.7332;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;168;605.9103,-672.2685;Inherit;False;Normal From Height;-1;;34;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;471;2295.567,1432.631;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;523;4434.149,1086.034;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;539;4430.805,1697.022;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-1445.674,-72.75952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;472;2398.568,1661.631;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;71;-2161.936,-482.9304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;604;4136.535,-332.7332;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-2288,-384;Inherit;False;Property;_Foam__Border;Foam__Border;14;0;Create;True;0;0;0;False;0;False;0;0.527;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;506;4500.503,382.4636;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;459;2327.045,1155.475;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;386;-1552,-2544;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;602;4224.23,-481.7964;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;414;-1280,-2176;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;399;-1552,-2416;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;338;-1056,-976;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;-22.2;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;404;-1280,-2256;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;63;-1040,-1216;Inherit;False;Property;_Depth__Color;Depth__Color;12;0;Create;True;0;0;0;False;0;False;0.990566,0.1170263,0,0;0.4394343,0.745283,0.6508056,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;82;-944,-1296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;508;4705.1,435.0063;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;474;2502.125,1156.319;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;524;4638.746,1138.577;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;475;2471.125,1515.319;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;540;4676.401,1695.565;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-1488,-1504;Inherit;False;66;WavesPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;115;-1938.48,-558.1832;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;476;2548.125,1635.319;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-1692.851,-470.9874;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;300;928,-672;Inherit;False;NormalOutput;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;562;62.82843,-2112.468;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;57;-1248,-1712;Inherit;False;Property;_Waves__ColorSecondary;Waves__Color Secondary;1;0;Create;True;0;0;0;False;0;False;0.510235,0.8939884,0.9245283,0;0.345098,0.6219615,0.7058823,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;424;-629.5072,-1200.23;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;59;-1152,-1488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;342;-784,-976;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;564;59.61261,-1908.516;Inherit;False;300;NormalOutput;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;56;-1248,-1904;Inherit;False;Property;_Waves__ColorPrimary;Waves__Color Primary;0;0;Create;True;0;0;0;False;0;False;0.510235,0.8939884,0.9245283,0;0.141772,0.2197466,0.56,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;597;4423.547,-479.4374;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-800,-1296;Inherit;False;DepthWaterMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;405;-1056,-2288;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;567;149.474,-1837.612;Inherit;False;Constant;_Float9;Float 9;39;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;385;-1056,-2544;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RangedFloatNode;113;-1312,-224;Inherit;False;Property;_Foam__RangeMax;Foam__Range Max;20;0;Create;True;0;0;0;False;0;False;0;0.456;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;525;4842.192,1230.698;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;507;4853.977,543.5468;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;541;4839.203,1457.661;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-1521.63,-516.3461;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-1311.755,-324.339;Inherit;False;Property;_Foam__RangeMin;Foam__Range Min;19;0;Create;True;0;0;0;False;0;False;0;0.43;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;550;5092.404,1272.483;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;607;4551.855,-415.4002;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;318;-208,-1376;Inherit;False;1612.941;303.0804;Base Color Blend;11;417;77;410;174;79;154;302;298;418;420;571;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;566;372.4748,-1933.612;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;423;-592,-1280;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;341;-544,-1136;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;563;315.2935,-2098.727;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;407;-864,-2432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;58;-912,-1744;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;549;5058.931,912.7369;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;110;-975,-399;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;509;5026.629,536.5956;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;548;5343.207,850.9645;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;411;-544,-2432;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;608;4761.855,-374.4002;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;418;-160,-1312;Inherit;False;Property;_Water__DetailPatternFactor;Water__Detail Pattern Factor;23;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;81;-774,-408;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;-160,-1216;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;565;526.4749,-2077.612;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenColorNode;427;578.2347,-1938.252;Inherit;False;Global;_GrabScreen1;Grab Screen 1;29;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;605;4969.495,-397.0266;Inherit;False;ClearWaterPointsMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;470;5533.689,978.8055;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-640,-416;Inherit;False;BorderWatherMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;420;96,-1200;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;317;-193.572,-364.0466;Inherit;False;1344.356;412.1401;Opacity Blend;15;349;307;308;312;350;351;173;346;310;345;90;96;92;88;554;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;417;192,-1312;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;606;214.0944,-1561.139;Inherit;False;605;ClearWaterPointsMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;410;340,-1224;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;568;497.9141,-1698.688;Inherit;False;DepthWavesEffect;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-160,-240;Inherit;False;91;BorderWatherMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;542;5721.999,989.6003;Inherit;False;Cascade_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-160,-320;Inherit;False;94;DepthWaterMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;573;562.6455,-1499.18;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;64,-304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;571;541.4712,-1366.15;Inherit;False;Property;_Water__TransparentFac;Water__TransparentFac;33;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;545;-999.6594,-97.29277;Inherit;False;91;BorderWatherMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;543;-956.5451,-189.6922;Inherit;False;542;Cascade_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;546;-765.6597,-163.2928;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;345;208,-224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;308;-160,-80;Inherit;False;Property;_Foam__BorderBlend;Foam__Border Blend;18;0;Create;True;0;0;0;False;0;False;0;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-160,-160;Inherit;False;Property;_Water__OpacityFactor;Water__Opacity Factor;36;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;609;892.2043,-1515.06;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;554;656.4965,-72.97308;Inherit;False;542;Cascade_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;72;-624,-640;Inherit;False;Property;_Foam__Color;Foam__Color;17;0;Create;True;0;0;0;False;0;False;0.990566,0.1170263,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;547;-598.6597,-165.2928;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;310;368,-224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;307;192,-80;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;174;477,-1219;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;79;622,-1217;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;349;432,-80;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;346;512,-304;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;351;640,-224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;173;640,-304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;154;800,-1216;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;298;928,-1216;Inherit;False;CloudsPattern;-1;;35;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.SimpleSubtractOpNode;350;800,-304;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;302;1168,-1216;Inherit;False;BaseColorOutput;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;316;256,384;Inherit;False;904.3105;363.9998;Vertex Offset;5;195;314;194;196;193;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;944,-304;Inherit;False;OpacityOutput;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;582;5091.562,-791.8369;Inherit;False;312;OpacityOutput;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;587;5074.632,-1092.285;Inherit;False;302;BaseColorOutput;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;576,608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;752,448;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;588;5159.03,-976.7484;Inherit;False;300;NormalOutput;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;193;288,608;Inherit;False;Property;_Water__VertexOffsetFactor;Water__Vertex Offset Factor;30;0;Create;True;0;0;0;False;0;False;0;0.001;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;425;-2188.532,855.2251;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;194;288,448;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;170;4985.189,-892.1792;Inherit;False;Property;_Water__Smoothness;Water__Smoothness;35;0;Create;True;0;0;0;False;0;False;1;0.95;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;589;5089.182,-650.2881;Inherit;False;314;LocalVertexOffsetOutput;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;314;896,448;Inherit;False;LocalVertexOffsetOutput;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5619.731,-959.6654;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Lemu/Nature/Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;188;0;185;0
WireConnection;188;1;183;0
WireConnection;187;0;183;0
WireConnection;187;1;184;0
WireConnection;186;0;187;0
WireConnection;186;1;188;0
WireConnection;15;0;14;1
WireConnection;15;1;14;3
WireConnection;158;0;186;0
WireConnection;16;0;15;0
WireConnection;181;0;182;0
WireConnection;180;0;179;0
WireConnection;178;0;180;0
WireConnection;178;1;181;0
WireConnection;18;0;17;0
WireConnection;18;1;178;0
WireConnection;199;0;183;0
WireConnection;277;0;161;0
WireConnection;291;0;161;0
WireConnection;24;0;18;0
WireConnection;24;1;25;0
WireConnection;200;0;199;0
WireConnection;278;0;277;0
WireConnection;121;0;161;0
WireConnection;270;0;278;0
WireConnection;270;1;25;0
WireConnection;192;0;121;0
WireConnection;192;1;200;0
WireConnection;286;0;24;0
WireConnection;284;0;24;0
WireConnection;290;0;291;0
WireConnection;271;0;270;0
WireConnection;271;1;272;0
WireConnection;289;0;290;0
WireConnection;282;0;284;0
WireConnection;285;0;286;0
WireConnection;266;0;192;0
WireConnection;266;1;272;0
WireConnection;287;0;24;0
WireConnection;283;0;24;0
WireConnection;292;0;289;0
WireConnection;267;0;285;0
WireConnection;267;2;271;0
WireConnection;288;0;287;0
WireConnection;265;0;282;0
WireConnection;265;2;266;0
WireConnection;281;0;283;0
WireConnection;464;0;457;0
WireConnection;464;1;435;0
WireConnection;452;0;457;0
WireConnection;452;1;434;0
WireConnection;468;0;457;0
WireConnection;468;1;436;0
WireConnection;510;0;457;0
WireConnection;510;1;464;0
WireConnection;11;0;288;0
WireConnection;11;2;292;0
WireConnection;49;0;281;0
WireConnection;49;2;192;0
WireConnection;494;0;457;0
WireConnection;494;1;452;0
WireConnection;250;0;265;0
WireConnection;250;1;251;0
WireConnection;526;0;457;0
WireConnection;526;1;468;0
WireConnection;268;0;267;0
WireConnection;268;1;251;0
WireConnection;273;0;268;0
WireConnection;273;3;275;0
WireConnection;273;4;276;0
WireConnection;257;0;250;0
WireConnection;257;3;275;0
WireConnection;257;4;276;0
WireConnection;48;0;49;0
WireConnection;9;0;11;0
WireConnection;496;0;494;0
WireConnection;527;0;526;0
WireConnection;201;0;183;0
WireConnection;511;0;510;0
WireConnection;202;0;201;0
WireConnection;160;0;159;0
WireConnection;495;0;496;1
WireConnection;495;1;496;0
WireConnection;495;2;496;2
WireConnection;514;0;512;0
WireConnection;531;0;527;1
WireConnection;531;1;527;0
WireConnection;531;2;527;2
WireConnection;530;0;528;0
WireConnection;515;0;511;1
WireConnection;515;1;511;0
WireConnection;515;2;511;2
WireConnection;504;0;490;0
WireConnection;38;0;9;0
WireConnection;38;1;48;0
WireConnection;38;2;257;0
WireConnection;38;3;273;0
WireConnection;66;0;38;0
WireConnection;505;0;497;0
WireConnection;598;0;593;0
WireConnection;598;1;591;0
WireConnection;592;0;593;0
WireConnection;592;1;590;0
WireConnection;532;0;529;0
WireConnection;516;0;513;0
WireConnection;501;0;495;0
WireConnection;501;2;504;0
WireConnection;189;0;160;0
WireConnection;189;1;202;0
WireConnection;488;0;495;0
WireConnection;488;2;490;0
WireConnection;533;0;531;0
WireConnection;533;2;528;0
WireConnection;518;0;515;0
WireConnection;518;2;514;0
WireConnection;534;0;531;0
WireConnection;534;2;530;0
WireConnection;517;0;515;0
WireConnection;517;2;512;0
WireConnection;197;0;61;0
WireConnection;594;0;592;0
WireConnection;594;1;595;0
WireConnection;599;0;598;0
WireConnection;599;1;595;0
WireConnection;536;0;534;0
WireConnection;536;1;532;0
WireConnection;535;0;533;0
WireConnection;535;1;529;0
WireConnection;520;0;518;0
WireConnection;520;1;516;0
WireConnection;489;0;488;0
WireConnection;489;1;497;0
WireConnection;102;0;100;0
WireConnection;102;2;159;0
WireConnection;502;0;501;0
WireConnection;502;1;505;0
WireConnection;519;0;517;0
WireConnection;519;1;513;0
WireConnection;203;0;69;0
WireConnection;105;0;100;0
WireConnection;105;2;189;0
WireConnection;205;0;101;0
WireConnection;98;0;102;0
WireConnection;98;1;205;0
WireConnection;60;0;197;0
WireConnection;600;0;599;0
WireConnection;522;0;519;0
WireConnection;171;0;164;0
WireConnection;171;1;172;0
WireConnection;467;0;468;0
WireConnection;467;1;469;0
WireConnection;596;0;594;0
WireConnection;537;0;536;0
WireConnection;503;0;502;0
WireConnection;521;0;520;0
WireConnection;466;0;464;0
WireConnection;466;1;465;0
WireConnection;498;0;489;0
WireConnection;104;0;105;0
WireConnection;104;1;205;0
WireConnection;461;0;452;0
WireConnection;461;1;462;0
WireConnection;70;0;203;0
WireConnection;538;0;535;0
WireConnection;406;0;400;0
WireConnection;65;0;60;0
WireConnection;603;0;596;0
WireConnection;168;20;171;0
WireConnection;471;0;466;0
WireConnection;523;0;522;0
WireConnection;523;1;521;0
WireConnection;539;0;538;0
WireConnection;539;1;537;0
WireConnection;106;0;98;0
WireConnection;106;1;104;0
WireConnection;472;0;467;0
WireConnection;71;0;70;0
WireConnection;604;0;600;0
WireConnection;506;0;498;0
WireConnection;506;1;503;0
WireConnection;459;0;461;0
WireConnection;602;0;603;0
WireConnection;602;1;604;0
WireConnection;414;0;387;0
WireConnection;414;1;430;0
WireConnection;399;0;400;0
WireConnection;404;0;406;0
WireConnection;82;0;65;0
WireConnection;508;0;506;0
WireConnection;474;0;459;0
WireConnection;524;0;523;0
WireConnection;475;0;471;0
WireConnection;540;0;539;0
WireConnection;115;0;71;0
WireConnection;115;1;116;0
WireConnection;476;0;472;0
WireConnection;97;0;71;0
WireConnection;97;1;106;0
WireConnection;300;0;168;40
WireConnection;424;0;63;0
WireConnection;59;0;68;0
WireConnection;342;0;338;0
WireConnection;597;0;602;0
WireConnection;94;0;82;0
WireConnection;405;0;386;0
WireConnection;405;1;404;0
WireConnection;405;2;414;0
WireConnection;385;0;386;0
WireConnection;385;1;399;0
WireConnection;385;2;387;0
WireConnection;525;0;475;0
WireConnection;525;1;524;0
WireConnection;507;0;474;0
WireConnection;507;1;508;0
WireConnection;541;0;476;0
WireConnection;541;1;540;0
WireConnection;119;0;115;0
WireConnection;119;1;97;0
WireConnection;550;0;541;0
WireConnection;607;0;597;0
WireConnection;566;0;564;0
WireConnection;566;1;567;0
WireConnection;423;0;424;0
WireConnection;341;0;94;0
WireConnection;341;1;342;0
WireConnection;563;0;562;1
WireConnection;563;1;562;2
WireConnection;407;0;385;0
WireConnection;407;1;405;0
WireConnection;58;0;56;0
WireConnection;58;1;57;0
WireConnection;58;2;59;0
WireConnection;549;0;525;0
WireConnection;110;0;119;0
WireConnection;110;1;112;0
WireConnection;110;2;113;0
WireConnection;509;0;507;0
WireConnection;548;0;509;0
WireConnection;548;1;549;0
WireConnection;548;2;550;0
WireConnection;411;0;407;0
WireConnection;411;1;423;0
WireConnection;608;0;607;0
WireConnection;81;0;110;0
WireConnection;77;0;58;0
WireConnection;77;1;63;0
WireConnection;77;2;341;0
WireConnection;565;0;563;0
WireConnection;565;1;566;0
WireConnection;427;0;565;0
WireConnection;605;0;608;0
WireConnection;470;0;548;0
WireConnection;91;0;81;0
WireConnection;420;0;77;0
WireConnection;417;0;411;0
WireConnection;417;1;418;0
WireConnection;410;0;417;0
WireConnection;410;1;420;0
WireConnection;568;0;427;0
WireConnection;542;0;470;0
WireConnection;573;0;410;0
WireConnection;573;1;568;0
WireConnection;573;2;606;0
WireConnection;90;0;96;0
WireConnection;90;1;92;0
WireConnection;546;0;543;0
WireConnection;546;1;545;0
WireConnection;345;0;90;0
WireConnection;609;0;573;0
WireConnection;609;1;571;0
WireConnection;547;0;546;0
WireConnection;310;0;345;0
WireConnection;310;1;88;0
WireConnection;307;0;308;0
WireConnection;174;0;609;0
WireConnection;79;0;174;0
WireConnection;79;1;72;0
WireConnection;79;2;547;0
WireConnection;349;0;307;0
WireConnection;346;0;90;0
WireConnection;346;1;310;0
WireConnection;346;2;554;0
WireConnection;351;0;349;0
WireConnection;173;0;346;0
WireConnection;154;0;79;0
WireConnection;298;21;154;0
WireConnection;350;0;173;0
WireConnection;350;1;351;0
WireConnection;302;0;298;0
WireConnection;312;0;350;0
WireConnection;196;0;193;0
WireConnection;195;0;194;0
WireConnection;195;1;196;0
WireConnection;425;0;161;0
WireConnection;194;2;66;0
WireConnection;314;0;195;0
WireConnection;0;0;587;0
WireConnection;0;1;588;0
WireConnection;0;4;170;0
WireConnection;0;9;582;0
ASEEND*/
//CHKSM=31F4B892DD7B07C4B6164316773EFE405617F057