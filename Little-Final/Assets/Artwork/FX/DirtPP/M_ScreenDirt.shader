// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_ScreenDirt"
{
	Properties
	{
		_CenterMaskSize("Center Mask Size", Range( 0 , 0.5)) = 0.06
		_CenterMaskEdge("Center Mask Edge", Range( 0 , 10)) = 0.5
		_NoiseScale("NoiseScale", Float) = 50
		_DirtColor("DirtColor", Color) = (1,1,1,1)
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
			
			uniform float4 _DirtColor;
			uniform float _CenterMaskSize;
			uniform float _CenterMaskEdge;
			uniform float _NoiseScale;


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
				float temp_output_1_0_g46 = _CenterMaskSize;
				float temp_output_10_0_g45 = ( 1.0 - ( ( ( distance( i.texcoord.xy , float2( 0.5,0.5 ) ) - temp_output_1_0_g46 ) / ( ( _CenterMaskSize + _CenterMaskEdge ) - temp_output_1_0_g46 ) ) * 0.5 ) );
				float simpleNoise12 = SimpleNoise( float2( 0,0 )*_NoiseScale );
				float smoothstepResult13 = smoothstep( 0.16 , 1.0 , simpleNoise12);
				float simpleNoise15 = SimpleNoise( float2( 0,0 )*_NoiseScale );
				float smoothstepResult16 = smoothstep( 0.16 , 1.0 , simpleNoise15);
				float lerpResult18 = lerp( smoothstepResult13 , smoothstepResult16 , 0.0);
				float smoothstepResult4 = smoothstep( 0.0 , 1.0 , lerpResult18);
				float smoothstepResult13_g45 = smoothstep( temp_output_10_0_g45 , ( temp_output_10_0_g45 + 1.85 ) , smoothstepResult4);
				float4 lerpResult8 = lerp( tex2D( _MainTex, uv_MainTex ) , _DirtColor , saturate( smoothstepResult13_g45 ));
				

				float4 color = lerpResult8;
				
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
Node;AmplifyShaderEditor.TexCoordVertexDataNode;26;-533.1451,238.387;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-284.9655,-102.4863;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;29;-466.9654,-110.2864;Inherit;False;0;0;_MainTex;Pass;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-2853.66,346.0411;Inherit;True;Property;_Flowmap;Flowmap;0;0;Create;True;0;0;0;False;0;False;-1;8a57741d6bb040c4aa25a2fc1ef1b388;8a57741d6bb040c4aa25a2fc1ef1b388;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;11;-2455.09,297.4652;Inherit;False;ApplyFlowMap;-1;;42;d07c6cfb183358d4a935d811fcf1d3f5;0;4;51;FLOAT2;0,0;False;36;COLOR;0,0,0,0;False;37;FLOAT;1;False;38;SAMPLER1D;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;18;-1244.44,136.5577;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;27;-219.0427,168.7727;Inherit;True;FilterScreenEdges;1;;45;626c4a924aeb00e48825dbac3b69614c;0;5;30;FLOAT;1;False;31;FLOAT2;0,0;False;32;FLOAT2;0.5,0.5;False;33;FLOAT;1.85;False;34;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;4;-897.3917,103.6453;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-2804.055,213.3816;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;12;-2121.417,-84.8041;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;15;-1988.371,174.2296;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-1821.226,-103.7047;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.16;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-1688.18,156.329;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.16;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2046.949,-236.0495;Inherit;False;Constant;_SmoothStepMin;SmoothStepMin;2;0;Create;True;0;0;0;False;0;False;0.16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2030.949,-155.0495;Inherit;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2340.949,55.95047;Inherit;False;Property;_NoiseScale;NoiseScale;4;0;Create;True;0;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;100.7806,287.9786;Inherit;False;Property;_DirtColor;DirtColor;6;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;8;391.746,111.7869;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;38;147.0757,162.5521;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2827.047,594.2993;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2629.653,528.4245;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2774.653,725.4245;Inherit;False;Property;_Speed;Speed;5;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;19;736,112;Float;False;True;-1;2;ASEMaterialInspector;0;8;M_ScreenDirt;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;28;0;29;0
WireConnection;11;51;24;0
WireConnection;11;36;7;0
WireConnection;11;37;40;0
WireConnection;18;0;13;0
WireConnection;18;1;16;0
WireConnection;27;30;4;0
WireConnection;27;31;26;0
WireConnection;4;0;18;0
WireConnection;12;1;35;0
WireConnection;15;1;35;0
WireConnection;13;0;12;0
WireConnection;13;1;36;0
WireConnection;13;2;37;0
WireConnection;16;0;15;0
WireConnection;16;1;36;0
WireConnection;16;2;37;0
WireConnection;8;0;28;0
WireConnection;8;1;9;0
WireConnection;8;2;38;0
WireConnection;38;0;27;0
WireConnection;40;0;10;0
WireConnection;40;1;39;0
WireConnection;19;0;8;0
ASEEND*/
//CHKSM=385359D0068CF9A3EB0055D7A09432FEB419B2DB