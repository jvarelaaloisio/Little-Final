// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Nature/Rocks"
{
	Properties
	{
		_Noise("Noise", 2D) = "white" {}
		[NoScaleOffset]_BaseColor("Base Color", 2D) = "white" {}
		[NoScaleOffset]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset]_Roughness("Roughness", 2D) = "white" {}
		_RoughnessLevels_Min("Roughness Levels_Min", Float) = 0.79
		_RoughnessLevels_Max("Roughness Levels_Max", Float) = 0.91
		_ShadowFactor("ShadowFactor", Range( 0 , 1)) = 0
		_ShadowColor("ShadowColor", Color) = (0.0471698,0.05283017,0.1886792,0)
		_WearHeigth("Wear Heigth", Range( 0 , 1)) = 0
		_WearEdge("Wear Edge", Range( 0 , 1)) = 0
		_Curvature("Curvature", 2D) = "white" {}
		_NoiseTiling("Noise Tiling", Float) = 0
		_WearFactor("Wear Factor", Range( 0 , 1)) = 0
		_WearColor("WearColor", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _BaseColor;
		uniform float4 _ShadowColor;
		uniform float _ShadowFactor;
		uniform float4 _WearColor;
		uniform float _WearHeigth;
		uniform sampler2D _Curvature;
		uniform float4 _Curvature_ST;
		uniform float _WearEdge;
		sampler2D _Noise;
		uniform float _NoiseTiling;
		uniform float _WearFactor;
		uniform sampler2D _Roughness;
		uniform float _RoughnessLevels_Min;
		uniform float _RoughnessLevels_Max;


		inline float4 TriplanarSampling87( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal4 = i.uv_texcoord;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal4 ) );
			float2 uv_BaseColor1 = i.uv_texcoord;
			float4 C_BaseColor100 = tex2D( _BaseColor, uv_BaseColor1 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float M_ShadowMask94 = saturate( ( -ase_normWorldNormal.y * _ShadowFactor ) );
			float4 lerpResult71 = lerp( C_BaseColor100 , _ShadowColor , M_ShadowMask94);
			float4 blendOpSrc97 = _WearColor;
			float4 blendOpDest97 = C_BaseColor100;
			float4 lerpBlendMode97 = lerp(blendOpDest97, (( blendOpSrc97 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc97 - 0.5 ) ) * ( 1.0 - blendOpDest97 ) ) : ( 2.0 * blendOpSrc97 * blendOpDest97 ) ),0.5);
			float temp_output_14_0_g1 = _WearHeigth;
			float temp_output_8_0_g1 = (0.0 + (ase_normWorldNormal.y - (1.0 + (temp_output_14_0_g1 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))) * (1.0 - 0.0) / (1.0 - (1.0 + (temp_output_14_0_g1 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))));
			float2 uv_Curvature = i.uv_texcoord * _Curvature_ST.xy + _Curvature_ST.zw;
			float temp_output_14_0_g3 = _WearEdge;
			float temp_output_8_0_g3 = (0.0 + (tex2D( _Curvature, uv_Curvature ).r - (1.0 + (temp_output_14_0_g3 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))) * (1.0 - 0.0) / (1.0 - (1.0 + (temp_output_14_0_g3 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))));
			float2 temp_cast_0 = (_NoiseTiling).xx;
			float3 ase_worldPos = i.worldPos;
			float4 triplanar87 = TriplanarSampling87( _Noise, ase_worldPos, ase_worldNormal, 1.0, temp_cast_0, 1.0, 0 );
			float temp_output_10_0_g8 = _WearFactor;
			float temp_output_11_0_g8 = (0.0 + (( saturate( temp_output_8_0_g1 ) * saturate( temp_output_8_0_g3 ) * triplanar87.x ) - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_10_0_g8 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float M_Wear78 = saturate( temp_output_11_0_g8 );
			float4 lerpResult98 = lerp( lerpResult71 , ( saturate( lerpBlendMode97 )) , M_Wear78);
			float4 OUT_BaseColor105 = lerpResult98;
			o.Albedo = OUT_BaseColor105.rgb;
			float2 uv_Roughness7 = i.uv_texcoord;
			float M_Smoothness110 = saturate( ( (_RoughnessLevels_Min + (( 1.0 - tex2D( _Roughness, uv_Roughness7 ).r ) - 0.0) * (_RoughnessLevels_Max - _RoughnessLevels_Min) / (1.0 - 0.0)) - M_Wear78 ) );
			o.Smoothness = M_Smoothness110;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
Node;AmplifyShaderEditor.CommentaryNode;114;0,-640;Inherit;False;729;482;;4;106;28;4;111;Output;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;112;-1664,-128;Inherit;False;1229;450;;8;7;14;9;8;13;109;79;110;Roughness recontruction;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;107;-2816,-128;Inherit;False;1123.1;736.7;;12;97;105;98;99;103;93;71;95;69;101;1;100;BaseColor;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;96;-1312,-1024;Inherit;False;898.9033;291.9987;;6;94;58;73;67;66;68;Shadow mask;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;85;-2816,-1024;Inherit;False;1474.125;833.1768;;12;78;92;91;80;82;87;89;83;88;77;81;76;Wear Mask;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.WorldNormalVector;76;-2784,-960;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;81;-2784,-832;Inherit;False;Property;_WearHeigth;Wear Heigth;8;0;Create;True;0;0;0;False;0;False;0;0.65;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2112,-624;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;88;-2784,-736;Inherit;True;Property;_Curvature;Curvature;10;0;Create;True;0;0;0;False;0;False;-1;None;a06d7d0c0a9afb246bbc3ed2496cffeb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;83;-2464,-640;Inherit;False;OverrideMinValue;-1;;3;452d473b2fa6fec43b0656f3f93a163f;4,11,1,12,1,18,0,23,0;2;9;FLOAT;0;False;14;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.TriplanarNode;87;-2592,-448;Inherit;True;Spherical;World;False;Noise;_Noise;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;NoiseTriplanar;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;82;-2784,-544;Inherit;False;Property;_WearEdge;Wear Edge;9;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;80;-2464,-928;Inherit;False;OverrideMinValue;-1;;1;452d473b2fa6fec43b0656f3f93a163f;4,11,1,12,1,18,0,23,0;2;9;FLOAT;0;False;14;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;-1568,-624;Inherit;False;M_Wear;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-2112,-512;Inherit;False;Property;_WearFactor;Wear Factor;12;0;Create;True;0;0;0;False;0;False;0;0.99;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-2784,-448;Inherit;False;Property;_NoiseTiling;Noise Tiling;11;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;68;-1088,-960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-944,-960;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-1280,-816;Inherit;False;Property;_ShadowFactor;ShadowFactor;6;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;73;-800,-960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;58;-1280,-960;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;92;-1792,-624;Inherit;False;OverrideMaxValue;-1;;8;a223fd650b6f3ed49990d9e847af2115;4,18,1,21,1,19,0,17,0;2;9;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;16
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-640,-960;Inherit;False;M_ShadowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-2784,-64;Inherit;False;100;C_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;69;-2784,32;Inherit;False;Property;_ShadowColor;ShadowColor;7;0;Create;True;0;0;0;False;0;False;0.0471698,0.05283017,0.1886792,0;0.1492968,0.1553888,0.5188679,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;95;-2784,192;Inherit;False;94;M_ShadowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;71;-2464,0;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;93;-2784,288;Inherit;False;Property;_WearColor;WearColor;13;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;103;-2784,448;Inherit;False;100;C_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-2528,512;Inherit;False;78;M_Wear;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;98;-2176,272;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-1920,272;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;97;-2528,288;Inherit;True;HardLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.5;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;7;-1632,-64;Inherit;True;Property;_Roughness;Roughness;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;029e7b08c8ba92a40a4e11ea403bde80;029e7b08c8ba92a40a4e11ea403bde80;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-1632,224;Inherit;False;Property;_RoughnessLevels_Max;Roughness Levels_Max;5;0;Create;True;0;0;0;False;0;False;0.91;0.97;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1632,128;Inherit;False;Property;_RoughnessLevels_Min;Roughness Levels_Min;4;0;Create;True;0;0;0;False;0;False;0.79;-0.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;8;-1312,-64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;13;-1152,-64;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;109;-928,-64;Inherit;True;SaturateSubtract;-1;;10;7fec0e09a134197478345092e0bdc7a3;0;2;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-1152,96;Inherit;False;78;M_Wear;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-704,-64;Inherit;False;M_Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-1920,-64;Inherit;False;C_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-2240,-64;Inherit;True;Property;_BaseColor;Base Color;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;d7c7f73fe32c947469da8d07645ffe0b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;106;32,-576;Inherit;False;105;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;4;32,-480;Inherit;True;Property;_Normal;Normal;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;7bb22a9c07ee6c04592d6bcf9609e938;7bb22a9c07ee6c04592d6bcf9609e938;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;111;32,-256;Inherit;False;110;M_Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;28;480,-576;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Nature/Rocks;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;77;0;80;6
WireConnection;77;1;83;6
WireConnection;77;2;87;1
WireConnection;83;9;88;1
WireConnection;83;14;82;0
WireConnection;87;3;89;0
WireConnection;80;9;76;2
WireConnection;80;14;81;0
WireConnection;78;0;92;16
WireConnection;68;0;58;2
WireConnection;66;0;68;0
WireConnection;66;1;67;0
WireConnection;73;0;66;0
WireConnection;92;9;77;0
WireConnection;92;10;91;0
WireConnection;94;0;73;0
WireConnection;71;0;101;0
WireConnection;71;1;69;0
WireConnection;71;2;95;0
WireConnection;98;0;71;0
WireConnection;98;1;97;0
WireConnection;98;2;99;0
WireConnection;105;0;98;0
WireConnection;97;0;93;0
WireConnection;97;1;103;0
WireConnection;8;0;7;1
WireConnection;13;0;8;0
WireConnection;13;3;9;0
WireConnection;13;4;14;0
WireConnection;109;4;13;0
WireConnection;109;5;79;0
WireConnection;110;0;109;0
WireConnection;100;0;1;0
WireConnection;28;0;106;0
WireConnection;28;1;4;0
WireConnection;28;4;111;0
ASEEND*/
//CHKSM=0EDAC18BDBAA9D3B889A7513E87D32464B63C133