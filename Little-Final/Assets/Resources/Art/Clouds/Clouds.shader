// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Clouds"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 3
		_Color2("Color 2", Color) = (1,1,1,0)
		_Color1("Color 1", Color) = (0,0,0,0)
		_SmoothMax("Smooth Max", Float) = 1
		_SmoothMin("Smooth Min", Float) = 0
		_Power("Power", Float) = 1
		_BaseStrength("Base Strength", Float) = 1
		_ScaleNoise("ScaleNoise", Float) = 5
		_BaseStrenght("Base Strenght", Float) = 0
		_LevelDetails("Level Details", Vector) = (0,1,-1,1)
		_EmissiveIntensiti("Emissive Intensiti", Float) = 0
		_CurvatureRadius("Curvature Radius", Float) = 0
		_FresnelPower("Fresnel Power", Float) = 1.69
		_Speed("Speed", Float) = 0.5
		_FadeDepth("Fade Depth", Float) = 100
		_FresnelOpacity("Fresnel Opacity", Float) = 1.41
		_BaseSpeed("Base Speed", Float) = 0.5
		_Height("Height", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
			float4 screenPos;
		};

		uniform float _CurvatureRadius;
		uniform float _SmoothMin;
		uniform float _SmoothMax;
		uniform float _Speed;
		uniform float _ScaleNoise;
		uniform float _Power;
		uniform float4 _LevelDetails;
		uniform float _BaseSpeed;
		uniform float _BaseStrength;
		uniform float _BaseStrenght;
		uniform float _Height;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float _FresnelPower;
		uniform float _FresnelOpacity;
		uniform float _EmissiveIntensiti;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FadeDepth;
		uniform float _EdgeLength;


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 objToWorld70 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_vertexNormal = v.normal.xyz;
			float mulTime4 = _Time.y * _Speed;
			float2 temp_cast_0 = (mulTime4).xx;
			float2 uv_TexCoord2 = v.texcoord.xy + temp_cast_0;
			float simplePerlin2D1 = snoise( uv_TexCoord2*_ScaleNoise );
			simplePerlin2D1 = simplePerlin2D1*0.5 + 0.5;
			float simplePerlin2D20 = snoise( v.texcoord.xy*_ScaleNoise );
			simplePerlin2D20 = simplePerlin2D20*0.5 + 0.5;
			float smoothstepResult33 = smoothstep( _SmoothMin , _SmoothMax , abs( (_LevelDetails.z + (pow( saturate( ( ( simplePerlin2D1 + simplePerlin2D20 ) / 2.0 ) ) , _Power ) - _LevelDetails.x) * (_LevelDetails.w - _LevelDetails.z) / (_LevelDetails.y - _LevelDetails.x)) ));
			float mulTime47 = _Time.y * _BaseSpeed;
			float2 temp_cast_1 = (mulTime47).xx;
			float2 uv_TexCoord44 = v.texcoord.xy + temp_cast_1;
			float simplePerlin2D43 = snoise( uv_TexCoord44*_BaseStrength );
			simplePerlin2D43 = simplePerlin2D43*0.5 + 0.5;
			float temp_output_51_0 = ( ( smoothstepResult33 + ( simplePerlin2D43 * _BaseStrenght ) ) / ( 1.0 + _BaseStrenght ) );
			v.vertex.xyz += ( ( ase_worldNormal * pow( ( distance( objToWorld70 , ase_worldPos ) / _CurvatureRadius ) , 2.0 ) ) + ( ase_vertex3Pos + ( ( ase_vertexNormal * temp_output_51_0 ) * _Height ) ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime4 = _Time.y * _Speed;
			float2 temp_cast_0 = (mulTime4).xx;
			float2 uv_TexCoord2 = i.uv_texcoord + temp_cast_0;
			float simplePerlin2D1 = snoise( uv_TexCoord2*_ScaleNoise );
			simplePerlin2D1 = simplePerlin2D1*0.5 + 0.5;
			float simplePerlin2D20 = snoise( i.uv_texcoord*_ScaleNoise );
			simplePerlin2D20 = simplePerlin2D20*0.5 + 0.5;
			float smoothstepResult33 = smoothstep( _SmoothMin , _SmoothMax , abs( (_LevelDetails.z + (pow( saturate( ( ( simplePerlin2D1 + simplePerlin2D20 ) / 2.0 ) ) , _Power ) - _LevelDetails.x) * (_LevelDetails.w - _LevelDetails.z) / (_LevelDetails.y - _LevelDetails.x)) ));
			float mulTime47 = _Time.y * _BaseSpeed;
			float2 temp_cast_1 = (mulTime47).xx;
			float2 uv_TexCoord44 = i.uv_texcoord + temp_cast_1;
			float simplePerlin2D43 = snoise( uv_TexCoord44*_BaseStrength );
			simplePerlin2D43 = simplePerlin2D43*0.5 + 0.5;
			float temp_output_51_0 = ( ( smoothstepResult33 + ( simplePerlin2D43 * _BaseStrenght ) ) / ( 1.0 + _BaseStrenght ) );
			float4 lerpResult29 = lerp( _Color1 , _Color2 , temp_output_51_0);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV72 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode72 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV72, _FresnelPower ) );
			float4 temp_output_76_0 = ( lerpResult29 + ( temp_output_51_0 * fresnelNode72 * _FresnelOpacity ) );
			o.Albedo = temp_output_76_0.rgb;
			o.Emission = ( temp_output_76_0 * _EmissiveIntensiti ).rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth78 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth78 = abs( ( screenDepth78 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			o.Alpha = saturate( ( ( distanceDepth78 - ( 1.0 - ase_screenPosNorm.w ) ) / _FadeDepth ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
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
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
Version=17800
255;73;1004;746;-400.7553;1062.924;4.195237;True;False
Node;AmplifyShaderEditor.CommentaryNode;41;-2069.149,-183.2154;Inherit;False;1287.283;527.9326;Cloud Details (Noise);10;4;5;40;23;22;1;20;21;2;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2053.761,-87.02549;Inherit;False;Property;_Speed;Speed;17;0;Create;True;0;0;False;0;0.5;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-1903.833,-81.40042;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1733.69,87.39472;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1736.362,-127.5135;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-1736.342,0.2308359;Inherit;False;Property;_ScaleNoise;ScaleNoise;11;0;Create;True;0;0;False;0;5;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-1484.181,82.29523;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;-1475.032,-131.659;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1286.885,-131.6623;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;52;-1062.311,423.0538;Inherit;False;1371.266;389.3627;Base Clouds (Big);7;46;47;45;44;50;43;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-761.3327,-180.0356;Inherit;False;1046.035;547.4192;Cloud Details Mod (Noise);8;24;36;25;35;33;38;37;56;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;23;-1162.858,-133.2154;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;40;-950.0455,-128.3528;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-711.3327,-59.02339;Inherit;False;Property;_Power;Power;9;0;Create;True;0;0;False;0;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1012.311,618.7509;Inherit;False;Property;_BaseSpeed;Base Speed;20;0;Create;True;0;0;False;0;0.5;0.015;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;47;-862.3829,623.376;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;37;-574.4667,-130.0355;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;56;-673.7423,72.70673;Inherit;False;Property;_LevelDetails;Level Details;13;0;Create;True;0;0;False;0;0,1,-1,1;0,1,-1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-616.4136,473.0538;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;24;-384.6485,86.39275;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-559.351,626.6402;Inherit;False;Property;_BaseStrength;Base Strength;10;0;Create;True;0;0;False;0;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-133.5904,155.3266;Inherit;False;Property;_SmoothMin;Smooth Min;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-362.5515,627.2607;Inherit;False;Property;_BaseStrenght;Base Strenght;12;0;Create;True;0;0;False;0;0;3.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-134.5904,232.3266;Inherit;False;Property;_SmoothMax;Smooth Max;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;25;-138.9127,85.90633;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;43;-369.6992,478.5349;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;33;95.7026,82.3173;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;77.01672,518.7872;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;71;67.79733,-989.6848;Inherit;False;1341.506;611.8538;Bowl Curvature;8;70;62;69;63;68;61;67;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;591.0165,353.2583;Inherit;False;521.4391;427.7033;Convine Clouds;3;51;54;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;62;133.8938,-596.6241;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;54;681.0419,645.9616;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;77;882.9598,977.0172;Inherit;False;1153.998;429.171;Fresnel;5;75;73;72;74;76;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TransformPositionNode;70;117.7972,-778.3503;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;85;1067.374,1460.27;Inherit;False;971.5798;377.8616;DepthFade;8;82;83;84;81;80;86;78;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;19;715.6355,-312.693;Inherit;False;689.9073;402.8972;Vertext Offset;6;12;13;18;9;8;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;641.0164,403.2583;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;1125.431,355.3244;Inherit;False;632.8163;426.4497;Color;3;29;31;30;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;86;1258.117,1654.905;Inherit;False;Constant;_Float0;Float 0;18;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;898.4979,1182.841;Inherit;False;Property;_FresnelPower;Fresnel Power;16;0;Create;True;0;0;False;0;1.69;1.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;8;728.2346,-85.02771;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;79;1085.542,1657.886;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;465.6478,-493.831;Inherit;False;Property;_CurvatureRadius;Curvature Radius;15;0;Create;True;0;0;False;0;0;90;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;877.4556,502.7745;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;63;446.4344,-721.6283;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;983.6741,-83.77911;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DepthFade;78;1083.067,1506.597;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;68;709.0775,-681.3008;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;1176.157,405.3245;Inherit;False;Property;_Color1;Color 1;6;0;Create;True;0;0;False;0;0,0,0,0;0.6773763,0.787846,0.8113207,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;982.2416,15.84955;Inherit;False;Property;_Height;Height;21;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;80;1407.387,1654.168;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;72;1083.274,1081.961;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;1360.87,1147.744;Inherit;False;Property;_FresnelOpacity;Fresnel Opacity;19;0;Create;True;0;0;False;0;1.41;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;1175.431,582.8984;Inherit;False;Property;_Color2;Color 2;5;0;Create;True;0;0;False;0;1,1,1,0;0.9103774,0.9910377,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;1545.29,1052.714;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;61;418.4326,-939.6848;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;60;2069.931,1103.634;Inherit;False;462;298.2347;Emissive;2;59;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;1156.572,-43.03791;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;67;815.4348,-621.1819;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;1458.374,537.1431;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;11;728.1466,-269.5093;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;84;1600.833,1718.73;Inherit;False;Property;_FadeDepth;Fade Depth;18;0;Create;True;0;0;False;0;100;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;81;1549.793,1504.649;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;83;1787.595,1587.058;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;2106.931,1273.869;Inherit;False;Property;_EmissiveIntensiti;Emissive Intensiti;14;0;Create;True;0;0;False;0;0;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;1174.303,-752.6284;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;1293.64,-68.51392;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;1790.47,1052.289;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;2316.249,1159.634;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;1611.057,-391.7674;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;82;1909.767,1587.422;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3165.306,791.5595;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Clouds;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;3;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;5;0
WireConnection;2;1;4;0
WireConnection;20;0;21;0
WireConnection;20;1;3;0
WireConnection;1;0;2;0
WireConnection;1;1;3;0
WireConnection;22;0;1;0
WireConnection;22;1;20;0
WireConnection;23;0;22;0
WireConnection;40;0;23;0
WireConnection;47;0;46;0
WireConnection;37;0;40;0
WireConnection;37;1;38;0
WireConnection;44;1;47;0
WireConnection;24;0;37;0
WireConnection;24;1;56;1
WireConnection;24;2;56;2
WireConnection;24;3;56;3
WireConnection;24;4;56;4
WireConnection;25;0;24;0
WireConnection;43;0;44;0
WireConnection;43;1;45;0
WireConnection;33;0;25;0
WireConnection;33;1;35;0
WireConnection;33;2;36;0
WireConnection;49;0;43;0
WireConnection;49;1;50;0
WireConnection;54;1;50;0
WireConnection;48;0;33;0
WireConnection;48;1;49;0
WireConnection;51;0;48;0
WireConnection;51;1;54;0
WireConnection;63;0;70;0
WireConnection;63;1;62;0
WireConnection;9;0;8;0
WireConnection;9;1;51;0
WireConnection;68;0;63;0
WireConnection;68;1;69;0
WireConnection;80;0;86;0
WireConnection;80;1;79;4
WireConnection;72;3;74;0
WireConnection;73;0;51;0
WireConnection;73;1;72;0
WireConnection;73;2;75;0
WireConnection;13;0;9;0
WireConnection;13;1;18;0
WireConnection;67;0;68;0
WireConnection;29;0;30;0
WireConnection;29;1;31;0
WireConnection;29;2;51;0
WireConnection;81;0;78;0
WireConnection;81;1;80;0
WireConnection;83;0;81;0
WireConnection;83;1;84;0
WireConnection;65;0;61;0
WireConnection;65;1;67;0
WireConnection;12;0;11;0
WireConnection;12;1;13;0
WireConnection;76;0;29;0
WireConnection;76;1;73;0
WireConnection;57;0;76;0
WireConnection;57;1;59;0
WireConnection;66;0;65;0
WireConnection;66;1;12;0
WireConnection;82;0;83;0
WireConnection;0;0;76;0
WireConnection;0;2;57;0
WireConnection;0;9;82;0
WireConnection;0;11;66;0
ASEEND*/
//CHKSM=A06B91A6939A74280C5FCE0D9AE19934EEC8862E