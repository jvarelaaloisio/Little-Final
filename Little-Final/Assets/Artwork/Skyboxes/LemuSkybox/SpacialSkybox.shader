// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpacialSkybox"
{
	Properties
	{
		_SpaceColor("Space Color", Color) = (0,0.007317648,0.02,0)
		[NoScaleOffset]_SpacePattern("Space Pattern", 2D) = "white" {}
		_SpaceScale("Space Scale", Float) = 0
		_StartsScale("Starts Scale", Float) = 0
		_StarsFactorSmall("Stars Factor Small", Float) = 0.01
		_StartFactprBig("Start Factpr Big", Float) = 0
		_BigStartsMaskFactor("BigStarts Mask Factor", Float) = 0
		_StartsAnimationSpeed("Starts Animation Speed", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 viewDir;
		};

		uniform float4 _SpaceColor;
		uniform float _SpaceScale;
		uniform sampler2D _SpacePattern;
		uniform float _StartsScale;
		uniform float _StarsFactorSmall;
		uniform float _StartsAnimationSpeed;
		uniform float _StartFactprBig;
		uniform float _BigStartsMaskFactor;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float VAR_BackgroundScale44 = _SpaceScale;
			float simplePerlin2D15 = snoise( i.viewDir.xy*VAR_BackgroundScale44 );
			simplePerlin2D15 = simplePerlin2D15*0.5 + 0.5;
			float4 tex2DNode17 = tex2D( _SpacePattern, ( VAR_BackgroundScale44 * i.viewDir ).xy );
			float4 VAR_SpcaeBackground62 = ( _SpaceColor * ( simplePerlin2D15 * tex2DNode17.r ) );
			float simplePerlin2D23 = snoise( i.viewDir.xy*_StartsScale );
			simplePerlin2D23 = simplePerlin2D23*0.5 + 0.5;
			float VAR_StarsSmall50 = step( simplePerlin2D23 , _StarsFactorSmall );
			float mulTime69 = _Time.y * _StartsAnimationSpeed;
			float VAR_AnimationSteps76 = ( ( sin( mulTime69 ) + 1.0 ) * 0.5 );
			float grayscale48 = Luminance(tex2DNode17.rgb);
			float VAR_SpacePattern47 = grayscale48;
			float lerpResult34 = lerp( 0.0 , step( simplePerlin2D23 , (0.1 + (VAR_AnimationSteps76 - 0.0) * (_StartFactprBig - 0.1) / (1.0 - 0.0)) ) , saturate( (_BigStartsMaskFactor + (VAR_SpacePattern47 - 0.0) * (1.0 - _BigStartsMaskFactor) / (1.0 - 0.0)) ));
			float VAR_StarsBig52 = lerpResult34;
			float4 OUT_Emissive64 = saturate( ( VAR_SpcaeBackground62 + VAR_StarsSmall50 + VAR_StarsBig52 ) );
			o.Emission = OUT_Emissive64.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
				float3 worldPos : TEXCOORD1;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Node;AmplifyShaderEditor.CommentaryNode;80;-2352,624;Inherit;False;1145;185;;6;73;74;69;70;71;76;Animation Steps;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;68;-1520,-1008;Inherit;False;523;166;;2;14;44;Scale control;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;61;-2354,-610;Inherit;False;1526.42;709.5267;;13;62;47;21;20;18;15;45;1;48;17;19;42;46;Space Background;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;42;-2304,-80;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2032,-160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;56;-2352,160;Inherit;False;2049.105;407.2096;;20;60;32;58;38;52;34;36;35;49;50;27;28;33;23;24;43;77;75;78;79;Generate Starts;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCGrayscale;48;-1440,-48;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;43;-2304,208;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1216,-48;Inherit;False;VAR_SpacePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;23;-2080,208;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1;-2304,-384;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;49;-1408,288;Inherit;False;47;VAR_SpacePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-2304,-240;Inherit;False;44;VAR_BackgroundScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;32;-1312,448;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;35;-1072,208;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1440,-272;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;38;-864,352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;58;-736,432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;27;-1536,208;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1200,-384;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;34;-656,304;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-496,304;Inherit;False;VAR_StarsBig;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-1072,-384;Inherit;False;VAR_SpcaeBackground;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;66;-2352,-1008;Inherit;False;818;326;;6;63;51;53;29;16;64;Blend Starts and backgrounds;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-1408,208;Inherit;False;VAR_StarsSmall;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-2304,-800;Inherit;False;52;VAR_StarsBig;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-2304,-880;Inherit;False;50;VAR_StarsSmall;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-2304,-960;Inherit;False;62;VAR_SpcaeBackground;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-2016,-960;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;16;-1888,-960;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-1760,-960;Inherit;False;OUT_Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-2304,464;Inherit;False;76;VAR_AnimationSteps;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;75;-1776,384;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;78;-1488,416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;60;-1840,336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;79;-1536,352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1600,672;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;69;-2064,672;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;70;-1888,672;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-1744,672;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;-1472,688;Inherit;False;VAR_AnimationSteps;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-128,-448;Inherit;False;64;OUT_Emissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;15;-2032,-384;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-1232,-960;Inherit;False;VAR_BackgroundScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-2304,-160;Inherit;False;44;VAR_BackgroundScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-2032,-560;Inherit;False;Property;_SpaceColor;Space Color;0;0;Create;True;0;0;0;False;0;False;0,0.007317648,0.02,0;0,0.007317648,0.02,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-1792,-160;Inherit;True;Property;_SpacePattern;Space Pattern;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-1504,-960;Inherit;False;Property;_SpaceScale;Space Scale;2;0;Create;True;0;0;0;False;0;False;0;4.63;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2304,367;Inherit;False;Property;_StartsScale;Starts Scale;3;0;Create;True;0;0;0;False;0;False;0;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2080,368;Inherit;False;Property;_StartFactprBig;Start Factpr Big;5;0;Create;True;0;0;0;False;0;False;0;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1792,272;Inherit;False;Property;_StarsFactorSmall;Stars Factor Small;4;0;Create;True;0;0;0;False;0;False;0.01;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1424,367;Inherit;False;Property;_BigStartsMaskFactor;BigStarts Mask Factor;6;0;Create;True;0;0;0;False;0;False;0;-2.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-2304,671;Inherit;False;Property;_StartsAnimationSpeed;Starts Animation Speed;7;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;91;128,-512;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SpacialSkybox;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;46;0
WireConnection;19;1;42;0
WireConnection;48;0;17;0
WireConnection;47;0;48;0
WireConnection;23;0;43;0
WireConnection;23;1;24;0
WireConnection;32;0;78;0
WireConnection;32;1;75;0
WireConnection;35;0;49;0
WireConnection;35;3;36;0
WireConnection;18;0;15;0
WireConnection;18;1;17;1
WireConnection;38;0;35;0
WireConnection;58;0;32;0
WireConnection;27;0;23;0
WireConnection;27;1;28;0
WireConnection;21;0;20;0
WireConnection;21;1;18;0
WireConnection;34;1;58;0
WireConnection;34;2;38;0
WireConnection;52;0;34;0
WireConnection;62;0;21;0
WireConnection;50;0;27;0
WireConnection;29;0;63;0
WireConnection;29;1;51;0
WireConnection;29;2;53;0
WireConnection;16;0;29;0
WireConnection;64;0;16;0
WireConnection;75;0;77;0
WireConnection;75;4;33;0
WireConnection;78;0;79;0
WireConnection;60;0;23;0
WireConnection;79;0;60;0
WireConnection;73;0;71;0
WireConnection;69;0;74;0
WireConnection;70;0;69;0
WireConnection;71;0;70;0
WireConnection;76;0;73;0
WireConnection;15;0;1;0
WireConnection;15;1;45;0
WireConnection;44;0;14;0
WireConnection;17;1;19;0
WireConnection;91;2;65;0
ASEEND*/
//CHKSM=F6606A5C2E0600B8E6DC9FAB47B4E5139195DDC9