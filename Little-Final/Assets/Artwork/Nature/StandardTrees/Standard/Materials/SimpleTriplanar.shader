// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplanal/SimpleTriplanar"
{
	Properties
	{
		[Header(PBR Maps)][NoScaleOffset][Space(10)]_BaseColor("BaseColor", 2D) = "white" {}
		[NoScaleOffset]_Smoothness("Smoothness", 2D) = "black" {}
		_SmoothnessFactor("Smoothness Factor", Range( 0 , 1)) = 0
		[NoScaleOffset][Normal]_Normal("Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 0
		[NoScaleOffset]_Occlusion("Occlusion", 2D) = "white" {}
		_HeigthFactor("Heigth Factor", Range( 0 , 1)) = 0
		[NoScaleOffset]_HeightOnlyShadows("Height (Only Shadows)", 2D) = "white" {}
		[Header(Tripplannar settings)][Space(10)]_FallOff("FallOff", Range( 0 , 1)) = 1
		_Tiling("Tiling", Float) = 1
		[Header(Light and Shadow Settings)][Space(10)]_LightColor("LightColor", Color) = (1,0.42488,0,0)
		_LightFactor("LightFactor", Range( 0 , 1)) = 0
		_ShadowColor("ShadowColor", Color) = (0.0471698,0.05283017,0.1886792,0)
		_ShadowFactor("ShadowFactor", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _Normal;
		uniform float _Tiling;
		uniform float _FallOff;
		uniform float _NormalScale;
		uniform sampler2D _BaseColor;
		uniform float4 _LightColor;
		uniform float _LightFactor;
		uniform float4 _ShadowColor;
		uniform float _ShadowFactor;
		uniform sampler2D _HeightOnlyShadows;
		uniform float _HeigthFactor;
		uniform sampler2D _Smoothness;
		uniform float _SmoothnessFactor;
		uniform sampler2D _Occlusion;


		inline float3 TriplanarSampling41( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling2( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling77( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling47( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling68( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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
			float F_Tiling57 = _Tiling;
			float2 temp_cast_0 = (F_Tiling57).xx;
			float F_FallOff53 = _FallOff;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 triplanar41 = TriplanarSampling41( _Normal, ase_worldPos, ase_worldNormal, F_FallOff53, temp_cast_0, _NormalScale, 0 );
			float3 tanTriplanarNormal41 = mul( ase_worldToTangent, triplanar41 );
			float3 N_Normal43 = tanTriplanarNormal41;
			o.Normal = N_Normal43;
			float2 temp_cast_1 = (F_Tiling57).xx;
			float4 triplanar2 = TriplanarSampling2( _BaseColor, ase_worldPos, ase_worldNormal, F_FallOff53, temp_cast_1, 1.0, 0 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV5 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode5 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV5, 5.0 ) );
			float4 C_Light27 = ( _LightColor * saturate( fresnelNode5 ) * _LightFactor );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float M_Shadow24 = saturate( ( -ase_normWorldNormal.y * _ShadowFactor ) );
			float2 temp_cast_4 = (F_Tiling57).xx;
			float4 triplanar77 = TriplanarSampling77( _HeightOnlyShadows, ase_worldPos, ase_worldNormal, F_FallOff53, temp_cast_4, 1.0, 0 );
			float temp_output_14_0_g5 = _HeigthFactor;
			float temp_output_8_0_g5 = (0.0 + (triplanar77.x - (1.0 + (temp_output_14_0_g5 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))) * (1.0 - 0.0) / (1.0 - (1.0 + (temp_output_14_0_g5 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))));
			float M_Heigth80 = saturate( temp_output_8_0_g5 );
			float4 lerpResult22 = lerp( ( triplanar2 + C_Light27 ) , _ShadowColor , ( M_Shadow24 + M_Heigth80 ));
			float4 OUT_BaseColor89 = saturate( lerpResult22 );
			o.Albedo = OUT_BaseColor89.rgb;
			float2 temp_cast_6 = (F_Tiling57).xx;
			float4 triplanar47 = TriplanarSampling47( _Smoothness, ase_worldPos, ase_worldNormal, F_FallOff53, temp_cast_6, 1.0, 0 );
			float M_Smoothness50 = ( triplanar47.x * _SmoothnessFactor );
			o.Smoothness = M_Smoothness50;
			float2 temp_cast_7 = (F_Tiling57).xx;
			float4 triplanar68 = TriplanarSampling68( _Occlusion, ase_worldPos, ase_worldNormal, F_FallOff53, temp_cast_7, 1.0, 0 );
			float M_Occluision72 = triplanar68.x;
			o.Occlusion = M_Occluision72;
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
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
Node;AmplifyShaderEditor.CommentaryNode;91;32,-576;Inherit;False;608;446;;5;44;0;74;51;90;Output;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;88;-1600,-1632;Inherit;False;1249.243;414.1348;;7;81;80;85;84;78;79;77;Heigth Maps;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;73;-2688,-1632;Inherit;False;1009.899;415.459;;5;67;72;69;71;68;Oclussion Triplannar;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;62;-3296,-1632;Inherit;False;581;258;;4;52;4;53;57;Inputs;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;61;-1632,-1152;Inherit;False;1102;417;;7;54;70;50;66;64;47;49;Smoothness Triplannar;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;60;-2688,-1152;Inherit;False;1021.012;514;;6;45;43;41;46;55;58;Normal Triplanar;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-1184,-576;Inherit;False;1060.956;448.3372;;7;89;14;22;83;25;82;21;Blend Shadow;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-1600,-576;Inherit;False;382.4496;256.645;;2;28;11;Blend Light;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;29;-2687.3,-576;Inherit;False;1056.761;416.0784;;5;59;56;2;32;3;Base Color;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;26;-2688,-96;Inherit;False;833;481;;6;27;12;10;5;7;15;Light Mask And Color;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;23;-1824,-96;Inherit;False;897;286;;6;24;20;19;18;17;16;Shadow Mask;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.WorldNormalVector;16;-1792,-32;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;17;-1600,-32;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1456,-32;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;20;-1312,-32;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-1152,-32;Inherit;False;M_Shadow;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2656,288;Inherit;False;Property;_LightFactor;LightFactor;11;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;5;-2656,128;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;10;-2432,128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-2240,96;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-2080,96;Inherit;False;C_Light;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1360,-512;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1568,-448;Inherit;False;27;C_Light;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;21;-1152,-448;Inherit;False;Property;_ShadowColor;ShadowColor;12;0;Create;True;0;0;0;False;0;False;0.0471698,0.05283017,0.1886792,0;0.1085793,0.1129144,0.3773582,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1888,-416;Inherit;False;M_FakeSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;2;-2304,-512;Inherit;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;56;-2560,-240;Inherit;False;53;F_FallOff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-2560,-320;Inherit;False;57;F_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-2560,-816;Inherit;False;57;F_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-2560,-736;Inherit;False;53;F_FallOff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2560,-896;Inherit;False;Property;_NormalScale;Normal Scale;4;0;Create;True;0;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;41;-2304,-992;Inherit;True;Spherical;World;True;NormalTriplanarTex;_NormalTriplanarTex;bump;0;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;NormalTriplanar;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-1920,-992;Inherit;False;N_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TriplanarNode;47;-1344,-1088;Inherit;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;0;None;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;SmoothnessTriplannar;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-3264,-1472;Inherit;False;Property;_Tiling;Tiling;9;0;Create;True;0;0;0;False;0;False;1;0.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-2976,-1568;Inherit;False;F_FallOff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-3072,-1472;Inherit;False;F_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-3264,-1568;Inherit;False;Property;_FallOff;FallOff;8;1;[Header];Create;True;1;Tripplannar settings;0;0;False;1;Space(10);False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-2656,-32;Inherit;False;Property;_LightColor;LightColor;10;1;[Header];Create;True;1;Light and Shadow Settings;0;0;False;1;Space(10);False;1,0.42488,0,0;0.7169812,0.522392,0.1048413,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-1792,112;Inherit;False;Property;_ShadowFactor;ShadowFactor;13;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1232,-896;Inherit;False;Property;_SmoothnessFactor;Smoothness Factor;2;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-912,-1072;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-752,-1072;Inherit;False;M_Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-1600,-896;Inherit;False;57;F_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1600,-816;Inherit;False;53;F_FallOff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;68;-2336,-1584;Inherit;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;-1;None;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;OclussionTriplannar;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;71;-2608,-1392;Inherit;False;57;F_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-2608,-1312;Inherit;False;53;F_FallOff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-1936,-1584;Inherit;False;M_Occluision;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;49;-1600,-1088;Inherit;True;Property;_Smoothness;Smoothness;1;2;[Header];[NoScaleOffset];Create;True;0;0;0;False;0;False;None;52a8e97a91159a24b895788c7e5b0645;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;45;-2656,-1088;Inherit;True;Property;_Normal;Normal;3;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;None;1e699561b984deb4a97ed84027f5c2a4;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;3;-2656,-512;Inherit;True;Property;_BaseColor;BaseColor;0;2;[Header];[NoScaleOffset];Create;True;1;PBR Maps;0;0;False;1;Space(10);False;ed4e7cb780fbe1d48a5018103dce226c;ed4e7cb780fbe1d48a5018103dce226c;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;67;-2656,-1584;Inherit;True;Property;_Occlusion;Occlusion;5;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;5548361d49e6e384881713552b2350c7;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TriplanarNode;77;-1216,-1568;Inherit;True;Spherical;World;False;Top Texture 3;_TopTexture3;white;-1;None;Mid Texture 4;_MidTexture4;white;-1;None;Bot Texture 4;_BotTexture4;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;79;-1472,-1376;Inherit;False;57;F_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-1472,-1296;Inherit;False;53;F_FallOff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;84;-800,-1568;Inherit;False;OverrideMinValue;-1;;5;452d473b2fa6fec43b0656f3f93a163f;4,11,1,12,1,18,0,23,0;2;9;FLOAT;0;False;14;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.RangedFloatNode;85;-1120,-1376;Inherit;False;Property;_HeigthFactor;Heigth Factor;6;0;Create;True;0;0;0;False;0;False;0;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;-576,-1568;Inherit;False;M_Heigth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;81;-1568,-1568;Inherit;True;Property;_HeightOnlyShadows;Height (Only Shadows);7;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;fcd21d792aecd3547a71733680eac4f2;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;82;-1088,-208;Inherit;False;80;M_Heigth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-1088,-288;Inherit;False;24;M_Shadow;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-864,-288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;22;-736,-512;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;14;-576,-512;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-416,-512;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;64,-512;Inherit;False;89;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;64,-320;Inherit;False;50;M_Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;64,-224;Inherit;False;72;M_Occluision;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;384,-512;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Triplanal/SimpleTriplanar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;64,-416;Inherit;False;43;N_Normal;1;0;OBJECT;;False;1;FLOAT3;0
WireConnection;17;0;16;2
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;20;0;18;0
WireConnection;24;0;20;0
WireConnection;10;0;5;0
WireConnection;12;0;7;0
WireConnection;12;1;10;0
WireConnection;12;2;15;0
WireConnection;27;0;12;0
WireConnection;11;0;2;0
WireConnection;11;1;28;0
WireConnection;32;0;2;1
WireConnection;2;0;3;0
WireConnection;2;3;59;0
WireConnection;2;4;56;0
WireConnection;41;0;45;0
WireConnection;41;8;46;0
WireConnection;41;3;58;0
WireConnection;41;4;55;0
WireConnection;43;0;41;0
WireConnection;47;0;49;0
WireConnection;47;3;70;0
WireConnection;47;4;54;0
WireConnection;53;0;52;0
WireConnection;57;0;4;0
WireConnection;66;0;47;1
WireConnection;66;1;64;0
WireConnection;50;0;66;0
WireConnection;68;0;67;0
WireConnection;68;3;71;0
WireConnection;68;4;69;0
WireConnection;72;0;68;1
WireConnection;77;0;81;0
WireConnection;77;3;79;0
WireConnection;77;4;78;0
WireConnection;84;9;77;1
WireConnection;84;14;85;0
WireConnection;80;0;84;6
WireConnection;83;0;25;0
WireConnection;83;1;82;0
WireConnection;22;0;11;0
WireConnection;22;1;21;0
WireConnection;22;2;83;0
WireConnection;14;0;22;0
WireConnection;89;0;14;0
WireConnection;0;0;90;0
WireConnection;0;1;44;0
WireConnection;0;4;51;0
WireConnection;0;5;74;0
ASEEND*/
//CHKSM=ECA3EE031A308AE6E7411F4BC3BF66DCF9CDC024