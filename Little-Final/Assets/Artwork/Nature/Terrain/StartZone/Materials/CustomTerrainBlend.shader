// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CustomTerrainBlend"
{
	Properties
	{
		[NoScaleOffset]_Texture0Base("Texture 0 (Base)", 2D) = "white" {}
		_Texture0Tiling("Texture 0 Tiling", Float) = 1
		[NoScaleOffset]_Texture1("Texture 1", 2D) = "white" {}
		_Texture1Tiling("Texture 1 Tiling", Float) = 1
		[NoScaleOffset]_Texture2("Texture 2", 2D) = "white" {}
		_Texture2Tiling("Texture 2 Tiling", Float) = 1
		[NoScaleOffset]_Texture3("Texture 3", 2D) = "white" {}
		_Texture3Tiling("Texture 3 Tiling", Float) = 1
		[NoScaleOffset]_MaskLayer1("Mask Layer 1", 2D) = "white" {}
		_MinLayerMask1("Min (Layer Mask 1)", Float) = 1
		_MaxLayerMask1("Max (Layer Mask 1)", Float) = 1
		[NoScaleOffset]_MaskLayer2("Mask Layer 2", 2D) = "white" {}
		_MinLayerMask2("Min (Layer Mask 2)", Float) = 1
		_MaxLayerMask2("Max (Layer Mask 2)", Float) = 1
		[NoScaleOffset]_MaskLayer3("Mask Layer 3", 2D) = "white" {}
		_MinLayerMask3("Min (Layer Mask 3)", Float) = 1
		_MaxLayerMask3("Max (Layer Mask 3)", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0Base;
		uniform float _Texture0Tiling;
		uniform sampler2D _Texture2;
		uniform float _Texture2Tiling;
		uniform sampler2D _MaskLayer3;
		uniform float _MinLayerMask3;
		uniform float _MaxLayerMask3;
		uniform sampler2D _Texture3;
		uniform float _Texture3Tiling;
		uniform sampler2D _MaskLayer2;
		uniform float _MinLayerMask2;
		uniform float _MaxLayerMask2;
		uniform sampler2D _Texture1;
		uniform float _Texture1Tiling;
		uniform sampler2D _MaskLayer1;
		uniform float _MinLayerMask1;
		uniform float _MaxLayerMask1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Texture0Tiling).xx;
			float2 uv_TexCoord11 = i.uv_texcoord * temp_cast_0;
			float2 temp_cast_1 = (_Texture2Tiling).xx;
			float2 uv_TexCoord30 = i.uv_texcoord * temp_cast_1;
			float2 uv_MaskLayer317 = i.uv_texcoord;
			float4 lerpResult8 = lerp( tex2D( _Texture0Base, uv_TexCoord11 ) , tex2D( _Texture2, uv_TexCoord30 ) , saturate( (_MinLayerMask3 + (tex2D( _MaskLayer3, uv_MaskLayer317 ).r - 0.0) * (_MaxLayerMask3 - _MinLayerMask3) / (1.0 - 0.0)) ));
			float2 temp_cast_2 = (_Texture3Tiling).xx;
			float2 uv_TexCoord31 = i.uv_texcoord * temp_cast_2;
			float2 uv_MaskLayer215 = i.uv_texcoord;
			float4 lerpResult18 = lerp( lerpResult8 , tex2D( _Texture3, uv_TexCoord31 ) , saturate( (_MinLayerMask2 + (tex2D( _MaskLayer2, uv_MaskLayer215 ).r - 0.0) * (_MaxLayerMask2 - _MinLayerMask2) / (1.0 - 0.0)) ));
			float2 temp_cast_3 = (_Texture1Tiling).xx;
			float2 uv_TexCoord13 = i.uv_texcoord * temp_cast_3;
			float2 uv_MaskLayer116 = i.uv_texcoord;
			float4 lerpResult21 = lerp( lerpResult18 , tex2D( _Texture1, uv_TexCoord13 ) , saturate( (_MinLayerMask1 + (tex2D( _MaskLayer1, uv_MaskLayer116 ).r - 0.0) * (_MaxLayerMask1 - _MinLayerMask1) / (1.0 - 0.0)) ));
			o.Albedo = lerpResult21.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
317;876;1883;760;2643.118;-6.123047;2.147912;True;True
Node;AmplifyShaderEditor.RangedFloatNode;12;-1488,-128;Inherit;False;Property;_Texture0Tiling;Texture 0 Tiling;1;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1488,288;Inherit;False;Property;_Texture2Tiling;Texture 2 Tiling;5;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-1024,1280;Inherit;True;Property;_MaskLayer3;Mask Layer 3;14;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;9ac3d8b8793a1bb41904a3192afc916c;9ac3d8b8793a1bb41904a3192afc916c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-720,1376;Inherit;False;Property;_MinLayerMask3;Min (Layer Mask 3);15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-720,1456;Inherit;False;Property;_MaxLayerMask3;Max (Layer Mask 3);16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-1296,288;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;40;-496,1280;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-1024,1024;Inherit;True;Property;_MaskLayer2;Mask Layer 2;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;f6e6cde90bc035844b9c7b8d57590260;f6e6cde90bc035844b9c7b8d57590260;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1280,-128;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-720,1200;Inherit;False;Property;_MaxLayerMask2;Max (Layer Mask 2);13;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-720,1120;Inherit;False;Property;_MinLayerMask2;Min (Layer Mask 2);12;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1488,496;Inherit;False;Property;_Texture3Tiling;Texture 3 Tiling;7;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1296,496;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-1024,288;Inherit;True;Property;_Texture2;Texture 2;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;c29ec51bd7874d647a62066d39c3d806;25e1d1375f6e5424fa4152cdc64a746c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;36;-496,1024;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-720,832;Inherit;False;Property;_MinLayerMask1;Min (Layer Mask 1);9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-1018.866,-128;Inherit;True;Property;_Texture0Base;Texture 0 (Base);0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;06d2f3147da96854fa9f6b36b4b3616c;06d2f3147da96854fa9f6b36b4b3616c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-720,912;Inherit;False;Property;_MaxLayerMask1;Max (Layer Mask 1);10;0;Create;True;0;0;0;False;0;False;1;3.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-1024,752;Inherit;True;Property;_MaskLayer1;Mask Layer 1;8;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;35aad738926e8b047b9fa4e4e6c07a8c;35aad738926e8b047b9fa4e4e6c07a8c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-1488,80;Inherit;False;Property;_Texture1Tiling;Texture 1 Tiling;3;0;Create;True;0;0;0;False;0;False;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-320,1280;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;8;-96,-112;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;33;-496,752;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1280,80;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-1024,496;Inherit;True;Property;_Texture3;Texture 3;6;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;25e1d1375f6e5424fa4152cdc64a746c;c29ec51bd7874d647a62066d39c3d806;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;35;-320,1024;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;96,271.2127;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1024,80;Inherit;True;Property;_Texture1;Texture 1;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;82775c992a97da846beeb308f76030c4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;28;-320,752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;336,480;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;759.3728,80;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;CustomTerrainBlend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;29;0
WireConnection;40;0;17;1
WireConnection;40;3;41;0
WireConnection;40;4;42;0
WireConnection;11;0;12;0
WireConnection;31;0;32;0
WireConnection;19;1;30;0
WireConnection;36;0;15;1
WireConnection;36;3;37;0
WireConnection;36;4;38;0
WireConnection;10;1;11;0
WireConnection;39;0;40;0
WireConnection;8;0;10;0
WireConnection;8;1;19;0
WireConnection;8;2;39;0
WireConnection;33;0;16;1
WireConnection;33;3;26;0
WireConnection;33;4;34;0
WireConnection;13;0;14;0
WireConnection;20;1;31;0
WireConnection;35;0;36;0
WireConnection;18;0;8;0
WireConnection;18;1;20;0
WireConnection;18;2;35;0
WireConnection;2;1;13;0
WireConnection;28;0;33;0
WireConnection;21;0;18;0
WireConnection;21;1;2;0
WireConnection;21;2;28;0
WireConnection;0;0;21;0
ASEEND*/
//CHKSM=3766BDAD66D1BC047EF4BD8EFC51FAE941DD6714