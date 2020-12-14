// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Island_0"
{
	Properties
	{
		_Styllized_snow_testambientOcclusion("Styllized_snow_test - ambientOcclusion", 2D) = "white"{}
		_GrassbaseColor("Grass - baseColor", 2D) = "white"{}
		_Styllized_snow_testbaseColor("Styllized_snow_test - baseColor", 2D) = "white"{}
		[NoScaleOffset]_Terrain_1001_BaseColor("Terrain_1001_BaseColor", 2D) = "white" {}
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Range("Range", Float) = 0
		[NoScaleOffset]_GrassMask("GrassMask", 2D) = "white" {}
		_TillingSnow("Tilling Snow", Float) = 50
		_TilingGrass("Tiling Grass", Float) = 120
		_snowmkas_ext("snowmkas_ext", 2D) = "white" {}
		_SaturationGrass("Saturation Grass", Float) = 0
		_SaturateSnow("SaturateSnow", Float) = 0
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Styllized_snow_testambientOcclusion;
		uniform float _TillingSnow;
		uniform float _Range;
		uniform sampler2D _Terrain_1001_BaseColor;
		uniform sampler2D _GrassbaseColor;
		uniform float _TilingGrass;
		uniform float _SaturationGrass;
		uniform sampler2D _GrassMask;
		uniform sampler2D _Styllized_snow_testbaseColor;
		uniform float _SaturateSnow;
		uniform sampler2D _snowmkas_ext;
		uniform float4 _snowmkas_ext_ST;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_TillingSnow).xx;
			float2 uv_TexCoord43 = i.uv_texcoord * temp_cast_0;
			float4 _Styllized_snow_testambientOcclusion41 = tex2D(_Styllized_snow_testambientOcclusion, uv_TexCoord43);
			float4 S_NormalSnow48 = _Styllized_snow_testambientOcclusion41;
			o.Normal = S_NormalSnow48.rgb;
			float2 uv_Terrain_1001_BaseColor1 = i.uv_texcoord;
			float4 AlbedoBase17 = saturate( ( _Range * tex2D( _Terrain_1001_BaseColor, uv_Terrain_1001_BaseColor1 ) ) );
			float2 temp_cast_2 = (_TilingGrass).xx;
			float2 uv_TexCoord19 = i.uv_texcoord * temp_cast_2;
			float4 _GrassbaseColor13 = tex2D(_GrassbaseColor, uv_TexCoord19);
			float4 S_GrassBase28 = _GrassbaseColor13;
			float2 uv_GrassMask15 = i.uv_texcoord;
			float4 lerpResult16 = lerp( AlbedoBase17 , saturate( ( S_GrassBase28 * _SaturationGrass ) ) , tex2D( _GrassMask, uv_GrassMask15 ));
			float4 _Styllized_snow_testbaseColor41 = tex2D(_Styllized_snow_testbaseColor, uv_TexCoord43);
			float4 S_ColorSnow46 = _Styllized_snow_testbaseColor41;
			float2 uv_snowmkas_ext = i.uv_texcoord * _snowmkas_ext_ST.xy + _snowmkas_ext_ST.zw;
			float4 lerpResult50 = lerp( lerpResult16 , ( S_ColorSnow46 * _SaturateSnow ) , tex2D( _snowmkas_ext, uv_snowmkas_ext ));
			o.Albedo = saturate( lerpResult50 ).rgb;
			float temp_output_39_0 = 0.0;
			o.Metallic = temp_output_39_0;
			o.Smoothness = temp_output_39_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
91;152;1055;687;212.1065;5.036125;1.093195;True;False
Node;AmplifyShaderEditor.RangedFloatNode;20;-2272.55,-533.3271;Inherit;False;Property;_TilingGrass;Tiling Grass;11;0;Create;True;0;0;False;0;120;300;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-2109.408,-551.3539;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-2516.473,-309.0521;Inherit;False;Property;_TillingSnow;Tilling Snow;10;0;Create;True;0;0;False;0;50;300;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SubstanceSamplerNode;13;-1887.958,-558.2976;Inherit;True;Property;_SubstanceSample0;Substance Sample 0;7;0;Create;True;0;0;False;0;65e31210135435347aecb3c9c9a3cf5d;0;True;1;0;FLOAT2;0,0;False;3;COLOR;0;COLOR;1;COLOR;2
Node;AmplifyShaderEditor.RangedFloatNode;8;-768.431,-589.8375;Inherit;False;Property;_Range;Range;6;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1152.431,-573.8375;Inherit;True;Property;_Terrain_1001_BaseColor;Terrain_1001_BaseColor;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;e4a0cb42b342b6a41a38f569371edde2;e4a0cb42b342b6a41a38f569371edde2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-1500.644,-549.5353;Inherit;False;S_GrassBase;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-608.431,-525.8374;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-2366.855,-333.1285;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SubstanceSamplerNode;41;-2115.41,-329.1942;Inherit;True;Property;_SubstanceSample1;Substance Sample 1;9;0;Create;True;0;0;False;0;6c35ae432aeb07f49a14c42934b0198c;0;True;1;0;FLOAT2;0,0;False;5;COLOR;0;COLOR;1;COLOR;2;COLOR;3;COLOR;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-772.3428,-194.9711;Inherit;False;Property;_SaturationGrass;Saturation Grass;14;0;Create;True;0;0;False;0;0;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-769.9744,-264.0457;Inherit;False;28;S_GrassBase;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;9;-460.4178,-506.6357;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-1505.379,-356.4109;Inherit;False;S_ColorSnow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-561.4965,-230.6205;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-319.414,-514.3262;Inherit;False;AlbedoBase;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-418.3378,-271.6721;Inherit;False;17;AlbedoBase;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;23;-373.937,-192.7419;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;15;-523.792,-120.0611;Inherit;True;Property;_GrassMask;GrassMask;8;1;[NoScaleOffset];Create;True;0;0;False;0;-1;633baa7a4a1b8b7488d75fde38ff7239;633baa7a4a1b8b7488d75fde38ff7239;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-502.2195,313.0751;Inherit;False;Property;_SaturateSnow;SaturateSnow;15;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-516.9803,230.8674;Inherit;False;46;S_ColorSnow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;58;-509.8941,447.7946;Inherit;True;Property;_snowmkas_ext;snowmkas_ext;13;0;Create;True;0;0;False;0;-1;2d7643b122557cf48a1b54a6e2390b6a;2d7643b122557cf48a1b54a6e2390b6a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;16;-42.38774,-134.9671;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-290.246,272.9634;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-1485.061,-129.4956;Inherit;False;S_NormalSnow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;50;153.1971,57.46094;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;49;-501.8,642.6783;Inherit;True;Property;_SnowMask;SnowMask;12;0;Create;True;0;0;False;0;-1;5ef1579932d7f0140a1864327e5d4e60;5ef1579932d7f0140a1864327e5d4e60;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;38;388.3714,32.88144;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;11;273.4096,884.8895;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1500.557,-463.9613;Inherit;False;S_GrassNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;39;405.3096,328.8447;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-179.9712,566.579;Inherit;False;48;S_NormalSnow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1481.798,-207.8318;Inherit;False;S_HeightSnow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-10.52848,883.8196;Inherit;True;Property;_Terrain_1001_Roughness;Terrain_1001_Roughness;16;1;[NoScaleOffset];Create;True;0;0;False;0;-1;7fe98168230b03347906aaaea351cb78;7fe98168230b03347906aaaea351cb78;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-1493.379,-285.4109;Inherit;False;S_Normal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;630.9061,86.93163;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Island_0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;20;0
WireConnection;13;0;19;0
WireConnection;28;0;13;0
WireConnection;7;0;8;0
WireConnection;7;1;1;0
WireConnection;43;0;42;0
WireConnection;41;0;43;0
WireConnection;9;0;7;0
WireConnection;46;0;41;0
WireConnection;21;0;29;0
WireConnection;21;1;22;0
WireConnection;17;0;9;0
WireConnection;23;0;21;0
WireConnection;16;0;18;0
WireConnection;16;1;23;0
WireConnection;16;2;15;0
WireConnection;52;0;51;0
WireConnection;52;1;53;0
WireConnection;48;0;41;4
WireConnection;50;0;16;0
WireConnection;50;1;52;0
WireConnection;50;2;58;0
WireConnection;38;0;50;0
WireConnection;11;0;5;0
WireConnection;26;0;13;2
WireConnection;47;0;41;2
WireConnection;45;0;41;1
WireConnection;0;0;38;0
WireConnection;0;1;57;0
WireConnection;0;3;39;0
WireConnection;0;4;39;0
ASEEND*/
//CHKSM=B75C9CED8568C6A8E758478BF55CD14FDEC70AAD