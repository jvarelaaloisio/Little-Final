// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PP_RainDrops"
{
	Properties
	{
		[NoScaleOffset][Normal]_NoiseNormal("Noise Normal", 2D) = "bump" {}
		_DropsRenderTexture("Drops RenderTexture", 2D) = "bump" {}
		_DropsNormalTiling("Drops Normal Tiling", Float) = 1
		_DropsNormalScale("Drops Normal Scale", Range( 0 , 1)) = 1
		_BorderMask("Border Mask", 2D) = "white" {}
		_BorderWaterSpeed("Border WaterSpeed", Float) = 0.2
		_BorderWaterSpeedOffsetFactor("Border WaterSpeedOffsetFactor", Float) = 2
		_BorderNormalTiling("Border Normal Tiling", Float) = 1
		_BorderNormalScale("Border Normal Scale", Float) = 1
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
			#include "UnityStandardUtils.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_SCREEN_POSITION_NORMALIZED

		
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
			
			uniform sampler2D _DropsRenderTexture;
			uniform float4 _DropsRenderTexture_ST;
			uniform sampler2D _NoiseNormal;
			uniform float _DropsNormalTiling;
			uniform float _DropsNormalScale;
			uniform float _BorderWaterSpeed;
			uniform float _BorderNormalTiling;
			uniform float _BorderNormalScale;
			uniform float _BorderWaterSpeedOffsetFactor;
			uniform sampler2D _BorderMask;
			uniform float4 _BorderMask_ST;


			
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

				float2 uv_DropsRenderTexture = i.texcoord.xy * _DropsRenderTexture_ST.xy + _DropsRenderTexture_ST.zw;
				float2 temp_cast_0 = (_DropsNormalTiling).xx;
				float2 texCoord29 = i.texcoord.xy * temp_cast_0 + float2( 0,0 );
				float3 NORMAL_Waves31 = ( tex2D( _DropsRenderTexture, uv_DropsRenderTexture ).r * UnpackScaleNormal( tex2D( _NoiseNormal, texCoord29 ), _DropsNormalScale ) );
				float4 UV_ScreenCordinates47 = ase_ppsScreenPosFragNorm;
				float VAR_BorderWaterSpeed101 = _BorderWaterSpeed;
				float2 appendResult80 = (float2(0.0 , VAR_BorderWaterSpeed101));
				float VAR_BorderNormalTiling98 = _BorderNormalTiling;
				float2 temp_cast_2 = (VAR_BorderNormalTiling98).xx;
				float2 texCoord45 = i.texcoord.xy * temp_cast_2 + float2( 0,0 );
				float2 panner78 = ( 1.0 * _Time.y * appendResult80 + texCoord45);
				float VAR_BorderNomalScale95 = _BorderNormalScale;
				float VAR_WaterSpeedOffsetFactor108 = _BorderWaterSpeedOffsetFactor;
				float2 appendResult88 = (float2(0.0 , ( VAR_BorderWaterSpeed101 * VAR_WaterSpeedOffsetFactor108 )));
				float2 temp_cast_3 = (VAR_BorderNormalTiling98).xx;
				float2 texCoord87 = i.texcoord.xy * temp_cast_3 + float2( 0,0 );
				float2 panner84 = ( 1.0 * _Time.y * appendResult88 + texCoord87);
				float3 NORMAL_WaterDeform92 = BlendNormals( UnpackScaleNormal( tex2D( _NoiseNormal, panner78 ), VAR_BorderNomalScale95 ) , UnpackScaleNormal( tex2D( _NoiseNormal, panner84 ), VAR_BorderNomalScale95 ) );
				float2 uv_BorderMask = i.texcoord.xy * _BorderMask_ST.xy + _BorderMask_ST.zw;
				float4 lerpResult56 = lerp( UV_ScreenCordinates47 , ( float4( NORMAL_WaterDeform92 , 0.0 ) + UV_ScreenCordinates47 ) , tex2D( _BorderMask, uv_BorderMask ).r);
				float4 UV_ScreenWithBorderDeformation60 = lerpResult56;
				float4 OUT_FragColor34 = tex2D( _MainTex, ( float4( NORMAL_Waves31 , 0.0 ) + UV_ScreenWithBorderDeformation60 ).xy );
				

				float4 color = OUT_FragColor34;
				
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
Node;AmplifyShaderEditor.CommentaryNode;106;-4384,-1104;Inherit;False;953.3152;810.4758;;14;108;107;42;41;54;53;37;11;101;81;98;95;46;44;Variables;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;104;-4391,-224;Inherit;False;1750.222;1259.977;;21;100;99;102;109;103;91;87;89;83;80;45;96;40;39;78;92;90;88;97;84;105;Water Border Normal Deformation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;105;-4352,560;Inherit;False;1181;440;;8;55;57;59;56;50;51;93;60;Blend Border With Screen Cordinates;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;48;-4896,-1104;Inherit;False;486;249;;2;47;17;Screen Cordinates;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;36;-2592,320;Inherit;False;1089;304.0001;;7;19;32;6;1;62;64;34;Apply Drops Deformation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-2592,-224;Inherit;False;1243;486;;9;29;27;23;14;28;30;31;38;43;Deform Drops With Normal Wave;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-2368,16;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-2080,-176;Inherit;True;Property;_DropRenderTexture_;DropRenderTexture_;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1728,-64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1584,-64;Inherit;False;NORMAL_Waves;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-2160,368;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-2000,416;Inherit;True;Property;_Screen;Screen;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;38;-2560,-176;Inherit;False;37;TEX_RenderTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-2368,-64;Inherit;False;42;TEX_WaterNormal;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;27;-2080,16;Inherit;True;Property;_DropsWaveDeformatio;DropsWaveDeformatio;1;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;6472ad6da0da0e249a21b11ffedb3876;6472ad6da0da0e249a21b11ffedb3876;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-2160,448;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2560,480;Inherit;False;60;UV_ScreenWithBorderDeformation;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-2560,400;Inherit;False;31;NORMAL_Waves;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;64;-2240,448;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;17;-4848,-1056;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-4656,-1056;Inherit;False;UV_ScreenCordinates;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;84;-3760,304;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-3744,432;Inherit;False;95;VAR_BorderNomalScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;88;-3936,336;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-4064,336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-2896,16;Inherit;False;NORMAL_WaterDeform;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;57;-4016,768;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;59;-4000,672;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;56;-3664,688;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-3904,608;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-3504,688;Inherit;False;UV_ScreenWithBorderDeformation;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-4304,768;Inherit;False;54;TEX_BorderMask;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-4304,688;Inherit;False;47;UV_ScreenCordinates;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-4304,608;Inherit;False;92;NORMAL_WaterDeform;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1696,416;Inherit;False;OUT_FragColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-3952,-1056;Inherit;False;VAR_BorderNomalScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-3952,-976;Inherit;False;VAR_BorderNormalTiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-3952,-896;Inherit;False;VAR_BorderWaterSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1152,0;Inherit;False;34;OUT_FragColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-896,0;Float;False;True;-1;2;ASEMaterialInspector;0;8;PP_RainDrops;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;True;7;False;;False;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;0;;0;0;Standard;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-4096,-512;Inherit;False;TEX_RenderTexture;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-4096,-720;Inherit;False;TEX_BorderMask;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-3648,-720;Inherit;False;TEX_WaterNormal;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-3952,-816;Inherit;False;VAR_WaterSpeedOffsetFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;78;-3760,-80;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-3760,-176;Inherit;False;42;TEX_WaterNormal;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;40;-3472,-176;Inherit;True;Property;_WavesBordersDeformation;WavesBordersDeformation;4;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;96;-3760,48;Inherit;False;95;VAR_BorderNomalScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-4016,-176;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;80;-3936,-48;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-3760,208;Inherit;False;42;TEX_WaterNormal;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;89;-3472,208;Inherit;True;Property;_WavesBordersDeformation1;WavesBordersDeformation;4;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;87;-4016,208;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;91;-3120,16;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;-4352,336;Inherit;False;101;VAR_BorderWaterSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-4352,416;Inherit;False;108;VAR_WaterSpeedOffsetFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-4352,-48;Inherit;False;101;VAR_BorderWaterSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-4352,-176;Inherit;False;98;VAR_BorderNormalTiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-4352,208;Inherit;False;98;VAR_BorderNormalTiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-4336,-816;Inherit;False;Property;_BorderWaterSpeedOffsetFactor;Border WaterSpeedOffsetFactor;6;0;Create;True;0;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-4336,-896;Inherit;False;Property;_BorderWaterSpeed;Border WaterSpeed;5;0;Create;True;0;0;0;False;0;False;0.2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-4336,-976;Inherit;False;Property;_BorderNormalTiling;Border Normal Tiling;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-4336,-1056;Inherit;False;Property;_BorderNormalScale;Border Normal Scale;8;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2368,144;Inherit;False;Property;_DropsNormalScale;Drops Normal Scale;3;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2576,16;Inherit;False;Property;_DropsNormalTiling;Drops Normal Tiling;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;53;-4336,-720;Inherit;True;Property;_BorderMask;Border Mask;4;0;Create;True;0;0;0;False;0;False;e85a86d788581674c92d56b6629f0546;e85a86d788581674c92d56b6629f0546;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;11;-4336,-512;Inherit;True;Property;_DropsRenderTexture;Drops RenderTexture;1;0;Create;True;0;0;0;False;0;False;51f1e5a8a4fa22440b16fc17241e0087;51f1e5a8a4fa22440b16fc17241e0087;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;41;-3872,-720;Inherit;True;Property;_NoiseNormal;Noise Normal;0;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;6472ad6da0da0e249a21b11ffedb3876;6472ad6da0da0e249a21b11ffedb3876;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
WireConnection;29;0;30;0
WireConnection;14;0;38;0
WireConnection;28;0;14;1
WireConnection;28;1;27;0
WireConnection;31;0;28;0
WireConnection;6;0;1;0
WireConnection;6;1;19;0
WireConnection;27;0;43;0
WireConnection;27;1;29;0
WireConnection;27;5;23;0
WireConnection;19;0;64;0
WireConnection;19;1;62;0
WireConnection;64;0;32;0
WireConnection;47;0;17;0
WireConnection;84;0;87;0
WireConnection;84;2;88;0
WireConnection;88;1;90;0
WireConnection;90;0;103;0
WireConnection;90;1;109;0
WireConnection;92;0;91;0
WireConnection;57;0;55;0
WireConnection;59;0;50;0
WireConnection;56;0;50;0
WireConnection;56;1;51;0
WireConnection;56;2;57;1
WireConnection;51;0;93;0
WireConnection;51;1;59;0
WireConnection;60;0;56;0
WireConnection;34;0;6;0
WireConnection;95;0;44;0
WireConnection;98;0;46;0
WireConnection;101;0;81;0
WireConnection;0;0;35;0
WireConnection;37;0;11;0
WireConnection;54;0;53;0
WireConnection;42;0;41;0
WireConnection;108;0;107;0
WireConnection;78;0;45;0
WireConnection;78;2;80;0
WireConnection;40;0;39;0
WireConnection;40;1;78;0
WireConnection;40;5;96;0
WireConnection;45;0;99;0
WireConnection;80;1;102;0
WireConnection;89;0;83;0
WireConnection;89;1;84;0
WireConnection;89;5;97;0
WireConnection;87;0;100;0
WireConnection;91;0;40;0
WireConnection;91;1;89;0
ASEEND*/
//CHKSM=9B1BA59B649C2FEC7D568FBE406E51621FA68C65