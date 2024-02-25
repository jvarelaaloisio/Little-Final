// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Nature/NewFloatingRocks"
{
	Properties
	{
		[Header(Textures)][NoScaleOffset][SingleLineTexture][Space(10)]_BaseColor("BaseColor", 2D) = "white" {}
		[NoScaleOffset][Normal][SingleLineTexture]_Normal("Normal", 2D) = "bump" {}
		[NoScaleOffset][SingleLineTexture]_MetallicSmoothness("MetallicSmoothness", 2D) = "white" {}
		[NoScaleOffset][SingleLineTexture]_Occlusion("Occlusion", 2D) = "white" {}
		[Header(Magic effect)][NoScaleOffset][SingleLineTexture][Space(10)]_SimbolMask("SimbolMask", 2D) = "white" {}
		_EmissColor("EmissColor", Color) = (0.4901961,0.1372549,0.1058824,0)
		_MagicSpeed("MagicSpeed", Float) = 0
		_EmissionFac("Emission Fac", Range( 0 , 1)) = 0
		_MinEmissive("MinEmissive", Float) = 0
		_MaxEmissive("MaxEmissive", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
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

		uniform sampler2D _Normal;
		uniform sampler2D _SimbolMask;
		uniform float4 _EmissColor;
		uniform sampler2D _BaseColor;
		uniform float _EmissionFac;
		uniform float _MagicSpeed;
		uniform float _MinEmissive;
		uniform float _MaxEmissive;
		uniform sampler2D _MetallicSmoothness;
		uniform sampler2D _Occlusion;


		float3 PerturbNormal107_g20( float3 surf_pos, float3 surf_norm, float height, float scale )
		{
			// "Bump Mapping Unparametrized Surfaces on the GPU" by Morten S. Mikkelsen
			float3 vSigmaS = ddx( surf_pos );
			float3 vSigmaT = ddy( surf_pos );
			float3 vN = surf_norm;
			float3 vR1 = cross( vSigmaT , vN );
			float3 vR2 = cross( vN , vSigmaS );
			float fDet = dot( vSigmaS , vR1 );
			float dBs = ddx( height );
			float dBt = ddy( height );
			float3 vSurfGrad = scale * 0.05 * sign( fDet ) * ( dBs * vR1 + dBt * vR2 );
			return normalize ( abs( fDet ) * vN - vSurfGrad );
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
			float3 ase_worldPos = i.worldPos;
			float3 surf_pos107_g20 = ase_worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 surf_norm107_g20 = ase_worldNormal;
			float2 uv_SimbolMask12 = i.uv_texcoord;
			float M_SimbolMask75 = tex2D( _SimbolMask, uv_SimbolMask12 ).r;
			float height107_g20 = M_SimbolMask75;
			float scale107_g20 = 0.2;
			float3 localPerturbNormal107_g20 = PerturbNormal107_g20( surf_pos107_g20 , surf_norm107_g20 , height107_g20 , scale107_g20 );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g20 = mul( ase_worldToTangent, localPerturbNormal107_g20);
			float3 OUT_Normal60 = BlendNormals( UnpackNormal( tex2D( _Normal, uv_Normal13 ) ) , worldToTangentDir42_g20 );
			o.Normal = OUT_Normal60;
			float4 C_Emissive104 = _EmissColor;
			float2 uv_BaseColor2 = i.uv_texcoord;
			float4 blendOpSrc103 = C_Emissive104;
			float4 blendOpDest103 = tex2D( _BaseColor, uv_BaseColor2 );
			float4 lerpBlendMode103 = lerp(blendOpDest103,2.0f*blendOpDest103*blendOpSrc103 + blendOpDest103*blendOpDest103*(1.0f - 2.0f*blendOpSrc103),M_SimbolMask75);
			float4 temp_output_103_0 = ( saturate( lerpBlendMode103 ));
			float4 OUT_BaseColor58 = temp_output_103_0;
			o.Albedo = OUT_BaseColor58.rgb;
			float time49 = 0.0;
			float2 voronoiSmoothId49 = 0;
			float2 coords49 = i.uv_texcoord * 150.0;
			float2 id49 = 0;
			float2 uv49 = 0;
			float voroi49 = voronoi49( coords49, time49, id49, uv49, 0, voronoiSmoothId49 );
			float grayscale50 = Luminance(float3( id49 ,  0.0 ));
			float lerpResult27 = lerp( 0.0 , saturate( ( grayscale50 + 0.5 ) ) , M_SimbolMask75);
			float M_Emissive78 = lerpResult27;
			float mulTime115 = _Time.y * _MagicSpeed;
			float4 OUT_Emission59 = ( ( M_Emissive78 * C_Emissive104 * (0.0 + (_EmissionFac - 0.0) * (30.0 - 0.0) / (1.0 - 0.0)) ) * (_MinEmissive + (sin( mulTime115 ) - -1.0) * (_MaxEmissive - _MinEmissive) / (1.0 - -1.0)) );
			o.Emission = OUT_Emission59.rgb;
			float2 uv_MetallicSmoothness7 = i.uv_texcoord;
			float M_HalfSimbolMask90 = ( M_Emissive78 * 0.5 );
			float OUT_Smothness93 = saturate( ( tex2D( _MetallicSmoothness, uv_MetallicSmoothness7 ).a + M_HalfSimbolMask90 ) );
			o.Smoothness = OUT_Smothness93;
			float2 uv_Occlusion119 = i.uv_texcoord;
			o.Occlusion = tex2D( _Occlusion, uv_Occlusion119 ).r;
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
Node;AmplifyShaderEditor.CommentaryNode;112;1279,-160;Inherit;False;707;706;;6;119;74;94;92;95;101;OUTPUT;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;111;-384,-768;Inherit;False;1262;450;;6;105;98;2;103;15;58;BaseColor;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;110;-384,-224;Inherit;False;1093;536;;7;49;50;77;27;12;75;78;EmissiveMask;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;109;-384,352;Inherit;False;1216.253;479.4524;;14;117;59;118;116;113;115;79;18;57;104;11;20;123;124;Emissive;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;108;-384,880;Inherit;False;1109;369;;6;7;80;83;90;82;93;Smothness;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;107;-384,1280;Inherit;False;1029;354;;5;13;87;60;121;122;Normal;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;384,1344;Inherit;False;OUT_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-128,1120;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;0,1120;Inherit;False;M_HalfSimbolMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;82;256,928;Inherit;False;SaturateAdd;-1;;14;8e2aa5d5bda3f5c41bc64ee811a5f21a;0;2;1;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;448,928;Inherit;False;OUT_Smothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-352,656;Inherit;False;Property;_EmissionFac;Emission Fac;7;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-96,480;Inherit;False;C_Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;57;-64,560;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;30;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;160,400;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-352,400;Inherit;False;78;M_Emissive;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-352,1120;Inherit;False;78;M_Emissive;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;49;-352,-160;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;150;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TFHCGrayscale;50;-160,-160;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;77;64,-160;Inherit;False;SaturateAdd;-1;;15;8e2aa5d5bda3f5c41bc64ee811a5f21a;0;2;1;FLOAT;0;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;288,-160;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-32,96;Inherit;False;M_SimbolMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;448,-160;Inherit;False;M_Emissive;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-352,-704;Inherit;False;104;C_Emissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-352,-416;Inherit;False;75;M_SimbolMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;103;128,-608;Inherit;False;SoftLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;608,-608;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;1311,-96;Inherit;False;58;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;1311,0;Inherit;False;60;OUT_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;1311,96;Inherit;False;59;OUT_Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;1311,192;Inherit;False;93;OUT_Smothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;74;1695,-96;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Nature/NewFloatingRocks;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-352,736;Inherit;False;Property;_MagicSpeed;MagicSpeed;6;0;Create;True;0;0;0;False;0;False;0;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;115;-128,736;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;113;64,736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;576,400;Inherit;False;OUT_Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;384,400;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;15;352,-672;Inherit;False;CloudsPattern;-1;;16;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.ColorNode;20;-352,496;Inherit;False;Property;_EmissColor;EmissColor;5;0;Create;True;0;0;0;False;0;False;0.4901961,0.1372549,0.1058824,0;0.07058821,0.4509804,0.3690312,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-352,1344;Inherit;True;Property;_Normal;Normal;1;3;[NoScaleOffset];[Normal];[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;94b596db858353c47a08485334f3b224;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-352,928;Inherit;True;Property;_MetallicSmoothness;MetallicSmoothness;2;2;[NoScaleOffset];[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;d78b1478f50ae674cbd470e9117ecf79;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;119;1312,320;Inherit;True;Property;_Occlusion;Occlusion;3;2;[NoScaleOffset];[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;864b87ff85e8a114ea434164c65c7d5f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-352,96;Inherit;True;Property;_SimbolMask;SimbolMask;4;3;[Header];[NoScaleOffset];[SingleLineTexture];Create;True;1;Magic effect;0;0;False;1;Space(10);False;-1;None;915236df016dbbd41b6b1d7e285676b5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-352,-608;Inherit;True;Property;_BaseColor;BaseColor;0;3;[Header];[NoScaleOffset];[SingleLineTexture];Create;True;1;Textures;0;0;False;1;Space(10);False;-1;None;96f0a9bbceb647b4e98acfe2f82aa51c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;122;128,1344;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-352,1536;Inherit;False;75;M_SimbolMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;121;-128,1535;Inherit;False;Normal From Height;-1;;20;1942fe2c5f1a1f94881a33d532e4afeb;0;2;20;FLOAT;0;False;110;FLOAT;0.2;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;116;352,512;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.2;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;160,576;Inherit;False;Property;_MinEmissive;MinEmissive;8;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;160,656;Inherit;False;Property;_MaxEmissive;MaxEmissive;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
WireConnection;60;0;122;0
WireConnection;83;0;80;0
WireConnection;90;0;83;0
WireConnection;82;1;7;4
WireConnection;82;3;90;0
WireConnection;93;0;82;0
WireConnection;104;0;20;0
WireConnection;57;0;11;0
WireConnection;18;0;79;0
WireConnection;18;1;104;0
WireConnection;18;2;57;0
WireConnection;50;0;49;1
WireConnection;77;1;50;0
WireConnection;27;1;77;0
WireConnection;27;2;75;0
WireConnection;75;0;12;1
WireConnection;78;0;27;0
WireConnection;103;0;105;0
WireConnection;103;1;2;0
WireConnection;103;2;98;0
WireConnection;58;0;103;0
WireConnection;74;0;101;0
WireConnection;74;1;95;0
WireConnection;74;2;92;0
WireConnection;74;4;94;0
WireConnection;74;5;119;1
WireConnection;115;0;117;0
WireConnection;113;0;115;0
WireConnection;59;0;118;0
WireConnection;118;0;18;0
WireConnection;118;1;116;0
WireConnection;15;21;103;0
WireConnection;122;0;13;0
WireConnection;122;1;121;40
WireConnection;121;20;87;0
WireConnection;116;0;113;0
WireConnection;116;3;123;0
WireConnection;116;4;124;0
ASEEND*/
//CHKSM=7B1412EE3FB760EDF5D288487E83C5D0A76B5DC7