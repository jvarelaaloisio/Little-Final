// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_StandardWeeds"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_BaseColor("BaseColor", 2D) = "white" {}
		_Speed("Speed", Float) = 0
		_Strength("Strength", Float) = 0
		_Noise("Noise", 2D) = "white" {}
		_Float0("Float 0", Float) = 1
		_Float2("Float 2", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Noise;
		uniform float _Speed;
		uniform float _Strength;
		uniform float _Float0;
		uniform float _Float2;
		uniform sampler2D _BaseColor;
		uniform float4 _BaseColor_ST;
		uniform float _Cutoff = 0.5;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 worldToObj59 = mul( unity_WorldToObject, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float2 temp_cast_0 = (( worldToObj59.x + worldToObj59.y + worldToObj59.z )).xx;
			float dotResult4_g37 = dot( temp_cast_0 , float2( 12.9898,78.233 ) );
			float lerpResult10_g37 = lerp( -1.0 , 1.0 , frac( ( sin( dotResult4_g37 ) * 43758.55 ) ));
			float2 temp_cast_1 = (_Speed).xx;
			float2 panner17 = ( 1.0 * _Time.y * temp_cast_1 + float2( 0.1,0.1 ));
			float4 tex2DNode75 = tex2Dlod( _Noise, float4( panner17, 0, 0.0) );
			float temp_output_67_0 = ( lerpResult10_g37 * tex2DNode75.r );
			float3 appendResult38 = (float3(temp_output_67_0 , 0.0 , temp_output_67_0));
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 rotatedValue26 = RotateAroundAxis( float3( 0,0,0 ), ase_vertex3Pos, appendResult38, (-_Strength + (tex2DNode75.r - -1.0) * (_Strength - -_Strength) / (1.0 - -1.0)) );
			float3 break85 = ( rotatedValue26 - ase_vertex3Pos );
			float2 temp_cast_2 = (_Float0).xx;
			float2 temp_cast_3 = (0.5).xx;
			float2 uv_TexCoord80 = v.texcoord.xy * temp_cast_3;
			float2 panner78 = ( 1.0 * _Time.y * temp_cast_2 + uv_TexCoord80);
			float3 appendResult86 = (float3(break85.x , ( break85.y * tex2Dlod( _Noise, float4( panner78, 0, 0.0) ).r * ( ase_vertex3Pos.y + _Float2 ) ) , break85.z));
			v.vertex.xyz += appendResult86;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BaseColor = i.uv_texcoord * _BaseColor_ST.xy + _BaseColor_ST.zw;
			float4 tex2DNode2 = tex2D( _BaseColor, uv_BaseColor );
			o.Albedo = tex2DNode2.rgb;
			o.Alpha = 1;
			clip( tex2DNode2.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.SamplerNode;2;-896,0;Inherit;True;Property;_BaseColor;BaseColor;1;0;Create;True;0;0;0;False;0;False;-1;None;765c48f94a33cb4479e01292d8f0a446;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;M_StandardWeeds;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TransformPositionNode;59;-2816,384;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-2560,384;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;61;-2400,384;Inherit;False;Random Range;-1;;37;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;-1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;26;-1408,384;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-1056,512;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;34;-1664,640;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;75;-2400,512;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-2080,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;38;-1920,384;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;71;-2080,608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-2272,704;Inherit;False;Property;_Strength;Strength;3;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;30;-1920,544;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;51;-2816,720;Inherit;False;Constant;_Crodinates;Crodinates;9;0;Create;True;0;0;0;False;0;False;0.1,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;17;-2624,720;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-2816,848;Inherit;False;Property;_Speed;Speed;2;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;74;-2816,528;Inherit;True;Property;_Noise;Noise;4;0;Create;True;0;0;0;False;0;False;None;8095a1f622748884d9476cda7163a5d0;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;76;-1154.813,818.9496;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;75;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;78;-1361.821,848.1847;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;80;-1650.695,826.1951;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;79;-1581.821,944.1847;Inherit;False;Property;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-1817.695,880.1951;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-644.9154,604.0931;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;85;-871.1155,601.4932;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;86;-496.7153,487.0932;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;82;-854.2158,808.1924;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-590.3154,866.6932;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-830.8152,944.6932;Inherit;False;Property;_Float2;Float 2;6;0;Create;True;0;0;0;False;0;False;1;-3;0;0;0;1;FLOAT;0
WireConnection;0;0;2;0
WireConnection;0;10;2;4
WireConnection;0;11;86;0
WireConnection;60;0;59;1
WireConnection;60;1;59;2
WireConnection;60;2;59;3
WireConnection;61;1;60;0
WireConnection;26;0;38;0
WireConnection;26;1;30;0
WireConnection;26;3;34;0
WireConnection;25;0;26;0
WireConnection;25;1;34;0
WireConnection;75;0;74;0
WireConnection;75;1;17;0
WireConnection;67;0;61;0
WireConnection;67;1;75;1
WireConnection;38;0;67;0
WireConnection;38;2;67;0
WireConnection;71;0;69;0
WireConnection;30;0;75;1
WireConnection;30;3;71;0
WireConnection;30;4;69;0
WireConnection;17;0;51;0
WireConnection;17;2;52;0
WireConnection;76;1;78;0
WireConnection;78;0;80;0
WireConnection;78;2;79;0
WireConnection;80;0;81;0
WireConnection;83;0;85;1
WireConnection;83;1;76;1
WireConnection;83;2;87;0
WireConnection;85;0;25;0
WireConnection;86;0;85;0
WireConnection;86;1;83;0
WireConnection;86;2;85;2
WireConnection;87;0;82;2
WireConnection;87;1;88;0
ASEEND*/
//CHKSM=C832D2C78D71BBBB562FB5FB7CD3290124DA57DE