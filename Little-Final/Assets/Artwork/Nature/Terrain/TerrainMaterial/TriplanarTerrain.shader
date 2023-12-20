// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TriplanarTerrain"
{
	Properties
	{
		[Header(Ground SetUp)][NoScaleOffset][SingleLineTexture][Space(10)]_Ground("Ground", 2D) = "white" {}
		_GroundTiling("Ground Tiling", Float) = 0
		_SecondaryGroundTilingFactor("Secondary Ground Tiling Factor", Float) = 0.5
		_GroundTilingBlend("Ground Tiling Blend", Range( 0 , 1)) = 0.5
		[Header(Down Walls Set Up)][NoScaleOffset][SingleLineTexture][Space(10)]_DownWalls("Down Walls", 2D) = "white" {}
		_DownWallsTiling("Down Walls Tiling", Float) = 0
		_SecondaryDownWallsTilingFactor("Secondary Down Walls Tiling Factor", Float) = 0.5
		_DownWallsBlend("Down Walls Blend", Range( 0 , 1)) = 0.5
		[Header(Cliff SetUp)][NoScaleOffset][SingleLineTexture][Space(10)]_Cliffs("Cliffs", 2D) = "white" {}
		_CliffTiling("Cliff Tiling", Float) = 0
		_SecondaryCliffTilingFactor("Secondary Cliff Tiling Factor", Float) = 0.5
		_CliffTilingBlend("Cliff Tiling Blend", Range( 0 , 1)) = 0.5
		[Header(Slope Set Up)][NoScaleOffset][SingleLineTexture][Space(10)]_Slope("Slope", 2D) = "white" {}
		_SlopeTiling("Slope Tiling", Float) = 0
		_SecondarySlopeTilingFactor("Secondary Slope Tiling Factor", Float) = 0.5
		_SlopeOffset("Slope Offset", Float) = 0
		_Slopeblend("Slope blend", Range( 0 , 1)) = 0.5
		[Header(Custom RGB)][NoScaleOffset][SingleLineTexture][Space(10)]_CustomMsakRGB("Custom Msak RGB", 2D) = "white" {}
		[Toggle]_Useredchanel("Use red chanel", Float) = 0
		[NoScaleOffset][SingleLineTexture]_CustomtextureR("Custom texture R", 2D) = "white" {}
		[Toggle]_Usegreenchanel("Use green chanel", Float) = 0
		[NoScaleOffset][SingleLineTexture]_CustomtextureG("Custom texture G", 2D) = "white" {}
		[Toggle]_Usebluechanel("Use blue chanel", Float) = 0
		[NoScaleOffset][SingleLineTexture]_CustomtextureB("Custom texture B", 2D) = "white" {}
		_Smothness("Smothness", Range( 0 , 1)) = 0
		_SlopeFalloff("SlopeFalloff", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			float2 uv_texcoord;
		};

		uniform float _Usebluechanel;
		uniform float _Usegreenchanel;
		uniform float _Useredchanel;
		uniform sampler2D _Cliffs;
		uniform float _CliffTiling;
		uniform float _SecondaryCliffTilingFactor;
		uniform float _CliffTilingBlend;
		uniform sampler2D _Ground;
		uniform float _GroundTiling;
		uniform float _SecondaryGroundTilingFactor;
		uniform float _GroundTilingBlend;
		uniform float _SlopeOffset;
		uniform sampler2D _DownWalls;
		uniform float _DownWallsTiling;
		uniform float _SecondaryDownWallsTilingFactor;
		uniform float _DownWallsBlend;
		uniform sampler2D _Slope;
		uniform float _SlopeTiling;
		uniform float _SlopeFalloff;
		uniform float _SecondarySlopeTilingFactor;
		uniform float _Slopeblend;
		uniform sampler2D _CustomtextureR;
		uniform sampler2D _CustomMsakRGB;
		uniform sampler2D _CustomtextureG;
		uniform sampler2D _CustomtextureB;
		uniform float _Smothness;


		inline float4 TriplanarSampling11_g45( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling6_g45( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling11_g44( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling6_g44( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling11_g46( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling6_g46( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling11_g47( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling6_g47( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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
			o.Normal = float3(0,0,1);
			float temp_output_13_0_g45 = _CliffTiling;
			float2 temp_cast_0 = (temp_output_13_0_g45).xx;
			float temp_output_20_0_g45 = 1.0;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar11_g45 = TriplanarSampling11_g45( _Cliffs, ase_worldPos, ase_worldNormal, temp_output_20_0_g45, temp_cast_0, 1.0, 0 );
			float2 temp_cast_1 = (( temp_output_13_0_g45 * _SecondaryCliffTilingFactor )).xx;
			float4 triplanar6_g45 = TriplanarSampling6_g45( _Cliffs, ase_worldPos, ase_worldNormal, temp_output_20_0_g45, temp_cast_1, 1.0, 0 );
			float4 lerpResult5_g45 = lerp( triplanar11_g45 , triplanar6_g45 , _CliffTilingBlend);
			float4 Cliff_Blend123 = lerpResult5_g45;
			float temp_output_13_0_g44 = _GroundTiling;
			float2 temp_cast_2 = (temp_output_13_0_g44).xx;
			float temp_output_20_0_g44 = 1.0;
			float4 triplanar11_g44 = TriplanarSampling11_g44( _Ground, ase_worldPos, ase_worldNormal, temp_output_20_0_g44, temp_cast_2, 1.0, 0 );
			float2 temp_cast_3 = (( temp_output_13_0_g44 * _SecondaryGroundTilingFactor )).xx;
			float4 triplanar6_g44 = TriplanarSampling6_g44( _Ground, ase_worldPos, ase_worldNormal, temp_output_20_0_g44, temp_cast_3, 1.0, 0 );
			float4 lerpResult5_g44 = lerp( triplanar11_g44 , triplanar6_g44 , _GroundTilingBlend);
			float4 GroundBlend125 = lerpResult5_g44;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float3 appendResult183 = (float3(saturate( (0.0 + (ase_vertexNormal.y - 0.8) * (1.0 - 0.0) / (1.0 - 0.8)) ) , saturate( (0.0 + (ase_vertexNormal.y - 0.0) * (1.0 - 0.0) / (-1.0 - 0.0)) ) , saturate( ( 1.0 - ( ase_worldPos.y + _SlopeOffset ) ) )));
			float3 Ground_Cliff_Slope_Mask184 = appendResult183;
			float3 break186 = Ground_Cliff_Slope_Mask184;
			float4 lerpResult10 = lerp( Cliff_Blend123 , GroundBlend125 , break186.x);
			float temp_output_13_0_g46 = _DownWallsTiling;
			float2 temp_cast_4 = (temp_output_13_0_g46).xx;
			float temp_output_20_0_g46 = 1.0;
			float4 triplanar11_g46 = TriplanarSampling11_g46( _DownWalls, ase_worldPos, ase_worldNormal, temp_output_20_0_g46, temp_cast_4, 1.0, 0 );
			float2 temp_cast_5 = (( temp_output_13_0_g46 * _SecondaryDownWallsTilingFactor )).xx;
			float4 triplanar6_g46 = TriplanarSampling6_g46( _DownWalls, ase_worldPos, ase_worldNormal, temp_output_20_0_g46, temp_cast_5, 1.0, 0 );
			float4 lerpResult5_g46 = lerp( triplanar11_g46 , triplanar6_g46 , _DownWallsBlend);
			float4 CliffDownBlend137 = lerpResult5_g46;
			float4 lerpResult23 = lerp( lerpResult10 , CliffDownBlend137 , break186.y);
			float temp_output_13_0_g47 = _SlopeTiling;
			float2 temp_cast_6 = (temp_output_13_0_g47).xx;
			float temp_output_20_0_g47 = _SlopeFalloff;
			float4 triplanar11_g47 = TriplanarSampling11_g47( _Slope, ase_worldPos, ase_worldNormal, temp_output_20_0_g47, temp_cast_6, 1.0, 0 );
			float2 temp_cast_7 = (( temp_output_13_0_g47 * _SecondarySlopeTilingFactor )).xx;
			float4 triplanar6_g47 = TriplanarSampling6_g47( _Slope, ase_worldPos, ase_worldNormal, temp_output_20_0_g47, temp_cast_7, 1.0, 0 );
			float4 lerpResult5_g47 = lerp( triplanar11_g47 , triplanar6_g47 , _Slopeblend);
			float4 SlopeBlend139 = lerpResult5_g47;
			float4 lerpResult61 = lerp( lerpResult23 , SlopeBlend139 , break186.z);
			float2 uv_CustomtextureR158 = i.uv_texcoord;
			float2 uv_CustomMsakRGB154 = i.uv_texcoord;
			float4 tex2DNode154 = tex2D( _CustomMsakRGB, uv_CustomMsakRGB154 );
			float R_ChanelMask175 = saturate( ( ( tex2DNode154.r - tex2DNode154.g ) - tex2DNode154.b ) );
			float4 lerpResult156 = lerp( lerpResult61 , tex2D( _CustomtextureR, uv_CustomtextureR158 ) , R_ChanelMask175);
			float2 uv_CustomtextureG162 = i.uv_texcoord;
			float G_ChanelMask176 = saturate( ( ( tex2DNode154.g - tex2DNode154.r ) - tex2DNode154.b ) );
			float4 lerpResult161 = lerp( (( _Useredchanel )?( lerpResult156 ):( lerpResult61 )) , tex2D( _CustomtextureG, uv_CustomtextureG162 ) , G_ChanelMask176);
			float2 uv_CustomtextureB163 = i.uv_texcoord;
			float B_ChanelMask177 = saturate( ( ( tex2DNode154.b - tex2DNode154.r ) - tex2DNode154.g ) );
			float4 lerpResult164 = lerp( (( _Usegreenchanel )?( lerpResult161 ):( (( _Useredchanel )?( lerpResult156 ):( lerpResult61 )) )) , tex2D( _CustomtextureB, uv_CustomtextureB163 ) , B_ChanelMask177);
			float4 OUT_BaseColor198 = (( _Usebluechanel )?( lerpResult164 ):( (( _Usegreenchanel )?( lerpResult161 ):( (( _Useredchanel )?( lerpResult156 ):( lerpResult61 )) )) ));
			o.Albedo = OUT_BaseColor198.rgb;
			o.Smoothness = _Smothness;
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
Node;AmplifyShaderEditor.CommentaryNode;200;-1423.543,-1933.402;Inherit;False;561;521;;3;199;0;225;OUT;0,1,0,0.5019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;197;-256,-1344;Inherit;False;2563.489;575.6664;Custom mask;13;158;196;164;181;163;195;161;180;162;194;179;156;198;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;187;-1280,-1280;Inherit;False;962.0658;603.9671;Terrain base color blend;9;186;185;140;138;126;61;23;10;124;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;182;-2560,-352;Inherit;False;1184.027;642.3251;Vertex normal mask;7;184;183;44;24;25;42;43;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;178;-1664,-2432;Inherit;False;1010;377;Custom mask set up;10;166;170;172;171;168;154;176;175;173;177;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;141;-2560,-960;Inherit;False;868.561;579.5876;Slope;5;136;224;82;139;85;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;134;-2560,-1568;Inherit;False;864.8318;545.8157;Cliff Down;5;137;223;133;80;84;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;128;-2560,-2144;Inherit;False;871.171;544.9988;Ground;5;221;125;116;83;78;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;127;-2560,-2720;Inherit;False;869.4387;545.7482;Cliff;5;123;130;222;75;76;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;86;-2560,320;Inherit;False;706.7206;318.7019;Slope mask;5;153;59;63;56;52;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;43;-2272,0;Inherit;False;224;251;DownCliffs;1;38;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-2272,-288;Inherit;False;226;257;Ground;1;40;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;52;-2528,384;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-2336,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;-2208,384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-2528,-2464;Inherit;False;Property;_CliffTiling;Cliff Tiling;9;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-2528,-1280;Inherit;False;Property;_DownWallsTiling;Down Walls Tiling;5;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;153;-2048,384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;166;-1248,-2368;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;170;-1248,-2272;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;172;-1248,-2176;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;171;-1088,-2272;Inherit;False;SaturateSubtract;-1;;18;7fec0e09a134197478345092e0bdc7a3;0;2;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;168;-1088,-2368;Inherit;False;SaturateSubtract;-1;;19;7fec0e09a134197478345092e0bdc7a3;0;2;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;-896,-2272;Inherit;False;G_ChanelMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-896,-2368;Inherit;False;R_ChanelMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;173;-1088,-2176;Inherit;False;SaturateSubtract;-1;;20;7fec0e09a134197478345092e0bdc7a3;0;2;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;177;-896,-2176;Inherit;False;B_ChanelMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;40;-2240,-224;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.8;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;38;-2240,64;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;-1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;25;-2528,-128;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;24;-2016,64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;44;-2016,-224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;183;-1824,32;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;184;-1664,32;Inherit;False;Ground_Cliff_Slope_Mask;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-1248,-1216;Inherit;False;123;Cliff_Blend;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;10;-864,-1216;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;23;-672,-1120;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;61;-496,-1024;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1248,-1120;Inherit;False;125;GroundBlend;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-1248,-1024;Inherit;False;137;CliffDownBlend;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;-1248,-832;Inherit;False;184;Ground_Cliff_Slope_Mask;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;156;96,-928;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-224,-1088;Inherit;False;175;R_ChanelMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;194;288,-1024;Inherit;False;Property;_Useredchanel;Use red chanel;18;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;180;544,-1088;Inherit;False;176;G_ChanelMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;161;864,-928;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;195;1056,-1024;Inherit;False;Property;_Usegreenchanel;Use green chanel;20;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;181;1312,-1088;Inherit;False;177;B_ChanelMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;164;1632,-928;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;196;1824,-1024;Inherit;False;Property;_Usebluechanel;Use blue chanel;22;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-2528,544;Inherit;False;Property;_SlopeOffset;Slope Offset;15;0;Create;True;0;0;0;False;0;False;0;-2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;198;2048,-1024;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1103.543,-1869.402;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;TriplanarTerrain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SamplerNode;158;-224,-1280;Inherit;True;Property;_CustomtextureR;Custom texture R;19;2;[NoScaleOffset];[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;162;544,-1280;Inherit;True;Property;_CustomtextureG;Custom texture G;21;2;[NoScaleOffset];[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;163;1312,-1280;Inherit;True;Property;_CustomtextureB;Custom texture B;23;2;[NoScaleOffset];[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;85;-2528,-672;Inherit;False;Property;_SlopeTiling;Slope Tiling;13;0;Create;True;0;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;78;-2528,-2080;Inherit;True;Property;_Ground;Ground;0;3;[Header];[NoScaleOffset];[SingleLineTexture];Create;True;1;Ground SetUp;0;0;False;1;Space(10);False;None;1034bfd56ed84b543b1607ecebc7afa5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;75;-2528,-2656;Inherit;True;Property;_Cliffs;Cliffs;8;3;[Header];[NoScaleOffset];[SingleLineTexture];Create;True;1;Cliff SetUp;0;0;False;1;Space(10);False;None;2fa68d0e83492a243a3f35e31b520f1f;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;80;-2528,-1504;Inherit;True;Property;_DownWalls;Down Walls;4;3;[Header];[NoScaleOffset];[SingleLineTexture];Create;True;1;Down Walls Set Up;0;0;False;1;Space(10);False;None;e90838db910529440b90e2a8891f7c91;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;82;-2528,-896;Inherit;True;Property;_Slope;Slope;12;3;[Header];[NoScaleOffset];[SingleLineTexture];Create;True;1;Slope Set Up;0;0;False;1;Space(10);False;None;ed60dbbd7504e194e8bed4b4308479e3;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;154;-1632,-2368;Inherit;True;Property;_CustomMsakRGB;Custom Msak RGB;17;3;[Header];[NoScaleOffset];[SingleLineTexture];Create;True;1;Custom RGB;0;0;False;1;Space(10);False;-1;None;804b3aceaa367cd4eba069f7323f3cc3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;83;-2528,-1888;Inherit;False;Property;_GroundTiling;Ground Tiling;1;0;Create;True;0;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-2528,-1696;Inherit;False;Property;_GroundTilingBlend;Ground Tiling Blend;3;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-1920,-1920;Inherit;False;GroundBlend;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-2528,-2368;Inherit;False;Property;_SecondaryCliffTilingFactor;Secondary Cliff Tiling Factor;10;0;Create;True;0;0;0;False;0;False;0.5;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-2528,-2272;Inherit;False;Property;_CliffTilingBlend;Cliff Tiling Blend;11;0;Create;True;0;0;0;False;0;False;0.5;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-1952,-2496;Inherit;False;Cliff_Blend;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-2528,-1792;Inherit;False;Property;_SecondaryGroundTilingFactor;Secondary Ground Tiling Factor;2;0;Create;True;0;0;0;False;0;False;0.5;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-2528,-1104;Inherit;False;Property;_DownWallsBlend;Down Walls Blend;7;0;Create;True;0;0;0;False;0;False;0.5;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-1920,-1296;Inherit;False;CliffDownBlend;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-2528,-1200;Inherit;False;Property;_SecondaryDownWallsTilingFactor;Secondary Down Walls Tiling Factor;6;0;Create;True;0;0;0;False;0;False;0.5;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-2528,-576;Inherit;False;Property;_SecondarySlopeTilingFactor;Secondary Slope Tiling Factor;14;0;Create;True;0;0;0;False;0;False;0.5;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-2528,-480;Inherit;False;Property;_Slopeblend;Slope blend;16;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-1920,-704;Inherit;False;SlopeBlend;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-1398.325,-1695.38;Inherit;False;Property;_Smothness;Smothness;24;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;-1391.543,-1869.402;Inherit;False;198;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;186;-880,-827;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;140;-1248,-928;Inherit;False;139;SlopeBlend;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;226;-2176,-1920;Inherit;False;TriplanarTilingBlend;-1;;44;3af183405f467664aa5662047cedce3a;0;5;12;SAMPLER2D;0;False;13;FLOAT;0;False;20;FLOAT;1;False;17;FLOAT;0.5;False;16;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;227;-2208,-2496;Inherit;False;TriplanarTilingBlend;-1;;45;3af183405f467664aa5662047cedce3a;0;5;12;SAMPLER2D;0;False;13;FLOAT;0;False;20;FLOAT;1;False;17;FLOAT;0.5;False;16;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;228;-2176,-1296;Inherit;False;TriplanarTilingBlend;-1;;46;3af183405f467664aa5662047cedce3a;0;5;12;SAMPLER2D;0;False;13;FLOAT;0;False;20;FLOAT;1;False;17;FLOAT;0.5;False;16;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;229;-2176,-704;Inherit;False;TriplanarTilingBlend;-1;;47;3af183405f467664aa5662047cedce3a;0;5;12;SAMPLER2D;0;False;13;FLOAT;0;False;20;FLOAT;1;False;17;FLOAT;0.5;False;16;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;230;-2864.194,-645.6993;Inherit;False;Property;_SlopeFalloff;SlopeFalloff;25;0;Create;True;0;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;231;-2023.736,-1510.64;Inherit;True;Property;_TextureSample0;Texture Sample 0;26;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;63;0;52;2
WireConnection;63;1;56;0
WireConnection;59;0;63;0
WireConnection;153;0;59;0
WireConnection;166;0;154;1
WireConnection;166;1;154;2
WireConnection;170;0;154;2
WireConnection;170;1;154;1
WireConnection;172;0;154;3
WireConnection;172;1;154;1
WireConnection;171;4;170;0
WireConnection;171;5;154;3
WireConnection;168;4;166;0
WireConnection;168;5;154;3
WireConnection;176;0;171;0
WireConnection;175;0;168;0
WireConnection;173;4;172;0
WireConnection;173;5;154;2
WireConnection;177;0;173;0
WireConnection;40;0;25;2
WireConnection;38;0;25;2
WireConnection;24;0;38;0
WireConnection;44;0;40;0
WireConnection;183;0;44;0
WireConnection;183;1;24;0
WireConnection;183;2;153;0
WireConnection;184;0;183;0
WireConnection;10;0;124;0
WireConnection;10;1;126;0
WireConnection;10;2;186;0
WireConnection;23;0;10;0
WireConnection;23;1;138;0
WireConnection;23;2;186;1
WireConnection;61;0;23;0
WireConnection;61;1;140;0
WireConnection;61;2;186;2
WireConnection;156;0;61;0
WireConnection;156;1;158;0
WireConnection;156;2;179;0
WireConnection;194;0;61;0
WireConnection;194;1;156;0
WireConnection;161;0;194;0
WireConnection;161;1;162;0
WireConnection;161;2;180;0
WireConnection;195;0;194;0
WireConnection;195;1;161;0
WireConnection;164;0;195;0
WireConnection;164;1;163;0
WireConnection;164;2;181;0
WireConnection;196;0;195;0
WireConnection;196;1;164;0
WireConnection;198;0;196;0
WireConnection;0;0;199;0
WireConnection;0;4;225;0
WireConnection;125;0;226;0
WireConnection;123;0;227;0
WireConnection;137;0;228;0
WireConnection;139;0;229;0
WireConnection;186;0;185;0
WireConnection;226;12;78;0
WireConnection;226;13;83;0
WireConnection;226;17;221;0
WireConnection;226;16;116;0
WireConnection;227;12;75;0
WireConnection;227;13;76;0
WireConnection;227;17;222;0
WireConnection;227;16;130;0
WireConnection;228;12;80;0
WireConnection;228;13;84;0
WireConnection;228;17;223;0
WireConnection;228;16;133;0
WireConnection;229;12;82;0
WireConnection;229;13;85;0
WireConnection;229;20;230;0
WireConnection;229;17;224;0
WireConnection;229;16;136;0
WireConnection;231;0;80;0
ASEEND*/
//CHKSM=490775FCD15771D5749D84A734EC10220815CF7D