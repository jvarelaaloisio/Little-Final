// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Nature/StandarPineBark"
{
	Properties
	{
		[NoScaleOffset]_Color_Texture("Color_Texture", 2D) = "white" {}
		_Trunk__MaskMin("Trunk__Mask Min", Float) = -0.01
		_Trunk__MaskMax("Trunk__Mask Max", Float) = 10
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _Trunk__MaskMin;
		uniform float _Trunk__MaskMax;
		uniform sampler2D _Color_Texture;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime12_g11 = _Time.y * 0.5;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 temp_output_14_0_g11 = ase_vertex3Pos;
			float3 rotatedValue2_g11 = RotateAroundAxis( float3( 0,0,0 ), temp_output_14_0_g11, float3(0,1,0), (-0.05 + (sin( mulTime12_g11 ) - -1.0) * (0.05 - -0.05) / (1.0 - -1.0)) );
			v.vertex.xyz += ( ( rotatedValue2_g11 - temp_output_14_0_g11 ) * saturate( (_Trunk__MaskMin + (ase_vertex3Pos.z - 0.0) * (_Trunk__MaskMax - _Trunk__MaskMin) / (1.0 - 0.0)) ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Color_Texture2 = i.uv_texcoord;
			float4 temp_output_21_0_g12 = tex2D( _Color_Texture, uv_Color_Texture2 );
			float4 color20_g12 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_0 = (0.1).xx;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5_g12 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g12 = ( 0.01 * 1.5 );
			float2 panner10_g13 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult5_g12 * temp_output_2_0_g12 ));
			float simplePerlin2D11_g13 = snoise( panner10_g13 );
			simplePerlin2D11_g13 = simplePerlin2D11_g13*0.5 + 0.5;
			float temp_output_8_0_g12 = simplePerlin2D11_g13;
			float2 temp_cast_1 = (0.1).xx;
			float2 panner10_g15 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g12 * 0.01 ));
			float simplePerlin2D11_g15 = snoise( panner10_g15 );
			simplePerlin2D11_g15 = simplePerlin2D11_g15*0.5 + 0.5;
			float2 temp_cast_2 = (0.1).xx;
			float2 panner10_g14 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g12 * ( temp_output_2_0_g12 * 4.0 ) ));
			float simplePerlin2D11_g14 = snoise( panner10_g14 );
			simplePerlin2D11_g14 = simplePerlin2D11_g14*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g12 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g12 * simplePerlin2D11_g15 ) + ( 1.0 - simplePerlin2D11_g14 ) ) * temp_output_8_0_g12 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g12 = lerp( temp_output_21_0_g12 , saturate( ( temp_output_21_0_g12 * color20_g12 ) ) , ( temp_output_16_0_g12 * 1.0 ));
			o.Albedo = lerpResult24_g12.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1807;1054;1931;1011;1226.274;430.7889;1.386667;True;False
Node;AmplifyShaderEditor.CommentaryNode;61;-928,448;Inherit;False;647;273;Trunk Mask;4;57;59;58;60;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;53;-928,208;Inherit;False;781;202;Animation;3;55;51;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;52;-896,256;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;-898,511;Inherit;False;Property;_Trunk__MaskMin;Trunk__Mask Min;1;0;Create;True;0;0;0;False;0;False;-0.01;-0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-897,609;Inherit;False;Property;_Trunk__MaskMax;Trunk__Mask Max;2;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;-928,-304;Inherit;False;634;280;Base Color;2;2;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;58;-640,512;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-896,-256;Inherit;True;Property;_Color_Texture;Color_Texture;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;46e04f04dc582bc4f9100c83afd0f6e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;51;-704,256;Inherit;False;PineMovement;-1;;11;d5c45313e033b094f86057ee8154a179;0;1;14;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;60;-448,512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;11;-576,-256;Inherit;False;CloudsPattern;-1;;12;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-288,256;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Nature/StandarPineBark;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;58;0;52;3
WireConnection;58;3;57;0
WireConnection;58;4;59;0
WireConnection;51;14;52;0
WireConnection;60;0;58;0
WireConnection;11;21;2;0
WireConnection;55;0;51;0
WireConnection;55;1;60;0
WireConnection;0;0;11;0
WireConnection;0;11;55;0
ASEEND*/
//CHKSM=645195C2C5F8CF2F80E13FDA8A23D56DFE721634