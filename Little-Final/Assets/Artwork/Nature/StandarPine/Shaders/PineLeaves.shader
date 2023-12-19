// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Common/PineLeaves"
{
	Properties
	{
		[NoScaleOffset]_Color_Alpha("Color_Alpha", 2D) = "white" {}
		_Color_Multiplier("Color_Multiplier", Color) = (1,1,1,0)
		_Wind_NoiseFactor("Wind_Noise Factor", Float) = 0
		_Wind_WorldNoiseScale("Wind_World Noise Scale", Float) = 2
		_Wind_WorldNosieSpeedX("Wind_World Nosie Speed X", Float) = 0
		_Wind_WorldNosieSpeedY("Wind_World Nosie Speed Y", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _Wind_NoiseFactor;
		uniform float _Wind_WorldNosieSpeedX;
		uniform float _Wind_WorldNosieSpeedY;
		uniform float _Wind_WorldNoiseScale;
		uniform sampler2D _Color_Alpha;
		uniform float4 _Color_Alpha_ST;
		uniform float4 _Color_Multiplier;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime12_g17 = _Time.y * 0.5;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 temp_output_14_0_g17 = ase_vertex3Pos;
			float3 rotatedValue2_g17 = RotateAroundAxis( float3( 0,0,0 ), temp_output_14_0_g17, float3(0,1,0), (-0.05 + (sin( mulTime12_g17 ) - -1.0) * (0.05 - -0.05) / (1.0 - -1.0)) );
			float2 appendResult40 = (float2(sin( _Time.y ) , 0.0));
			float2 uv_TexCoord41 = v.texcoord.xy + appendResult40;
			float simplePerlin2D42 = snoise( uv_TexCoord41*1.0 );
			simplePerlin2D42 = simplePerlin2D42*0.5 + 0.5;
			float temp_output_46_0 = (0.0 + (simplePerlin2D42 - 0.0) * (( _Wind_NoiseFactor * 0.001 ) - 0.0) / (1.0 - 0.0));
			float4 appendResult47 = (float4(temp_output_46_0 , 0.0 , temp_output_46_0 , 0.0));
			float4 transform48 = mul(unity_ObjectToWorld,( appendResult47 * ( 1.0 - v.texcoord.xy.y ) ));
			float2 appendResult73 = (float2(_Wind_WorldNosieSpeedX , _Wind_WorldNosieSpeedY));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 panner10_g16 = ( 1.0 * _Time.y * appendResult73 + ( ase_worldPos * _Wind_WorldNoiseScale ).xy);
			float simplePerlin2D11_g16 = snoise( panner10_g16 );
			simplePerlin2D11_g16 = simplePerlin2D11_g16*0.5 + 0.5;
			float2 _Wind_WorldNoiseLevels = float2(0,1.2);
			float4 lerpResult66 = lerp( transform48 , float4( 0,0,0,0 ) , saturate( (_Wind_WorldNoiseLevels.x + (simplePerlin2D11_g16 - 0.0) * (_Wind_WorldNoiseLevels.y - _Wind_WorldNoiseLevels.x) / (1.0 - 0.0)) ));
			float4 OUT_VertexOffset76 = ( float4( ( rotatedValue2_g17 - temp_output_14_0_g17 ) , 0.0 ) + lerpResult66 );
			v.vertex.xyz += OUT_VertexOffset76.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Color_Alpha = i.uv_texcoord * _Color_Alpha_ST.xy + _Color_Alpha_ST.zw;
			float4 tex2DNode1 = tex2D( _Color_Alpha, uv_Color_Alpha );
			float4 temp_output_21_0_g18 = saturate( ( tex2DNode1 * _Color_Multiplier ) );
			float4 color20_g18 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_0 = (0.1).xx;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5_g18 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g18 = ( 0.01 * 1.5 );
			float2 panner10_g19 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult5_g18 * temp_output_2_0_g18 ));
			float simplePerlin2D11_g19 = snoise( panner10_g19 );
			simplePerlin2D11_g19 = simplePerlin2D11_g19*0.5 + 0.5;
			float temp_output_8_0_g18 = simplePerlin2D11_g19;
			float2 temp_cast_1 = (0.1).xx;
			float2 panner10_g21 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g18 * 0.01 ));
			float simplePerlin2D11_g21 = snoise( panner10_g21 );
			simplePerlin2D11_g21 = simplePerlin2D11_g21*0.5 + 0.5;
			float2 temp_cast_2 = (0.1).xx;
			float2 panner10_g20 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g18 * ( temp_output_2_0_g18 * 4.0 ) ));
			float simplePerlin2D11_g20 = snoise( panner10_g20 );
			simplePerlin2D11_g20 = simplePerlin2D11_g20*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g18 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g18 * simplePerlin2D11_g21 ) + ( 1.0 - simplePerlin2D11_g20 ) ) * temp_output_8_0_g18 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g18 = lerp( temp_output_21_0_g18 , saturate( ( temp_output_21_0_g18 * color20_g18 ) ) , ( temp_output_16_0_g18 * 1.0 ));
			float4 OUT_BaseColor74 = lerpResult24_g18;
			o.Emission = OUT_BaseColor74.rgb;
			float OUT_Opacity75 = tex2DNode1.a;
			o.Alpha = OUT_Opacity75;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.CommentaryNode;68;-2781,432;Inherit;False;2270;433;Individual Animation;15;66;48;50;52;47;51;46;42;53;49;41;43;40;44;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;45;-2768,480;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;44;-2576,480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-2432,480;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-2272,480;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;67;-1925,912;Inherit;False;1180;456;Alternate Mask;9;59;62;72;71;73;65;63;56;64;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;42;-1984,480;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1808,720;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-1616,960;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;46;-1632,496;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-1632,720;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;18;-1696,-272;Inherit;False;1189;451;Base Color;8;7;6;2;3;1;4;69;70;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;59;-1904,1200;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;47;-1312,560;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;52;-1312,720;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1664,-224;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;56;-1456,960;Inherit;True;WorldNoise;-1;;16;f17c4c9c155f92e4cb0e3f353a46552a;0;3;14;FLOAT2;0,0;False;13;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;63;-1056,960;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1120,560;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;19;-1055,192;Inherit;False;542.8;228.2;Animation ;2;20;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;65;-880,960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;16;-1024,240;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-1024,-144;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;48;-928,560;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;6;-896,-144;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;20;-800,240;Inherit;False;PineMovement;-1;;17;d5c45313e033b094f86057ee8154a179;0;1;14;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;66;-688,560;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;70;-1088,96;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-384,240;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;69;-1072,112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;7;-768,-144;Inherit;False;CloudsPattern;-1;;18;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-128,-128;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-128,64;Inherit;False;OUT_Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;-128,224;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;120;256,-128;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Common/PineLeaves;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;1;-1408,-224;Inherit;True;Property;_Color_Alpha;Color_Alpha;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;fd28405bc1e6aaa448362eb81fff150a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-1408,-32;Inherit;False;Property;_Color_Multiplier;Color_Multiplier;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.1785192,0.248,0.158224,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-2320,624;Inherit;False;Constant;_Wind_NoiseAnimationScale;Wind_Noise Animation Scale;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2032,719;Inherit;False;Property;_Wind_NoiseFactor;Wind_Noise Factor;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1904,1120;Inherit;False;Property;_Wind_WorldNoiseScale;Wind_World Noise Scale;3;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1904,1039;Inherit;False;Property;_Wind_WorldNosieSpeedY;Wind_World Nosie Speed Y;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-1904,960;Inherit;False;Property;_Wind_WorldNosieSpeedX;Wind_World Nosie Speed X;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;64;-1457,1184;Inherit;False;Constant;_Wind_WorldNoiseLevels;Wind_World Noise Levels;5;0;Create;True;0;0;0;False;0;False;0,1.2;0,1.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
WireConnection;44;0;45;0
WireConnection;40;0;44;0
WireConnection;41;1;40;0
WireConnection;42;0;41;0
WireConnection;42;1;43;0
WireConnection;53;0;49;0
WireConnection;73;0;71;0
WireConnection;73;1;72;0
WireConnection;46;0;42;0
WireConnection;46;4;53;0
WireConnection;47;0;46;0
WireConnection;47;2;46;0
WireConnection;52;0;51;2
WireConnection;56;14;73;0
WireConnection;56;13;62;0
WireConnection;56;2;59;0
WireConnection;63;0;56;0
WireConnection;63;3;64;1
WireConnection;63;4;64;2
WireConnection;50;0;47;0
WireConnection;50;1;52;0
WireConnection;65;0;63;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;48;0;50;0
WireConnection;6;0;2;0
WireConnection;20;14;16;0
WireConnection;66;0;48;0
WireConnection;66;2;65;0
WireConnection;70;0;1;4
WireConnection;55;0;20;0
WireConnection;55;1;66;0
WireConnection;69;0;70;0
WireConnection;7;21;6;0
WireConnection;74;0;7;0
WireConnection;75;0;69;0
WireConnection;76;0;55;0
WireConnection;120;2;74;0
WireConnection;120;9;75;0
WireConnection;120;11;76;0
WireConnection;1;1;4;0
ASEEND*/
//CHKSM=943F4EA868967CBD294E6DD2206D0B28CC5C34F4