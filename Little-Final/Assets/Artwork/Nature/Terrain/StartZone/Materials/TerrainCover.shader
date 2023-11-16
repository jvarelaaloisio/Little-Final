// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TerrainCover"
{
	Properties
	{
		[NoScaleOffset]_BaseColor("BaseColor", 2D) = "white" {}
		_Tiling("Tiling", Float) = 2
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
		};

		uniform sampler2D _BaseColor;
		uniform float _Tiling;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord2 = i.uv_texcoord * temp_cast_0;
			float cos4 = cos( 0.0 * _Time.y );
			float sin4 = sin( 0.0 * _Time.y );
			float2 rotator4 = mul( uv_TexCoord2 - float2( 0,90 ) , float2x2( cos4 , -sin4 , sin4 , cos4 )) + float2( 0,90 );
			o.Albedo = tex2D( _BaseColor, rotator4 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.RangedFloatNode;3;-1336.101,-30.60002;Inherit;False;Property;_Tiling;Tiling;1;0;Create;True;0;0;0;False;0;False;2;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1141.101,-76.60001;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;4;-872.037,41.25492;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,90;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-627.5,-86;Inherit;True;Property;_BaseColor;BaseColor;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;06d2f3147da96854fa9f6b36b4b3616c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;15;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;TerrainCover;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;3;0
WireConnection;4;0;2;0
WireConnection;1;1;4;0
WireConnection;15;0;1;0
ASEEND*/
//CHKSM=3008B4A8E3AE82F84F8E1ACB198A9D3255560BAC