// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Nature/PBR_TriplannarRocks"
{
	Properties
	{
		[Header(PBR settings)][NoScaleOffset][Space(10)]_BaseColor("Base Color", 2D) = "gray" {}
		[NoScaleOffset]_Smoothness("Smoothness", 2D) = "black" {}
		_SmoothnessMin("Smoothness Min", Float) = 0.79
		_SmoothenessMax("Smootheness Max", Float) = 0.91
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 0
		[NoScaleOffset][Normal]_MeshNormal("Mesh Normal", 2D) = "bump" {}
		_MeshNormalScale("Mesh Normal Scale", Float) = 1
		[NoScaleOffset]_Curvature("Curvature", 2D) = "black" {}
		[Header(Triplannar settings)][Space(10)]_TriplannarTiling("Triplannar Tiling", Float) = 0
		_TriplannarFallOff("Triplannar FallOff", Float) = 0
		[Header(Wear settings)][Space(10)]_WearColor("Wear Color", Color) = (1,1,1,0)
		_WearFactor("Wear Factor", Range( 0 , 1)) = 0
		_WearHeigth("Wear Heigth", Range( 0 , 1)) = 0
		_WearEdge("Wear Edge", Range( 0 , 1)) = 0
		[Header(Shadow settings)][Space(10)]_ShadowColor("Shadow Color", Color) = (0.0471698,0.05283017,0.1886792,0)
		_ShadowFactor("Shadow Factor", Range( 0 , 1)) = 0
		[Header(Noise settings)][NoScaleOffset][Space(10)]_NoiseTexture("Noise Texture", 2D) = "white" {}
		_NoiseTiling("Noise Tiling", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _MeshNormal;
		uniform float _MeshNormalScale;
		uniform sampler2D _Normal;
		uniform float _TriplannarTiling;
		uniform float _TriplannarFallOff;
		uniform float _NormalScale;
		uniform sampler2D _BaseColor;
		uniform float4 _ShadowColor;
		uniform float _ShadowFactor;
		uniform float4 _WearColor;
		uniform float _WearHeigth;
		uniform sampler2D _Curvature;
		uniform float _WearEdge;
		uniform sampler2D _NoiseTexture;
		uniform float _NoiseTiling;
		uniform float _WearFactor;
		uniform sampler2D _Smoothness;
		uniform float _SmoothnessMin;
		uniform float _SmoothenessMax;


		inline float3 TriplanarSampling122( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			xNorm.xyz  = half3( UnpackScaleNormal( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz  = half3( UnpackScaleNormal( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz  = half3( UnpackScaleNormal( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
		}


		inline float4 TriplanarSampling136( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling149( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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
			float2 uv_MeshNormal117 = i.uv_texcoord;
			float F_TriplannarTiling125 = _TriplannarTiling;
			float2 temp_cast_0 = (F_TriplannarTiling125).xx;
			float F_TriplannarFallOff126 = _TriplannarFallOff;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 triplanar122 = TriplanarSampling122( _Normal, ase_worldPos, ase_worldNormal, F_TriplannarFallOff126, temp_cast_0, _NormalScale, 0 );
			float3 tanTriplanarNormal122 = mul( ase_worldToTangent, triplanar122 );
			float3 OUT_Normal121 = BlendNormals( UnpackScaleNormal( tex2D( _MeshNormal, uv_MeshNormal117 ), _MeshNormalScale ) , tanTriplanarNormal122 );
			o.Normal = OUT_Normal121;
			float2 temp_cast_1 = (F_TriplannarTiling125).xx;
			float4 triplanar136 = TriplanarSampling136( _BaseColor, ase_worldPos, ase_worldNormal, F_TriplannarFallOff126, temp_cast_1, 1.0, 0 );
			float4 RGB_BaseColor144 = triplanar136;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float M_ShadowMask94 = saturate( ( -ase_normWorldNormal.y * _ShadowFactor ) );
			float4 lerpResult71 = lerp( RGB_BaseColor144 , _ShadowColor , M_ShadowMask94);
			float4 blendOpSrc97 = _WearColor;
			float4 blendOpDest97 = RGB_BaseColor144;
			float4 lerpBlendMode97 = lerp(blendOpDest97, (( blendOpSrc97 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc97 - 0.5 ) ) * ( 1.0 - blendOpDest97 ) ) : ( 2.0 * blendOpSrc97 * blendOpDest97 ) ),0.5);
			float temp_output_14_0_g5 = _WearHeigth;
			float temp_output_8_0_g5 = (0.0 + (ase_normWorldNormal.y - (1.0 + (temp_output_14_0_g5 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))) * (1.0 - 0.0) / (1.0 - (1.0 + (temp_output_14_0_g5 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))));
			float2 uv_Curvature88 = i.uv_texcoord;
			float temp_output_14_0_g3 = _WearEdge;
			float temp_output_8_0_g3 = (0.0 + (tex2D( _Curvature, uv_Curvature88 ).r - (1.0 + (temp_output_14_0_g3 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))) * (1.0 - 0.0) / (1.0 - (1.0 + (temp_output_14_0_g3 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))));
			float2 temp_cast_5 = (_NoiseTiling).xx;
			float4 triplanar87 = TriplanarSampling87( _NoiseTexture, ase_worldPos, ase_worldNormal, 1.0, temp_cast_5, 1.0, 0 );
			float temp_output_10_0_g11 = _WearFactor;
			float temp_output_11_0_g11 = (0.0 + (( saturate( temp_output_8_0_g5 ) * saturate( temp_output_8_0_g3 ) * triplanar87.x ) - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_10_0_g11 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float M_Wear78 = saturate( temp_output_11_0_g11 );
			float4 lerpResult98 = lerp( lerpResult71 , ( saturate( lerpBlendMode97 )) , M_Wear78);
			float4 OUT_BaseColor105 = lerpResult98;
			o.Albedo = OUT_BaseColor105.xyz;
			float2 temp_cast_7 = (F_TriplannarTiling125).xx;
			float4 triplanar149 = TriplanarSampling149( _Smoothness, ase_worldPos, ase_worldNormal, F_TriplannarFallOff126, temp_cast_7, 1.0, 0 );
			float4 temp_cast_8 = (_SmoothnessMin).xxxx;
			float4 temp_cast_9 = (_SmoothenessMax).xxxx;
			float4 temp_cast_10 = (M_Wear78).xxxx;
			float4 M_Smoothness110 = saturate( ( (temp_cast_8 + (triplanar149 - float4( 0,0,0,0 )) * (temp_cast_9 - temp_cast_8) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) - temp_cast_10 ) );
			o.Smoothness = M_Smoothness110.x;
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
Node;AmplifyShaderEditor.CommentaryNode;129;-2816,480;Inherit;False;1183.406;766.6703;;10;121;120;118;133;128;122;127;132;117;116;Normal blend;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;114;0,-640;Inherit;False;729;482;;4;106;28;111;130;Output;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;112;-1584,480;Inherit;False;1503.765;445.5333;;10;14;9;110;79;109;13;149;151;150;147;Roughness recontruction;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;107;-2816,-128;Inherit;False;2431.688;544.5704;;15;105;99;98;97;146;93;71;95;69;145;144;137;136;138;134;BaseColor;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;96;-1088,-1024;Inherit;False;898.9033;291.9987;;6;94;58;73;67;66;68;Shadow mask;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;85;-2816,-1024;Inherit;False;1693.757;830.1485;;13;78;92;91;77;87;89;115;80;82;83;88;81;76;Wear Mask;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.WorldNormalVector;76;-2784,-960;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;81;-2784,-832;Inherit;False;Property;_WearHeigth;Wear Heigth;13;0;Create;True;0;0;0;False;0;False;0;0.65;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;83;-2464,-640;Inherit;False;OverrideMinValue;-1;;3;452d473b2fa6fec43b0656f3f93a163f;4,11,1,12,1,18,0,23,0;2;9;FLOAT;0;False;14;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.RangedFloatNode;82;-2784,-544;Inherit;False;Property;_WearEdge;Wear Edge;14;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;80;-2464,-928;Inherit;False;OverrideMinValue;-1;;5;452d473b2fa6fec43b0656f3f93a163f;4,11,1,12,1,18,0,23,0;2;9;FLOAT;0;False;14;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.NegateNode;68;-864,-960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-720,-960;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;73;-576,-960;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;58;-1056,-960;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-416,-960;Inherit;False;M_ShadowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;32,-256;Inherit;False;110;M_Smoothness;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;28;480,-576;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Nature/PBR_TriplannarRocks;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-2496,-336;Inherit;False;Property;_NoiseTiling;Noise Tiling;18;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;87;-2304,-448;Inherit;True;Spherical;World;False;NoiseRef;_NoiseRef;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;NoiseTriplanar;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-1888,-640;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1888,-512;Inherit;False;Property;_WearFactor;Wear Factor;12;0;Create;True;0;0;0;False;0;False;0;0.99;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;92;-1600,-640;Inherit;False;OverrideMaxValue;-1;;11;a223fd650b6f3ed49990d9e847af2115;4,18,1,21,1,19,0,17,0;2;9;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;16
Node;AmplifyShaderEditor.TexturePropertyNode;115;-2784,-448;Inherit;True;Property;_NoiseTexture;Noise Texture;17;2;[Header];[NoScaleOffset];Create;True;1;Noise settings;0;0;False;1;Space(10);False;None;4cb1ca0c46287974c8eb5469458bbdd7;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;67;-1056,-816;Inherit;False;Property;_ShadowFactor;Shadow Factor;16;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-1304.738,-1264.313;Inherit;False;Property;_TriplannarFallOff;Triplannar FallOff;10;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-1080.738,-1360.313;Inherit;False;F_TriplannarTiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-1080.738,-1264.313;Inherit;False;F_TriplannarFallOff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;32,-480;Inherit;False;121;OUT_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;117;-2416,592;Inherit;True;Property;_TextureSample0;Texture Sample 0;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;127;-2784,1152;Inherit;False;126;F_TriplannarFallOff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;122;-2496,992;Inherit;True;Spherical;World;True;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;NormalTriplanar;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;128;-2784,1088;Inherit;False;125;F_TriplannarTiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-2784,1024;Inherit;False;Property;_NormalScale;Normal Scale;5;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;120;-2080,800;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-1856,800;Inherit;False;OUT_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-2784,736;Inherit;False;Property;_MeshNormalScale;Mesh Normal Scale;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;-1344,-640;Inherit;False;M_Wear;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;32,-576;Inherit;False;105;OUT_BaseColor;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-2784,128;Inherit;False;125;F_TriplannarTiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-2784,192;Inherit;False;126;F_TriplannarFallOff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-1824,-64;Inherit;False;144;RGB_BaseColor;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;69;-1824,32;Inherit;False;Property;_ShadowColor;Shadow Color;15;1;[Header];Create;True;1;Shadow settings;0;0;False;1;Space(10);False;0.0471698,0.05283017,0.1886792,0;0.1492966,0.1553886,0.5188676,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;95;-1568,96;Inherit;False;94;M_ShadowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;71;-1344,-64;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;146;-1568,272;Inherit;False;144;RGB_BaseColor;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BlendOpsNode;97;-1312,192;Inherit;True;HardLight;True;3;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0.5;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;98;-864,-64;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-1056,256;Inherit;False;78;M_Wear;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-608,-64;Inherit;False;OUT_BaseColor;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;88;-2784,-736;Inherit;True;Property;_Curvature;Curvature;8;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;c72f75f49310d734ebc57a66d5819471;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;116;-2784,544;Inherit;True;Property;_MeshNormal;Mesh Normal;6;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;118;-2784,816;Inherit;True;Property;_Normal;Normal;4;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;None;db7fc420981044f4098da99877528d7e;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;150;-1552,736;Inherit;False;125;F_TriplannarTiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;151;-1552,832;Inherit;False;126;F_TriplannarFallOff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;149;-1232,544;Inherit;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;-1;None;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;SmoothnessTriplanar;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;13;-752,544;Inherit;False;5;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,1,1,1;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;1,1,1,1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;109;-528,544;Inherit;False;SaturateSubtract;-1;;13;7fec0e09a134197478345092e0bdc7a3;0;2;4;FLOAT4;0,0,0,0;False;5;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-752,704;Inherit;False;78;M_Wear;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-304,544;Inherit;False;M_Smoothness;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;147;-1552,544;Inherit;True;Property;_Smoothness;Smoothness;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TriplanarNode;136;-2464,64;Inherit;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-2080,64;Inherit;False;RGB_BaseColor;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1040,736;Inherit;False;Property;_SmoothnessMin;Smoothness Min;2;0;Create;True;0;0;0;False;0;False;0.79;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1042,832;Inherit;False;Property;_SmoothenessMax;Smootheness Max;3;0;Create;True;0;0;0;False;0;False;0.91;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;93;-1824,192;Inherit;False;Property;_WearColor;Wear Color;11;1;[Header];Create;True;1;Wear settings;0;0;False;1;Space(10);False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;123;-1304.738,-1360.313;Inherit;False;Property;_TriplannarTiling;Triplannar Tiling;9;1;[Header];Create;True;1;Triplannar settings;0;0;False;1;Space(10);False;0;0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;134;-2784,-64;Inherit;True;Property;_BaseColor;Base Color;0;2;[Header];[NoScaleOffset];Create;True;1;PBR settings;0;0;False;1;Space(10);False;None;023a3561d08842945a5373ae69eb0b40;False;gray;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
WireConnection;83;9;88;1
WireConnection;83;14;82;0
WireConnection;80;9;76;2
WireConnection;80;14;81;0
WireConnection;68;0;58;2
WireConnection;66;0;68;0
WireConnection;66;1;67;0
WireConnection;73;0;66;0
WireConnection;94;0;73;0
WireConnection;28;0;106;0
WireConnection;28;1;130;0
WireConnection;28;4;111;0
WireConnection;87;0;115;0
WireConnection;87;3;89;0
WireConnection;77;0;80;6
WireConnection;77;1;83;6
WireConnection;77;2;87;1
WireConnection;92;9;77;0
WireConnection;92;10;91;0
WireConnection;125;0;123;0
WireConnection;126;0;124;0
WireConnection;117;0;116;0
WireConnection;117;5;132;0
WireConnection;122;0;118;0
WireConnection;122;8;133;0
WireConnection;122;3;128;0
WireConnection;122;4;127;0
WireConnection;120;0;117;0
WireConnection;120;1;122;0
WireConnection;121;0;120;0
WireConnection;78;0;92;16
WireConnection;71;0;145;0
WireConnection;71;1;69;0
WireConnection;71;2;95;0
WireConnection;97;0;93;0
WireConnection;97;1;146;0
WireConnection;98;0;71;0
WireConnection;98;1;97;0
WireConnection;98;2;99;0
WireConnection;105;0;98;0
WireConnection;149;0;147;0
WireConnection;149;3;150;0
WireConnection;149;4;151;0
WireConnection;13;0;149;0
WireConnection;13;3;9;0
WireConnection;13;4;14;0
WireConnection;109;4;13;0
WireConnection;109;5;79;0
WireConnection;110;0;109;0
WireConnection;136;0;134;0
WireConnection;136;3;138;0
WireConnection;136;4;137;0
WireConnection;144;0;136;0
ASEEND*/
//CHKSM=D1186BC89DCB80A046DB9CA499F53B9D71CAEA41