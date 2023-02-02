// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Drimys/Nature/Bark"
{
	Properties
	{
		_BaseColorHue("Base Color Hue", Range( -1 , 1)) = 0
		_BaseColorSat("Base Color Sat", Range( -1 , 1)) = 0
		_BasecolorValue("Base color Value", Range( -1 , 1)) = 0
		_Tilling("Tilling", Float) = 0
		[NoScaleOffset]_BaseColor("Base Color", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_Metallic("Metallic", 2D) = "white" {}
		[NoScaleOffset]_Roughness("Roughness", 2D) = "white" {}
		[NoScaleOffset]_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
		[NoScaleOffset]_Heigth("Heigth", 2D) = "white" {}
		_ParallaxScale("Parallax Scale", Range( 0 , 1)) = 0
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
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform float _Tilling;
		uniform sampler2D _Heigth;
		SamplerState sampler_Heigth;
		uniform float _ParallaxScale;
		uniform sampler2D _BaseColor;
		uniform float _BaseColorHue;
		uniform float _BaseColorSat;
		uniform float _BasecolorValue;
		uniform sampler2D _Metallic;
		uniform sampler2D _Roughness;
		uniform sampler2D _AmbientOcclusion;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Tilling).xx;
			float2 uv_TexCoord19 = i.uv_texcoord * temp_cast_0;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 Offset27 = ( ( tex2D( _Heigth, uv_TexCoord19 ).r - 1 ) * ase_worldViewDir.xy * _ParallaxScale ) + uv_TexCoord19;
			o.Normal = UnpackNormal( tex2D( _Normal, Offset27 ) );
			float3 hsvTorgb2_g2 = RGBToHSV( tex2D( _BaseColor, Offset27 ).rgb );
			float3 hsvTorgb8_g2 = HSVToRGB( float3(( hsvTorgb2_g2.x + _BaseColorHue ),( hsvTorgb2_g2.y + _BaseColorSat ),( hsvTorgb2_g2.z + _BasecolorValue )) );
			o.Albedo = hsvTorgb8_g2;
			o.Metallic = tex2D( _Metallic, Offset27 ).r;
			float4 temp_cast_3 = (0.36).xxxx;
			o.Smoothness = ( ( 1.0 - tex2D( _Roughness, Offset27 ) ) - temp_cast_3 ).r;
			o.Occlusion = tex2D( _AmbientOcclusion, Offset27 ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
1616;656;1721;888;1248.403;350.5602;1.801188;True;False
Node;AmplifyShaderEditor.RangedFloatNode;20;-1843.957,92.81621;Inherit;False;Property;_Tilling;Tilling;3;0;Create;True;0;0;False;0;False;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-1599.779,93.73161;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;29;-1196.046,453.7807;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;28;-1195.758,377.5066;Inherit;False;Property;_ParallaxScale;Parallax Scale;10;0;Create;True;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-1302.587,184.6178;Inherit;True;Property;_Heigth;Heigth;9;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;61d8da5cc4250584f8e7d5cdfb2632ca;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxMappingNode;27;-912.8257,94.88275;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;4;-486.8229,514.4772;Inherit;True;Property;_Roughness;Roughness;7;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;af1a827a593f8134dad6e0f8a29eec80;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-472.349,-449.7043;Inherit;False;Property;_BaseColorSat;Base Color Sat;1;0;Create;True;0;0;False;0;False;0;0.14;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-472.9666,-520.4992;Inherit;False;Property;_BaseColorHue;Base Color Hue;0;0;Create;True;0;0;False;0;False;0;-0.14;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-472.4659,-380.1536;Inherit;False;Property;_BasecolorValue;Base color Value;2;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-146.4264,595.3612;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;False;0.36;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;5;-150.1698,509.0709;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-479.5,-300;Inherit;True;Property;_BaseColor;Base Color;4;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;14fddd115fec0d546a9dbf8c860daeea;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-482.6324,84.98236;Inherit;True;Property;_Metallic;Metallic;6;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;71f90b8b6a46ce04aa5f69d2c977214a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;18;-90.09219,-507.1901;Inherit;False;HSV;-1;;2;1d09c0b080619d84f85fef3df119befc;0;4;13;FLOAT;0;False;14;FLOAT;0;False;15;FLOAT;0;False;9;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;8;-492.5251,286.5741;Inherit;True;Property;_AmbientOcclusion;Ambient Occlusion;8;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;856fe53723ece7c4392df6370076b8bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-481.7265,-107.8676;Inherit;True;Property;_Normal;Normal;5;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;False;-1;None;a7d49c6afb8e1d445bb5e71d33c974be;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;32.10627,510.2342;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;565.9963,-31.92762;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Drimys/Nature/Bark;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;20;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;20;0
WireConnection;21;1;19;0
WireConnection;27;0;19;0
WireConnection;27;1;21;1
WireConnection;27;2;28;0
WireConnection;27;3;29;0
WireConnection;4;1;27;0
WireConnection;5;0;4;0
WireConnection;1;1;27;0
WireConnection;3;1;27;0
WireConnection;18;13;11;0
WireConnection;18;14;9;0
WireConnection;18;15;12;0
WireConnection;18;9;1;0
WireConnection;8;1;27;0
WireConnection;2;1;27;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;0;0;18;0
WireConnection;0;1;2;0
WireConnection;0;3;3;0
WireConnection;0;4;6;0
WireConnection;0;5;8;0
ASEEND*/
//CHKSM=E32C0A6121837FDE05CF832937EDBD05F1F3B3E0