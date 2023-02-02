// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Common/BackFaceCullMasked"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[NoScaleOffset]_BaseColor("Base Color", 2D) = "white" {}
		_ColorMultiply("Color Multiply", Color) = (1,1,1,0)
		[NoScaleOffset]_Metallic("Metallic", 2D) = "white" {}
		_MetallicMultiply("Metallic Multiply", Range( 0 , 1)) = 0
		[NoScaleOffset]_Roughness("Roughness", 2D) = "white" {}
		_RoughnessMultiply("Roughness Multiply", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BaseColor;
		uniform float4 _ColorMultiply;
		uniform sampler2D _Metallic;
		uniform float _MetallicMultiply;
		uniform sampler2D _Roughness;
		uniform float _RoughnessMultiply;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BaseColor1 = i.uv_texcoord;
			float4 tex2DNode1 = tex2D( _BaseColor, uv_BaseColor1 );
			o.Albedo = ( tex2DNode1 * _ColorMultiply ).rgb;
			float2 uv_Metallic3 = i.uv_texcoord;
			o.Metallic = ( tex2D( _Metallic, uv_Metallic3 ) * _MetallicMultiply ).r;
			float2 uv_Roughness4 = i.uv_texcoord;
			o.Smoothness = ( 1.0 - ( tex2D( _Roughness, uv_Roughness4 ) * _RoughnessMultiply ) ).r;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
149;272;1780;908;1312.959;243.7969;1;True;False
Node;AmplifyShaderEditor.SamplerNode;4;-725.5,383.5;Inherit;True;Property;_Roughness;Roughness;5;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-727.709,593.4331;Inherit;False;Property;_RoughnessMultiply;Roughness Multiply;6;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-713.3748,-87.96002;Inherit;False;Property;_ColorMultiply;Color Multiply;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-745.0351,-271.195;Inherit;True;Property;_BaseColor;Base Color;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;9cc01fea27b56574b9f9ffca8747aa46;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-738.5,91.5;Inherit;True;Property;_Metallic;Metallic;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-717.709,275.4331;Inherit;False;Property;_MetallicMultiply;Metallic Multiply;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-364.8583,440.2579;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-320.5,-124.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-357.709,144.4331;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;5;-163.0144,424.0043;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Common/BackFaceCullMasked;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;4;0
WireConnection;12;1;11;0
WireConnection;8;0;1;0
WireConnection;8;1;7;0
WireConnection;10;0;3;0
WireConnection;10;1;9;0
WireConnection;5;0;12;0
WireConnection;0;0;8;0
WireConnection;0;3;10;0
WireConnection;0;4;5;0
WireConnection;0;10;1;4
ASEEND*/
//CHKSM=F3101CB6010D0BF76AA11322475B4C8D7FDF7B21