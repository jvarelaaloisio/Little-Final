// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Nature/FloatingRocks"
{
	Properties
	{
		[NoScaleOffset]_Color__Albedo("Color__Albedo", 2D) = "white" {}
		[NoScaleOffset]_EmissionMask("EmissionMask", 2D) = "white" {}
		_EmissionFac("Emission Fac", Range( 0 , 1)) = 0
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_Metalic("Metalic", 2D) = "white" {}
		[NoScaleOffset]_Roughness("Roughness", 2D) = "white" {}
		_RoughnessFac("Roughness Fac", Range( 0 , 1)) = 1
		[NoScaleOffset]_AO("AO", 2D) = "white" {}
		_EmissColor("EmissColor", Color) = (0.4901961,0.1372549,0.1058824,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _Color__Albedo;
		uniform sampler2D _EmissionMask;
		uniform float4 _EmissColor;
		uniform float _EmissionFac;
		uniform sampler2D _Metalic;
		uniform sampler2D _Roughness;
		uniform float _RoughnessFac;
		uniform sampler2D _AO;


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


		float2 voronoihash49( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi49( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash49( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal13 = i.uv_texcoord;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal13 ) );
			float2 uv_Color__Albedo2 = i.uv_texcoord;
			float4 temp_output_21_0_g1 = tex2D( _Color__Albedo, uv_Color__Albedo2 );
			float4 color20_g1 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_0 = (0.1).xx;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5_g1 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g1 = ( 0.01 * 1.5 );
			float2 panner10_g8 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult5_g1 * temp_output_2_0_g1 ));
			float simplePerlin2D11_g8 = snoise( panner10_g8 );
			simplePerlin2D11_g8 = simplePerlin2D11_g8*0.5 + 0.5;
			float temp_output_8_0_g1 = simplePerlin2D11_g8;
			float2 temp_cast_1 = (0.1).xx;
			float2 panner10_g12 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g1 * 0.01 ));
			float simplePerlin2D11_g12 = snoise( panner10_g12 );
			simplePerlin2D11_g12 = simplePerlin2D11_g12*0.5 + 0.5;
			float2 temp_cast_2 = (0.1).xx;
			float2 panner10_g11 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g1 * ( temp_output_2_0_g1 * 4.0 ) ));
			float simplePerlin2D11_g11 = snoise( panner10_g11 );
			simplePerlin2D11_g11 = simplePerlin2D11_g11*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g1 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g1 * simplePerlin2D11_g12 ) + ( 1.0 - simplePerlin2D11_g11 ) ) * temp_output_8_0_g1 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g1 = lerp( temp_output_21_0_g1 , saturate( ( temp_output_21_0_g1 * color20_g1 ) ) , ( temp_output_16_0_g1 * 1.0 ));
			o.Albedo = lerpResult24_g1.rgb;
			float time49 = 0.0;
			float2 voronoiSmoothId49 = 0;
			float2 coords49 = i.uv_texcoord * 150.0;
			float2 id49 = 0;
			float2 uv49 = 0;
			float voroi49 = voronoi49( coords49, time49, id49, uv49, 0, voronoiSmoothId49 );
			float grayscale50 = Luminance(float3( id49 ,  0.0 ));
			float2 uv_EmissionMask12 = i.uv_texcoord;
			float lerpResult27 = lerp( 0.0 , saturate( ( grayscale50 + 0.5 ) ) , tex2D( _EmissionMask, uv_EmissionMask12 ).r);
			o.Emission = ( lerpResult27 * _EmissColor * (0.0 + (_EmissionFac - 0.0) * (30.0 - 0.0) / (1.0 - 0.0)) ).rgb;
			float2 uv_Metalic17 = i.uv_texcoord;
			o.Metallic = tex2D( _Metalic, uv_Metalic17 ).r;
			float2 uv_Roughness7 = i.uv_texcoord;
			o.Smoothness = ( ( 1.0 - tex2D( _Roughness, uv_Roughness7 ).r ) * _RoughnessFac );
			float2 uv_AO14 = i.uv_texcoord;
			o.Occlusion = tex2D( _AO, uv_AO14 ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
695;1242;1515;732;1588.276;805.4375;2.978554;True;True
Node;AmplifyShaderEditor.RangedFloatNode;23;-299.8197,-158.6022;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;150;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;49;-37.84168,-308.1551;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TFHCGrayscale;50;196.5144,-184.036;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;401.2284,-170.4644;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;828.445,788.4102;Inherit;True;Property;_Roughness;Roughness;5;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;6e592319f123f774f94eddfac50f18bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;583.445,269.4105;Inherit;False;Property;_EmissionFac;Emission Fac;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;53;498.4065,-36.82413;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-181.5557,51.71067;Inherit;True;Property;_EmissionMask;EmissionMask;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;a9293e14d60e9674d91164431bf28c70;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;27;703.1351,93.73297;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;9;1116.445,788.4102;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;817.0291,-315.5895;Inherit;True;Property;_Color__Albedo;Color__Albedo;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;8e3d6ec56feb3184483fc39376741a20;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;259.5735,287.4351;Inherit;False;Property;_EmissColor;EmissColor;8;0;Create;True;0;0;0;False;0;False;0.4901961,0.1372549,0.1058824,0;0.490196,0.1383387,0.1058823,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;57;894.8339,195.3854;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;30;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;828.445,980.4102;Inherit;False;Property;_RoughnessFac;Roughness Fac;6;0;Create;True;0;0;0;False;0;False;1;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;828.445,372.4105;Inherit;True;Property;_Metalic;Metalic;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;bb2b03ee2b3a2be4c96120ff8f9563ca;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;1148.445,84.41058;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;13;828.445,-107.5894;Inherit;True;Property;_Normal;Normal;3;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;019b5c51fa21c6543ba4e1f9aa9fffab;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;15;1212.445,-299.5895;Inherit;False;CloudsPattern;-1;;1;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;1276.445,788.4102;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;824.445,581.4106;Inherit;True;Property;_AO;AO;7;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1478.321,38.64892;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Nature/FloatingRocks;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;49;2;23;0
WireConnection;50;0;49;1
WireConnection;54;0;50;0
WireConnection;53;0;54;0
WireConnection;27;1;53;0
WireConnection;27;2;12;0
WireConnection;9;0;7;1
WireConnection;57;0;11;0
WireConnection;18;0;27;0
WireConnection;18;1;20;0
WireConnection;18;2;57;0
WireConnection;15;21;2;0
WireConnection;16;0;9;0
WireConnection;16;1;8;0
WireConnection;0;0;15;0
WireConnection;0;1;13;0
WireConnection;0;2;18;0
WireConnection;0;3;17;0
WireConnection;0;4;16;0
WireConnection;0;5;14;0
ASEEND*/
//CHKSM=AB7FC516DDAFD793180FB2ED81A9F4A3528DFF47