// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "StandarTreeURP"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Leaves__BaseColor("Leaves__BaseColor", Color) = (0.3019608,0.3019608,0.3019608,0)
		_Light__Color("Light__Color", Color) = (0.6,0.6,0.6,0)
		_Light__Factor("Light__Factor", Range( 0 , 1)) = 0.3
		_Light__MaskScale("Light__Mask Scale", Float) = 1
		_Shadow__Color("Shadow__Color", Color) = (0.1921569,0.1921569,0.1921569,0)
		_Shadow__Factor("Shadow__Factor", Range( 0 , 1)) = 1
		_Shadow__MaskScale("Shadow__Mask Scale", Float) = 0.3
		_LocalVertexOffsetFactor("LocalVertexOffsetFactor", Float) = 1
		_Wind__Direction("Wind__Direction", Range( 0 , 360)) = 0
		_Wind__BaseSpeed("Wind__Base Speed", Float) = 0
		_Wind__PrimarySpeed("Wind__Primary Speed", Float) = 0.2
		_Wind__SecondarySpeed("Wind__Secondary Speed", Float) = 0
		_Wind__NoiseFactor("Wind__Noise Factor", Float) = 2
		_Wind__NoiseAnimationScale("Wind__Noise Animation Scale", Float) = 0.3
		_Wind__WorldNoiseScale("Wind__World Noise Scale", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
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
			float vertexToFrag52;
			float vertexToFrag53;
			float2 uv_texcoord;
		};

		uniform float _Wind__PrimarySpeed;
		uniform float _Wind__SecondarySpeed;
		uniform float _Wind__BaseSpeed;
		uniform float _Wind__NoiseAnimationScale;
		uniform float _Wind__NoiseFactor;
		uniform float _Wind__Direction;
		uniform float _Wind__WorldNoiseScale;
		uniform float _LocalVertexOffsetFactor;
		uniform float4 _Leaves__BaseColor;
		uniform float4 _Light__Color;
		uniform float _Light__MaskScale;
		uniform float _Light__Factor;
		uniform float4 _Shadow__Color;
		uniform float _Shadow__MaskScale;
		uniform float _Shadow__Factor;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
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
			float mulTime22 = _Time.y * ( _Wind__BaseSpeed * 0.001 );
			float lerpResult28 = lerp( _Wind__PrimarySpeed , _Wind__SecondarySpeed , ( ( sin( mulTime22 ) + 1.0 ) * 0.5 ));
			float mulTime31 = _Time.y * lerpResult28;
			float WindSpeedBase89 = mulTime31;
			float2 appendResult42 = (float2(WindSpeedBase89 , 0.0));
			float2 uv_TexCoord45 = v.texcoord.xy + appendResult42;
			float simplePerlin2D47 = snoise( uv_TexCoord45*_Wind__NoiseAnimationScale );
			simplePerlin2D47 = simplePerlin2D47*0.5 + 0.5;
			float temp_output_62_0 = (0.0 + (( simplePerlin2D47 * 0.001 ) - 0.0) * (( _Wind__NoiseFactor * 0.001 ) - 0.0) / (1.0 - 0.0));
			float4 appendResult70 = (float4(temp_output_62_0 , temp_output_62_0 , temp_output_62_0 , 0.0));
			float4 MASK_IndividualAnimation97 = appendResult70;
			float VAR_AngleRotation25_g23 = _Wind__Direction;
			float2 appendResult12_g23 = (float2((0.0 + (VAR_AngleRotation25_g23 - 0.0) * (1.0 - 0.0) / (90.0 - 0.0)) , (1.0 + (VAR_AngleRotation25_g23 - 0.0) * (0.0 - 1.0) / (90.0 - 0.0))));
			float2 appendResult9_g23 = (float2((1.0 + (VAR_AngleRotation25_g23 - 90.1) * (0.0 - 1.0) / (180.0 - 90.1)) , (0.0 + (VAR_AngleRotation25_g23 - 90.1) * (-1.0 - 0.0) / (180.0 - 90.1))));
			float2 appendResult7_g23 = (float2((0.0 + (VAR_AngleRotation25_g23 - 180.1) * (-1.0 - 0.0) / (270.0 - 180.1)) , (-1.0 + (VAR_AngleRotation25_g23 - 180.1) * (0.0 - -1.0) / (270.0 - 180.1))));
			float2 appendResult4_g23 = (float2((-1.0 + (VAR_AngleRotation25_g23 - 270.1) * (0.0 - -1.0) / (360.0 - 270.1)) , (0.0 + (VAR_AngleRotation25_g23 - 270.1) * (1.0 - 0.0) / (360.0 - 270.1))));
			float2 normalizeResult2_g23 = normalize( (( VAR_AngleRotation25_g23 >= 0.0 && VAR_AngleRotation25_g23 <= 90.0 ) ? appendResult12_g23 :  (( VAR_AngleRotation25_g23 >= 90.1 && VAR_AngleRotation25_g23 <= 180.0 ) ? appendResult9_g23 :  (( VAR_AngleRotation25_g23 >= 180.1 && VAR_AngleRotation25_g23 <= 270.0 ) ? appendResult7_g23 :  (( VAR_AngleRotation25_g23 >= 270.1 && VAR_AngleRotation25_g23 <= 360.0 ) ? appendResult4_g23 :  float2( 0,0 ) ) ) ) ) );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 panner10_g18 = ( 1.0 * _Time.y * normalizeResult2_g23 + ( ase_worldPos * _Wind__WorldNoiseScale ).xy);
			float simplePerlin2D11_g18 = snoise( panner10_g18 );
			simplePerlin2D11_g18 = simplePerlin2D11_g18*0.5 + 0.5;
			float4 _Wind__WorldNoiseLevels = float4(0.3,0.5,0,0.6);
			float MASK_IndividualRandomAnimationMask90 = saturate( (_Wind__WorldNoiseLevels.z + (simplePerlin2D11_g18 - _Wind__WorldNoiseLevels.x) * (_Wind__WorldNoiseLevels.w - _Wind__WorldNoiseLevels.z) / (_Wind__WorldNoiseLevels.y - _Wind__WorldNoiseLevels.x)) );
			float4 lerpResult93 = lerp( MASK_IndividualAnimation97 , float4( 0,0,0,0 ) , MASK_IndividualRandomAnimationMask90);
			float4 transform94 = mul(unity_ObjectToWorld,lerpResult93);
			float4 OUT_VertexOffset113 = ( transform94 * _LocalVertexOffsetFactor );
			v.vertex.xyz += OUT_VertexOffset113.xyz;
			v.vertex.w = 1;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult38 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_43_0 = pow( dotResult38 , _Light__MaskScale );
			o.vertexToFrag52 = temp_output_43_0;
			float dotResult37 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_44_0 = pow( dotResult37 , _Shadow__MaskScale );
			o.vertexToFrag53 = temp_output_44_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 VAR_LeavesBaseColor79 = _Leaves__BaseColor;
			float4 VAR_LeavesLightColor80 = _Light__Color;
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult38 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_43_0 = pow( dotResult38 , _Light__MaskScale );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float MASK_LightMask100 = ( saturate( ( temp_output_43_0 * ase_lightColor * i.vertexToFrag52 ) ) * _Light__Factor ).a;
			float4 lerpResult85 = lerp( VAR_LeavesBaseColor79 , VAR_LeavesLightColor80 , MASK_LightMask100);
			float4 VAR_LeavesShadowColor81 = _Shadow__Color;
			float dotResult37 = dot( ase_worldNormal , ase_worldlightDir );
			float temp_output_44_0 = pow( dotResult37 , _Shadow__MaskScale );
			float MASK_ShadowMask99 = ( ( 1.0 - saturate( ( temp_output_44_0 * ase_lightColor * i.vertexToFrag53 ) ) ) * _Shadow__Factor ).a;
			float4 lerpResult88 = lerp( lerpResult85 , VAR_LeavesShadowColor81 , MASK_ShadowMask99);
			float4 temp_output_21_0_g28 = lerpResult88;
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
			float4 OUT_BaseColor118 = lerpResult24_g28;
			o.Albedo = OUT_BaseColor118.rgb;
			o.Alpha = 1;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			clip( tex2D( _TextureSample0, uv_TextureSample0 ).a - _Cutoff );
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
				o.customPack1.x = customInputData.vertexToFrag52;
				o.customPack1.y = customInputData.vertexToFrag53;
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
				surfIN.vertexToFrag52 = IN.customPack1.x;
				surfIN.vertexToFrag53 = IN.customPack1.y;
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
Node;AmplifyShaderEditor.CommentaryNode;16;-431.8279,836.4034;Inherit;False;1000;518;;11;111;110;109;108;107;106;105;104;103;102;101;Camera Proximity mask (DEV);1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;17;-2365.828,886.4034;Inherit;False;1319;323;;7;113;96;95;94;93;92;91;Blend Vertex Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;18;-2541.828,-1289.597;Inherit;False;1604.7;585.1;;9;119;118;88;87;86;85;84;83;82;Light and shadow basecolor blend;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;19;-5862.273,459.5364;Inherit;False;1571.374;342;;11;89;31;28;27;26;25;24;23;22;21;20;Wind Speed Base;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-5837.273,670.5364;Inherit;False;Property;_Wind__BaseSpeed;Wind__Base Speed;11;0;Create;True;0;0;0;False;0;False;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-5619.273,667.5364;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;22;-5491.273,667.5364;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;23;-5299.273,667.5364;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-5171.273,667.5364;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-5187.273,507.5364;Inherit;False;Property;_Wind__PrimarySpeed;Wind__Primary Speed;12;0;Create;True;0;0;0;False;0;False;0.2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-5043.273,667.5364;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-5187.273,587.5364;Inherit;False;Property;_Wind__SecondarySpeed;Wind__Secondary Speed;13;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;-4835.273,571.5365;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;29;-4301.828,-457.5967;Inherit;False;1781.906;418.3855;;13;100;74;73;66;65;60;54;52;43;40;38;35;32;Light Mask (Para magnificar la luz en las copas);1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-4493.828,-9.596686;Inherit;False;1927.619;418.3159;;14;99;98;75;71;68;64;58;53;51;44;41;37;34;33;Shadow Mask (Para magnificar la sombras en las copas);1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;31;-4691.273,587.5364;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;32;-4253.828,-249.5966;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;33;-4445.828,198.4033;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;34;-4445.828,38.40332;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;35;-4253.828,-409.5966;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;36;-4243.273,459.5364;Inherit;False;1783.682;397.6738;;10;97;70;62;59;55;49;47;46;45;42;Animacion individual;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;37;-4189.828,38.40332;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;38;-3997.828,-409.5966;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;39;-3966.686,890.0723;Inherit;False;1553.223;437.9597;;8;115;90;67;61;57;56;50;48;Mascara para randomizar el movimiento individual;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-4029.828,-185.5967;Inherit;False;Property;_Light__MaskScale;Light__Mask Scale;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-4237.828,262.4033;Inherit;False;Property;_Shadow__MaskScale;Shadow__Mask Scale;8;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;42;-3981.828,502.4034;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;43;-3837.828,-345.5966;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;44;-4029.828,102.4033;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-3805.828,502.4034;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;-3853.828,630.4034;Inherit;False;Property;_Wind__NoiseAnimationScale;Wind__Noise Animation Scale;15;0;Create;True;0;0;0;False;0;False;0.3;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;47;-3549.828,502.4034;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-3933.828,1094.403;Inherit;False;Property;_Wind__WorldNoiseScale;Wind__World Noise Scale;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-3549.828,726.4034;Inherit;False;Property;_Wind__NoiseFactor;Wind__Noise Factor;14;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;50;-3933.828,1174.403;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightColorNode;51;-3997.828,214.4033;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.VertexToFragmentNode;52;-3677.828,-409.5966;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;53;-3869.828,38.40332;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;54;-3837.828,-233.5966;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-3293.828,502.4034;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;56;-3453.828,950.4034;Inherit;False;WorldNoise;-1;;18;f17c4c9c155f92e4cb0e3f353a46552a;0;3;14;FLOAT2;0,0;False;13;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;57;-3453.828,1078.403;Inherit;False;Constant;_Wind__WorldNoiseLevels;Wind__World Noise Levels;18;0;Create;True;0;0;0;False;0;False;0.3,0.5,0,0.6;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-3661.828,134.4033;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-3293.828,630.4034;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-3469.828,-313.5966;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;61;-3133.828,950.4034;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;62;-3133.828,502.4034;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;63;-3453.828,-1289.597;Inherit;False;578.9652;777.8897;;8;114;81;80;79;77;76;72;69;Base Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;64;-3501.828,166.4033;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;65;-3309.828,-281.5966;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-3469.828,-169.5967;Inherit;False;Property;_Light__Factor;Light__Factor;4;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;67;-2877.828,950.4034;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;68;-3373.828,166.4033;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;69;-3405.828,-1049.597;Inherit;False;Property;_Leaves__BaseColor;Leaves__BaseColor;1;0;Create;True;0;0;0;False;0;False;0.3019608,0.3019608,0.3019608,0;0.1019603,0.3019603,0.2431367,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;70;-2845.828,502.4034;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-3773.828,278.4033;Inherit;False;Property;_Shadow__Factor;Shadow__Factor;7;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;72;-3409.828,-1237.597;Inherit;True;Property;_Leaves_AlphaLeaf;Leaves_Alpha Leaf;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;f89f6ec5b6b4e5f4d853c114c6920858;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-3117.828,-297.5966;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;74;-2893.828,-297.5966;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-3197.828,166.4033;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;76;-3405.828,-873.5966;Inherit;False;Property;_Light__Color;Light__Color;3;0;Create;True;0;0;0;False;0;False;0.6,0.6,0.6,0;0.1999995,0.6,0.4823529,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;77;-3405.828,-697.5966;Inherit;False;Property;_Shadow__Color;Shadow__Color;6;0;Create;True;0;0;0;False;0;False;0.1921569,0.1921569,0.1921569,0;0.06274473,0.1921564,0.1568623,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-3197.828,-1049.597;Inherit;False;VAR_LeavesBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;-3166.898,-875.7371;Inherit;False;VAR_LeavesLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-3165.828,-697.5966;Inherit;False;VAR_LeavesShadowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-2493.828,-1241.597;Inherit;False;79;VAR_LeavesBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-2493.828,-1145.597;Inherit;False;80;VAR_LeavesLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;-2493.828,-1049.597;Inherit;False;100;MASK_LightMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;85;-2189.828,-1161.597;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-2365.828,-857.5966;Inherit;False;99;MASK_ShadowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-2365.828,-937.5966;Inherit;False;81;VAR_LeavesShadowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;88;-1981.828,-1033.597;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-4531.273,587.5364;Inherit;False;WindSpeedBase;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-2749.828,950.4034;Inherit;False;MASK_IndividualRandomAnimationMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;-2317.828,934.4034;Inherit;False;97;MASK_IndividualAnimation;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-2317.828,1030.403;Inherit;False;90;MASK_IndividualRandomAnimationMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;93;-1933.828,950.4034;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;94;-1773.828,950.4034;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;95;-1773.828,1126.403;Inherit;False;Property;_LocalVertexOffsetFactor;LocalVertexOffsetFactor;9;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-1469.828,950.4034;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-2717.828,502.4034;Inherit;False;MASK_IndividualAnimation;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;98;-3023.362,70.40332;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-2813.828,70.40332;Inherit;False;MASK_ShadowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-2749.828,-297.5966;Inherit;False;MASK_LightMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;101;50.17209,1046.403;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;102;-157.8279,886.4034;Inherit;False;0;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-381.8279,1238.403;Inherit;False;Property;_ProximityMask_SizeMax;ProximityMask_SizeMax;19;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-381.8279,886.4034;Inherit;False;Property;_ProximityMask__Size;ProximityMask__Size;17;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;105;-381.8279,1046.403;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;106;-125.8279,1046.403;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-381.8279,1158.403;Inherit;False;Property;_ProximityMask_SizeMin;ProximityMask_SizeMin;18;0;Create;True;0;0;0;False;0;False;-0.2;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-125.8279,1238.403;Inherit;False;Property;_ProximityMask__Factor;ProximityMask__Factor;20;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-381.8279,966.4034;Inherit;False;114;OUT_Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;110;210.1721,886.4034;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;111;386.1721,966.4034;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-1309.828,950.4034;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-3069.828,-1241.597;Inherit;False;OUT_Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;115;-3837.828,950.4034;Inherit;False;Direction2D;-1;;23;ac70dfc8e86cbbb48941a8d7b266955a;0;1;27;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-4253.828,950.4034;Inherit;False;Property;_Wind__Direction;Wind__Direction;10;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-1302.328,-1045.297;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;119;-1771.128,-1124.597;Inherit;False;CloudsPattern;-1;;28;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.GetLocalVarNode;117;-896,-128;Inherit;False;118;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-896,-32;Inherit;False;114;OUT_Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-896,64;Inherit;False;113;OUT_VertexOffset;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;122;-963.5112,-346.7872;Inherit;True;Property;_TextureSample0;Texture Sample 0;21;0;Create;True;0;0;0;False;0;False;-1;None;f89f6ec5b6b4e5f4d853c114c6920858;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;123;-384,-128;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;StandarTreeURP;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;20;0
WireConnection;22;0;21;0
WireConnection;23;0;22;0
WireConnection;24;0;23;0
WireConnection;26;0;24;0
WireConnection;28;0;25;0
WireConnection;28;1;27;0
WireConnection;28;2;26;0
WireConnection;31;0;28;0
WireConnection;37;0;34;0
WireConnection;37;1;33;0
WireConnection;38;0;35;0
WireConnection;38;1;32;0
WireConnection;42;0;89;0
WireConnection;43;0;38;0
WireConnection;43;1;40;0
WireConnection;44;0;37;0
WireConnection;44;1;41;0
WireConnection;45;1;42;0
WireConnection;47;0;45;0
WireConnection;47;1;46;0
WireConnection;52;0;43;0
WireConnection;53;0;44;0
WireConnection;55;0;47;0
WireConnection;56;14;115;0
WireConnection;56;13;48;0
WireConnection;56;2;50;0
WireConnection;58;0;44;0
WireConnection;58;1;51;0
WireConnection;58;2;53;0
WireConnection;59;0;49;0
WireConnection;60;0;43;0
WireConnection;60;1;54;0
WireConnection;60;2;52;0
WireConnection;61;0;56;0
WireConnection;61;1;57;1
WireConnection;61;2;57;2
WireConnection;61;3;57;3
WireConnection;61;4;57;4
WireConnection;62;0;55;0
WireConnection;62;4;59;0
WireConnection;64;0;58;0
WireConnection;65;0;60;0
WireConnection;67;0;61;0
WireConnection;68;0;64;0
WireConnection;70;0;62;0
WireConnection;70;1;62;0
WireConnection;70;2;62;0
WireConnection;73;0;65;0
WireConnection;73;1;66;0
WireConnection;74;0;73;0
WireConnection;75;0;68;0
WireConnection;75;1;71;0
WireConnection;79;0;69;0
WireConnection;80;0;76;0
WireConnection;81;0;77;0
WireConnection;85;0;82;0
WireConnection;85;1;83;0
WireConnection;85;2;84;0
WireConnection;88;0;85;0
WireConnection;88;1;87;0
WireConnection;88;2;86;0
WireConnection;89;0;31;0
WireConnection;90;0;67;0
WireConnection;93;0;91;0
WireConnection;93;2;92;0
WireConnection;94;0;93;0
WireConnection;96;0;94;0
WireConnection;96;1;95;0
WireConnection;97;0;70;0
WireConnection;98;0;75;0
WireConnection;99;0;98;3
WireConnection;100;0;74;3
WireConnection;101;0;106;0
WireConnection;102;0;104;0
WireConnection;106;0;105;0
WireConnection;106;3;107;0
WireConnection;106;4;103;0
WireConnection;110;0;102;0
WireConnection;110;1;109;0
WireConnection;110;2;101;0
WireConnection;111;0;109;0
WireConnection;111;1;110;0
WireConnection;111;2;108;0
WireConnection;113;0;96;0
WireConnection;114;0;72;4
WireConnection;115;27;116;0
WireConnection;118;0;119;0
WireConnection;119;21;88;0
WireConnection;123;0;117;0
WireConnection;123;10;122;4
WireConnection;123;11;112;0
ASEEND*/
//CHKSM=E30703395CB6AC27827CFEFE19FFD176D6D1B7F3