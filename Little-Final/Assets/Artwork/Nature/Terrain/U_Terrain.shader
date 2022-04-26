// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "U_Terrain"
{
	Properties
	{
		[HideInInspector]_TerrainHolesTexture("_TerrainHolesTexture", 2D) = "white" {}
		[HideInInspector]_Control("Control", 2D) = "white" {}
		[HideInInspector]_Splat3("Splat3", 2D) = "white" {}
		[HideInInspector]_Splat2("Splat2", 2D) = "white" {}
		[HideInInspector]_Splat1("Splat1", 2D) = "white" {}
		[HideInInspector]_Splat0("Splat0", 2D) = "white" {}
		[HideInInspector]_Normal0("Normal0", 2D) = "white" {}
		[HideInInspector]_Normal1("Normal1", 2D) = "white" {}
		[HideInInspector]_Normal2("Normal2", 2D) = "white" {}
		[HideInInspector]_Normal3("Normal3", 2D) = "white" {}
		[HideInInspector]_Smoothness3("Smoothness3", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness1("Smoothness1", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness0("Smoothness0", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness2("Smoothness2", Range( 0 , 1)) = 1
		[HideInInspector][Gamma]_Metallic0("Metallic0", Range( 0 , 1)) = 0
		[HideInInspector][Gamma]_Metallic2("Metallic2", Range( 0 , 1)) = 0
		[HideInInspector][Gamma]_Metallic3("Metallic3", Range( 0 , 1)) = 0
		[HideInInspector][Gamma]_Metallic1("Metallic1", Range( 0 , 1)) = 0
		[HideInInspector]_Mask2("_Mask2", 2D) = "white" {}
		[HideInInspector]_Mask0("_Mask0", 2D) = "white" {}
		[HideInInspector]_Mask1("_Mask1", 2D) = "white" {}
		[HideInInspector]_Mask3("_Mask3", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry-100" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_local __ _ALPHATEST_ON
		#pragma shader_feature_local _MASKMAP
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Mask1;
		uniform sampler2D _Mask0;
		uniform sampler2D _Mask3;
		uniform sampler2D _Mask2;
		uniform float4 _MaskMapRemapScale1;
		uniform float4 _MaskMapRemapScale0;
		uniform float4 _MaskMapRemapOffset1;
		uniform float4 _MaskMapRemapOffset2;
		uniform float4 _MaskMapRemapScale2;
		uniform float4 _MaskMapRemapScale3;
		uniform float4 _MaskMapRemapOffset0;
		uniform float4 _MaskMapRemapOffset3;
		uniform sampler2D _Control;
		uniform float4 _Control_ST;
		uniform sampler2D _Normal0;
		uniform sampler2D _Splat0;
		uniform float4 _Splat0_ST;
		uniform sampler2D _Normal1;
		uniform sampler2D _Splat1;
		uniform float4 _Splat1_ST;
		uniform sampler2D _Normal2;
		uniform sampler2D _Splat2;
		uniform float4 _Splat2_ST;
		uniform sampler2D _Normal3;
		uniform sampler2D _Splat3;
		uniform float4 _Splat3_ST;
		uniform float _Smoothness0;
		uniform float _Smoothness1;
		uniform float _Smoothness2;
		uniform float _Smoothness3;
		uniform sampler2D _TerrainHolesTexture;
		uniform float4 _TerrainHolesTexture_ST;
		uniform float _Metallic0;
		uniform float _Metallic1;
		uniform float _Metallic2;
		uniform float _Metallic3;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Control = i.uv_texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode5_g1 = tex2D( _Control, uv_Control );
			float dotResult20_g1 = dot( tex2DNode5_g1 , float4(1,1,1,1) );
			float SplatWeight22_g1 = dotResult20_g1;
			float localSplatClip74_g1 = ( SplatWeight22_g1 );
			float SplatWeight74_g1 = SplatWeight22_g1;
			{
			#if !defined(SHADER_API_MOBILE) && defined(TERRAIN_SPLAT_ADDPASS)
				clip(SplatWeight74_g1 == 0.0f ? -1 : 1);
			#endif
			}
			float4 SplatControl26_g1 = ( tex2DNode5_g1 / ( localSplatClip74_g1 + 0.001 ) );
			float4 temp_output_59_0_g1 = SplatControl26_g1;
			float2 uv_Splat0 = i.uv_texcoord * _Splat0_ST.xy + _Splat0_ST.zw;
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 weightedBlendVar8_g1 = temp_output_59_0_g1;
			float4 weightedBlend8_g1 = ( weightedBlendVar8_g1.x*tex2D( _Normal0, uv_Splat0 ) + weightedBlendVar8_g1.y*tex2D( _Normal1, uv_Splat1 ) + weightedBlendVar8_g1.z*tex2D( _Normal2, uv_Splat2 ) + weightedBlendVar8_g1.w*tex2D( _Normal3, uv_Splat3 ) );
			float3 temp_output_61_0_g1 = UnpackNormal( weightedBlend8_g1 );
			o.Normal = temp_output_61_0_g1;
			float4 appendResult33_g1 = (float4(1.0 , 1.0 , 1.0 , _Smoothness0));
			float4 tex2DNode4_g1 = tex2D( _Splat0, uv_Splat0 );
			float4 appendResult36_g1 = (float4(1.0 , 1.0 , 1.0 , _Smoothness1));
			float4 tex2DNode3_g1 = tex2D( _Splat1, uv_Splat1 );
			float4 appendResult39_g1 = (float4(1.0 , 1.0 , 1.0 , _Smoothness2));
			float4 tex2DNode6_g1 = tex2D( _Splat2, uv_Splat2 );
			float4 appendResult42_g1 = (float4(1.0 , 1.0 , 1.0 , _Smoothness3));
			float4 tex2DNode7_g1 = tex2D( _Splat3, uv_Splat3 );
			float4 weightedBlendVar9_g1 = temp_output_59_0_g1;
			float4 weightedBlend9_g1 = ( weightedBlendVar9_g1.x*( appendResult33_g1 * tex2DNode4_g1 ) + weightedBlendVar9_g1.y*( appendResult36_g1 * tex2DNode3_g1 ) + weightedBlendVar9_g1.z*( appendResult39_g1 * tex2DNode6_g1 ) + weightedBlendVar9_g1.w*( appendResult42_g1 * tex2DNode7_g1 ) );
			float4 MixDiffuse28_g1 = weightedBlend9_g1;
			float4 temp_output_60_0_g1 = MixDiffuse28_g1;
			float4 localClipHoles100_g1 = ( temp_output_60_0_g1 );
			float2 uv_TerrainHolesTexture = i.uv_texcoord * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
			float holeClipValue99_g1 = tex2D( _TerrainHolesTexture, uv_TerrainHolesTexture ).r;
			float Hole100_g1 = holeClipValue99_g1;
			{
			#ifdef _ALPHATEST_ON
				clip(Hole100_g1 == 0.0f ? -1 : 1);
			#endif
			}
			float4 temp_output_21_0_g101 = localClipHoles100_g1;
			float4 color20_g101 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_8 = (0.1).xx;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5_g101 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g101 = ( 0.01 * 1.5 );
			float2 panner10_g102 = ( 1.0 * _Time.y * temp_cast_8 + ( appendResult5_g101 * temp_output_2_0_g101 ));
			float simplePerlin2D11_g102 = snoise( panner10_g102 );
			simplePerlin2D11_g102 = simplePerlin2D11_g102*0.5 + 0.5;
			float temp_output_8_0_g101 = simplePerlin2D11_g102;
			float2 temp_cast_9 = (0.1).xx;
			float2 panner10_g104 = ( 1.0 * _Time.y * temp_cast_9 + ( appendResult5_g101 * 0.01 ));
			float simplePerlin2D11_g104 = snoise( panner10_g104 );
			simplePerlin2D11_g104 = simplePerlin2D11_g104*0.5 + 0.5;
			float2 temp_cast_10 = (0.1).xx;
			float2 panner10_g103 = ( 1.0 * _Time.y * temp_cast_10 + ( appendResult5_g101 * ( temp_output_2_0_g101 * 4.0 ) ));
			float simplePerlin2D11_g103 = snoise( panner10_g103 );
			simplePerlin2D11_g103 = simplePerlin2D11_g103*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g101 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g101 * simplePerlin2D11_g104 ) + ( 1.0 - simplePerlin2D11_g103 ) ) * temp_output_8_0_g101 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g101 = lerp( temp_output_21_0_g101 , saturate( ( temp_output_21_0_g101 * color20_g101 ) ) , ( temp_output_16_0_g101 * 1.0 ));
			o.Albedo = lerpResult24_g101.xyz;
			float4 appendResult55_g1 = (float4(_Metallic0 , _Metallic1 , _Metallic2 , _Metallic3));
			float dotResult53_g1 = dot( SplatControl26_g1 , appendResult55_g1 );
			o.Metallic = dotResult53_g1;
			float4 appendResult205_g1 = (float4(_Smoothness0 , _Smoothness1 , _Smoothness2 , _Smoothness3));
			float4 appendResult206_g1 = (float4(tex2DNode4_g1.a , tex2DNode3_g1.a , tex2DNode6_g1.a , tex2DNode7_g1.a));
			float4 defaultSmoothness210_g1 = ( appendResult205_g1 * appendResult206_g1 );
			float dotResult216_g1 = dot( defaultSmoothness210_g1 , SplatControl26_g1 );
			o.Smoothness = dotResult216_g1;
			float4 appendResult188_g1 = (float4(_MaskMapRemapOffset0.y , _MaskMapRemapOffset1.y , _MaskMapRemapOffset2.y , _MaskMapRemapOffset3.y));
			float4 appendResult189_g1 = (float4(_MaskMapRemapScale0.y , _MaskMapRemapScale1.y , _MaskMapRemapScale2.y , _MaskMapRemapScale3.y));
			float4 defaultOcclusion191_g1 = ( appendResult188_g1 + appendResult189_g1 );
			float dotResult197_g1 = dot( defaultOcclusion191_g1 , SplatControl26_g1 );
			o.Occlusion = dotResult197_g1;
			o.Alpha = 1;
		}

		ENDCG
	}

	Dependency "BaseMapShader"="ASESampleShaders/SimpleTerrainBase"
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
3;1108;1931;917;1560.828;68.65179;1;True;False
Node;AmplifyShaderEditor.FunctionNode;1;-1092.938,37.35559;Inherit;False;Four Splats First Pass Terrain;0;;1;37452fdfb732e1443b7e39720d05b708;2,85,0,102,1;7;59;FLOAT4;0,0,0,0;False;60;FLOAT4;0,0,0,0;False;61;FLOAT3;0,0,0;False;57;FLOAT;0;False;58;FLOAT;0;False;201;FLOAT;0;False;62;FLOAT;0;False;7;FLOAT4;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;200;FLOAT;19;FLOAT3;17
Node;AmplifyShaderEditor.FunctionNode;63;-600.1445,-53.43982;Inherit;False;CloudsPattern;-1;;101;bc2eb12446620194aa304028cc3322f4;0;1;21;FLOAT4;0,0,0,0;False;2;FLOAT4;0;FLOAT;29
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;128,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;U_Terrain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;-100;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;1;BaseMapShader=ASESampleShaders/SimpleTerrainBase;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;63;21;1;0
WireConnection;0;0;63;0
WireConnection;0;1;1;14
WireConnection;0;3;1;56
WireConnection;0;4;1;45
WireConnection;0;5;1;200
ASEEND*/
//CHKSM=6AAD936754C114B5203E22195EFFCED2F77E4F18