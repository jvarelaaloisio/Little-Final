// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Nature/MeshVegetation"
{
	Properties
	{
		[NoScaleOffset]_Leaves_AlphaLeaf("Leaves_Alpha Leaf", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_PrimaryColor("Primary Color", Color) = (0.3019608,0.3019608,0.3019608,0)
		_LightColor("Light Color", Color) = (0.6,0.6,0.6,0)
		_SecondaryColor("Secondary Color", Color) = (0.1921569,0.1921569,0.1921569,0)
		_ShowdSpots("ShowdSpots", Range( 0 , 1)) = 0
		_LocalVertexOffsetFactor("LocalVertexOffsetFactor", Float) = 1
		_Turbulence("Turbulence", Float) = 1
		_Speed("Speed", Float) = 0
		_Inflate("Inflate", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0

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
			float vertexToFrag532;
			float3 worldNormal;
			half ASEIsFrontFacing : VFACE;
			float2 uv_texcoord;
		};

		uniform float _Speed;
		uniform float _Turbulence;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _LocalVertexOffsetFactor;
		uniform float _Inflate;
		uniform float4 _PrimaryColor;
		uniform float4 _SecondaryColor;
		uniform float _ShowdSpots;
		uniform float4 _LightColor;
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


		void vertexDataFunc( inout appdata_full_custom v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_Speed).xx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 panner10_g39 = ( 1.0 * _Time.y * temp_cast_0 + ( ase_worldPos * _Turbulence ).xy);
			float simplePerlin2D11_g39 = snoise( panner10_g39 );
			simplePerlin2D11_g39 = simplePerlin2D11_g39*0.5 + 0.5;
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth550 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( ase_screenPosNorm.xy, 0, 0 ) ));
			float distanceDepth550 = saturate( abs( ( screenDepth550 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) ) );
			float lerpResult551 = lerp( 0.0 , simplePerlin2D11_g39 , distanceDepth550);
			float4 temp_cast_2 = (lerpResult551).xxxx;
			float4 transform169 = mul(unity_ObjectToWorld,temp_cast_2);
			float3 ase_vertexNormal = v.normal.xyz;
			float3 appendResult555 = (float3(ase_vertexNormal.x , ( ase_vertexNormal.y + _Inflate ) , ase_vertexNormal.z));
			float4 OUT_VertexOffset239 = ( ( transform169 * ( _LocalVertexOffsetFactor * 0.0001 ) ) * float4( appendResult555 , 0.0 ) );
			v.vertex.xyz += OUT_VertexOffset239.xyz;
			v.vertex.w = 1;
			uint currInstanceId = 0;
			#ifdef UNITY_INSTANCING_ENABLED
			currInstanceId = unity_InstanceID;
			#endif
			float2 temp_cast_5 = ( currInstanceId + v.ase_vertexId );
			float dotResult4_g32 = dot( temp_cast_5 , float2( 12.9898,78.233 ) );
			float lerpResult10_g32 = lerp( 0.0 , _ShowdSpots , frac( ( sin( dotResult4_g32 ) * 43758.55 ) ));
			float F_SafeRandomValue516 = lerpResult10_g32;
			o.vertexToFrag532 = F_SafeRandomValue516;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 VAR_LeavesBaseColor298 = _PrimaryColor;
			float4 VAR_LeavesShadowColor299 = _SecondaryColor;
			float4 lerpResult533 = lerp( VAR_LeavesBaseColor298 , VAR_LeavesShadowColor299 , i.vertexToFrag532);
			float4 OUT_BaseColor21 = lerpResult533;
			o.Albedo = OUT_BaseColor21.rgb;
			float4 VAR_LeavesLightColor297 = _LightColor;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV410 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode410 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV410, 5.0 ) );
			float4 OUT_Emissive529 = ( VAR_LeavesLightColor297 * saturate( ( fresnelNode410 * i.ASEIsFrontFacing ) ) );
			o.Emission = OUT_Emissive529.rgb;
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
				float3 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
				o.customPack1.x = customInputData.vertexToFrag532;
				o.customPack1.yz = customInputData.uv_texcoord;
				o.customPack1.yz = v.texcoord;
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
				surfIN.vertexToFrag532 = IN.customPack1.x;
				surfIN.uv_texcoord = IN.customPack1.yz;
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
Node;AmplifyShaderEditor.CommentaryNode;554;32,80;Inherit;False;2139.706;532.4937;;11;296;169;551;550;541;544;548;549;523;556;559;New VertexOffset;0,1,0,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;539;1024,-384;Inherit;False;934;349;;6;21;533;532;537;534;538;New Base Color;0,1,0,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;531;2432,256;Inherit;False;804.2864;609.3902;;6;268;322;280;530;307;409;Material;1,0.516874,0,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;528;32,-384;Inherit;False;963.2;389.1997;;7;529;412;413;414;434;433;410;New Scattering effect;0,1,0,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;308;-1596.207,-2386.036;Inherit;False;1994.516;802.1486;;8;439;370;417;525;526;423;422;524;Light and shadow basecolor blend;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;527;32,-768;Inherit;False;932.864;321.4091;;6;427;428;516;424;416;418;New Safe Random;0,1,0,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;526;-987.2068,-2323.036;Inherit;False;543.9999;292;Blend the shadow with the highlighted base color;3;78;306;302;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;525;-1563.207,-2323.036;Inherit;False;543;353;Blend the light with the base color;4;53;305;301;300;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;313;-192,1536;Inherit;False;1818.527;783.5115;;5;519;232;310;312;522;Blend Vertex Offset;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;523;1248,128;Inherit;False;874;290;Finally, the displacement was applied taking into consideration the normal ones, to avoid breakages.;5;239;555;440;441;295;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;522;-160,1600;Inherit;False;513;254;For individual random pos offset;3;520;521;517;;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;323;1742,1486;Inherit;False;1000;518;;11;285;281;291;286;282;290;287;292;20;283;294;Camera Proximity mask (DEV);1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;219;-3712,1152;Inherit;False;1601.374;353;;11;217;161;199;237;164;214;213;210;212;216;215;Wind Speed Base;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-2176,0;Inherit;False;1781.906;418.3855;;13;303;73;55;56;54;38;39;41;34;35;33;32;37;Light Mask (Para magnificar la luz en las copas);1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;59;-2176,448;Inherit;False;2082.369;452.445;;14;304;76;70;69;74;68;67;65;66;64;62;61;63;60;Shadow Mask (Para magnificar la sombras en las copas);1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;238;-2069.445,1109.133;Inherit;False;1783.682;397.6738;;10;311;170;152;190;189;165;142;144;143;162;Animacion individual;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;236;-2304,1664;Inherit;False;1765.223;416.9597;;8;309;229;244;228;224;222;326;327;Mascara para randomizar el movimiento individual;1,1,1,0.2;0;0
Node;AmplifyShaderEditor.CommentaryNode;58;-1024,-1024;Inherit;False;641.9652;736.8897;;8;299;77;297;45;298;3;19;138;Base Color Inputs;0,1,0,0.2;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;162;-1808,1152;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;143;-1632,1152;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;142;-1376,1152;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-1120,1152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-1120,1280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;152;-960,1152;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;311;-544,1152;Inherit;False;MASK_IndividualAnimation;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;285;2224,1696;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;281;2016,1536;Inherit;False;0;False;4;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;3;SAMPLERSTATE;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;291;1792,1888;Inherit;False;Property;_ProximityMask_SizeMax;ProximityMask_SizeMax;21;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;282;1792,1696;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;290;2048,1696;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;287;1792,1808;Inherit;False;Property;_ProximityMask_SizeMin;ProximityMask_SizeMin;20;0;Create;True;0;0;0;False;0;False;-0.2;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;1792,1616;Inherit;False;19;OUT_Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;283;2384,1536;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;-1376,1376;Inherit;False;Property;_Wind_NoiseFactor;Wind_Noise Factor;16;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-1680,1279;Inherit;False;Property;_Wind_NoiseAnimationScale;Wind_Noise Animation Scale;17;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;286;1792,1536;Inherit;False;Property;_ProximityMask_Size;ProximityMask_Size;19;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;292;2048,1888;Inherit;False;Property;_ProximityMask_Factor;ProximityMask_Factor;22;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;294;2560,1616;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;170;-742,1147;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;517;-128,1664;Inherit;False;516;F_SafeRandomValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;521;-128,1760;Inherit;False;Property;_RandomVertexOffset;RandomVertexOffset;23;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;520;160,1664;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;232;288,1920;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;519;448,1600;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;53;-1179.207,-2195.036;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;306;-955.2068,-2131.036;Inherit;False;304;MASK_ShadowMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;-635.207,-2211.036;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;418;480,-704;Inherit;False;Random Range;-1;;32;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexIdVariableNode;416;64,-640;Inherit;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;424;64,-544;Inherit;False;Property;_ShowdSpots;ShowdSpots;10;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;417;-379.207,-2035.036;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;370;-251.207,-2035.036;Inherit;False;CloudsPattern;-1;;33;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.SaturateNode;439;4.793022,-2035.036;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;410;64,-240;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FaceVariableNode;433;64,-80;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;434;320,-240;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;414;448,-240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;412;608,-304;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;138;-992,-960;Inherit;True;Property;_Leaves_AlphaLeaf;Leaves_Alpha Leaf;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;393745bdb00886c42810374665c9d89b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;37;-2144,224;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;32;-2144,64;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;33;-1888,64;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;34;-1728,128;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;41;-1568,64;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;39;-1728,240;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1360,160;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;54;-1200,192;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1008,176;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;73;-784,176;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;303;-640,176;Inherit;False;MASK_LightMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1920,288;Inherit;False;Property;_Light_MaskScale;Light_Mask Scale;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1360,304;Inherit;False;Property;_Light_Factor;Light_Factor;5;0;Create;True;0;0;0;False;0;False;0.3;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;60;-2144,512;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;63;-1888,512;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;61;-2144,672;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;62;-1888,672;Inherit;False;Property;_Shadow_MaskScale;Shadow_Mask Scale;9;0;Create;True;0;0;0;False;0;False;0.3;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;64;-1664,512;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;66;-1472,512;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;65;-1632,640;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1216,640;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;68;-1056,640;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;74;-896,640;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-736,640;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1056,736;Inherit;False;Property;_Shadow_Factor;Shadow_Factor;8;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;76;-576,544;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;304;-352,544;Inherit;False;MASK_ShadowMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-3680,1376;Inherit;False;Property;_Wind_BaseSpeed;Wind_Base Speed;13;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;212;-3296,1376;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;210;-3104,1376;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;213;-2976,1376;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-2848,1376;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-3040,1296;Inherit;False;Property;_Wind_SecondarySpeed;Wind_Secondary Speed;15;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;199;-2688,1216;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;161;-2528,1216;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;327;-2272,1728;Inherit;False;Property;_Wind_Direction;Wind_Direction;12;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;326;-1984,1728;Inherit;False;Direction2D;-1;;37;ac70dfc8e86cbbb48941a8d7b266955a;0;1;27;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;222;-1984,1824;Inherit;False;Property;_Wind_WorldNoiseScale;Wind_World Noise Scale;18;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;224;-1984,1920;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;228;-1568,1728;Inherit;False;WorldNoise;-1;;38;f17c4c9c155f92e4cb0e3f353a46552a;0;3;14;FLOAT2;0,0;False;13;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;244;-1568,1856;Inherit;False;Constant;_Wind_WorldNoiseLevels;Wind_World Noise Levels;18;0;Create;True;0;0;0;False;0;False;0.3,0.5,0,0.6;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;229;-1216,1728;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;309;-928,1728;Inherit;False;MASK_IndividualRandomAnimationMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;310;-128,2016;Inherit;False;309;MASK_IndividualRandomAnimationMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;312;-128,1920;Inherit;False;311;MASK_IndividualAnimation;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-1531.207,-2163.036;Inherit;False;297;VAR_LeavesLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;305;-1531.207,-2067.036;Inherit;False;303;MASK_LightMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;300;-1533.268,-2259.036;Inherit;False;298;VAR_LeavesBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;302;-955.2068,-2259.036;Inherit;False;299;VAR_LeavesShadowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;409;2944,416;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Nature/MeshVegetation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;280;2464,544;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;307;2464,320;Inherit;False;21;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;530;2464,416;Inherit;False;529;OUT_Emissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;322;2464,640;Inherit;False;19;OUT_Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;516;704,-704;Inherit;False;F_SafeRandomValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;533;1568,-320;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;268;2464,752;Inherit;False;239;OUT_VertexOffset;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;216;-3456,1376;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;217;-2352,1216;Inherit;False;WindSpeedBase;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-3040,1216;Inherit;False;Property;_Wind_PrimarySpeed;Wind_Primary Speed;14;0;Create;True;0;0;0;False;0;False;0.2;0.0002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;549;64,144;Inherit;False;Property;_Speed;Speed;25;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;548;64,240;Inherit;False;Property;_Turbulence;Turbulence;24;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;544;64,336;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;541;320,144;Inherit;False;WorldNoise;-1;;39;f17c4c9c155f92e4cb0e3f353a46552a;0;3;14;FLOAT2;0,0;False;13;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;551;608,144;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;295;1280,192;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;169;976,144;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;1728,-320;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;529;768,-304;Inherit;False;OUT_Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;413;64,-320;Inherit;False;297;VAR_LeavesLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;534;1056,-320;Inherit;False;298;VAR_LeavesBaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;537;1056,-226.6449;Inherit;False;299;VAR_LeavesShadowColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexToFragmentNode;532;1312,-128;Inherit;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;538;1056,-128;Inherit;False;516;F_SafeRandomValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;423;-666.9801,-1864.973;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;422;-826.9802,-1864.973;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;524;-1146.98,-1800.973;Inherit;False;297;VAR_LeavesLightColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;428;352,-704;Inherit;False;2;2;0;INT;0;False;1;INT;0;False;1;INT;0
Node;AmplifyShaderEditor.InstanceIdNode;427;64,-704;Inherit;False;False;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;298;-672,-768;Inherit;False;VAR_LeavesBaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;297;-672,-608;Inherit;False;VAR_LeavesLightColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;299;-672,-448;Inherit;False;VAR_LeavesShadowColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-672,-960;Inherit;False;OUT_Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;441;1712,192;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalVertexDataNode;440;1280,288;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;555;1568,256;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;557;1472,464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;239;1856,192;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;556;1280,480;Inherit;False;Property;_Inflate;Inflate;26;0;Create;True;0;0;0;False;0;False;0.1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;77;-992,-448;Inherit;False;Property;_SecondaryColor;Secondary Color;7;0;Create;True;0;0;0;False;0;False;0.1921569,0.1921569,0.1921569,0;0.07685804,0.2264151,0.06941967,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;45;-992,-608;Inherit;False;Property;_LightColor;Light Color;4;0;Create;True;0;0;0;False;0;False;0.6,0.6,0.6,0;0.8679245,0.8535555,0.1351015,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-993,-768;Inherit;False;Property;_PrimaryColor;Primary Color;3;0;Create;True;0;0;0;False;0;False;0.3019608,0.3019608,0.3019608,0;0.2863632,0.3490566,0.07738519,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;296;608,256;Inherit;False;Property;_LocalVertexOffsetFactor;LocalVertexOffsetFactor;11;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;559;976,288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.0001;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;550;320,256;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
WireConnection;162;0;217;0
WireConnection;143;1;162;0
WireConnection;142;0;143;0
WireConnection;142;1;144;0
WireConnection;189;0;142;0
WireConnection;190;0;165;0
WireConnection;152;0;189;0
WireConnection;152;4;190;0
WireConnection;311;0;170;0
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
WireConnection;170;0;152;0
WireConnection;170;1;152;0
WireConnection;170;2;152;0
WireConnection;520;0;517;0
WireConnection;520;1;521;0
WireConnection;232;0;312;0
WireConnection;232;2;310;0
WireConnection;519;0;520;0
WireConnection;519;1;232;0
WireConnection;53;0;300;0
WireConnection;53;1;301;0
WireConnection;53;2;305;0
WireConnection;78;0;53;0
WireConnection;78;1;302;0
WireConnection;78;2;306;0
WireConnection;418;1;428;0
WireConnection;418;3;424;0
WireConnection;417;1;78;0
WireConnection;370;21;417;0
WireConnection;439;0;370;0
WireConnection;434;0;410;0
WireConnection;434;1;433;0
WireConnection;414;0;434;0
WireConnection;412;0;413;0
WireConnection;412;1;414;0
WireConnection;33;0;32;0
WireConnection;33;1;37;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;41;0;34;0
WireConnection;38;0;34;0
WireConnection;38;1;39;0
WireConnection;38;2;41;0
WireConnection;54;0;38;0
WireConnection;55;0;54;0
WireConnection;55;1;56;0
WireConnection;73;0;55;0
WireConnection;303;0;73;3
WireConnection;63;0;60;0
WireConnection;63;1;61;0
WireConnection;64;0;63;0
WireConnection;64;1;62;0
WireConnection;66;0;64;0
WireConnection;67;0;64;0
WireConnection;67;1;65;0
WireConnection;67;2;66;0
WireConnection;68;0;67;0
WireConnection;74;0;68;0
WireConnection;69;0;74;0
WireConnection;69;1;70;0
WireConnection;76;0;69;0
WireConnection;304;0;76;3
WireConnection;212;0;216;0
WireConnection;210;0;212;0
WireConnection;213;0;210;0
WireConnection;214;0;213;0
WireConnection;199;0;164;0
WireConnection;199;1;237;0
WireConnection;199;2;214;0
WireConnection;161;0;199;0
WireConnection;326;27;327;0
WireConnection;228;14;326;0
WireConnection;228;13;222;0
WireConnection;228;2;224;0
WireConnection;229;0;228;0
WireConnection;229;1;244;1
WireConnection;229;2;244;2
WireConnection;229;3;244;3
WireConnection;229;4;244;4
WireConnection;309;0;229;0
WireConnection;409;0;307;0
WireConnection;409;2;530;0
WireConnection;409;4;280;0
WireConnection;409;10;322;0
WireConnection;409;11;268;0
WireConnection;516;0;418;0
WireConnection;533;0;534;0
WireConnection;533;1;537;0
WireConnection;533;2;532;0
WireConnection;216;0;215;0
WireConnection;217;0;161;0
WireConnection;541;14;549;0
WireConnection;541;13;548;0
WireConnection;541;2;544;0
WireConnection;551;1;541;0
WireConnection;551;2;550;0
WireConnection;295;0;169;0
WireConnection;295;1;559;0
WireConnection;169;0;551;0
WireConnection;21;0;533;0
WireConnection;529;0;412;0
WireConnection;532;0;538;0
WireConnection;423;0;422;0
WireConnection;422;0;524;0
WireConnection;428;0;427;0
WireConnection;428;1;416;0
WireConnection;298;0;3;0
WireConnection;297;0;45;0
WireConnection;299;0;77;0
WireConnection;19;0;138;4
WireConnection;441;0;295;0
WireConnection;441;1;555;0
WireConnection;555;0;440;1
WireConnection;555;1;557;0
WireConnection;555;2;440;3
WireConnection;557;0;440;2
WireConnection;557;1;556;0
WireConnection;239;0;441;0
WireConnection;559;0;296;0
ASEEND*/
//CHKSM=8F8899CDDB96483AD073AA4B1F467F9CF1D8A559