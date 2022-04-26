// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "stone"
{
	Properties
	{
		_Hand_Painted_Stonenormal("Hand_Painted_Stone - normal", 2D) = "white"{}
		_Hand_Painted_StonebaseColor("Hand_Painted_Stone - baseColor", 2D) = "white"{}
		_Hand_Painted_Stonemetallic("Hand_Painted_Stone - metallic", 2D) = "white"{}
		_Hand_Painted_Stoneroughness("Hand_Painted_Stone - roughness", 2D) = "white"{}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Hand_Painted_Stonenormal;
		uniform float4 _Hand_Painted_StonebaseColor_ST;
		uniform sampler2D _Hand_Painted_StonebaseColor;
		uniform sampler2D _Hand_Painted_Stonemetallic;
		uniform sampler2D _Hand_Painted_Stoneroughness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Hand_Painted_StonebaseColor = i.uv_texcoord * _Hand_Painted_StonebaseColor_ST.xy + _Hand_Painted_StonebaseColor_ST.zw;
			float3 _Hand_Painted_Stonenormal9 = UnpackNormal( tex2D(_Hand_Painted_Stonenormal, uv_Hand_Painted_StonebaseColor) );
			o.Normal = _Hand_Painted_Stonenormal9;
			float4 _Hand_Painted_StonebaseColor9 = tex2D(_Hand_Painted_StonebaseColor, uv_Hand_Painted_StonebaseColor);
			o.Albedo = _Hand_Painted_StonebaseColor9.rgb;
			float4 _Hand_Painted_Stonemetallic9 = tex2D(_Hand_Painted_Stonemetallic, uv_Hand_Painted_StonebaseColor);
			o.Metallic = _Hand_Painted_Stonemetallic9.r;
			float4 _Hand_Painted_Stoneroughness9 = tex2D(_Hand_Painted_Stoneroughness, uv_Hand_Painted_StonebaseColor);
			o.Smoothness = ( 1.0 - _Hand_Painted_Stoneroughness9 ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
1934;812;1721;1270;1320.038;362.1173;1;True;False
Node;AmplifyShaderEditor.SubstanceSamplerNode;9;-1074.038,132.8827;Inherit;True;Property;_SubstanceSample0;Substance Sample 0;0;0;Create;True;0;0;False;0;False;bb742069855374945bc632cb03d75499;0;True;1;0;FLOAT2;0,0;False;6;COLOR;0;COLOR;1;COLOR;2;COLOR;3;FLOAT3;4;COLOR;5
Node;AmplifyShaderEditor.OneMinusNode;7;-493.0378,217.8827;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;stone;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;9;5
WireConnection;0;0;9;1
WireConnection;0;1;9;4
WireConnection;0;3;9;3
WireConnection;0;4;7;0
ASEEND*/
//CHKSM=C3358407DDFC25FB8665319DFE7DD8A9F6DB6CEB