// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_Bush"
{
	Properties
	{
		[Header(Base color)][Space(10)]_BaseColor("Base Color", Color) = (0.5508001,0.8773585,0.5173104,0)
		_SecondaryColor("Secondary Color", Color) = (0.5508001,0.8773585,0.5173104,0)
		_LigthingColor("Ligthing Color", Color) = (0,0,0,0)
		_ShadowSpotsColor("Shadow Spots Color", Color) = (0.02352941,0.07058824,0.282353,1)
		_MainColor("Main Color", Color) = (0.3921569,0.3921569,0.3921569,1)
		_LigthFactor("Ligth Factor", Range( 0 , 1)) = 0
		_SecondaryColorFactor("Secondary Color Factor", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[Header(Bilboard)][NoScaleOffset][Space(10)]_LeavesAlpha("Leaves Alpha", 2D) = "white" {}
		_BilbordScale("Bilbord Scale", Float) = 0
		_EffectBlend("Effect Blend", Range( 0 , 1)) = 0
		_Inflate("Inflate", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Header(Animation)][Space(10)]_WindSpeed("Wind Speed", Float) = 0
		_WindTurbulence("Wind Turbulence", Float) = 1
		_WindIntensity("Wind Intensity", Float) = 0
		_RandomFactor("Random Factor", Range( 0 , 1)) = 0
		_RandomForceFactor("Random Force Factor", Float) = 0
		[Header(Other)][NoScaleOffset][SingleLineTexture][Space(10)]_NoisePatternTexture("Noise Pattern Texture", 2D) = "white" {}
		_ShadowFactor("ShadowFactor", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#pragma multi_compile_local __ _LOD_FADE_CROSSFADE
		#pragma multi_compile __ LOD_FADE_CROSSFADE
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif

		struct appdata_full_custom
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
			float4 texcoord3 : TEXCOORD3;
			float4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
			uint ase_vertexId : SV_VertexID;
		};
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 screenPosition;
			float2 uv_texcoord;
		};

		uniform float _WindSpeed;
		uniform float _WindIntensity;
		uniform float _WindTurbulence;
		uniform float _RandomFactor;
		uniform float _RandomForceFactor;
		uniform float _BilbordScale;
		uniform float _Inflate;
		uniform float _EffectBlend;
		uniform float4 _BaseColor;
		uniform float4 _SecondaryColor;
		uniform float _SecondaryColorFactor;
		uniform float4 _ShadowSpotsColor;
		uniform float _ShadowFactor;
		uniform float4 _LigthingColor;
		uniform float4 _MainColor;
		uniform float _LigthFactor;
		uniform float _Smoothness;
		uniform sampler2D _NoisePatternTexture;
		float4 _NoisePatternTexture_TexelSize;
		uniform sampler2D _LeavesAlpha;
		uniform float _Cutoff = 0.5;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		inline float DitherNoiseTex( float4 screenPos, sampler2D noiseTexture, float4 noiseTexelSize )
		{
			float dither = tex2Dlod( noiseTexture, float4(screenPos.xy * _ScreenParams.xy * noiseTexelSize.xy, 0, 0) ).g;
			float ditherRate = noiseTexelSize.x * noiseTexelSize.y;
			dither = ( 1 - ditherRate ) * dither + ditherRate;
			return dither;
		}


		void vertexDataFunc( inout appdata_full_custom v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float Prop_WindSpeed124 = _WindSpeed;
			float mulTime45 = _Time.y * Prop_WindSpeed124;
			float Prop_WindIntensity131 = _WindIntensity;
			float A_RotationSpeed136 = ( sin( mulTime45 ) * Prop_WindIntensity131 );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 RAW_WorldPosition112 = ase_worldPos;
			float mulTime96 = _Time.y * ( Prop_WindSpeed124 * 0.2 );
			float Prop_WindTurbulece116 = _WindTurbulence;
			float simplePerlin3D86 = snoise( ( RAW_WorldPosition112 + mulTime96 )*Prop_WindTurbulece116 );
			simplePerlin3D86 = simplePerlin3D86*0.5 + 0.5;
			float AM_RotatorMask121 = simplePerlin3D86;
			float3 worldToObj177 = mul( unity_WorldToObject, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float2 temp_cast_0 = (( worldToObj177.x + worldToObj177.y + worldToObj177.z )).xx;
			float dotResult4_g37 = dot( temp_cast_0 , float2( 12.9898,78.233 ) );
			float lerpResult10_g37 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g37 ) * 43758.55 ) ));
			float ifLocalVar250 = 0;
			if( lerpResult10_g37 <= 0.5 )
				ifLocalVar250 = 0.0;
			else
				ifLocalVar250 = 1.0;
			float F_SafeAssetRandomNumber170 = ifLocalVar250;
			uint currInstanceId = 0;
			#ifdef UNITY_INSTANCING_ENABLED
			currInstanceId = unity_InstanceID;
			#endif
			float2 temp_cast_1 = ( currInstanceId + v.ase_vertexId );
			float dotResult4_g32 = dot( temp_cast_1 , float2( 12.9898,78.233 ) );
			float lerpResult10_g32 = lerp( 0.0 , _RandomFactor , frac( ( sin( dotResult4_g32 ) * 43758.55 ) ));
			float F_SafeRandomNumber161 = lerpResult10_g32;
			float cos43 = cos( ( ( ( A_RotationSpeed136 * AM_RotatorMask121 ) + F_SafeAssetRandomNumber170 + F_SafeRandomNumber161 ) * _RandomForceFactor ) );
			float sin43 = sin( ( ( ( A_RotationSpeed136 * AM_RotatorMask121 ) + F_SafeAssetRandomNumber170 + F_SafeRandomNumber161 ) * _RandomForceFactor ) );
			float2 rotator43 = mul( (float2( -1,-1 ) + (v.texcoord.xy - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 ))) - float2( 0,0 ) , float2x2( cos43 , -sin43 , sin43 , cos43 )) + float2( 0,0 );
			float3 appendResult14 = (float3(rotator43 , 0.0));
			float3 normalizeResult18 = normalize( mul( float4( mul( float4( appendResult14 , 0.0 ), UNITY_MATRIX_V ).xyz , 0.0 ), unity_ObjectToWorld ).xyz );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 lerpResult20 = lerp( float3( 0,0,0 ) , ( ( normalizeResult18 * _BilbordScale ) + ( ase_vertexNormal * _Inflate ) ) , _EffectBlend);
			float3 OUT_VertexOffset144 = lerpResult20;
			v.vertex.xyz += OUT_VertexOffset144;
			v.vertex.w = 1;
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float3 worldToObj177 = mul( unity_WorldToObject, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float2 temp_cast_0 = (( worldToObj177.x + worldToObj177.y + worldToObj177.z )).xx;
			float dotResult4_g37 = dot( temp_cast_0 , float2( 12.9898,78.233 ) );
			float lerpResult10_g37 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g37 ) * 43758.55 ) ));
			float ifLocalVar250 = 0;
			if( lerpResult10_g37 <= 0.5 )
				ifLocalVar250 = 0.0;
			else
				ifLocalVar250 = 1.0;
			float F_SafeAssetRandomNumber170 = ifLocalVar250;
			float4 lerpResult181 = lerp( _BaseColor , _SecondaryColor , ( F_SafeAssetRandomNumber170 * _SecondaryColorFactor ));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float temp_output_14_0_g39 = _ShadowFactor;
			float temp_output_8_0_g39 = (0.0 + (-ase_worldNormal.y - (1.0 + (temp_output_14_0_g39 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))) * (1.0 - 0.0) / (1.0 - (1.0 + (temp_output_14_0_g39 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0))));
			float M_ShadowMask263 = saturate( temp_output_8_0_g39 );
			float4 lerpResult186 = lerp( lerpResult181 , _ShadowSpotsColor , M_ShadowMask263);
			float4 OUT_BaseColor148 = saturate( lerpResult186 );
			o.Albedo = OUT_BaseColor148.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV25 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode25 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV25, 5.0 ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 normalizeResult64_g34 = normalize( (WorldNormalVector( i , float3(0,0,1) )) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult14_g34 = dot( normalizeResult64_g34 , ase_worldlightDir );
			float4 temp_output_42_0_g34 = _MainColor;
			float grayscale218 = Luminance(( ( ( ( ase_lightColor * 1 ) * max( dotResult14_g34 , 0.0 ) ) + float4( float3(0,0,0) , 0.0 ) ) * float4( (temp_output_42_0_g34).rgb , 0.0 ) ).rgb);
			float temp_output_10_0_g49 = _LigthFactor;
			float temp_output_11_0_g49 = (0.0 + (saturate( ( grayscale218 * ase_worldNormal.y ) ) - 0.0) * (1.0 - 0.0) / ((1.0 + (temp_output_10_0_g49 - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) - 0.0));
			float M_LigthMask217 = saturate( temp_output_11_0_g49 );
			float4 OUT_Emissive146 = ( _LigthingColor * ( saturate( fresnelNode25 ) * M_LigthMask217 ) );
			o.Emission = OUT_Emissive146.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float dither242 = DitherNoiseTex(ase_screenPosNorm, _NoisePatternTexture, _NoisePatternTexture_TexelSize);
			float2 uv_LeavesAlpha23 = i.uv_texcoord;
			float M_Opacity151 = tex2D( _LeavesAlpha, uv_LeavesAlpha23 ).r;
			#ifdef _LOD_FADE_CROSSFADE
				float staticSwitch240 = unity_LODFade.x;
			#else
				float staticSwitch240 = M_Opacity151;
			#endif
			dither242 = step( dither242, staticSwitch240 );
			float OUT_Opacity245 = dither242;
			clip( OUT_Opacity245 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows dithercrossfade vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.0
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
				float4 customPack1 : TEXCOORD1;
				float2 customPack2 : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full_custom v )
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xyzw = customInputData.screenPosition;
				o.customPack2.xy = customInputData.uv_texcoord;
				o.customPack2.xy = v.texcoord;
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
				surfIN.screenPosition = IN.customPack1.xyzw;
				surfIN.uv_texcoord = IN.customPack2.xy;
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
Node;AmplifyShaderEditor.CommentaryNode;244;-1408,1312;Inherit;False;1063.424;414.4797;;6;245;242;243;240;152;239;LOD animated effect;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;238;-3200,1312;Inherit;False;1728.349;677.1936;;2;236;237;Base color;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;237;-2432,1472;Inherit;False;920.9441;448.4961;RandomShadows;5;148;185;186;166;230;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;236;-3168,1376;Inherit;False;672.22;578;AssetVariation;6;181;232;229;171;178;19;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;227;-3200,-832;Inherit;False;1490.7;291;;6;168;170;231;177;250;253;Position random generator;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;226;-4866,800;Inherit;False;1254;606;Imporve "Lambert Light Node";12;267;264;266;213;263;217;210;258;225;212;218;272;Shadow Mask;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;165;-3200,-480;Inherit;False;959;353;;6;156;154;157;155;158;161;Vertex random generator;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;153;-512,-32;Inherit;False;676;547;;6;149;147;24;0;246;145;Shader;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;150;-3200,832;Inherit;False;1072.741;439.8267;;7;146;28;27;219;25;29;256;Ligthing emissive;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;143;-4864,-768;Inherit;False;552.3708;727.9926;;10;151;23;94;124;48;131;129;112;116;87;Properties;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;142;-1504,-32;Inherit;False;771;321;;4;144;20;22;36;Vertex Position Blend;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;141;-2112,320;Inherit;False;419;320;;3;34;32;33;Inflate Effect;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;140;-3200,320;Inherit;False;994.9595;446.9396;;9;235;233;234;162;137;164;122;43;88;Rotation Animation;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;139;-3200,-32;Inherit;False;1668;291;;10;1;9;30;31;14;12;15;13;16;18;Bilbord construction;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;138;-4864,128;Inherit;False;1059.812;256.0122;TODO Mejorar el este random sine wave;6;132;136;46;44;45;130;Rotation Animation Speed;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;120;-4864,448;Inherit;False;1509.109;290.2487;;8;121;86;117;95;113;96;123;125;Rotator Mask;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1;-3168,32;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;9;-2912,32;Inherit;False;5;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1728,32;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-2464,32;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewMatrixNode;12;-2464,160;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.ObjectToWorldMatrixNode;15;-2272,160;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2272,32;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2080,32;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;18;-1920,32;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-2912,384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;43;-2688,384;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1856,384;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;32;-2080,384;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-2080,544;Inherit;False;Property;_Inflate;Inflate;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1296,32;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;20;-1136,32;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-960,32;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-3168,480;Inherit;False;121;AM_RotatorMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexIdVariableNode;155;-3168,-320;Inherit;False;0;1;INT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;-2912,-416;Inherit;False;2;2;0;INT;0;False;1;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.FunctionNode;157;-2752,-416;Inherit;False;Random Range;-1;;32;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.InstanceIdNode;154;-3168,-416;Inherit;False;False;0;1;INT;0
Node;AmplifyShaderEditor.FresnelNode;25;-3168,1088;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;-2784,992;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-2528,896;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;-2368,896;Inherit;False;OUT_Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-4832,-512;Inherit;False;Property;_WindTurbulence;Wind Turbulence;15;0;Create;True;0;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-4832,-704;Inherit;False;Property;_WindIntensity;Wind Intensity;16;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-4832,512;Inherit;False;124;Prop_WindSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-4832,192;Inherit;False;124;Prop_WindSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-4576,512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;96;-4416,608;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-4416,512;Inherit;False;112;RAW_WorldPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-4128,512;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-4128,640;Inherit;False;116;Prop_WindTurbulece;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;86;-3840,512;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-3616,512;Inherit;False;AM_RotatorMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;45;-4576,192;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;44;-4384,192;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-4224,192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;-4576,288;Inherit;False;131;Prop_WindIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;218;-4608,864;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-4384,864;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;225;-4224,864;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-480,32;Inherit;False;148;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-480,128;Inherit;False;146;OUT_Emissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-480,224;Inherit;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-4048,192;Inherit;False;A_RotationSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-3168,384;Inherit;False;136;A_RotationSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;94;-4832,-416;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-128,32;Float;False;True;-1;4;ASEMaterialInspector;0;0;Standard;S_Bush;False;False;False;False;False;False;False;False;False;False;False;False;True;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;13;-1;-1;-1;0;False;0;0;False;;-1;0;False;;1;Pragma;multi_compile __ LOD_FADE_CROSSFADE;False;;Custom;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-2560,-416;Inherit;False;F_SafeRandomNumber;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;177;-3168,-768;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;231;-2912,-768;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;162;-3168,560;Inherit;False;170;F_SafeAssetRandomNumber;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;186;-2080,1536;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;185;-1920,1536;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;148;-1760,1536;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;29;-3168,896;Inherit;False;Property;_LigthingColor;Ligthing Color;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2705881,0.6235294,0.2509803,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-4544,-256;Inherit;False;M_Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;-4608,-704;Inherit;False;Prop_WindIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-4608,-608;Inherit;False;Prop_WindSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-4608,-416;Inherit;False;RAW_WorldPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-4608,-512;Inherit;False;Prop_WindTurbulece;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;230;-2400,1664;Inherit;False;Property;_ShadowSpotsColor;Shadow Spots Color;3;0;Create;True;0;0;0;False;0;False;0.02352941,0.07058824,0.282353,1;0.02352941,0.07058806,0.2823528,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;19;-3136,1440;Inherit;False;Property;_BaseColor;Base Color;0;1;[Header];Create;True;1;Base color;0;0;False;1;Space(10);False;0.5508001,0.8773585,0.5173104,0;0.1921568,0.4196078,0.1882352,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;229;-3136,1856;Inherit;False;Property;_SecondaryColorFactor;Secondary Color Factor;7;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-4832,-256;Inherit;True;Property;_LeavesAlpha;Leaves Alpha;9;2;[Header];[NoScaleOffset];Create;True;1;Bilboard;0;0;False;1;Space(10);False;-1;None;ffba334276e7701479ca39d8bb15ff0e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-4832,-608;Inherit;False;Property;_WindSpeed;Wind Speed;14;1;[Header];Create;True;1;Animation;0;0;False;1;Space(10);False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1920,128;Inherit;False;Property;_BilbordScale;Bilbord Scale;10;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-3168,-224;Inherit;False;Property;_RandomFactor;Random Factor;17;0;Create;True;0;0;0;False;0;False;0;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;233;-3168,640;Inherit;False;161;F_SafeRandomNumber;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1376,192;Inherit;False;Property;_EffectBlend;Effect Blend;11;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;-2848,544;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;235;-2848,672;Inherit;False;Property;_RandomForceFactor;Random Force Factor;18;0;Create;True;0;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;234;-2656,544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;246;-480,320;Inherit;False;245;OUT_Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;152;-1376,1472;Inherit;False;151;M_Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;240;-1152,1376;Inherit;False;Property;_LOD_FADE_CROSSFADE;LOD_FADE_CROSSFADE;20;0;Create;True;0;0;0;False;0;False;1;0;0;False;LOD_FADE_CROSSFADE;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;242;-832,1376;Inherit;False;2;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;245;-576,1376;Inherit;False;OUT_Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LODFadeNode;239;-1376,1376;Inherit;False;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;145;-492.4393,416.6643;Inherit;False;144;OUT_VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;243;-1152,1504;Inherit;True;Property;_NoisePatternTexture;Noise Pattern Texture;19;3;[Header];[NoScaleOffset];[SingleLineTexture];Create;True;1;Other;0;0;False;1;Space(10);False;None;8095a1f622748884d9476cda7163a5d0;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;178;-3136,1600;Inherit;False;Property;_SecondaryColor;Secondary Color;1;0;Create;True;0;0;0;False;0;False;0.5508001,0.8773585,0.5173104,0;0.1019607,0.1490195,0.1725489,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;181;-2656,1536;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;-2816,1760;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-3136,1760;Inherit;False;170;F_SafeAssetRandomNumber;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;168;-2784,-768;Inherit;False;Random Range;-1;;37;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;170;-2272,-762;Inherit;False;F_SafeAssetRandomNumber;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;250;-2537.931,-761.9529;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-2783.931,-650.9529;Inherit;False;Constant;_Float1;Float 1;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;254;-2785.931,-579.9529;Inherit;False;Constant;_Float2;Float 2;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;219;-2876,1132;Inherit;False;217;M_LigthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;-2619.021,1052.678;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;210;-4832,864;Inherit;False;Lambert Light;4;;34;9be9b95d80559e74dac059ac0a4060cf;0;2;42;COLOR;0,0,0,0;False;52;FLOAT3;0,0,0;False;2;COLOR;0;FLOAT;57
Node;AmplifyShaderEditor.GetLocalVarNode;166;-2400,1824;Inherit;False;263;M_ShadowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;263;-3840,1216;Inherit;False;M_ShadowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;267;-4096,1216;Inherit;False;OverrideMinValue;-1;;39;452d473b2fa6fec43b0656f3f93a163f;4,11,1,12,1,18,0,23,0;2;9;FLOAT;0;False;14;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.NegateNode;264;-4480,1216;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;258;-4832,1056;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;217;-3840,864;Inherit;False;M_LigthMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-4360.459,993.6814;Inherit;False;Property;_LigthFactor;Ligth Factor;6;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;266;-4480,1312;Inherit;False;Property;_ShadowFactor;ShadowFactor;20;0;Create;True;0;0;0;False;0;False;0;0.23;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;272;-4064,864;Inherit;False;OverrideMaxValue;-1;;49;a223fd650b6f3ed49990d9e847af2115;4,18,1,21,1,19,0,17,0;2;9;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;16
WireConnection;9;0;1;0
WireConnection;30;0;18;0
WireConnection;30;1;31;0
WireConnection;14;0;43;0
WireConnection;13;0;14;0
WireConnection;13;1;12;0
WireConnection;16;0;13;0
WireConnection;16;1;15;0
WireConnection;18;0;16;0
WireConnection;88;0;137;0
WireConnection;88;1;122;0
WireConnection;43;0;9;0
WireConnection;43;2;234;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;36;0;30;0
WireConnection;36;1;33;0
WireConnection;20;1;36;0
WireConnection;20;2;22;0
WireConnection;144;0;20;0
WireConnection;156;0;154;0
WireConnection;156;1;155;0
WireConnection;157;1;156;0
WireConnection;157;3;158;0
WireConnection;27;0;25;0
WireConnection;28;0;29;0
WireConnection;28;1;256;0
WireConnection;146;0;28;0
WireConnection;123;0;125;0
WireConnection;96;0;123;0
WireConnection;95;0;113;0
WireConnection;95;1;96;0
WireConnection;86;0;95;0
WireConnection;86;1;117;0
WireConnection;121;0;86;0
WireConnection;45;0;130;0
WireConnection;44;0;45;0
WireConnection;46;0;44;0
WireConnection;46;1;132;0
WireConnection;218;0;210;0
WireConnection;212;0;218;0
WireConnection;212;1;258;2
WireConnection;225;0;212;0
WireConnection;136;0;46;0
WireConnection;0;0;149;0
WireConnection;0;2;147;0
WireConnection;0;4;24;0
WireConnection;0;10;246;0
WireConnection;0;11;145;0
WireConnection;161;0;157;0
WireConnection;231;0;177;1
WireConnection;231;1;177;2
WireConnection;231;2;177;3
WireConnection;186;0;181;0
WireConnection;186;1;230;0
WireConnection;186;2;166;0
WireConnection;185;0;186;0
WireConnection;148;0;185;0
WireConnection;151;0;23;1
WireConnection;131;0;129;0
WireConnection;124;0;48;0
WireConnection;112;0;94;0
WireConnection;116;0;87;0
WireConnection;164;0;88;0
WireConnection;164;1;162;0
WireConnection;164;2;233;0
WireConnection;234;0;164;0
WireConnection;234;1;235;0
WireConnection;240;1;152;0
WireConnection;240;0;239;1
WireConnection;242;0;240;0
WireConnection;242;1;243;0
WireConnection;245;0;242;0
WireConnection;181;0;19;0
WireConnection;181;1;178;0
WireConnection;181;2;232;0
WireConnection;232;0;171;0
WireConnection;232;1;229;0
WireConnection;168;1;231;0
WireConnection;170;0;250;0
WireConnection;250;0;168;0
WireConnection;250;2;253;0
WireConnection;250;3;254;0
WireConnection;250;4;254;0
WireConnection;256;0;27;0
WireConnection;256;1;219;0
WireConnection;263;0;267;6
WireConnection;267;9;264;0
WireConnection;267;14;266;0
WireConnection;264;0;258;2
WireConnection;217;0;272;16
WireConnection;272;9;225;0
WireConnection;272;10;213;0
ASEEND*/
//CHKSM=3CA135D9FEF4A511AEFB28C6F2DBE4D9389F0F54