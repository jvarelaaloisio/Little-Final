// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "araucaria_bark"
{
	Properties
	{
		_araucaria_bark("araucaria_bark", 2D) = "white" {}
		_Tilingx("Tiling x", Float) = 2
		_Tilingy("Tiling y", Float) = 2
		_Smothness("Smothness", Range( 0 , 1)) = 0
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

		uniform sampler2D _araucaria_bark;
		uniform float _Tilingx;
		uniform float _Tilingy;
		uniform float _Smothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 appendResult20 = (float4(_Tilingx , _Tilingy , 0.0 , 0.0));
			float2 uv_TexCoord3 = i.uv_texcoord * appendResult20.xy;
			o.Albedo = tex2D( _araucaria_bark, uv_TexCoord3 ).rgb;
			o.Smoothness = _Smothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.RangedFloatNode;18;-432.493,385.4808;Inherit;False;Property;_Smothness;Smothness;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1892.838,4.031101;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1648.5,-40.5;Inherit;True;Property;_araucaria_bark;araucaria_bark;0;0;Create;True;0;0;0;False;0;False;-1;7c22b5563449af14ea150517c9b70f38;d1f5b6d598443874c809b1a37281442e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;17;298,-40;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;araucaria_bark;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-2064.354,-10.75708;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2262.893,-18.96185;Inherit;False;Property;_Tilingx;Tiling x;1;0;Create;True;0;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2274.354,50.24292;Inherit;False;Property;_Tilingy;Tiling y;2;0;Create;True;0;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
WireConnection;3;0;20;0
WireConnection;1;1;3;0
WireConnection;17;0;1;0
WireConnection;17;4;18;0
WireConnection;20;0;4;0
WireConnection;20;1;19;0
ASEEND*/
//CHKSM=3D9ED4D6FCACBCD006AD42563326FB332CA7A017