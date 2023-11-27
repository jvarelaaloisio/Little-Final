// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Nature/StandardTree"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Leaves_BaseColor("Leaves_BaseColor", Color) = (0.3019608,0.3019608,0.3019608,0)
		[NoScaleOffset]_Leaves_AlphaLeaf("Leaves_Alpha Leaf", 2D) = "white" {}
		_Light_Color("Light_Color", Color) = (0.6,0.6,0.6,0)
		_Light_Factor("Light_Factor", Range( 0 , 1)) = 0.3
		_Light_MaskScale("Light_Mask Scale", Float) = 1
		_Shadow_Color("Shadow_Color", Color) = (0.1921569,0.1921569,0.1921569,0)
		_Shadow_Factor("Shadow_Factor", Range( 0 , 1)) = 1
		_Shadow_MaskScale("Shadow_Mask Scale", Float) = 0.3
		_LocalVertexOffsetFactor("LocalVertexOffsetFactor", Float) = 1
		_Wind_Direction("Wind_Direction", Range( 0 , 360)) = 0
		_Wind_BaseSpeed("Wind_Base Speed", Float) = 0
		_Wind_PrimarySpeed("Wind_Primary Speed", Float) = 0.2
		_Wind_SecondarySpeed("Wind_Secondary Speed", Float) = 0
		_Wind_NoiseFactor("Wind_Noise Factor", Float) = 2
		_Wind_NoiseAnimationScale("Wind_Noise Animation Scale", Float) = 0.3
		_Wind_WorldNoiseScale("Wind_World Noise Scale", Float) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float vertexToFrag41;
			float vertexToFrag66;
			float2 uv_texcoord;
		};

		uniform float _Wind_PrimarySpeed;
		uniform float _Wind_SecondarySpeed;
		uniform float _Wind_BaseSpeed;
		uniform float _Wind_NoiseAnimationScale;
		uniform float _Wind_NoiseFactor;
		uniform float _Wind_Direction;
		uniform float _Wind_WorldNoiseScale;
		uniform float _LocalVertexOffsetFactor;
		uniform float4 _Leaves_BaseColor;
		uniform float4 _Light_Color;
		uniform float _Light_MaskScale;
		uniform float _Light_Factor;
		uniform float4 _Shadow_Color;
		uniform float _Shadow_MaskScale;
		uniform float _Shadow_Factor;
		uniform float _Smoothness;
		uniform sampler2D _Leaves_AlphaLeaf;
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime212 = _Time.y * ( _Wind_BaseSpeed * 0.001 );
			float lerpResult199 = lerp( _Wind_PrimarySpeed , _Wind_SecondarySpeed , ( ( sin( mulTime212 ) + 1.0 ) * 0.5 ));
			float mulTime161 = _Time.y * lerpResult199;
			float WindSpeedBase217 = mulTime161;
			float2 appendResult162 = (float2(WindSpeedBase217 , 0.0));
			float2 uv_TexCoord143 = v.texcoord.xy + appendResult162;
			float simplePerlin2D142 = snoise( uv_TexCoord143*_Wind_NoiseAnimationScale );
			simplePerlin2D142 = simplePerlin2D142*0.5 + 0.5;
			float temp_output_152_0 = (0.0 + (( simplePerlin2D142 * 0.001 ) - 0.0) * (( _Wind_NoiseFactor * 0.001 ) - 0.0) / (1.0 - 0.0));
			float4 appendResult170 = (float4(temp_output_152_0 , temp_output_152_0 , temp_output_152_0 , 0.0));
			float4 MASK_IndividualAnimation311 = appendResult170;
			float VAR_AngleRotation25_g23 = _Wind_Direction;
			float2 appendResult12_g23 = (float2((0.0 + (VAR_AngleRotation25_g23 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g23 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
			float2 appendResult9_g23 = (float2((1.0 + (VAR_AngleRotation25_g23 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g23 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
			float2 appendResult7_g23 = (float2((0.0 + (VAR_AngleRotation25_g23 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g23 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
			float2 appendResult4_g23 = (float2((-1.0 + (VAR_AngleRotation25_g23 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g23 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
			float2 normalizeResult2_g23 = normalize( (( VAR_AngleRotation25_g23 >= 0.0 && VAR_AngleRotation25_g23 <= 90.0 ) ? appendResult12_g23 :  (( VAR_AngleRotation25_g23 >= 90.1 && VAR_AngleRotation25_g23 <= 180.0 ) ? appendResult9_g23 :  (( VAR_AngleRotation25_g23 >= 180.1 && VAR_AngleRotation25_g23 <= 270.0 ) ? appendResult7_g23 :  (( VAR_AngleRotation25_g23 >= 270.1 && VAR_AngleRotation25_g23 <= 360.0 ) ? appendResult4_g23 :  float2( 0,0 ) ) ) ) ) );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 panner10_g18 = ( 1.0 * _Time.y * normalizeResult2_g23 + ( ase_worldPos * _Wind_WorldNoiseScale ).xy);
			float simplePerlin2D11_g18 = snoise( panner10_g18 );
			simplePerlin2D11_g18 = simplePerlin2D11_g18*0.5 + 0.5;
			float4 _Wind_WorldNoiseLevels = float4(0.3,0.5,0,0.6);
			float MASK_IndividualRandomAnimationMask309 = saturate( (_Wind_WorldNoiseLevels.z + (simplePerlin2D11_g18 - _Wind_WorldNoiseLevels.x) * (_Wind_WorldNoiseLevels.w - _Wind_WorldNoiseLevels.z) / (_Wind_WorldNoiseLevels.y - _Wind_WorldNoiseLevels.x)) );
			float4 lerpResult232 = lerp( MASK_IndividualAnimation311 , float4( 0,0,0,0 ) , MASK_IndividualRandomAnimationMask309);
			float4 transform169 = mul(unity_ObjectToWorld,lerpResult232);
			float4 OUT_VertexOffset239 = ( transform169 * _LocalVertexOffsetFactor );
			v.vertex.xyz += OUT_VertexOffset239.xyz;
			v.vertex.w = 1;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult33 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_34_0 = pow( dotResult33 , _Light_MaskScale );
			o.vertexToFrag41 = temp_output_34_0;
			float dotResult63 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_64_0 = pow( dotResult63 , _Shadow_MaskScale );
			o.vertexToFrag66 = temp_output_64_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 VAR_LeavesBaseColor298 = _Leaves_BaseColor;
			float4 VAR_LeavesLightColor297 = _Light_Color;
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult33 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_34_0 = pow( dotResult33 , _Light_MaskScale );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float MASK_LightMask303 = ( saturate( ( temp_output_34_0 * ase_lightColor * i.vertexToFrag41 ) ) * _Light_Factor ).a;
			float4 lerpResult53 = lerp( VAR_LeavesBaseColor298 , VAR_LeavesLightColor297 , MASK_LightMask303);
			float4 VAR_LeavesShadowColor299 = _Shadow_Color;
			float dotResult63 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_64_0 = pow( dotResult63 , _Shadow_MaskScale );
			float MASK_ShadowMask304 = ( ( 1.0 - saturate( ( temp_output_64_0 * ase_lightColor * i.vertexToFrag66 ) ) ) * _Shadow_Factor ).a;
			float4 lerpResult78 = lerp( lerpResult53 , VAR_LeavesShadowColor299 , MASK_ShadowMask304);
			float4 temp_output_21_0_g28 = lerpResult78;
			float4 color20_g28 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_0 = (0.1).xx;
			float2 appendResult5_g28 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g28 = ( 0.01 * 1.5 );
			float2 panner10_g29 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult5_g28 * temp_output_2_0_g28 ));
			float simplePerlin2D11_g29 = snoise( panner10_g29 );
			simplePerlin2D11_g29 = simplePerlin2D11_g29*0.5 + 0.5;
			float temp_output_8_0_g28 = simplePerlin2D11_g29;
			float2 temp_cast_1 = (0.1).xx;
			float2 panner10_g31 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g28 * 0.01 ));
			float simplePerlin2D11_g31 = snoise( panner10_g31 );
			simplePerlin2D11_g31 = simplePerlin2D11_g31*0.5 + 0.5;
			float2 temp_cast_2 = (0.1).xx;
			float2 panner10_g30 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g28 * ( temp_output_2_0_g28 * 4.0 ) ));
			float simplePerlin2D11_g30 = snoise( panner10_g30 );
			simplePerlin2D11_g30 = simplePerlin2D11_g30*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g28 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g28 * simplePerlin2D11_g31 ) + ( 1.0 - simplePerlin2D11_g30 ) ) * temp_output_8_0_g28 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g28 = lerp( temp_output_21_0_g28 , saturate( ( temp_output_21_0_g28 * color20_g28 ) ) , ( temp_output_16_0_g28 * 1.0 ));
			float4 OUT_BaseColor21 = lerpResult24_g28;
			o.Albedo = saturate( OUT_BaseColor21 ).rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			float2 uv_Leaves_AlphaLeaf138 = i.uv_texcoord;
			float OUT_Opacity19 = tex2D( _Leaves_AlphaLeaf, uv_Leaves_AlphaLeaf138 ).a;
			clip( OUT_Opacity19 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.customPack1.x = customInputData.vertexToFrag41;
				o.customPack1.y = customInputData.vertexToFrag66;
				o.customPack1.zw = customInputData.uv_texcoord;
				o.customPack1.zw = v.texcoord;
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
				surfIN.vertexToFrag41 = IN.customPack1.x;
				surfIN.vertexToFrag66 = IN.customPack1.y;
				surfIN.uv_texcoord = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
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
Node;AmplifyShaderEditor.CommentaryNode;323;1742,1486;Inherit;False;1000;518;;11;285;281;291;286;282;290;287;292;20;283;294;Camera Proximity mask (DEV);1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;313;-192,1536;Inherit;False;1319;323;;7;239;295;296;169;232;310;312;Blend Vertex Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;308;-368,-640;Inherit;False;1604.7;585.1;;9;21;78;302;306;53;305;301;300;370;Light and shadow basecolor blend;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;219;-3688.445,1109.133;Inherit;False;1571.374;342;;11;215;237;164;217;161;199;214;213;210;212;216;Wind Speed Base;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-2128,192;Inherit;False;1781.906;418.3855;;13;303;73;55;56;54;38;39;41;34;35;33;32;37;Light Mask (Para magnificar la luz en las copas);1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;59;-2320,640;Inherit;False;1927.619;418.3159;;14;304;76;69;70;74;68;67;66;65;64;62;63;60;61;Shadow Mask (Para magnificar la sombras en las copas);1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;238;-2069.445,1109.133;Inherit;False;1783.682;397.6738;;10;311;170;152;190;189;165;142;144;143;162;Animacion individual;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;236;-1792.858,1539.669;Inherit;False;1553.223;437.9597;;8;309;233;229;244;228;224;222;326;Mascara para randomizar el movimiento individual;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;58;-1280,-640;Inherit;False;578.9652;777.8897;;8;19;77;45;3;138;297;298;299;Base Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;216;-3445.445,1317.133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;212;-3317.445,1317.133;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;210;-3125.445,1317.133;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;213;-2997.445,1317.133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-2869.445,1317.133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;199;-2661.445,1221.133;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;161;-2517.445,1237.133;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;37;-2080,400;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;61;-2272,848;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;60;-2272,688;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;32;-2080,240;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;63;-2016,688;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;33;-1824,240;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;162;-1808,1152;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;34;-1664,304;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;64;-1856,752;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;143;-1632,1152;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;142;-1376,1152;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;224;-1760,1824;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightColorNode;65;-1824,864;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.VertexToFragmentNode;41;-1504,240;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;66;-1696,688;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;39;-1664,416;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-1120,1152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;228;-1280,1600;Inherit;False;WorldNoise;-1;;18;f17c4c9c155f92e4cb0e3f353a46552a;0;3;14;FLOAT2;0,0;False;13;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1488,784;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-1120,1280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1296,336;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;229;-960,1600;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;152;-960,1152;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;68;-1328,816;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;54;-1136,368;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;233;-704,1600;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;74;-1200,816;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;170;-672,1152;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;138;-1236,-588;Inherit;True;Property;_Leaves_AlphaLeaf;Leaves_Alpha Leaf;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;ea15a28edcab85b4ea2ae6e567ae9e09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-944,352;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;73;-720,352;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1024,816;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;298;-1024,-400;Inherit;False;VAR_LeavesBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;297;-993.0703,-226.1405;Inherit;False;VAR_LeavesLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;299;-992,-48;Inherit;False;VAR_LeavesShadowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;53;-16,-512;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;78;192,-384;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;217;-2357.445,1237.133;Inherit;False;WindSpeedBase;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;309;-576,1600;Inherit;False;MASK_IndividualRandomAnimationMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;312;-144,1584;Inherit;False;311;MASK_IndividualAnimation;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;310;-144,1680;Inherit;False;309;MASK_IndividualRandomAnimationMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;232;240,1600;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;169;400,1600;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;296;400,1776;Inherit;False;Property;_LocalVertexOffsetFactor;LocalVertexOffsetFactor;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;704,1600;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;311;-544,1152;Inherit;False;MASK_IndividualAnimation;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;76;-849.5348,720;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;304;-640,720;Inherit;False;MASK_ShadowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;303;-576,352;Inherit;False;MASK_LightMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;285;2224,1696;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;281;2016,1536;Inherit;False;0;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;291;1792,1888;Inherit;False;Property;_ProximityMask_SizeMax;ProximityMask_SizeMax;19;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;282;1792,1696;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;290;2048,1696;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;287;1792,1808;Inherit;False;Property;_ProximityMask_SizeMin;ProximityMask_SizeMin;18;0;Create;True;0;0;0;False;0;False;-0.2;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;1792,1616;Inherit;False;19;OUT_Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;283;2384,1536;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;294;2560,1616;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;239;864,1600;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-896,-592;Inherit;False;OUT_Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;326;-1664,1600;Inherit;False;Direction2D;-1;;23;ac70dfc8e86cbbb48941a8d7b266955a;0;1;27;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;871.5001,-395.7;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;370;402.6998,-474.9997;Inherit;False;CloudsPattern;-1;;28;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.RangedFloatNode;280;960,480;Inherit;False;Property;_Smoothness;Smoothness;21;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;322;960,576;Inherit;False;19;OUT_Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;268;960,672;Inherit;False;239;OUT_VertexOffset;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;307;960,384;Inherit;False;21;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;300;-320,-592;Inherit;False;298;VAR_LeavesBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-320,-496;Inherit;False;297;VAR_LeavesLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;305;-321.6799,-398.3201;Inherit;False;303;MASK_LightMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;302;-192,-288;Inherit;False;299;VAR_LeavesShadowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;306;-192,-208;Inherit;False;304;MASK_ShadowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;407;1184,384;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;409;1536,384;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Nature/StandardTree;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ColorNode;45;-1232,-224;Inherit;False;Property;_Light_Color;Light_Color;3;0;Create;True;0;0;0;False;0;False;0.6,0.6,0.6,0;0.6,0.6,0.6,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-1232,-400;Inherit;False;Property;_Leaves_BaseColor;Leaves_BaseColor;1;0;Create;True;0;0;0;False;0;False;0.3019608,0.3019608,0.3019608,0;0.3019607,0.3019607,0.3019607,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;77;-1232,-48;Inherit;False;Property;_Shadow_Color;Shadow_Color;6;0;Create;True;0;0;0;False;0;False;0.1921569,0.1921569,0.1921569,0;0.1921568,0.1921568,0.1921568,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-1856,464;Inherit;False;Property;_Light_MaskScale;Light_Mask Scale;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1296,480;Inherit;False;Property;_Light_Factor;Light_Factor;4;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1600,927;Inherit;False;Property;_Shadow_Factor;Shadow_Factor;7;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2064,912;Inherit;False;Property;_Shadow_MaskScale;Shadow_Mask Scale;8;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;327;-2081,1600;Inherit;False;Property;_Wind_Direction;Wind_Direction;10;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-1760,1744;Inherit;False;Property;_Wind_WorldNoiseScale;Wind_World Noise Scale;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;244;-1280,1727;Inherit;False;Constant;_Wind_WorldNoiseLevels;Wind_World Noise Levels;18;0;Create;True;0;0;0;False;0;False;0.3,0.5,0,0.6;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;215;-3663.445,1320.133;Inherit;False;Property;_Wind_BaseSpeed;Wind_Base Speed;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-3013.445,1157.133;Inherit;False;Property;_Wind_PrimarySpeed;Wind_Primary Speed;12;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-3013.445,1237.133;Inherit;False;Property;_Wind_SecondarySpeed;Wind_Secondary Speed;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;-1376,1376;Inherit;False;Property;_Wind_NoiseFactor;Wind_Noise Factor;14;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-1680,1279;Inherit;False;Property;_Wind_NoiseAnimationScale;Wind_Noise Animation Scale;15;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;286;1792,1536;Inherit;False;Property;_ProximityMask_Size;ProximityMask_Size;17;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;292;2048,1888;Inherit;False;Property;_ProximityMask_Factor;ProximityMask_Factor;20;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
WireConnection;216;0;215;0
WireConnection;212;0;216;0
WireConnection;210;0;212;0
WireConnection;213;0;210;0
WireConnection;214;0;213;0
WireConnection;199;0;164;0
WireConnection;199;1;237;0
WireConnection;199;2;214;0
WireConnection;161;0;199;0
WireConnection;63;0;60;0
WireConnection;63;1;61;0
WireConnection;33;0;32;0
WireConnection;33;1;37;0
WireConnection;162;0;217;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;64;0;63;0
WireConnection;64;1;62;0
WireConnection;143;1;162;0
WireConnection;142;0;143;0
WireConnection;142;1;144;0
WireConnection;41;0;34;0
WireConnection;66;0;64;0
WireConnection;189;0;142;0
WireConnection;228;14;326;0
WireConnection;228;13;222;0
WireConnection;228;2;224;0
WireConnection;67;0;64;0
WireConnection;67;1;65;0
WireConnection;67;2;66;0
WireConnection;190;0;165;0
WireConnection;38;0;34;0
WireConnection;38;1;39;0
WireConnection;38;2;41;0
WireConnection;229;0;228;0
WireConnection;229;1;244;1
WireConnection;229;2;244;2
WireConnection;229;3;244;3
WireConnection;229;4;244;4
WireConnection;152;0;189;0
WireConnection;152;4;190;0
WireConnection;68;0;67;0
WireConnection;54;0;38;0
WireConnection;233;0;229;0
WireConnection;74;0;68;0
WireConnection;170;0;152;0
WireConnection;170;1;152;0
WireConnection;170;2;152;0
WireConnection;55;0;54;0
WireConnection;55;1;56;0
WireConnection;73;0;55;0
WireConnection;69;0;74;0
WireConnection;69;1;70;0
WireConnection;298;0;3;0
WireConnection;297;0;45;0
WireConnection;299;0;77;0
WireConnection;53;0;300;0
WireConnection;53;1;301;0
WireConnection;53;2;305;0
WireConnection;78;0;53;0
WireConnection;78;1;302;0
WireConnection;78;2;306;0
WireConnection;217;0;161;0
WireConnection;309;0;233;0
WireConnection;232;0;312;0
WireConnection;232;2;310;0
WireConnection;169;0;232;0
WireConnection;295;0;169;0
WireConnection;295;1;296;0
WireConnection;311;0;170;0
WireConnection;76;0;69;0
WireConnection;304;0;76;3
WireConnection;303;0;73;3
WireConnection;285;0;290;0
WireConnection;281;0;286;0
WireConnection;290;0;282;0
WireConnection;290;3;287;0
WireConnection;290;4;291;0
WireConnection;283;0;281;0
WireConnection;283;1;20;0
WireConnection;283;2;285;0
WireConnection;294;0;20;0
WireConnection;294;1;283;0
WireConnection;294;2;292;0
WireConnection;239;0;295;0
WireConnection;19;0;138;4
WireConnection;326;27;327;0
WireConnection;21;0;370;0
WireConnection;370;21;78;0
WireConnection;407;0;307;0
WireConnection;409;0;407;0
WireConnection;409;4;280;0
WireConnection;409;10;322;0
WireConnection;409;11;268;0
ASEEND*/
//CHKSM=292BD1B6EED104B0BA322DC206CADEAB1FE6AEDD