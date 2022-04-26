// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BranchKid"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_BigWindScale1("BigWindScale", Float) = 1.5
		_CloudsShadowScale2("CloudsShadowScale", Float) = 0.01
		_Vector2("Vector 0", Vector) = (0,-1.6,1,0)
		_CloudShadowSpeed2("CloudShadowSpeed", Float) = 0.1
		[NoScaleOffset]_PonchoMask("PonchoMask", 2D) = "white" {}
		_Scan_Color("Scan_Color", Color) = (0,1,0.8446779,0)
		_Scan_LineWidth("Scan_LineWidth", Float) = 0.08
		_Scan_FallOff("Scan_FallOff", Float) = 1.08
		_Scan_Radius("Scan_Radius", Float) = 11.3
		_Scan_Speed("Scan_Speed", Float) = 3
		_Scan_LinesAmount("Scan_LinesAmount", Float) = 1
		_NoiseScale("Noise Scale", Float) = 20
		_NoiseSpeed("Noise Speed", Float) = 1
		_NoiseColor("Noise Color", Color) = (0,1,0.7673321,0)
		_Activate("Activate", Float) = 1
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_Emissive("Emissive", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _Albedo;
		uniform float _CloudShadowSpeed2;
		uniform float _CloudsShadowScale2;
		uniform float _BigWindScale1;
		uniform float3 _Vector2;
		uniform sampler2D _Emissive;
		uniform float4 _Scan_Color;
		uniform float _Activate;
		sampler2D _Sampler1781;
		uniform float4 _Sampler1781_ST;
		uniform float _Scan_Radius;
		uniform float _Scan_Speed;
		uniform float _Scan_LinesAmount;
		uniform float _Scan_FallOff;
		uniform float _Scan_LineWidth;
		uniform sampler2D _PonchoMask;
		uniform float _NoiseSpeed;
		uniform float _NoiseScale;
		uniform float4 _NoiseColor;
		uniform float _EdgeLength;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal6 = i.uv_texcoord;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal6 ) );
			float2 uv_Albedo1 = i.uv_texcoord;
			float4 temp_output_21_0_g10 = tex2D( _Albedo, uv_Albedo1 );
			float4 color20_g10 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_0 = (_CloudShadowSpeed2).xx;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5_g10 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g10 = ( _CloudsShadowScale2 * _BigWindScale1 );
			float2 panner10_g13 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult5_g10 * temp_output_2_0_g10 ));
			float simplePerlin2D11_g13 = snoise( panner10_g13 );
			simplePerlin2D11_g13 = simplePerlin2D11_g13*0.5 + 0.5;
			float temp_output_8_0_g10 = simplePerlin2D11_g13;
			float2 temp_cast_1 = (_CloudShadowSpeed2).xx;
			float2 panner10_g11 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g10 * _CloudsShadowScale2 ));
			float simplePerlin2D11_g11 = snoise( panner10_g11 );
			simplePerlin2D11_g11 = simplePerlin2D11_g11*0.5 + 0.5;
			float2 temp_cast_2 = (_CloudShadowSpeed2).xx;
			float2 panner10_g12 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g10 * ( temp_output_2_0_g10 * 4.0 ) ));
			float simplePerlin2D11_g12 = snoise( panner10_g12 );
			simplePerlin2D11_g12 = simplePerlin2D11_g12*0.5 + 0.5;
			float4 lerpResult24_g10 = lerp( temp_output_21_0_g10 , saturate( ( temp_output_21_0_g10 * color20_g10 ) ) , saturate( (_Vector2.y + (( ( ( temp_output_8_0_g10 * simplePerlin2D11_g11 ) + ( 1.0 - simplePerlin2D11_g12 ) ) * temp_output_8_0_g10 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) ));
			o.Albedo = lerpResult24_g10.rgb;
			float2 uv_Emissive9 = i.uv_texcoord;
			float Activate72 = _Activate;
			float2 uv_Sampler1781 = i.uv_texcoord * _Sampler1781_ST.xy + _Sampler1781_ST.zw;
			float grayscale1_g5 = (tex2D( _Sampler1781, uv_Sampler1781 ).rgb.r + tex2D( _Sampler1781, uv_Sampler1781 ).rgb.g + tex2D( _Sampler1781, uv_Sampler1781 ).rgb.b) / 3;
			float4 lerpResult25_g5 = lerp( float4( 0,0,0,0 ) , ( _Scan_Color * Activate72 ) , saturate( (0.0 + (( 1.0 - grayscale1_g5 ) - 0.1) * (1.0 - 0.0) / (1.0 - 0.1)) ));
			float temp_output_9_0_g5 = distance( float3(0,0,0) , ase_worldPos );
			float mulTime5_g5 = _Time.y * _Scan_Speed;
			float4 lerpResult15_g5 = lerp( float4( 0,0,0,0 ) , lerpResult25_g5 , saturate( ( pow( ( temp_output_9_0_g5 / ( _Scan_Radius * ( ( sin( ( mulTime5_g5 + -( temp_output_9_0_g5 * _Scan_LinesAmount ) ) ) + 1.0 ) / 2.0 ) ) ) , _Scan_FallOff ) * _Scan_LineWidth ) ));
			float2 uv_PonchoMask10 = i.uv_texcoord;
			float4 PonchoMask61 = tex2D( _PonchoMask, uv_PonchoMask10 );
			float4 lerpResult41 = lerp( float4( 0,0,0,0 ) , lerpResult15_g5 , PonchoMask61);
			float mulTime46 = _Time.y * ( _NoiseSpeed * Activate72 );
			float4 appendResult53 = (float4(mulTime46 , 0.0 , 0.0 , 0.0));
			float2 uv_TexCoord44 = i.uv_texcoord + appendResult53.xy;
			float simplePerlin2D43 = snoise( uv_TexCoord44*_NoiseScale );
			simplePerlin2D43 = simplePerlin2D43*0.5 + 0.5;
			float4 lerpResult60 = lerp( float4( 0,0,0,0 ) , ( lerpResult41 + ( saturate( simplePerlin2D43 ) * _NoiseColor ) ) , PonchoMask61);
			float4 lerpResult76 = lerp( lerpResult60 , ( PonchoMask61 * _NoiseColor ) , ( 1.0 - Activate72 ));
			o.Emission = ( tex2D( _Emissive, uv_Emissive9 ) + lerpResult76 ).rgb;
			float temp_output_4_0 = 0.0;
			o.Metallic = temp_output_4_0;
			o.Smoothness = temp_output_4_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
35;1021;1906;1077;1132.517;529.6422;1;False;False
Node;AmplifyShaderEditor.RangedFloatNode;71;-2482.568,-3.489834;Inherit;False;Property;_Activate;Activate;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-2355.095,-3.528026;Inherit;False;Activate;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-2698.935,458.6779;Inherit;False;72;Activate;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-2695.039,380.2199;Inherit;False;Property;_NoiseSpeed;Noise Speed;18;0;Create;True;0;0;0;False;0;False;1;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-2492.849,439.1786;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;46;-2364.394,439.2679;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;-2204.321,415.9942;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;10;-2635.842,67.95656;Inherit;True;Property;_PonchoMask;PonchoMask;10;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;4c51f2036ac9ae74a9a6b0299220edf7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;73;-2026.608,49.80521;Inherit;False;72;Activate;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2017.271,480.9049;Inherit;False;Property;_NoiseScale;Noise Scale;17;0;Create;True;0;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-2045.149,-123.4104;Inherit;False;Property;_Scan_Color;Scan_Color;11;0;Create;True;0;0;0;False;0;False;0,1,0.8446779,0;0.9963673,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-2078.988,366.8858;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;39;-1913.592,-195.0863;Inherit;False;Property;_Scan_LineWidth;Scan_LineWidth;12;0;Create;True;0;0;0;False;0;False;0.08;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;43;-1769.396,387.2907;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1892.655,-407.9932;Inherit;False;Property;_Scan_Speed;Scan_Speed;15;0;Create;True;0;0;0;False;0;False;3;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1934.903,-480.4076;Inherit;False;Property;_Scan_LinesAmount;Scan_LinesAmount;16;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1891.514,-337.8839;Inherit;False;Property;_Scan_Radius;Scan_Radius;14;0;Create;True;0;0;0;False;0;False;11.3;11.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1892.05,-267.0907;Inherit;False;Property;_Scan_FallOff;Scan_FallOff;13;0;Create;True;0;0;0;False;0;False;1.08;1.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1813.423,-44.79456;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-2355.539,70.48936;Inherit;False;PonchoMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;58;-1738.555,610.506;Inherit;False;Property;_NoiseColor;Noise Color;19;0;Create;True;0;0;0;False;0;False;0,1,0.7673321,0;0.3301886,0.1384929,0.04516729,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;81;-1652.585,-295.4628;Inherit;True;SimpleScan;-1;;5;8f9e1c514e30fe643a0eedbb2e0ea94b;0;9;31;FLOAT4;0,0,0,0;False;6;FLOAT;0;False;4;FLOAT;0;False;3;FLOAT;0;False;16;FLOAT;0;False;29;FLOAT;0;False;26;COLOR;0,0,0,0;False;27;COLOR;0,0,0,0;False;17;SAMPLER2D;_Sampler1781;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;68;-1457.635,346.9438;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1540.725,-29.17123;Inherit;False;61;PonchoMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;41;-1280.532,-177.2538;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1232.188,293.3033;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-817.3279,812.8227;Inherit;False;72;Activate;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-997.2324,270.0327;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-974.9362,517.0341;Inherit;False;61;PonchoMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;80;-647.3621,817.8796;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;60;-723.5965,335.5639;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-690.6526,583.9641;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;76;-364.4023,483.3846;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;-759.8629,-4.759696;Inherit;True;Property;_Emissive;Emissive;23;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;9e8e306d5b8e2794587eb5031502a77c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-773.9036,-482.0106;Inherit;True;Property;_Albedo;Albedo;21;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;0d823bc15b3011f4fa70263c4b9da4a2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-201.8388,133.9728;Inherit;False;Constant;_MtalicSmoothness;Mtalic/Smoothness;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-769.2614,-291.6056;Inherit;True;Property;_Normal;Normal;22;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;3d22ecf38274270428c1139ffca03e44;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-408.1447,46.01179;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;83;-71.51697,-222.6422;Inherit;False;CloudsPattern;5;;10;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;314,-16;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;BranchKid;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;72;0;71;0
WireConnection;74;0;54;0
WireConnection;74;1;75;0
WireConnection;46;0;74;0
WireConnection;53;0;46;0
WireConnection;44;1;53;0
WireConnection;43;0;44;0
WireConnection;43;1;45;0
WireConnection;70;0;34;0
WireConnection;70;1;73;0
WireConnection;61;0;10;0
WireConnection;81;6;35;0
WireConnection;81;4;36;0
WireConnection;81;3;37;0
WireConnection;81;16;38;0
WireConnection;81;29;39;0
WireConnection;81;27;70;0
WireConnection;68;0;43;0
WireConnection;41;1;81;0
WireConnection;41;2;62;0
WireConnection;57;0;68;0
WireConnection;57;1;58;0
WireConnection;59;0;41;0
WireConnection;59;1;57;0
WireConnection;80;0;77;0
WireConnection;60;1;59;0
WireConnection;60;2;63;0
WireConnection;78;0;63;0
WireConnection;78;1;58;0
WireConnection;76;0;60;0
WireConnection;76;1;78;0
WireConnection;76;2;80;0
WireConnection;14;0;9;0
WireConnection;14;1;76;0
WireConnection;83;21;1;0
WireConnection;0;0;83;0
WireConnection;0;1;6;0
WireConnection;0;2;14;0
WireConnection;0;3;4;0
WireConnection;0;4;4;0
ASEEND*/
//CHKSM=BF88DC404F5361CD88447AD922B16CD4DAC6A8B1