// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Nature/Rocks"
{
	Properties
	{
		_BaseColor("Base Color", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Roughness("Roughness", 2D) = "white" {}
		_RoughnessLevels_Min("Roughness Levels_Min", Float) = 0.79
		_RoughnessLevels_Max("Roughness Levels_Max", Float) = 0.91
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
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
		uniform float4 _Normal_ST;
		uniform sampler2D _BaseColor;
		uniform float4 _BaseColor_ST;
		uniform sampler2D _Roughness;
		uniform float4 _Roughness_ST;
		uniform float _RoughnessLevels_Min;
		uniform float _RoughnessLevels_Max;


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
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 OUT_Normal16 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			o.Normal = OUT_Normal16;
			float2 uv_BaseColor = i.uv_texcoord * _BaseColor_ST.xy + _BaseColor_ST.zw;
			float4 temp_output_21_0_g1 = tex2D( _BaseColor, uv_BaseColor );
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
			float2 panner10_g12 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g1 * 0.01 ));
			float simplePerlin2D11_g12 = snoise( panner10_g12 );
			simplePerlin2D11_g12 = simplePerlin2D11_g12*0.5 + 0.5;
			float2 temp_cast_2 = (0.1).xx;
			float2 panner10_g11 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g1 * ( temp_output_2_0_g1 * 4.0 ) ));
			float simplePerlin2D11_g11 = snoise( panner10_g11 );
			simplePerlin2D11_g11 = simplePerlin2D11_g11*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g1 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g1 * simplePerlin2D11_g12 ) + ( 1.0 - simplePerlin2D11_g11 ) ) * temp_output_8_0_g1 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g1 = lerp( temp_output_21_0_g1 , saturate( ( temp_output_21_0_g1 * color20_g1 ) ) , ( temp_output_16_0_g1 * 1.0 ));
			float4 OUT_BaseColor15 = lerpResult24_g1;
			o.Albedo = OUT_BaseColor15.rgb;
			float2 uv_Roughness = i.uv_texcoord * _Roughness_ST.xy + _Roughness_ST.zw;
			float OUT_Smoothness17 = (_RoughnessLevels_Min + (( 1.0 - tex2D( _Roughness, uv_Roughness ).r ) - 0.0) * (_RoughnessLevels_Max - _RoughnessLevels_Min) / (1.0 - 0.0));
			o.Smoothness = OUT_Smoothness17;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.SamplerNode;7;-768,384;Inherit;True;Property;_Roughness;Roughness;2;0;Create;True;0;0;0;False;0;False;-1;029e7b08c8ba92a40a4e11ea403bde80;029e7b08c8ba92a40a4e11ea403bde80;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;8;-448,384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-768,-128;Inherit;True;Property;_BaseColor;Base Color;0;0;Create;True;0;0;0;False;0;False;-1;None;d7c7f73fe32c947469da8d07645ffe0b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;2;-352,-80;Inherit;False;CloudsPattern;-1;;1;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.SamplerNode;4;-768,128;Inherit;True;Property;_Normal;Normal;1;0;Create;True;0;0;0;False;0;False;-1;7bb22a9c07ee6c04592d6bcf9609e938;7bb22a9c07ee6c04592d6bcf9609e938;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;13;-290,388;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-94.67896,-64.19888;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-93.67896,347.8011;Inherit;False;OUT_Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-87.67896,126.8011;Inherit;False;OUT_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-768,576;Inherit;False;Property;_RoughnessLevels_Min;Roughness Levels_Min;3;0;Create;True;0;0;0;False;0;False;0.79;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-768,640;Inherit;False;Property;_RoughnessLevels_Max;Roughness Levels_Max;4;0;Create;True;0;0;0;False;0;False;0.91;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;28;203,-3;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Nature/Rocks;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;1
WireConnection;2;21;1;0
WireConnection;13;0;8;0
WireConnection;13;3;9;0
WireConnection;13;4;14;0
WireConnection;15;0;2;0
WireConnection;17;0;13;0
WireConnection;16;0;4;0
WireConnection;28;0;15;0
WireConnection;28;1;16;0
WireConnection;28;4;17;0
ASEEND*/
//CHKSM=BD23B6DD1662196D7230BE8337B667ACFCB5CD15