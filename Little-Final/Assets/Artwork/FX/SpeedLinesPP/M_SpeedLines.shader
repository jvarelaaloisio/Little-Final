// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_SpeedLines"
{
	Properties
	{
		_LineQty("Line Qty", Range( 1 , 10)) = 5
		_Center("Center", Vector) = (0.5,0.5,0,0)
		_CenterMaskSize("Center Mask Size", Range( 0 , 0.5)) = 0.06
		_CenterMaskEdge("Center Mask Edge", Range( 0 , 10)) = 0.5
		_LineDensity("Line Density", Float) = 0.5
		_LineFalloff("Line Falloff", Range( 0 , 1)) = 0.1836318
		_Speed("Speed", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"

		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float2 _Center;
			uniform float _CenterMaskSize;
			uniform float _CenterMaskEdge;
			uniform float _LineDensity;
			uniform float _LineFalloff;
			uniform float _LineQty;
			uniform float _Speed;


			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			

			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float2 uv_MainTex = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 VertexTexCord55 = i.texcoord.xy;
				float2 Center56 = _Center;
				float temp_output_1_0_g37 = _CenterMaskSize;
				float temp_output_18_0 = ( 1.0 - ( ( ( distance( VertexTexCord55 , Center56 ) - temp_output_1_0_g37 ) / ( ( _CenterMaskSize + _CenterMaskEdge ) - temp_output_1_0_g37 ) ) * _LineDensity ) );
				float2 CenteredUV15_g8 = ( VertexTexCord55 - Center56 );
				float2 break17_g8 = CenteredUV15_g8;
				float2 appendResult23_g8 = (float2(( length( CenteredUV15_g8 ) * 0.07 * 2.0 ) , ( atan2( break17_g8.x , break17_g8.y ) * ( 1.0 / 6.28318548202515 ) * _LineQty )));
				float2 appendResult110 = (float2(0.0 , 1.0));
				float mulTime30 = _Time.y * _Speed;
				float cos29 = cos( mulTime30 );
				float sin29 = sin( mulTime30 );
				float2 rotator29 = mul( ( abs( appendResult23_g8 ) + appendResult110 ) - float2( 0,0 ) , float2x2( cos29 , -sin29 , sin29 , cos29 )) + float2( 0,0 );
				float simpleNoise2 = SimpleNoise( rotator29*200.0 );
				float AnimatedLineNoise61 = simpleNoise2;
				float smoothstepResult21 = smoothstep( temp_output_18_0 , ( temp_output_18_0 + _LineFalloff ) , AnimatedLineNoise61);
				float InvertedMask49 = ( 1.0 - smoothstepResult21 );
				float temp_output_2_0_g5 = InvertedMask49;
				float temp_output_3_0_g5 = ( 1.0 - temp_output_2_0_g5 );
				float3 appendResult7_g5 = (float3(temp_output_3_0_g5 , temp_output_3_0_g5 , temp_output_3_0_g5));
				

				float4 color = float4( ( ( tex2D( _MainTex, uv_MainTex ).rgb * temp_output_2_0_g5 ) + appendResult7_g5 ) , 0.0 );
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.CommentaryNode;111;-1792,-1024;Inherit;False;1826.466;386;;12;61;2;31;30;29;108;110;106;4;3;59;60;AnimatedNoise;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;64;-640,-1408;Inherit;False;468.2417;324.5509;;4;56;55;8;1;Input;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;63;-1792,-576;Inherit;False;2146.348;450.3016;;16;49;37;62;21;20;19;18;17;16;12;7;57;58;15;14;13;Circular Mask;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;51;-128,-1408;Inherit;False;1122.16;290.136;;5;5;36;50;32;33;Output;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1;-592,-1360;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;8;-592,-1232;Inherit;False;Property;_Center;Center;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-400,-1360;Inherit;False;VertexTexCord;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-416,-1232;Inherit;False;Center;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-1760,-960;Inherit;False;55;VertexTexCord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-1760,-864;Inherit;False;56;Center;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1760,-768;Inherit;False;Property;_LineQty;Line Qty;0;0;Create;True;0;0;0;False;0;False;5;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;4;-1440,-960;Inherit;False;Polar Coordinates;-1;;8;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;0.07;False;4;FLOAT;0.98;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;106;-1152,-960;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;-1152,-864;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-992,-960;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;29;-736,-960;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;30;-992,-736;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1152,-736;Inherit;False;Property;_Speed;Speed;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-480,-960;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-224,-960;Inherit;False;AnimatedLineNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;33;-96,-1344;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;32;64,-1344;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;50;352,-1248;Inherit;False;49;InvertedMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;36;576,-1344;Inherit;True;Lerp White To;-1;;5;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;800,-1344;Float;False;True;-1;2;ASEMaterialInspector;0;8;M_SpeedLines;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1760,-512;Inherit;False;Property;_CenterMaskSize;Center Mask Size;2;0;Create;True;0;0;0;False;0;False;0.06;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1760,-416;Inherit;False;Property;_CenterMaskEdge;Center Mask Edge;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1408,-416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-1760,-320;Inherit;False;55;VertexTexCord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1760,-224;Inherit;False;56;Center;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;7;-1408,-288;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;12;-1184,-512;Inherit;False;Inverse Lerp;-1;;37;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1184,-256;Inherit;False;Property;_LineDensity;Line Density;4;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-960,-512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;-800,-416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-800,-320;Inherit;False;Property;_LineFalloff;Line Falloff;5;0;Create;True;0;0;0;False;0;False;0.1836318;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-448,-352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;21;-256,-432;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-512,-480;Inherit;False;61;AnimatedLineNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;37;-32,-432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;128,-432;Inherit;False;InvertedMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
WireConnection;55;0;1;0
WireConnection;56;0;8;0
WireConnection;4;1;60;0
WireConnection;4;2;59;0
WireConnection;4;4;3;0
WireConnection;106;0;4;0
WireConnection;108;0;106;0
WireConnection;108;1;110;0
WireConnection;29;0;108;0
WireConnection;29;2;30;0
WireConnection;30;0;31;0
WireConnection;2;0;29;0
WireConnection;61;0;2;0
WireConnection;32;0;33;0
WireConnection;36;1;32;0
WireConnection;36;2;50;0
WireConnection;5;0;36;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;7;0;58;0
WireConnection;7;1;57;0
WireConnection;12;1;13;0
WireConnection;12;2;15;0
WireConnection;12;3;7;0
WireConnection;17;0;12;0
WireConnection;17;1;16;0
WireConnection;18;0;17;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;21;0;62;0
WireConnection;21;1;18;0
WireConnection;21;2;20;0
WireConnection;37;0;21;0
WireConnection;49;0;37;0
ASEEND*/
//CHKSM=F39354D97955BB95197E8B8140B3AF92E58E6D2F