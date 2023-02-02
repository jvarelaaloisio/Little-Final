// Made with Amplify Shader Editor v1.9.1.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Nature/Water"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
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
		_Foam__RangeMin("Foam__Range Min", Range( 0 , 1)) = 0
		_Foam__RangeMax("Foam__Range Max", Range( 0 , 1)) = 0
		_Water__PatternScale("Water__Pattern Scale", Float) = 7.37
		_Water__PatternDetailSpeed("Water__Pattern Detail Speed", Float) = 1
		_Water__DetailPatternFactor("Water__Detail Pattern Factor", Range( 0 , 1)) = 0
		_Water__Pattern_OffsetScale("Water__Pattern_Offset Scale", Float) = 0
		_Water__VertexOffsetFactor("Water__Vertex Offset Factor", Range( 0 , 1)) = 0
		_Water__TransparentFac("Water__TransparentFac", Range( 0 , 1)) = 0
		_Water__Smoothness("Water__Smoothness", Range( 0 , 1)) = 1
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float4 screenPos;
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
		uniform float _Water__VertexOffsetFactor;
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
		uniform float _Foam__Distance;
		uniform float _Foam__Border;
		uniform float _Foam__Scale;
		uniform float _Foam__RangeMin;
		uniform float _Foam__RangeMax;
		uniform float _Water__Smoothness;
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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 appendResult186 = (float2(( _Waves__SpeedFactor * _Waves__SpeedDirX ) , ( _Waves__SpeedDirY * _Waves__SpeedFactor )));
			float2 SpeedDirWaves158 = appendResult186;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult15 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 WorldSpaceUV16 = appendResult15;
			float2 appendResult178 = (float2(( _Waves__ScaleX * 0.4 ) , ( _Waves__ScaleY * 0.4 )));
			float2 temp_output_24_0 = ( ( WorldSpaceUV16 * appendResult178 ) * 1.0 );
			float2 panner11 = ( 1.0 * _Time.y * SpeedDirWaves158 + temp_output_24_0);
			float simplePerlin2D9 = snoise( panner11 );
			simplePerlin2D9 = simplePerlin2D9*0.5 + 0.5;
			float temp_output_622_0 = ( ( _Waves__SpeedDirX + _Waves__SpeedDirY ) * 0.5 );
			float2 temp_output_192_0 = ( ( 1.0 - SpeedDirWaves158 ) * ( temp_output_622_0 * _Waves__SpeedFactor ) );
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
			float4 appendResult194 = (float4(0.0 , WavesPattern66 , 0.0 , 0.0));
			float4 LocalVertexOffsetOutput314 = ( appendResult194 * ( _Water__VertexOffsetFactor * 2.0 ) );
			v.vertex.xyz += LocalVertexOffsetOutput314.xyz;
			v.vertex.w = 1;
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
			float temp_output_622_0 = ( ( _Waves__SpeedDirX + _Waves__SpeedDirY ) * 0.5 );
			float2 temp_output_192_0 = ( ( 1.0 - SpeedDirWaves158 ) * ( temp_output_622_0 * _Waves__SpeedFactor ) );
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
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_viewPos = UnityObjectToViewPos( ase_vertex4Pos );
			float ase_screenDepth = -ase_viewPos.z;
			float cameraDepthFade338 = (( ase_screenDepth -_ProjectionParams.y - 10.0 ) / -22.2);
			float4 lerpResult77 = lerp( lerpResult58 , _Depth__Color , ( DepthWaterMask94 - saturate( cameraDepthFade338 ) ));
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult563 = (float2(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g));
			float4 screenColor427 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float3( appendResult563 ,  0.0 ) - ( NormalOutput300 * 0.1 ) ).xy);
			float4 DepthWavesEffect568 = screenColor427;
			float ClearWaterPointsMask605 = saturate( (0.0 + (saturate( ( saturate( ( 1.0 - ( distance( ase_worldPos , ClearWater_1 ) * _ClearWaterFac ) ) ) + saturate( ( 1.0 - ( distance( ase_worldPos , ClearWater_2 ) * _ClearWaterFac ) ) ) ) ) - 0.0) * (4.0 - 0.0) / (1.0 - 0.0)) );
			float4 lerpResult573 = lerp( ( ( ( ( voroi385 * voroi405 ) * _Depth__Color ) * _Water__DetailPatternFactor ) + saturate( lerpResult77 ) ) , DepthWavesEffect568 , ClearWaterPointsMask605);
			float Cascade_Mask542 = 0.0;
			float screenDepth70 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth70 = abs( ( screenDepth70 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( ( _Foam__Distance * 10.0 ) ) );
			float temp_output_71_0 = ( 1.0 - distanceDepth70 );
			float2 panner102 = ( 1.0 * _Time.y * SpeedDirWaves158 + WorldSpaceUV16);
			float temp_output_205_0 = ( _Foam__Scale * 10.0 );
			float simplePerlin2D98 = snoise( panner102*temp_output_205_0 );
			simplePerlin2D98 = simplePerlin2D98*0.5 + 0.5;
			float2 panner105 = ( 1.0 * _Time.y * ( ( 1.0 - SpeedDirWaves158 ) * ( temp_output_622_0 * _Waves__SpeedFactor ) ) + WorldSpaceUV16);
			float simplePerlin2D104 = snoise( panner105*temp_output_205_0 );
			simplePerlin2D104 = simplePerlin2D104*0.5 + 0.5;
			float BorderWatherMask91 = saturate( (0.0 + (( ( temp_output_71_0 - _Foam__Border ) + ( temp_output_71_0 * ( simplePerlin2D98 * simplePerlin2D104 ) ) ) - _Foam__RangeMin) * (1.0 - 0.0) / (_Foam__RangeMax - _Foam__RangeMin)) );
			float4 lerpResult79 = lerp( saturate( ( lerpResult573 * _Water__TransparentFac ) ) , _Foam__Color , saturate( ( Cascade_Mask542 + BorderWatherMask91 ) ));
			float4 temp_output_154_0 = saturate( lerpResult79 );
			float4 BaseColorOutput302 = temp_output_154_0;
			o.Albedo = BaseColorOutput302.rgb;
			o.Smoothness = _Water__Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19102
Node;AmplifyShaderEditor.CommentaryNode;627;3278,-434;Inherit;False;1500;494;IN DEV;10;591;626;590;595;625;602;597;607;608;605;ClearWaterMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;163;-3566.45,-1046.791;Inherit;False;1002.902;2299.046;Variables;18;203;69;200;199;181;180;158;179;186;182;187;188;87;183;184;185;619;622;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;87;-3427.739,912.4824;Inherit;False;700.8978;243.0804;WordSpaceUV;3;14;15;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;183;-3517.823,-116.426;Inherit;False;Property;_Waves__SpeedFactor;Waves__Speed Factor;11;0;Create;True;0;0;0;False;0;False;0;0.8;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-3536,-896;Inherit;False;Property;_Waves__SpeedDirY;Waves__Speed Dir Y;10;0;Create;True;0;0;0;False;0;False;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-3536,-987;Inherit;False;Property;_Waves__SpeedDirX;Waves__Speed Dir X;9;0;Create;True;0;0;0;False;0;False;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-3200,-864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;14;-3377.739,962.4822;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-3200,-992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;186;-3040,-928;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-3548.823,491.574;Inherit;False;Property;_Waves__ScaleX;Waves__Scale  X;7;0;Create;True;0;0;0;False;0;False;0.368;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-3136.688,965.5623;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-3549.823,635.5737;Inherit;False;Property;_Waves__ScaleY;Waves__Scale Y;8;0;Create;True;0;0;0;False;0;False;0.372;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;86;-2505.23,355.7284;Inherit;False;2697.585;1213.271;Waves patern;43;66;38;273;9;257;48;49;276;11;250;268;275;292;265;281;288;251;267;289;285;283;271;266;287;282;286;272;192;270;284;290;291;278;24;121;18;25;277;178;17;161;425;623;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-2951.841,988.9434;Inherit;False;WorldSpaceUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-2848,-928;Inherit;False;SpeedDirWaves;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;-3165.823,619.5737;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;-3165.823,523.5739;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;17;-2464,414;Inherit;False;16;WorldSpaceUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;-2464,702;Inherit;False;158;SpeedDirWaves;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;619;-3180.175,-703.1196;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;178;-2464,526;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;199;-3227.11,812.9337;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;277;-2256,974;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;200;-3207.395,834.6201;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2208,590;Inherit;False;Constant;_AuxEx_1;AuxEx_1;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2208,414;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;622;-3040,-704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;623;-2457.576,827.6647;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;121;-2192,766;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;291;-1744,734;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;278;-2240,990;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2048,414;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;270;-2016,958;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;272;-2017,1166;Inherit;False;Property;_BigWaves__Speed;Big Waves__Speed;14;0;Create;True;0;0;0;False;0;False;3;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;286;-1648,414;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;-2016,766;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;290;-1728,718;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;284;-1648,414;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;289;-1728,510;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;282;-1632,430;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;-1792,1006;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;287;-1648,414;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;-1776,1310;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;283;-1648,414;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;285;-1632,430;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;251;-1280,1134;Inherit;False;Property;_BigWaves__Scale;Big Waves__Scale;13;0;Create;True;0;0;0;False;0;False;0.2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;292;-1712,494;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;265;-1536,1006;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;267;-1536,1294;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;281;-1632,430;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;288;-1632,430;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;250;-1024,1006;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;275;-768,1374;Inherit;False;Property;_BigWaves__LevelsMin;Big Waves__Levels Min;15;0;Create;True;0;0;0;False;0;False;0.89;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;11;-1536,430;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;49;-1536,718;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;268;-1024,1294;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-768,1454;Inherit;False;Property;_BigWaves__LevelsMax;Big Waves__Levels Max;16;0;Create;True;0;0;0;False;0;False;0.89;-1.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-2483.979,-744.7645;Inherit;False;2090.815;1029.931;Foam;27;91;81;110;72;119;112;113;115;97;71;106;116;70;98;104;205;102;105;101;189;100;160;159;545;543;546;547;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;48;-1024,718;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;9;-1024,430;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;257;-416,1022;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;273;-400,1294;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;84;-1776,-1360;Inherit;False;1362.402;543.1866;Depth Water;11;63;94;82;65;60;197;61;341;343;423;424;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;-2451.696,-37.19388;Inherit;False;158;SpeedDirWaves;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-128,958;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;624;-2427.306,164.2056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;160;-2400,48;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1744,-1296;Inherit;False;Property;_Depth__Distance;Depth__Distance;18;0;Create;True;0;0;0;False;0;False;0;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;299;189.9106,-736.2684;Inherit;False;933.308;253.9423;Normal;5;172;164;171;168;300;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;0,958;Inherit;False;WavesPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;-1488,-1296;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;221.9106,-672.2685;Inherit;False;66;WavesPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-3536,-448;Inherit;False;Property;_Foam__Distance;Foam__Distance;20;0;Create;True;0;0;0;False;0;False;0;0.314;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-2240,80;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;416;-1888,-2592;Inherit;False;1476;608;Pattern Detail;12;386;399;400;406;387;414;404;405;385;407;411;430;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-2455.898,-119.8135;Inherit;False;16;WorldSpaceUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-2464,-208;Inherit;False;Property;_Foam__Scale;Foam__Scale;21;0;Create;True;0;0;0;False;0;False;0;0.287;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;221.9106,-576.2685;Inherit;False;Property;_Waves__NormalFactor;Waves__Normal Factor;12;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;105;-2063.131,2.691421;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;102;-2084.534,-262.6619;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;-2048,-128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;-3184,-448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;60;-1328,-1296;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;461.9104,-672.2685;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;400;-1840,-2416;Inherit;False;Property;_Water__PatternDetailSpeed;Water__Pattern Detail Speed;27;0;Create;True;0;0;0;False;0;False;1;2.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;387;-1552,-2336;Inherit;False;Property;_Water__PatternScale;Water__Pattern Scale;26;0;Create;True;0;0;0;False;0;False;7.37;28.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;168;605.9103,-672.2685;Inherit;False;Normal From Height;-1;;34;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;1;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;65;-1104,-1296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;343;-1093,-1040;Inherit;False;524;207;Le resto el Depth que genera la camara;2;338;342;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;406;-1552,-2256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;430;-1584,-2144;Inherit;False;Property;_Water__Pattern_OffsetScale;Water__Pattern_Offset Scale;30;0;Create;True;0;0;0;False;0;False;0;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;98;-1751.119,-259.3956;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;70;-2432,-672;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;104;-1740.538,-18.2953;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;83;-1536,-1952;Inherit;False;886.8557;570.4091;WavesBaseColor;5;68;59;56;57;58;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;300;928,-672;Inherit;False;NormalOutput;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;399;-1552,-2416;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-1445.674,-72.75952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;63;-1040,-1216;Inherit;False;Property;_Depth__Color;Depth__Color;17;0;Create;True;0;0;0;False;0;False;0.990566,0.1170263,0,0;0.4394342,0.745283,0.6508056,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;414;-1280,-2176;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-20;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;338;-1056,-976;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;-22.2;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;82;-944,-1296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;404;-1280,-2256;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;386;-1552,-2544;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;71;-2176,-672;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-2432,-576;Inherit;False;Property;_Foam__Border;Foam__Border;19;0;Create;True;0;0;0;False;0;False;0;0.527;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-1488,-1504;Inherit;False;66;WavesPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;59;-1152,-1488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;562;62.82843,-2112.468;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;405;-1056,-2288;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;385;-1056,-2544;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.ColorNode;56;-1248,-1904;Inherit;False;Property;_Waves__ColorPrimary;Waves__Color Primary;5;0;Create;True;0;0;0;False;0;False;0.510235,0.8939884,0.9245283,0;0.2848877,0.4802141,0.6226414,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;342;-784,-976;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-1696,-672;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;57;-1248,-1712;Inherit;False;Property;_Waves__ColorSecondary;Waves__Color Secondary;6;0;Create;True;0;0;0;False;0;False;0.510235,0.8939884,0.9245283,0;0.2410376,0.4028301,0.525,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;424;-629.5072,-1200.23;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-800,-1296;Inherit;False;DepthWaterMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;115;-1968,-608;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;567;67.474,-1832.612;Inherit;False;Constant;_Float9;Float 9;39;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;564;59.61261,-1908.516;Inherit;False;300;NormalOutput;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;58;-912,-1744;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1312,-224;Inherit;False;Property;_Foam__RangeMax;Foam__Range Max;25;0;Create;True;0;0;0;False;0;False;0;0.456;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;318;-208,-1376;Inherit;False;1612.941;303.0804;Base Color Blend;11;417;77;410;174;79;154;302;298;418;420;571;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-1311.755,-324.339;Inherit;False;Property;_Foam__RangeMin;Foam__Range Min;24;0;Create;True;0;0;0;False;0;False;0;0.43;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;566;372.4748,-1933.612;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;341;-544,-1136;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;407;-864,-2432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;563;315.2935,-2098.727;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;423;-592,-1280;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-1488,-640;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;418;-162,-1316;Inherit;False;Property;_Water__DetailPatternFactor;Water__Detail Pattern Factor;28;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;411;-544,-2432;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;565;526.4749,-2077.612;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;110;-975,-399;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;-160,-1216;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;427;578.2347,-1938.252;Inherit;False;Global;_GrabScreen1;Grab Screen 1;29;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;81;-774,-408;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;420;96,-1200;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;417;192,-1312;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;568;497.9141,-1698.688;Inherit;False;DepthWavesEffect;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;606;214.0944,-1561.139;Inherit;False;605;ClearWaterPointsMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-640,-416;Inherit;False;BorderWatherMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;410;340,-1224;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;542;1962.575,2648.33;Inherit;False;Cascade_Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;571;541.4712,-1366.15;Inherit;False;Property;_Water__TransparentFac;Water__TransparentFac;38;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;573;562.6455,-1499.18;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;545;-999.6594,-97.29277;Inherit;False;91;BorderWatherMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;543;-956.5451,-189.6922;Inherit;False;542;Cascade_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;609;892.2043,-1515.06;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;316;256,384;Inherit;False;904.3105;363.9998;Vertex Offset;5;195;314;194;196;193;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;546;-765.6597,-163.2928;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;174;477,-1219;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;193;288,608;Inherit;False;Property;_Water__VertexOffsetFactor;Water__Vertex Offset Factor;35;0;Create;True;0;0;0;False;0;False;0;0.079;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;547;-598.6597,-165.2928;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;72;-624,-640;Inherit;False;Property;_Foam__Color;Foam__Color;22;0;Create;True;0;0;0;False;0;False;0.990566,0.1170263,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;79;622,-1217;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;576,608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;194;288,448;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;752,448;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;154;800,-1216;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;314;896,448;Inherit;False;LocalVertexOffsetOutput;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;317;-193.572,-364.0466;Inherit;False;1344.356;412.1401;Opacity Blend;15;349;307;308;312;350;351;173;346;310;345;90;96;92;88;554;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;302;1168,-1216;Inherit;False;BaseColorOutput;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;511;-425.3114,2568.56;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NoiseGeneratorNode;535;77.04447,3188.577;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;501;-118.6445,2158.002;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;523;674.7252,2744.764;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;461;-1592.38,2942.205;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;472;-1360.857,3320.36;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;539;671.3814,3355.751;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;508;945.6763,2093.736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;525;1082.768,2889.428;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;475;-1288.3,3174.048;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;506;741.0792,2041.194;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;457;-2377.697,2421.406;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;524;879.3223,2797.307;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;503;361.357,2158.002;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;474;-1257.3,2815.048;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;510;-581.9174,2569.075;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;519;80.38969,2577.589;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;548;1583.783,2509.694;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;476;-1211.3,3294.048;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;517;-127.6103,2577.589;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;512;-271.6105,2721.588;Inherit;False;Property;_Float5;Float 5;32;0;Create;True;0;0;0;False;0;False;0.1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;350;800,-304;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;425;-2192.532,850.2251;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;550;1332.98,2931.212;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;490;-205.2573,2018.018;Inherit;False;Property;_Float3;Float 3;33;0;Create;True;0;0;0;False;0;False;0.1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;527;-428.6564,3179.546;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;549;1299.507,2571.466;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;536;19.65873,3472.561;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;467;-1569.646,3592.673;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;462;-1766.379,3030.205;Inherit;False;Property;_Float0;Float 0;29;0;Create;True;0;0;0;False;0;False;0;0.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;489;146.7427,1874.018;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;469;-1743.646,3680.673;Inherit;False;Property;_Float2;Float 2;34;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;496;-358.9584,1864.989;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;531;-276.6564,3180.546;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;435;-2374.242,3078.894;Inherit;False;Global;Cascade_2;Cascade_2;30;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;513;-95.61032,2753.588;Inherit;False;Property;_Float7;Float 7;39;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;64,-304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;540;916.9771,3354.294;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;349;432,-80;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;345;208,-224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;494;-515.5634,1865.505;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;170;5216,-896;Inherit;False;Property;_Water__Smoothness;Water__Smoothness;40;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;554;656.4965,-72.97308;Inherit;False;542;Cascade_Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;471;-1463.858,3091.36;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;488;-61.25729,1874.018;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;530;-336.1425,3501.561;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-1569.17,3266.517;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.21;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;502;89.35551,2158.002;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;434;-2386.412,2838.471;Inherit;False;Global;Cascade_1;Cascade_1;30;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;470;1774.265,2637.535;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;504;-266.4445,2187.002;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;495;-206.9585,1865.989;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DistanceOpNode;468;-1777.279,3455.738;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;514;-332.7975,2890.573;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;532;-130.1425,3611.561;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;518;-184.9975,2861.573;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-160,-160;Inherit;False;Property;_Water__OpacityFactor;Water__Opacity Factor;41;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;516;-126.7973,3000.573;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-160,-320;Inherit;False;94;DepthWaterMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;537;291.6587,3472.561;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;497;-29.25729,2050.019;Inherit;False;Property;_Float4;Float 4;37;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;533;-130.9555,3188.577;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;498;418.7442,1874.018;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;522;352.3902,2577.589;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;944,-304;Inherit;False;OpacityOutput;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;452;-1800.013,2805.269;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;464;-1776.802,3129.581;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;529;-98.95554,3364.577;Inherit;False;Property;_Float8;Float 8;36;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;528;-347.9555,3349.577;Inherit;False;Constant;_Float6;Float 6;33;0;Create;True;0;0;0;False;0;False;0.1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;346;512,-304;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;520;23.00248,2861.573;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;436;-2388.666,3528.333;Inherit;False;Global;Cascade_3;Cascade_3;30;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;538;349.0464,3188.577;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;521;295.0025,2861.573;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.44;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;526;-585.2614,3180.063;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DepthFade;307;192,-80;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;505;-60.44431,2297.002;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;534;-188.3413,3472.561;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;459;-1432.38,2814.205;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;308;-160,-80;Inherit;False;Property;_Foam__BorderBlend;Foam__Border Blend;23;0;Create;True;0;0;0;False;0;False;0;0.09705883;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;507;1094.553,2202.277;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;515;-273.3114,2569.56;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;298;917,-1323;Inherit;False;CloudsPattern;-1;;35;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.GetLocalVarNode;582;5216,-816;Inherit;False;312;OpacityOutput;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;351;640,-224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;589;5216,-736;Inherit;False;314;LocalVertexOffsetOutput;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;310;368,-224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;587;5216,-1088;Inherit;False;302;BaseColorOutput;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;588;5216,-1008;Inherit;False;300;NormalOutput;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;465;-1743.168,3354.517;Inherit;False;Property;_Float1;Float 1;31;0;Create;True;0;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;541;1079.779,3116.391;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;509;1267.205,2195.326;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;173;640,-304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-160,-240;Inherit;False;91;BorderWatherMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5632,-1088;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Lemu/Nature/Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.Vector3Node;591;3328,-128;Inherit;False;Global;ClearWater_2;ClearWater_2;37;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;626;3584,-128;Inherit;False;ProximityMask;-1;;2;032017421c799b24a9911b3ca1595579;0;2;7;FLOAT;0;False;8;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;590;3328,-384;Inherit;False;Global;ClearWater_1;ClearWater_1;37;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;595;3328,-224;Inherit;False;Property;_ClearWaterFac;ClearWaterFac;42;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;625;3584,-384;Inherit;False;ProximityMask;-1;;1;032017421c799b24a9911b3ca1595579;0;2;7;FLOAT;0;False;8;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;602;3872,-256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;597;4000,-256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;607;4176,-304;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;608;4368,-304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;605;4512,-304;Inherit;False;ClearWaterPointsMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
WireConnection;188;0;185;0
WireConnection;188;1;183;0
WireConnection;187;0;183;0
WireConnection;187;1;184;0
WireConnection;186;0;187;0
WireConnection;186;1;188;0
WireConnection;15;0;14;1
WireConnection;15;1;14;3
WireConnection;16;0;15;0
WireConnection;158;0;186;0
WireConnection;181;0;182;0
WireConnection;180;0;179;0
WireConnection;619;0;184;0
WireConnection;619;1;185;0
WireConnection;178;0;180;0
WireConnection;178;1;181;0
WireConnection;199;0;183;0
WireConnection;277;0;161;0
WireConnection;200;0;199;0
WireConnection;18;0;17;0
WireConnection;18;1;178;0
WireConnection;622;0;619;0
WireConnection;623;0;622;0
WireConnection;623;1;200;0
WireConnection;121;0;161;0
WireConnection;291;0;161;0
WireConnection;278;0;277;0
WireConnection;24;0;18;0
WireConnection;24;1;25;0
WireConnection;270;0;278;0
WireConnection;270;1;25;0
WireConnection;286;0;24;0
WireConnection;192;0;121;0
WireConnection;192;1;623;0
WireConnection;290;0;291;0
WireConnection;284;0;24;0
WireConnection;289;0;290;0
WireConnection;282;0;284;0
WireConnection;266;0;192;0
WireConnection;266;1;272;0
WireConnection;287;0;24;0
WireConnection;271;0;270;0
WireConnection;271;1;272;0
WireConnection;283;0;24;0
WireConnection;285;0;286;0
WireConnection;292;0;289;0
WireConnection;265;0;282;0
WireConnection;265;2;266;0
WireConnection;267;0;285;0
WireConnection;267;2;271;0
WireConnection;281;0;283;0
WireConnection;288;0;287;0
WireConnection;250;0;265;0
WireConnection;250;1;251;0
WireConnection;11;0;288;0
WireConnection;11;2;292;0
WireConnection;49;0;281;0
WireConnection;49;2;192;0
WireConnection;268;0;267;0
WireConnection;268;1;251;0
WireConnection;48;0;49;0
WireConnection;9;0;11;0
WireConnection;257;0;250;0
WireConnection;257;3;275;0
WireConnection;257;4;276;0
WireConnection;273;0;268;0
WireConnection;273;3;275;0
WireConnection;273;4;276;0
WireConnection;38;0;9;0
WireConnection;38;1;48;0
WireConnection;38;2;257;0
WireConnection;38;3;273;0
WireConnection;624;0;622;0
WireConnection;624;1;183;0
WireConnection;160;0;159;0
WireConnection;66;0;38;0
WireConnection;197;0;61;0
WireConnection;189;0;160;0
WireConnection;189;1;624;0
WireConnection;105;0;100;0
WireConnection;105;2;189;0
WireConnection;102;0;100;0
WireConnection;102;2;159;0
WireConnection;205;0;101;0
WireConnection;203;0;69;0
WireConnection;60;0;197;0
WireConnection;171;0;164;0
WireConnection;171;1;172;0
WireConnection;168;20;171;0
WireConnection;65;0;60;0
WireConnection;406;0;400;0
WireConnection;98;0;102;0
WireConnection;98;1;205;0
WireConnection;70;0;203;0
WireConnection;104;0;105;0
WireConnection;104;1;205;0
WireConnection;300;0;168;40
WireConnection;399;0;400;0
WireConnection;106;0;98;0
WireConnection;106;1;104;0
WireConnection;414;0;387;0
WireConnection;414;1;430;0
WireConnection;82;0;65;0
WireConnection;404;0;406;0
WireConnection;71;0;70;0
WireConnection;59;0;68;0
WireConnection;405;0;386;0
WireConnection;405;1;404;0
WireConnection;405;2;414;0
WireConnection;385;0;386;0
WireConnection;385;1;399;0
WireConnection;385;2;387;0
WireConnection;342;0;338;0
WireConnection;97;0;71;0
WireConnection;97;1;106;0
WireConnection;424;0;63;0
WireConnection;94;0;82;0
WireConnection;115;0;71;0
WireConnection;115;1;116;0
WireConnection;58;0;56;0
WireConnection;58;1;57;0
WireConnection;58;2;59;0
WireConnection;566;0;564;0
WireConnection;566;1;567;0
WireConnection;341;0;94;0
WireConnection;341;1;342;0
WireConnection;407;0;385;0
WireConnection;407;1;405;0
WireConnection;563;0;562;1
WireConnection;563;1;562;2
WireConnection;423;0;424;0
WireConnection;119;0;115;0
WireConnection;119;1;97;0
WireConnection;411;0;407;0
WireConnection;411;1;423;0
WireConnection;565;0;563;0
WireConnection;565;1;566;0
WireConnection;110;0;119;0
WireConnection;110;1;112;0
WireConnection;110;2;113;0
WireConnection;77;0;58;0
WireConnection;77;1;63;0
WireConnection;77;2;341;0
WireConnection;427;0;565;0
WireConnection;81;0;110;0
WireConnection;420;0;77;0
WireConnection;417;0;411;0
WireConnection;417;1;418;0
WireConnection;568;0;427;0
WireConnection;91;0;81;0
WireConnection;410;0;417;0
WireConnection;410;1;420;0
WireConnection;573;0;410;0
WireConnection;573;1;568;0
WireConnection;573;2;606;0
WireConnection;609;0;573;0
WireConnection;609;1;571;0
WireConnection;546;0;543;0
WireConnection;546;1;545;0
WireConnection;174;0;609;0
WireConnection;547;0;546;0
WireConnection;79;0;174;0
WireConnection;79;1;72;0
WireConnection;79;2;547;0
WireConnection;196;0;193;0
WireConnection;194;1;66;0
WireConnection;195;0;194;0
WireConnection;195;1;196;0
WireConnection;154;0;79;0
WireConnection;314;0;195;0
WireConnection;302;0;154;0
WireConnection;511;0;510;0
WireConnection;535;0;533;0
WireConnection;535;1;529;0
WireConnection;501;0;495;0
WireConnection;501;2;504;0
WireConnection;523;0;522;0
WireConnection;523;1;521;0
WireConnection;461;0;452;0
WireConnection;461;1;462;0
WireConnection;472;0;467;0
WireConnection;539;0;538;0
WireConnection;539;1;537;0
WireConnection;508;0;506;0
WireConnection;525;0;475;0
WireConnection;525;1;524;0
WireConnection;475;0;471;0
WireConnection;506;0;498;0
WireConnection;506;1;503;0
WireConnection;524;0;523;0
WireConnection;503;0;502;0
WireConnection;474;0;459;0
WireConnection;510;0;457;0
WireConnection;510;1;464;0
WireConnection;519;0;517;0
WireConnection;519;1;513;0
WireConnection;548;0;509;0
WireConnection;548;1;549;0
WireConnection;548;2;550;0
WireConnection;476;0;472;0
WireConnection;517;0;515;0
WireConnection;517;2;512;0
WireConnection;350;0;173;0
WireConnection;350;1;351;0
WireConnection;425;0;161;0
WireConnection;550;0;541;0
WireConnection;527;0;526;0
WireConnection;549;0;525;0
WireConnection;536;0;534;0
WireConnection;536;1;532;0
WireConnection;467;0;468;0
WireConnection;467;1;469;0
WireConnection;489;0;488;0
WireConnection;489;1;497;0
WireConnection;496;0;494;0
WireConnection;531;0;527;1
WireConnection;531;1;527;0
WireConnection;531;2;527;2
WireConnection;90;0;96;0
WireConnection;90;1;92;0
WireConnection;540;0;539;0
WireConnection;349;0;307;0
WireConnection;345;0;90;0
WireConnection;494;0;457;0
WireConnection;494;1;452;0
WireConnection;471;0;466;0
WireConnection;488;0;495;0
WireConnection;488;2;490;0
WireConnection;530;0;528;0
WireConnection;466;0;464;0
WireConnection;466;1;465;0
WireConnection;502;0;501;0
WireConnection;502;1;505;0
WireConnection;470;0;548;0
WireConnection;504;0;490;0
WireConnection;495;0;496;1
WireConnection;495;1;496;0
WireConnection;495;2;496;2
WireConnection;468;0;457;0
WireConnection;468;1;436;0
WireConnection;514;0;512;0
WireConnection;532;0;529;0
WireConnection;518;0;515;0
WireConnection;518;2;514;0
WireConnection;516;0;513;0
WireConnection;537;0;536;0
WireConnection;533;0;531;0
WireConnection;533;2;528;0
WireConnection;498;0;489;0
WireConnection;522;0;519;0
WireConnection;312;0;350;0
WireConnection;452;0;457;0
WireConnection;452;1;434;0
WireConnection;464;0;457;0
WireConnection;464;1;435;0
WireConnection;346;0;90;0
WireConnection;346;1;310;0
WireConnection;346;2;554;0
WireConnection;520;0;518;0
WireConnection;520;1;516;0
WireConnection;538;0;535;0
WireConnection;521;0;520;0
WireConnection;526;0;457;0
WireConnection;526;1;468;0
WireConnection;307;0;308;0
WireConnection;505;0;497;0
WireConnection;534;0;531;0
WireConnection;534;2;530;0
WireConnection;459;0;461;0
WireConnection;507;0;474;0
WireConnection;507;1;508;0
WireConnection;515;0;511;1
WireConnection;515;1;511;0
WireConnection;515;2;511;2
WireConnection;298;21;154;0
WireConnection;351;0;349;0
WireConnection;310;0;345;0
WireConnection;310;1;88;0
WireConnection;541;0;476;0
WireConnection;541;1;540;0
WireConnection;509;0;507;0
WireConnection;173;0;346;0
WireConnection;0;0;587;0
WireConnection;0;1;588;0
WireConnection;0;4;170;0
WireConnection;0;11;589;0
WireConnection;626;7;595;0
WireConnection;626;8;591;0
WireConnection;625;7;595;0
WireConnection;625;8;590;0
WireConnection;602;0;625;0
WireConnection;602;1;626;0
WireConnection;597;0;602;0
WireConnection;607;0;597;0
WireConnection;608;0;607;0
WireConnection;605;0;608;0
ASEEND*/
//CHKSM=2749A971E7819A7C57516ED5EA9F6A90319F5894