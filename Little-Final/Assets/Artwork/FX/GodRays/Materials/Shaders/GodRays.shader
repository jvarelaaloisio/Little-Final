// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/FX/GodRays"
{
	Properties
	{
		_OpacityFactor("Opacity Factor", Range( 0 , 1)) = 1
		_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_EmissiveFactor("Emissive Factor", Float) = 1
		_FresnelScale("Fresnel Scale", Float) = 1.1
		_FresnelPower("Fresnel Power", Float) = 0.26
		_CameraDistanceMaskFactor("Camera DistanceMaskFactor", Float) = 8
		_VolumenMaskFactor("VolumenMask Factor", Float) = 5.5
		_VerticalGradientMask("VerticalGradient Mask", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float4 screenPosition50;
			float eyeDepth;
		};

		uniform float4 _EmissionColor;
		uniform float _EmissiveFactor;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _VolumenMaskFactor;
		uniform float _CameraDistanceMaskFactor;
		uniform float _VerticalGradientMask;
		uniform float BigWindFactor;
		uniform float BigWindSpeed;
		uniform float WindIntensity;
		uniform float _OpacityFactor;


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
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos50 = ase_vertex3Pos;
			float4 ase_screenPos50 = ComputeScreenPos( UnityObjectToClipPos( vertexPos50 ) );
			o.screenPosition50 = ase_screenPos50;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 OUT_BaseColor109 = ( _EmissionColor * _EmissiveFactor );
			o.Emission = OUT_BaseColor109.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV16 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode16 = ( 0.0 + _FresnelScale * pow( max( 1.0 - fresnelNdotV16 , 0.0001 ), _FresnelPower ) );
			float MASK_Fresnel96 = saturate( ( 1.0 - fresnelNode16 ) );
			float4 ase_screenPos50 = i.screenPosition50;
			float4 ase_screenPosNorm50 = ase_screenPos50 / ase_screenPos50.w;
			ase_screenPosNorm50.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm50.z : ase_screenPosNorm50.z * 0.5 + 0.5;
			float screenDepth50 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm50.xy ));
			float distanceDepth50 = abs( ( screenDepth50 - LinearEyeDepth( ase_screenPosNorm50.z ) ) / ( _VolumenMaskFactor ) );
			float MASK_ObjectMask98 = saturate( distanceDepth50 );
			float cameraDepthFade54 = (( i.eyeDepth -_ProjectionParams.y - 0.0 ) / _CameraDistanceMaskFactor);
			float MASK_DistanceMask100 = saturate( (-1.7 + (cameraDepthFade54 - 0.0) * (1.8 - -1.7) / (1.0 - 0.0)) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float MASK_VerticalGradient102 = saturate( (_VerticalGradientMask + (ase_vertex3Pos.z - 0.0) * (7.76 - _VerticalGradientMask) / (1.0 - 0.0)) );
			float2 temp_cast_1 = (BigWindSpeed).xx;
			float3 appendResult43 = (float3(ase_worldPos.x , 0.0 , ase_worldPos.z));
			float2 panner10_g13 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult43 * WindIntensity ).xy);
			float simplePerlin2D11_g13 = snoise( panner10_g13 );
			simplePerlin2D11_g13 = simplePerlin2D11_g13*0.5 + 0.5;
			float MASK_WindMask104 = ( BigWindFactor * simplePerlin2D11_g13 );
			float OUT_Opacity106 = ( MASK_Fresnel96 * MASK_ObjectMask98 * MASK_DistanceMask100 * MASK_VerticalGradient102 * MASK_WindMask104 * _OpacityFactor );
			o.Alpha = OUT_Opacity106;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float4 customPack1 : TEXCOORD1;
				float1 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
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
				o.worldNormal = worldNormal;
				o.customPack1.xyzw = customInputData.screenPosition50;
				o.customPack2.x = customInputData.eyeDepth;
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
				surfIN.screenPosition50 = IN.customPack1.xyzw;
				surfIN.eyeDepth = IN.customPack2.x;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Node;AmplifyShaderEditor.CommentaryNode;111;-1664,-560;Inherit;False;887;328;;5;112;109;113;1;95;Base Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;108;-512,400;Inherit;False;786;566;;8;97;99;101;103;105;45;46;106;Opacity Blend;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;78;-1664,1248;Inherit;False;1014.8;431.1;;8;104;40;39;35;38;43;36;42;Wind Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;76;-1668,398;Inherit;False;1101;371;Distance Mask;7;55;59;58;100;61;57;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;74;-1667,-178;Inherit;False;997;242;;6;52;22;16;19;28;96;Fresnel Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;77;-1663,784;Inherit;False;989;396;;6;102;71;72;68;73;70;Vertical Gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;75;-1667,112;Inherit;False;858;273;;5;98;47;50;48;49;Objects Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-464,528;Inherit;False;98;MASK_ObjectMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-464,608;Inherit;False;100;MASK_DistanceMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;-464,688;Inherit;False;102;MASK_VerticalGradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-80,560;Inherit;False;6;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;48,560;Inherit;False;OUT_Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;49;-1632,160;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;68;-1632,832;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;22;-1184,-128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;72;-1280,832;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;50;-1408,160;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;52;-1024,-128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;71;-1072,832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;-1168,160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-896,-128;Inherit;False;MASK_Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-1040,160;Inherit;False;MASK_ObjectMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;-928,832;Inherit;False;MASK_VerticalGradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-465,448;Inherit;False;96;MASK_Fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;95;-1408,-512;Inherit;False;CloudsPattern;-1;;2;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-1120,-416;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-800,448;Inherit;False;MASK_DistanceMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;61;-928,448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;57;-1104,448;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;54;-1344,448;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-464,768;Inherit;False;104;MASK_WindMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-976,-416;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;16;-1424,-128;Inherit;False;Standard;WorldNormal;ViewDir;False;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;512,512;Inherit;False;109;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;512,608;Inherit;False;106;OUT_Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-464,848;Inherit;False;Property;_OpacityFactor;Opacity Factor;0;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-1632,-512;Inherit;False;Property;_EmissionColor;Emission Color;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.9023281,0.9150943,0.7467515,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;113;-1632,-336;Inherit;False;Property;_EmissiveFactor;Emissive Factor;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1632,-128;Inherit;False;Property;_FresnelScale;Fresnel Scale;3;0;Create;True;0;0;0;False;0;False;1.1;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1633,-32;Inherit;False;Property;_FresnelPower;Fresnel Power;4;0;Create;True;0;0;0;False;0;False;0.26;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1632,304;Inherit;False;Property;_VolumenMaskFactor;VolumenMask Factor;6;0;Create;True;0;0;0;False;0;False;5.5;5.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-1649,448;Inherit;False;Property;_CameraDistanceMaskFactor;Camera DistanceMaskFactor;5;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-1648,576;Inherit;False;Constant;_DistanceMaskLevelsMin;DistanceMask LevelsMin;6;0;Create;True;0;0;0;False;0;False;-1.7;-1.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1648,656;Inherit;False;Constant;_DistanceMaskLelvelsMax;DistanceMask LelvelsMax;7;0;Create;True;0;0;0;False;0;False;1.8;1.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-1632,1072;Inherit;False;Constant;_VerticalGradLvMax;VerticalGrad LvMax;7;0;Create;True;0;0;0;False;0;False;7.76;7.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1632,992;Inherit;False;Property;_VerticalGradientMask;VerticalGradient Mask;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;42;-1632,1504;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;36;-1632,1312;Inherit;False;Global;BigWindSpeed;BigWindSpeed;3;0;Create;True;0;0;0;False;0;False;1;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1632,1408;Inherit;False;Global;WindIntensity;WindIntensity;3;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-1440,1536;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;35;-1280,1440;Inherit;False;WorldNoise;-1;;13;f17c4c9c155f92e4cb0e3f353a46552a;0;3;14;FLOAT2;0,0;False;13;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1344,1312;Inherit;False;Global;BigWindFactor;BigWindFactor;3;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-992,1312;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-864,1312;Inherit;False;MASK_WindMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;171;768,512;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Lemu/FX/GodRays;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;45;0;97;0
WireConnection;45;1;99;0
WireConnection;45;2;101;0
WireConnection;45;3;103;0
WireConnection;45;4;105;0
WireConnection;45;5;46;0
WireConnection;106;0;45;0
WireConnection;22;0;16;0
WireConnection;72;0;68;3
WireConnection;72;3;70;0
WireConnection;72;4;73;0
WireConnection;50;1;49;0
WireConnection;50;0;48;0
WireConnection;52;0;22;0
WireConnection;71;0;72;0
WireConnection;47;0;50;0
WireConnection;96;0;52;0
WireConnection;98;0;47;0
WireConnection;102;0;71;0
WireConnection;95;21;1;0
WireConnection;112;0;1;0
WireConnection;112;1;113;0
WireConnection;100;0;61;0
WireConnection;61;0;57;0
WireConnection;57;0;54;0
WireConnection;57;3;58;0
WireConnection;57;4;59;0
WireConnection;54;0;55;0
WireConnection;109;0;112;0
WireConnection;16;2;19;0
WireConnection;16;3;28;0
WireConnection;43;0;42;1
WireConnection;43;2;42;3
WireConnection;35;14;36;0
WireConnection;35;13;38;0
WireConnection;35;2;43;0
WireConnection;40;0;39;0
WireConnection;40;1;35;0
WireConnection;104;0;40;0
WireConnection;171;2;110;0
WireConnection;171;9;107;0
ASEEND*/
//CHKSM=8AB9ECCAC2ED85C182953145BDE9EA09C76FDD88