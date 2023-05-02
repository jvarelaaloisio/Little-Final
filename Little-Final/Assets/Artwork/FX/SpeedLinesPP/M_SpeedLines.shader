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
				float4 tex2DNode32 = tex2D( _MainTex, uv_MainTex );
				float2 VertexTexCord55 = i.texcoord.xy;
				float2 Center56 = _Center;
				float temp_output_1_0_g37 = _CenterMaskSize;
				float temp_output_18_0 = ( 1.0 - ( ( ( distance( VertexTexCord55 , Center56 ) - temp_output_1_0_g37 ) / ( ( _CenterMaskSize + _CenterMaskEdge ) - temp_output_1_0_g37 ) ) * _LineDensity ) );
				float temp_output_20_0 = ( temp_output_18_0 + _LineFalloff );
				float2 CenteredUV15_g8 = ( VertexTexCord55 - Center56 );
				float2 break17_g8 = CenteredUV15_g8;
				float2 appendResult23_g8 = (float2(( length( CenteredUV15_g8 ) * 0.07 * 2.0 ) , ( atan2( break17_g8.x , break17_g8.y ) * ( 1.0 / 6.28318548202515 ) * _LineQty )));
				float mulTime30 = _Time.y * _Speed;
				float cos29 = cos( mulTime30 );
				float sin29 = sin( mulTime30 );
				float2 rotator29 = mul( appendResult23_g8 - float2( 0,0 ) , float2x2( cos29 , -sin29 , sin29 , cos29 )) + float2( 0,0 );
				float simpleNoise2 = SimpleNoise( rotator29*200.0 );
				float AnimatedLineNoise61 = simpleNoise2;
				float smoothstepResult21 = smoothstep( temp_output_18_0 , temp_output_20_0 , AnimatedLineNoise61);
				float InvertedMask49 = ( 1.0 - smoothstepResult21 );
				float temp_output_2_0_g5 = InvertedMask49;
				float temp_output_3_0_g5 = ( 1.0 - temp_output_2_0_g5 );
				float3 appendResult7_g5 = (float3(temp_output_3_0_g5 , temp_output_3_0_g5 , temp_output_3_0_g5));
				

				float4 color = float4( ( ( tex2DNode32.rgb * temp_output_2_0_g5 ) + appendResult7_g5 ) , 0.0 );
				
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
Node;AmplifyShaderEditor.CommentaryNode;64;-154.1458,-955.2507;Inherit;False;468.2417;324.5509;Input;4;56;55;8;1;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;63;-1793.547,-550.5984;Inherit;False;2229.1;440.5808;Circular Mask;16;49;62;15;57;58;7;13;14;37;19;20;18;21;17;16;12;;0.735849,0.1770203,0.1770203,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;54;-1795.576,-986.9861;Inherit;False;1389.956;400.9238;Line Noise;8;61;3;59;60;53;2;4;29;;0.4625005,0.2705589,0.6037736,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;51;-574.9409,-1371.148;Inherit;False;1046.62;327.828;Output;5;33;32;50;36;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1789.854,-1398.587;Inherit;False;1183.604;356.4168;FrameRateControl;11;46;44;52;45;40;43;42;39;41;30;31;;0.4464667,0.745283,0.6630868,1;0;0
Node;AmplifyShaderEditor.FunctionNode;36;77.33202,-1307.148;Inherit;True;Lerp White To;-1;;5;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-130.6684,-1243.147;Inherit;False;49;InvertedMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1628.289,-776.3033;Inherit;False;Property;_LineQty;Line Qty;0;0;Create;True;0;0;0;False;0;False;5;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1;-104.1461,-905.2505;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;8;-104.1461,-777.2505;Inherit;False;Property;_Center;Center;1;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;32;-418.6695,-1307.148;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;87.85428,-905.2505;Inherit;False;VertexTexCord;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;71.85427,-777.2505;Inherit;False;Center;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-1549.38,-947.2271;Inherit;False;55;VertexTexCord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-1522.435,-863.4387;Inherit;False;56;Center;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-625.5751,-840.9861;Inherit;False;AnimatedLineNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;30;-1632,-1344;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;41;-1456,-1344;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1328,-1344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;42;-1168,-1344;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1328,-1248;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1008,-1344;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;44;-1184,-1232;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;46;-1168,-1136;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;240,-480;Inherit;False;InvertedMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;37;48,-480;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;33;-562.6695,-1291.148;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-1648,-1216;Half;False;Property;_FramesPerSecond;Frames Per Second;7;0;Create;True;0;0;0;False;0;False;120;24;0;120;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-1265.575,-792.9861;Inherit;False;52;FPS;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;4;-1329.575,-936.9861;Inherit;False;Polar Coordinates;-1;;8;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;0.07;False;4;FLOAT;0.98;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;29;-1073.575,-840.9861;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-881.5751,-840.9861;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;68;-1603,40.2876;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;77;-2153.615,287.2797;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;80;-2034.615,247.2797;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;82;-749.5128,188.9332;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;78;-2506.615,315.2797;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;67;-1873,129.2876;Inherit;False;Polar Coordinates;-1;;9;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;0.1;False;4;FLOAT;1.04;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;86;-2157.243,657.1329;Inherit;True;Property;_Flowmap;Flowmap;8;0;Create;True;0;0;0;False;0;False;-1;8a57741d6bb040c4aa25a2fc1ef1b388;8a57741d6bb040c4aa25a2fc1ef1b388;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;98;-344.97,335.6186;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;99;-596.5442,46.66382;Inherit;False;Constant;_Color0;Color 0;9;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;100;-1875.63,821.391;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;102;-1758.673,608.5569;Inherit;False;ApplyFlowMap;-1;;34;d07c6cfb183358d4a935d811fcf1d3f5;0;4;51;FLOAT2;0,0;False;36;COLOR;0,0,0,0;False;37;FLOAT;1;False;38;SAMPLER1D;0,0,0,0;False;4;FLOAT;54;FLOAT2;52;FLOAT2;53;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;69;-1425,225.2876;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;74;-1124.809,207.387;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.16;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-1567.673,201.9883;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;103;-1291.954,485.3213;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;104;-991.7632,467.4207;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.16;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1434.627,462.022;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;94;-703.5219,708.1091;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;301.3321,-1307.148;Float;False;True;-1;2;ASEMaterialInspector;0;8;M_SpeedLines;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1743.547,-388.5984;Inherit;False;Property;_CenterMaskEdge;Center Mask Edge;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1743.547,-468.5984;Inherit;False;Property;_CenterMaskSize;Center Mask Size;2;0;Create;True;0;0;0;False;0;False;0.06;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;7;-1407.547,-308.5984;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1391.547,-404.5984;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;12;-1184,-464;Inherit;True;Inverse Lerp;-1;;37;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1104,-240;Inherit;False;Property;_LineDensity;Line Density;4;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-896,-464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;-736,-464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-768,-352;Inherit;False;Property;_LineFalloff;Line Falloff;5;0;Create;True;0;0;0;False;0;False;0.1836318;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;21;-224,-480;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-432,-400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-512,-496;Inherit;False;61;AnimatedLineNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-1663.547,-308.5984;Inherit;False;55;VertexTexCord;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1631.547,-228.5984;Inherit;False;56;Center;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-800,-1344;Inherit;False;FPS;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1776,-1344;Inherit;False;Property;_Speed;Speed;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
WireConnection;36;1;32;0
WireConnection;36;2;50;0
WireConnection;32;0;33;0
WireConnection;55;0;1;0
WireConnection;56;0;8;0
WireConnection;61;0;2;0
WireConnection;30;0;31;0
WireConnection;41;0;30;0
WireConnection;39;0;41;0
WireConnection;39;1;40;0
WireConnection;42;0;39;0
WireConnection;45;0;42;0
WireConnection;45;1;44;0
WireConnection;45;2;46;0
WireConnection;44;0;43;0
WireConnection;44;1;40;0
WireConnection;49;0;37;0
WireConnection;37;0;21;0
WireConnection;4;1;60;0
WireConnection;4;2;59;0
WireConnection;4;4;3;0
WireConnection;29;0;4;0
WireConnection;29;2;30;0
WireConnection;2;0;29;0
WireConnection;77;0;78;0
WireConnection;80;0;77;0
WireConnection;82;0;94;0
WireConnection;82;1;18;0
WireConnection;82;2;20;0
WireConnection;98;0;32;0
WireConnection;98;1;99;0
WireConnection;98;2;82;0
WireConnection;102;51;67;0
WireConnection;102;36;86;0
WireConnection;102;37;100;0
WireConnection;69;0;95;0
WireConnection;74;0;69;0
WireConnection;95;0;67;0
WireConnection;95;1;102;52
WireConnection;103;0;105;0
WireConnection;104;0;103;0
WireConnection;105;0;67;0
WireConnection;105;1;102;53
WireConnection;94;0;74;0
WireConnection;94;1;104;0
WireConnection;94;2;102;54
WireConnection;5;0;36;0
WireConnection;7;0;58;0
WireConnection;7;1;57;0
WireConnection;15;0;13;0
WireConnection;15;1;14;0
WireConnection;12;1;13;0
WireConnection;12;2;15;0
WireConnection;12;3;7;0
WireConnection;17;0;12;0
WireConnection;17;1;16;0
WireConnection;18;0;17;0
WireConnection;21;0;62;0
WireConnection;21;1;18;0
WireConnection;21;2;20;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;52;0;45;0
ASEEND*/
//CHKSM=3B173EF5743A58AAF619A72A068A8CB9614EF440