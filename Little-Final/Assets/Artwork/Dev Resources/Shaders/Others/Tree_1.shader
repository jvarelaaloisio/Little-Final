// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tree_1"
{
	Properties
	{
		_Holacalyx_Balansae__Alecrin_o_Sabuguero_height("Holacalyx_Balansae__Alecrin_o_Sabuguero_ - height", 2D) = "white"{}
		_Holacalyx_Balansae__Alecrin_o_Sabuguero_normal("Holacalyx_Balansae__Alecrin_o_Sabuguero_ - normal", 2D) = "white"{}
		_Holacalyx_Balansae__Alecrin_o_Sabuguero_baseColor("Holacalyx_Balansae__Alecrin_o_Sabuguero_ - baseColor", 2D) = "white"{}
		_Holacalyx_Balansae__Alecrin_o_Sabuguero_metallic("Holacalyx_Balansae__Alecrin_o_Sabuguero_ - metallic", 2D) = "white"{}
		_Holacalyx_Balansae__Alecrin_o_Sabuguero_roughness("Holacalyx_Balansae__Alecrin_o_Sabuguero_ - roughness", 2D) = "white"{}
		_Holacalyx_Balansae__Alecrin_o_Sabuguero_ambientOcclusion("Holacalyx_Balansae__Alecrin_o_Sabuguero_ - ambientOcclusion", 2D) = "white"{}
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 15
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_Tiling("Tiling", Float) = 1
		_HeightIntensity("Height Intensity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Holacalyx_Balansae__Alecrin_o_Sabuguero_height;
		uniform float _Tiling;
		uniform float _HeightIntensity;
		uniform sampler2D _Holacalyx_Balansae__Alecrin_o_Sabuguero_normal;
		uniform sampler2D _Holacalyx_Balansae__Alecrin_o_Sabuguero_baseColor;
		uniform sampler2D _Holacalyx_Balansae__Alecrin_o_Sabuguero_metallic;
		uniform sampler2D _Holacalyx_Balansae__Alecrin_o_Sabuguero_roughness;
		uniform sampler2D _Holacalyx_Balansae__Alecrin_o_Sabuguero_ambientOcclusion;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord50 = v.texcoord.xy * temp_cast_0;
			float4 _Holacalyx_Balansae__Alecrin_o_Sabuguero_height28 = tex2Dlod(_Holacalyx_Balansae__Alecrin_o_Sabuguero_height, float4( uv_TexCoord50, 0.0 , 0.0 ));
			float3 ase_vertexNormal = v.normal.xyz;
			float3 appendResult49 = (float3(ase_vertexNormal));
			v.vertex.xyz += ( ( _Holacalyx_Balansae__Alecrin_o_Sabuguero_height28 * _HeightIntensity ) * float4( appendResult49 , 0.0 ) ).xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord50 = i.uv_texcoord * temp_cast_0;
			float3 _Holacalyx_Balansae__Alecrin_o_Sabuguero_normal28 = UnpackNormal( tex2D(_Holacalyx_Balansae__Alecrin_o_Sabuguero_normal, uv_TexCoord50) );
			o.Normal = _Holacalyx_Balansae__Alecrin_o_Sabuguero_normal28;
			float4 _Holacalyx_Balansae__Alecrin_o_Sabuguero_baseColor28 = tex2D(_Holacalyx_Balansae__Alecrin_o_Sabuguero_baseColor, uv_TexCoord50);
			o.Albedo = _Holacalyx_Balansae__Alecrin_o_Sabuguero_baseColor28.xyz;
			float4 _Holacalyx_Balansae__Alecrin_o_Sabuguero_metallic28 = tex2D(_Holacalyx_Balansae__Alecrin_o_Sabuguero_metallic, uv_TexCoord50);
			o.Metallic = _Holacalyx_Balansae__Alecrin_o_Sabuguero_metallic28.x;
			float4 _Holacalyx_Balansae__Alecrin_o_Sabuguero_roughness28 = tex2D(_Holacalyx_Balansae__Alecrin_o_Sabuguero_roughness, uv_TexCoord50);
			o.Smoothness = ( 1.0 - _Holacalyx_Balansae__Alecrin_o_Sabuguero_roughness28 ).x;
			float4 _Holacalyx_Balansae__Alecrin_o_Sabuguero_ambientOcclusion28 = tex2D(_Holacalyx_Balansae__Alecrin_o_Sabuguero_ambientOcclusion, uv_TexCoord50);
			o.Occlusion = _Holacalyx_Balansae__Alecrin_o_Sabuguero_ambientOcclusion28.x;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
1408;1114;1721;928;2243.38;486.6244;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;51;-1670.38,-143.6244;Inherit;False;Property;_Tiling;Tiling;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-1466.38,-189.6244;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SubstanceSamplerNode;28;-1220.012,-198.96;Inherit;True;Property;_SubstanceSample1;Substance Sample 1;6;0;Create;True;0;0;False;0;False;210345067c3ddb944a883532d34b2e5b;0;True;1;0;FLOAT2;0,0;False;6;FLOAT4;0;FLOAT4;1;FLOAT4;2;FLOAT4;3;FLOAT3;4;FLOAT4;5
Node;AmplifyShaderEditor.NormalVertexDataNode;48;-669.311,162.9157;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;-768.7668,90.37163;Inherit;False;Property;_HeightIntensity;Height Intensity;7;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;-482.8349,163.3334;Inherit;False;FLOAT3;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-475.7664,72.37164;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-112.7664,103.3716;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;17;-205.2816,-36.84657;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;619.7001,-178.1;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Tree_1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;15;10;25;False;0.52;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;50;0;51;0
WireConnection;28;0;50;0
WireConnection;49;0;48;0
WireConnection;45;0;28;2
WireConnection;45;1;46;0
WireConnection;47;0;45;0
WireConnection;47;1;49;0
WireConnection;17;0;28;5
WireConnection;0;0;28;1
WireConnection;0;1;28;4
WireConnection;0;3;28;3
WireConnection;0;4;17;0
WireConnection;0;5;28;0
WireConnection;0;11;47;0
ASEEND*/
//CHKSM=FB0EE26D78C06E3A3BA0DBEA995D0C6331A72149