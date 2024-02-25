// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Actors/Niandu"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[NoScaleOffset]_Niandu_Roughtness("Niandu_Roughtness", 2D) = "white" {}
		[NoScaleOffset]_Niandu_BaseColor("Niandu_BaseColor", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Niandu_BaseColor;
		uniform sampler2D _Niandu_Roughtness;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Niandu_BaseColor4 = i.uv_texcoord;
			float4 tex2DNode4 = tex2D( _Niandu_BaseColor, uv_Niandu_BaseColor4 );
			float4 OUt_BaseColor5 = tex2DNode4;
			o.Albedo = OUt_BaseColor5.rgb;
			float2 uv_Niandu_Roughtness1 = i.uv_texcoord;
			o.Smoothness = ( 1.0 - tex2D( _Niandu_Roughtness, uv_Niandu_Roughtness1 ) ).r;
			o.Alpha = 1;
			float OUT_Opacity6 = tex2DNode4.a;
			clip( OUT_Opacity6 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.SamplerNode;1;-672,256;Inherit;True;Property;_Niandu_Roughtness;Niandu_Roughtness;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;21aa7891414c7a144b3ab5006a3bc1c4;21aa7891414c7a144b3ab5006a3bc1c4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;2;-384,256;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-672,64;Inherit;True;Property;_Niandu_Emissive;Niandu_Emissive;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;4383e351140e49b429bea67c2b2b4e43;4383e351140e49b429bea67c2b2b4e43;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-341.611,-141.3924;Inherit;False;OUt_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-342.611,34.6076;Inherit;False;OUT_Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;18;123,-130;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Actors/Niandu;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;4;-674,-129;Inherit;True;Property;_Niandu_BaseColor;Niandu_BaseColor;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;88c2e40c859e2e4449eb9d01a86ae8fa;88c2e40c859e2e4449eb9d01a86ae8fa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;2;0;1;0
WireConnection;5;0;4;0
WireConnection;6;0;4;4
WireConnection;18;0;5;0
WireConnection;18;4;2;0
WireConnection;18;10;6;0
ASEEND*/
//CHKSM=CA822A245A7F13A0AC329169A0F7B4E1CA477653