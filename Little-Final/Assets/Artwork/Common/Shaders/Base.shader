// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Common/Base"
{
	Properties
	{
		[NoScaleOffset]_BaseColor("Base Color", 2D) = "white" {}
		[NoScaleOffset]_Emission("Emission", 2D) = "white" {}
		_EmissionFac("Emission Fac", Range( 0 , 1)) = 0.1195025
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_Metalic("Metalic", 2D) = "white" {}
		[NoScaleOffset]_Roughness("Roughness", 2D) = "white" {}
		_RoughnessFac("Roughness Fac", Range( 0 , 1)) = 0.1195025
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _BaseColor;
		uniform sampler2D _Emission;
		uniform float _EmissionFac;
		uniform sampler2D _Metalic;
		uniform sampler2D _Roughness;
		uniform float _RoughnessFac;


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
			float2 uv_Normal4 = i.uv_texcoord;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal4 ) );
			float2 uv_BaseColor1 = i.uv_texcoord;
			float4 temp_output_21_0_g1 = tex2D( _BaseColor, uv_BaseColor1 );
			float4 color20_g1 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_0 = (0.1).xx;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5_g1 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g1 = ( 0.01 * 1.5 );
			float2 panner10_g8 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult5_g1 * temp_output_2_0_g1 ));
			float simplePerlin2D11_g8 = snoise( panner10_g8 );
			simplePerlin2D11_g8 = simplePerlin2D11_g8*0.5 + 0.5;
			float temp_output_8_0_g1 = simplePerlin2D11_g8;
			float2 temp_cast_1 = (0.1).xx;
			float2 panner10_g6 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g1 * 0.01 ));
			float simplePerlin2D11_g6 = snoise( panner10_g6 );
			simplePerlin2D11_g6 = simplePerlin2D11_g6*0.5 + 0.5;
			float2 temp_cast_2 = (0.1).xx;
			float2 panner10_g9 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g1 * ( temp_output_2_0_g1 * 4.0 ) ));
			float simplePerlin2D11_g9 = snoise( panner10_g9 );
			simplePerlin2D11_g9 = simplePerlin2D11_g9*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g1 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g1 * simplePerlin2D11_g6 ) + ( 1.0 - simplePerlin2D11_g9 ) ) * temp_output_8_0_g1 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g1 = lerp( temp_output_21_0_g1 , saturate( ( temp_output_21_0_g1 * color20_g1 ) ) , temp_output_16_0_g1);
			o.Albedo = lerpResult24_g1.rgb;
			float2 uv_Emission14 = i.uv_texcoord;
			o.Emission = ( tex2D( _Emission, uv_Emission14 ) * _EmissionFac ).rgb;
			float2 uv_Metalic9 = i.uv_texcoord;
			o.Metallic = tex2D( _Metalic, uv_Metalic9 ).r;
			float2 uv_Roughness5 = i.uv_texcoord;
			o.Smoothness = ( ( 1.0 - tex2D( _Roughness, uv_Roughness5 ).r ) * _RoughnessFac );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
38;1020;1906;1081;2852.072;735.3456;2.194589;True;False
Node;AmplifyShaderEditor.SamplerNode;5;-768,736;Inherit;True;Property;_Roughness;Roughness;5;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-768,-128;Inherit;True;Property;_BaseColor;Base Color;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;46e04f04dc582bc4f9100c83afd0f6e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-768,256;Inherit;True;Property;_Emission;Emission;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-768,448;Inherit;False;Property;_EmissionFac;Emission Fac;2;0;Create;True;0;0;0;False;0;False;0.1195025;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-768,928;Inherit;False;Property;_RoughnessFac;Roughness Fac;6;0;Create;True;0;0;0;False;0;False;0.1195025;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;11;-480,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-768,64;Inherit;True;Property;_Normal;Normal;3;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-448,256;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;-768,544;Inherit;True;Property;_Metalic;Metalic;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-320,736;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;6;-384,-128;Inherit;False;CloudsPattern;-1;;1;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Common/Base;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;5;1
WireConnection;16;0;14;0
WireConnection;16;1;17;0
WireConnection;12;0;11;0
WireConnection;12;1;13;0
WireConnection;6;21;1;0
WireConnection;0;0;6;0
WireConnection;0;1;4;0
WireConnection;0;2;16;0
WireConnection;0;3;9;0
WireConnection;0;4;12;0
ASEEND*/
//CHKSM=8E44CE5E4A7A2EB67447F70D1612FAEBE54F3101