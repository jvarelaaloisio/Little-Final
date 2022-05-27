// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Nature/StandardTree"
{
	Properties
	{
		_Leaves__BaseColor("Leaves__BaseColor", Color) = (0.3019608,0.3019608,0.3019608,0)
		[NoScaleOffset]_Leaves_AlphaLeaf("Leaves_Alpha Leaf", 2D) = "white" {}
		_Light__Color("Light__Color", Color) = (0.6,0.6,0.6,0)
		_Light__Factor("Light__Factor", Range( 0 , 1)) = 0.3
		_Light__MaskScale("Light__Mask Scale", Float) = 1
		_Shadow__Color("Shadow__Color", Color) = (0.1921569,0.1921569,0.1921569,0)
		_Shadow__Factor("Shadow__Factor", Range( 0 , 1)) = 1
		_Shadow__MaskScale("Shadow__Mask Scale", Float) = 0.3
		_Wind__BaseSpeed("Wind__Base Speed", Float) = 0
		_Wind__PrimarySpeed("Wind__Primary Speed", Float) = 0.2
		_Wind__SecondarySpeed("Wind__Secondary Speed", Float) = 0
		_Wind__NoiseFactor("Wind__Noise Factor", Float) = 2
		_Wind__NoiseAnimationScale("Wind__Noise Animation Scale", Float) = 0.3
		_Wind__WorldNoiseSpeedX("Wind__World Noise Speed X", Float) = 1
		_Wind__WorldNoiseSpeedY("Wind__World Noise Speed Y", Float) = 0
		_Wind__WorldNoiseScale("Wind__World Noise Scale", Float) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_ProximityMask__Size("ProximityMask__Size", Float) = 0.15
		_ProximityMask_SizeMin("ProximityMask_SizeMin", Float) = -0.2
		_ProximityMask_SizeMax("ProximityMask_SizeMax", Float) = 0.1
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_ProximityMask__Factor("ProximityMask__Factor", Range( 0 , 1)) = 0
		_TranslucencyFactor("Translucency Factor", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#pragma multi_compile __ LOD_FADE_CROSSFADE
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
			float vertexToFrag41;
			float vertexToFrag66;
			float4 screenPosition;
			float eyeDepth;
		};

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Translucency;
		};

		uniform float _Wind__PrimarySpeed;
		uniform float _Wind__SecondarySpeed;
		uniform float _Wind__BaseSpeed;
		uniform float _Wind__NoiseAnimationScale;
		uniform float _Wind__NoiseFactor;
		uniform float _Wind__WorldNoiseSpeedX;
		uniform float _Wind__WorldNoiseSpeedY;
		uniform float _Wind__WorldNoiseScale;
		uniform sampler2D _Leaves_AlphaLeaf;
		uniform float4 _Leaves__BaseColor;
		uniform float4 _Light__Color;
		uniform float _Light__MaskScale;
		uniform float _Light__Factor;
		uniform float4 _Shadow__Color;
		uniform float _Shadow__MaskScale;
		uniform float _Shadow__Factor;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform float _TranslucencyFactor;
		uniform float _ProximityMask__Size;
		uniform float _ProximityMask_SizeMin;
		uniform float _ProximityMask_SizeMax;
		uniform float _ProximityMask__Factor;
		uniform float _Cutoff = 0.5;


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


		inline float Dither4x4Bayer( int x, int y )
		{
			const float dither[ 16 ] = {
				 1,  9,  3, 11,
				13,  5, 15,  7,
				 4, 12,  2, 10,
				16,  8, 14,  6 };
			int r = y * 4 + x;
			return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime212 = _Time.y * ( _Wind__BaseSpeed * 0.001 );
			float lerpResult199 = lerp( _Wind__PrimarySpeed , _Wind__SecondarySpeed , ( ( sin( mulTime212 ) + 1.0 ) * 0.5 ));
			float mulTime161 = _Time.y * lerpResult199;
			float WindSpeedBase217 = mulTime161;
			float2 appendResult162 = (float2(WindSpeedBase217 , 0.0));
			float2 uv_TexCoord143 = v.texcoord.xy + appendResult162;
			float simplePerlin2D142 = snoise( uv_TexCoord143*_Wind__NoiseAnimationScale );
			simplePerlin2D142 = simplePerlin2D142*0.5 + 0.5;
			float temp_output_152_0 = (0.0 + (( simplePerlin2D142 * 0.001 ) - 0.0) * (( _Wind__NoiseFactor * 0.001 ) - 0.0) / (1.0 - 0.0));
			float4 appendResult170 = (float4(temp_output_152_0 , temp_output_152_0 , temp_output_152_0 , 0.0));
			float2 appendResult247 = (float2(_Wind__WorldNoiseSpeedX , _Wind__WorldNoiseSpeedY));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 panner10_g13 = ( 1.0 * _Time.y * appendResult247 + ( ase_worldPos * _Wind__WorldNoiseScale ).xy);
			float simplePerlin2D11_g13 = snoise( panner10_g13 );
			simplePerlin2D11_g13 = simplePerlin2D11_g13*0.5 + 0.5;
			float4 _Wind__WorldNoiseLevels = float4(0.3,0.5,0,0.6);
			float4 lerpResult232 = lerp( appendResult170 , float4( 0,0,0,0 ) , saturate( (_Wind__WorldNoiseLevels.z + (simplePerlin2D11_g13 - _Wind__WorldNoiseLevels.x) * (_Wind__WorldNoiseLevels.w - _Wind__WorldNoiseLevels.z) / (_Wind__WorldNoiseLevels.y - _Wind__WorldNoiseLevels.x)) ));
			float4 transform169 = mul(unity_ObjectToWorld,lerpResult232);
			float4 LocalVertexOffsetOutput239 = transform169;
			v.vertex.xyz += LocalVertexOffsetOutput239.xyz;
			v.vertex.w = 1;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult33 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_34_0 = pow( dotResult33 , _Light__MaskScale );
			o.vertexToFrag41 = temp_output_34_0;
			float dotResult63 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_64_0 = pow( dotResult63 , _Shadow__MaskScale );
			o.vertexToFrag66 = temp_output_64_0;
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			o.screenPosition = ase_screenPos;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !defined(DIRECTIONAL)
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float2 uv_Leaves_AlphaLeaf138 = i.uv_texcoord;
			float4 tex2DNode138 = tex2D( _Leaves_AlphaLeaf, uv_Leaves_AlphaLeaf138 );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult33 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_34_0 = pow( dotResult33 , _Light__MaskScale );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 lerpResult53 = lerp( ( tex2DNode138 * _Leaves__BaseColor ) , _Light__Color , ( saturate( ( temp_output_34_0 * ase_lightColor * i.vertexToFrag41 ) ) * _Light__Factor ).a);
			float dotResult63 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_64_0 = pow( dotResult63 , _Shadow__MaskScale );
			float4 lerpResult78 = lerp( lerpResult53 , _Shadow__Color , ( ( 1.0 - saturate( ( temp_output_64_0 * ase_lightColor * i.vertexToFrag66 ) ) ) * _Shadow__Factor ).a);
			float4 temp_output_21_0_g14 = lerpResult78;
			float4 color20_g14 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_0 = (0.1).xx;
			float2 appendResult5_g14 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g14 = ( 0.01 * 1.5 );
			float2 panner10_g15 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult5_g14 * temp_output_2_0_g14 ));
			float simplePerlin2D11_g15 = snoise( panner10_g15 );
			simplePerlin2D11_g15 = simplePerlin2D11_g15*0.5 + 0.5;
			float temp_output_8_0_g14 = simplePerlin2D11_g15;
			float2 temp_cast_1 = (0.1).xx;
			float2 panner10_g17 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g14 * 0.01 ));
			float simplePerlin2D11_g17 = snoise( panner10_g17 );
			simplePerlin2D11_g17 = simplePerlin2D11_g17*0.5 + 0.5;
			float2 temp_cast_2 = (0.1).xx;
			float2 panner10_g16 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g14 * ( temp_output_2_0_g14 * 4.0 ) ));
			float simplePerlin2D11_g16 = snoise( panner10_g16 );
			simplePerlin2D11_g16 = simplePerlin2D11_g16*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g14 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g14 * simplePerlin2D11_g17 ) + ( 1.0 - simplePerlin2D11_g16 ) ) * temp_output_8_0_g14 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g14 = lerp( temp_output_21_0_g14 , saturate( ( temp_output_21_0_g14 * color20_g14 ) ) , ( temp_output_16_0_g14 * 1.0 ));
			float4 BaseColorOutput21 = lerpResult24_g14;
			o.Albedo = BaseColorOutput21.rgb;
			float3 temp_cast_4 = (_TranslucencyFactor).xxx;
			o.Translucency = temp_cast_4;
			o.Alpha = 1;
			float BaseColorAlpha19 = tex2DNode138.a;
			float4 ase_screenPos = i.screenPosition;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 clipScreen281 = ase_screenPosNorm.xy * _ScreenParams.xy;
			float dither281 = Dither4x4Bayer( fmod(clipScreen281.x, 4), fmod(clipScreen281.y, 4) );
			dither281 = step( dither281, _ProximityMask__Size );
			float cameraDepthFade282 = (( i.eyeDepth -_ProjectionParams.y - 0.0 ) / 1.0);
			float lerpResult283 = lerp( dither281 , BaseColorAlpha19 , saturate( (_ProximityMask_SizeMin + (cameraDepthFade282 - 0.0) * (_ProximityMask_SizeMax - _ProximityMask_SizeMin) / (1.0 - 0.0)) ));
			float lerpResult294 = lerp( BaseColorAlpha19 , lerpResult283 , _ProximityMask__Factor);
			clip( lerpResult294 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustom keepalpha fullforwardshadows exclude_path:deferred dithercrossfade vertex:vertexDataFunc 

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
				float4 customPack2 : TEXCOORD2;
				float1 customPack3 : TEXCOORD3;
				float3 worldPos : TEXCOORD4;
				float3 worldNormal : TEXCOORD5;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.z = customInputData.vertexToFrag41;
				o.customPack1.w = customInputData.vertexToFrag66;
				o.customPack2.xyzw = customInputData.screenPosition;
				o.customPack3.x = customInputData.eyeDepth;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.vertexToFrag41 = IN.customPack1.z;
				surfIN.vertexToFrag66 = IN.customPack1.w;
				surfIN.screenPosition = IN.customPack2.xyzw;
				surfIN.eyeDepth = IN.customPack3.x;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandardCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardCustom, o )
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
Version=18935
1194;1102;1780;878;256.1097;-433.4203;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;219;-3688.445,1109.133;Inherit;False;1571.374;342;Wind Speed Base;11;215;237;164;217;161;199;214;213;210;212;216;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-3663.445,1320.133;Inherit;False;Property;_Wind__BaseSpeed;Wind__Base Speed;8;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;216;-3445.445,1317.133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;212;-3317.445,1317.133;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;210;-3125.445,1317.133;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;213;-2997.445,1317.133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-3013.445,1237.133;Inherit;False;Property;_Wind__SecondarySpeed;Wind__Secondary Speed;10;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-2869.445,1317.133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-3013.445,1157.133;Inherit;False;Property;_Wind__PrimarySpeed;Wind__Primary Speed;9;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;199;-2661.445,1221.133;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;59;-2320,640;Inherit;False;1807.906;421.3855;Shadow Mask (Para magnificar la sombras en las copas);13;74;66;63;60;64;61;65;68;67;70;69;62;76;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-2128,192;Inherit;False;1607.906;410.3855;Light Mask (Para magnificar la luz en las copas);12;56;55;54;38;41;39;34;33;35;37;32;73;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;37;-2080,400;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;60;-2272,688;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;32;-2080,240;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;161;-2517.445,1237.133;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;61;-2272,848;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;62;-2064,912;Inherit;False;Property;_Shadow__MaskScale;Shadow__Mask Scale;7;0;Create;True;0;0;0;False;0;False;0.3;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1856,464;Inherit;False;Property;_Light__MaskScale;Light__Mask Scale;4;0;Create;True;0;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;33;-1824,240;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;238;-2069.445,1109.133;Inherit;False;1555;390;Animacion individual;9;170;162;143;144;142;165;189;190;152;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;217;-2357.445,1237.133;Inherit;False;WindSpeedBase;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;63;-2016,688;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;236;-1792.858,1539.669;Inherit;False;1279;447;Mascara para randomizar el movimiento individual;9;224;222;246;245;247;233;229;244;228;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;34;-1664,304;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;162;-1808,1152;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;64;-1856,752;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;-1760,1664;Inherit;False;Property;_Wind__WorldNoiseSpeedY;Wind__World Noise Speed Y;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;143;-1632,1152;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;39;-1664,416;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;245;-1760,1584;Inherit;False;Property;_Wind__WorldNoiseSpeedX;Wind__World Noise Speed X;13;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;65;-1824,864;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.VertexToFragmentNode;41;-1504,240;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;66;-1696,688;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-1680,1280;Inherit;False;Property;_Wind__NoiseAnimationScale;Wind__Noise Animation Scale;12;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;224;-1760,1824;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;165;-1376,1376;Inherit;False;Property;_Wind__NoiseFactor;Wind__Noise Factor;11;0;Create;True;0;0;0;False;0;False;2;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1296,336;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;247;-1472,1600;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;142;-1376,1152;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-1760,1744;Inherit;False;Property;_Wind__WorldNoiseScale;Wind__World Noise Scale;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1488,784;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;58;-1280,-640;Inherit;False;578.9652;777.8897;Base Color;6;2;19;77;45;3;138;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;54;-1136,368;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;228;-1280,1600;Inherit;False;WorldNoise;-1;;13;f17c4c9c155f92e4cb0e3f353a46552a;0;3;14;FLOAT2;0,0;False;13;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;244;-1280,1728;Inherit;False;Constant;_Wind__WorldNoiseLevels;Wind__World Noise Levels;18;0;Create;True;0;0;0;False;0;False;0.3,0.5,0,0.6;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-1120,1280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1296,480;Inherit;False;Property;_Light__Factor;Light__Factor;3;0;Create;True;0;0;0;False;0;False;0.3;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;68;-1328,816;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-1120,1152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;74;-1200,816;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-944,352;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;138;-1236,-588;Inherit;True;Property;_Leaves_AlphaLeaf;Leaves_Alpha Leaf;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;ea15a28edcab85b4ea2ae6e567ae9e09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-1232,-400;Inherit;False;Property;_Leaves__BaseColor;Leaves__BaseColor;0;0;Create;True;0;0;0;False;0;False;0.3019608,0.3019608,0.3019608,0;0.4627449,0.5450979,0.1803921,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;152;-960,1152;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;229;-960,1600;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1600,928;Inherit;False;Property;_Shadow__Factor;Shadow__Factor;6;0;Create;True;0;0;0;False;0;False;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;170;-672,1152;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;73;-720,352;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SaturateNode;233;-704,1600;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-896,-512;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;45;-1232,-224;Inherit;False;Property;_Light__Color;Light__Color;2;0;Create;True;0;0;0;False;0;False;0.6,0.6,0.6,0;0.7137255,0.8431372,0.2784313,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1024,816;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;291;128,912;Inherit;False;Property;_ProximityMask_SizeMax;ProximityMask_SizeMax;21;0;Create;True;0;0;0;False;0;False;0.1;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;282;128,720;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;287;128,832;Inherit;False;Property;_ProximityMask_SizeMin;ProximityMask_SizeMin;20;0;Create;True;0;0;0;False;0;False;-0.2;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;286;128,560;Inherit;False;Property;_ProximityMask__Size;ProximityMask__Size;19;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-896,-592;Inherit;False;BaseColorAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;232;-384,1152;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;290;384,720;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;76;-848,720;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;53;-393.9788,-140.2251;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;77;-1232,-48;Inherit;False;Property;_Shadow__Color;Shadow__Color;5;0;Create;True;0;0;0;False;0;False;0.1921569,0.1921569,0.1921569,0;0.207843,0.2431372,0.07843129,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;78;-172.4045,-63.01109;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;285;560,720;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;169;-48,1152;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DitheringNode;281;352,560;Inherit;False;0;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;128,640;Inherit;False;19;BaseColorAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;242;0,-64;Inherit;False;CloudsPattern;-1;;14;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.RegisterLocalVarNode;239;192,1152;Inherit;False;LocalVertexOffsetOutput;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;283;720,560;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;292;384,912;Inherit;False;Property;_ProximityMask__Factor;ProximityMask__Factor;29;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;-640,2336;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;271;-1248,2336;Inherit;False;270;BrnachesWindPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;258;-960,2176;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;273;-960,2336;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;280;960,544;Inherit;False;Property;_TranslucencyFactor;Translucency Factor;30;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;257;-2096,2176;Inherit;False;Property;_Wind__BranchSpeedMovement;Wind__Branch Speed Movement;18;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;253;-1616,2176;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;268;768,896;Inherit;False;239;LocalVertexOffsetOutput;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-1248,2464;Inherit;False;270;BrnachesWindPattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;278;-432,2304;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.VertexColorNode;266;-960,2656;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;262;-1888,2256;Inherit;False;Property;_Wind__BranchesIntencity;Wind__Branches Intencity;17;0;Create;True;0;0;0;False;0;False;0.05;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;275;-960,2496;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;263;-35.72061,1409.573;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;320,128;Inherit;False;BaseColorOutput;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;259;-1440,2176;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;277;-640,2496;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;256;-1792,2176;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;265;-1616,2256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1E-05;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;270;-1234.443,2172.166;Inherit;False;BrnachesWindPattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;279;-193.8205,1252.127;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;267;-640,2176;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;294;896,640;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1283.947,387.4701;Float;False;True;-1;4;ASEMaterialInspector;0;0;Standard;Lemu/Nature/StandardTree;False;False;False;False;False;False;False;False;False;False;False;False;True;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;16;22;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;1;Pragma;multi_compile __ LOD_FADE_CROSSFADE;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;216;0;215;0
WireConnection;212;0;216;0
WireConnection;210;0;212;0
WireConnection;213;0;210;0
WireConnection;214;0;213;0
WireConnection;199;0;164;0
WireConnection;199;1;237;0
WireConnection;199;2;214;0
WireConnection;161;0;199;0
WireConnection;33;0;32;0
WireConnection;33;1;37;0
WireConnection;217;0;161;0
WireConnection;63;0;60;0
WireConnection;63;1;61;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;162;0;217;0
WireConnection;64;0;63;0
WireConnection;64;1;62;0
WireConnection;143;1;162;0
WireConnection;41;0;34;0
WireConnection;66;0;64;0
WireConnection;38;0;34;0
WireConnection;38;1;39;0
WireConnection;38;2;41;0
WireConnection;247;0;245;0
WireConnection;247;1;246;0
WireConnection;142;0;143;0
WireConnection;142;1;144;0
WireConnection;67;0;64;0
WireConnection;67;1;65;0
WireConnection;67;2;66;0
WireConnection;54;0;38;0
WireConnection;228;14;247;0
WireConnection;228;13;222;0
WireConnection;228;2;224;0
WireConnection;190;0;165;0
WireConnection;68;0;67;0
WireConnection;189;0;142;0
WireConnection;74;0;68;0
WireConnection;55;0;54;0
WireConnection;55;1;56;0
WireConnection;152;0;189;0
WireConnection;152;4;190;0
WireConnection;229;0;228;0
WireConnection;229;1;244;1
WireConnection;229;2;244;2
WireConnection;229;3;244;3
WireConnection;229;4;244;4
WireConnection;170;0;152;0
WireConnection;170;1;152;0
WireConnection;170;2;152;0
WireConnection;73;0;55;0
WireConnection;233;0;229;0
WireConnection;2;0;138;0
WireConnection;2;1;3;0
WireConnection;69;0;74;0
WireConnection;69;1;70;0
WireConnection;19;0;138;4
WireConnection;232;0;170;0
WireConnection;232;2;233;0
WireConnection;290;0;282;0
WireConnection;290;3;287;0
WireConnection;290;4;291;0
WireConnection;76;0;69;0
WireConnection;53;0;2;0
WireConnection;53;1;45;0
WireConnection;53;2;73;3
WireConnection;78;0;53;0
WireConnection;78;1;77;0
WireConnection;78;2;76;3
WireConnection;285;0;290;0
WireConnection;169;0;232;0
WireConnection;281;0;286;0
WireConnection;242;21;78;0
WireConnection;239;0;169;0
WireConnection;283;0;281;0
WireConnection;283;1;20;0
WireConnection;283;2;285;0
WireConnection;276;0;273;0
WireConnection;276;1;266;2
WireConnection;258;0;270;0
WireConnection;258;1;270;0
WireConnection;273;1;271;0
WireConnection;273;2;271;0
WireConnection;253;0;256;0
WireConnection;278;0;267;0
WireConnection;278;1;276;0
WireConnection;278;2;277;0
WireConnection;275;0;274;0
WireConnection;275;2;274;0
WireConnection;263;0;278;0
WireConnection;21;0;242;0
WireConnection;259;0;253;0
WireConnection;259;4;265;0
WireConnection;277;0;275;0
WireConnection;277;1;266;3
WireConnection;256;0;257;0
WireConnection;265;0;262;0
WireConnection;270;0;259;0
WireConnection;279;1;278;0
WireConnection;267;0;258;0
WireConnection;267;1;266;1
WireConnection;294;0;20;0
WireConnection;294;1;283;0
WireConnection;294;2;292;0
WireConnection;0;0;21;0
WireConnection;0;7;280;0
WireConnection;0;10;294;0
WireConnection;0;11;268;0
ASEEND*/
//CHKSM=57F77DCCACF21E1169797E4BA4D5BF083B0AD84B