// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASESampleShaders/VertexNormalReconstruction"
{
	Properties
	{
		_Amplitude("Amplitude", Range( 0 , 10)) = 0
		_Frequency("Frequency", Float) = 0
		_Normalpositiondeviation("Normal position deviation", Range( 0.01 , 1)) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		ZTest LEqual
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
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
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _Normalpositiondeviation;
		uniform float _Frequency;
		uniform float _Amplitude;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float deviation199 = _Normalpositiondeviation;
			float3 appendResult206 = (float3(0.0 , deviation199 , 0.0));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float4 ase_vertexTangent = mul( unity_WorldToObject, float4( ase_worldTangent, 0 ) );
			float3x3 ObjectToTangent121 = float3x3(cross( ase_vertexNormal , ase_vertexTangent.xyz ), ase_vertexTangent.xyz, ase_vertexNormal);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 break3_g18 = mul( ( appendResult206 + mul( ObjectToTangent121, ase_vertex3Pos ) ), ObjectToTangent121 );
			float frequency291 = _Frequency;
			float mulTime4_g18 = _Time.y * 2.0;
			float amplitude287 = _Amplitude;
			float3 appendResult11_g18 = (float3(break3_g18.x , ( break3_g18.y + ( sin( ( ( break3_g18.x * frequency291 ) + mulTime4_g18 ) ) * ( amplitude287 * i.uv_texcoord.x ) ) ) , break3_g18.z));
			float3 yDeviation114 = appendResult11_g18;
			float3 break3_g17 = ase_vertex3Pos;
			float mulTime4_g17 = _Time.y * 2.0;
			float3 appendResult11_g17 = (float3(break3_g17.x , ( break3_g17.y + ( sin( ( ( break3_g17.x * frequency291 ) + mulTime4_g17 ) ) * ( amplitude287 * i.uv_texcoord.x ) ) ) , break3_g17.z));
			float3 newVertexPos56 = appendResult11_g17;
			float3 appendResult198 = (float3(deviation199 , 0.0 , 0.0));
			float3 break3_g16 = mul( ( appendResult198 + mul( ObjectToTangent121, ase_vertex3Pos ) ), ObjectToTangent121 );
			float mulTime4_g16 = _Time.y * 2.0;
			float3 appendResult11_g16 = (float3(break3_g16.x , ( break3_g16.y + ( sin( ( ( break3_g16.x * frequency291 ) + mulTime4_g16 ) ) * ( amplitude287 * i.uv_texcoord.x ) ) ) , break3_g16.z));
			float3 xDeviation113 = appendResult11_g16;
			float3 normalizeResult97 = normalize( cross( ( yDeviation114 - newVertexPos56 ) , ( xDeviation113 - newVertexPos56 ) ) );
			o.Emission = normalizeResult97 + 1E-5;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows noforwardadd 

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
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
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
Version=18900
2072;153;1909;859;-836.903;687.5942;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;296;-2659.058,197.2267;Inherit;False;1078.618;465.5402;object to tangent matrix without tangent sign;5;116;121;125;118;117;Object to tangent matrix;1,1,1,1;0;0
Node;AmplifyShaderEditor.TangentVertexDataNode;118;-2612.48,354.8413;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;117;-2603.058,498.4479;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;295;-2241.312,-521.0488;Inherit;False;645.3955;379.0187;Comment;6;130;199;127;291;112;287;Inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.CrossProductOpNode;125;-2260.48,290.8413;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors;116;-2084.48,322.8413;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-2188.269,-262.6044;Float;False;Property;_Normalpositiondeviation;Normal position deviation;2;0;Create;True;0;0;0;False;0;False;0.1;0.1;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;177;-1568,-528;Inherit;False;1562.402;582.1888;move the position in tangent X direction by the deviation amount;14;308;289;314;309;113;197;293;196;195;198;194;192;200;201;delta X position;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;199;-1868.269,-262.6044;Float;False;deviation;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-1828.48,322.8413;Float;False;ObjectToTangent;-1;True;1;0;FLOAT3x3;0,0,0,0,1,0,0,0,1;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.CommentaryNode;202;-1552,192;Inherit;False;1552.676;586.3004;move the position in tangent Y direction by the deviation amount;14;311;310;114;313;292;210;288;209;208;206;207;205;203;204;delta Y position;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;-1511.005,-316.4977;Inherit;False;121;ObjectToTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.PosVertexDataNode;201;-1472,-208;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;112;-2188.269,-454.6044;Float;False;Property;_Amplitude;Amplitude;0;0;Create;True;0;0;0;False;0;False;0;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;-1504,400;Inherit;False;121;ObjectToTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.GetLocalVarNode;200;-1472,-432;Inherit;False;199;deviation;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;205;-1472,496;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;203;-1456,288;Inherit;False;199;deviation;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-1216,-288;Inherit;False;2;2;0;FLOAT3x3;0,0,0,0,1,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;287;-1868.269,-454.6044;Float;False;amplitude;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-2076.269,-358.6044;Float;False;Property;_Frequency;Frequency;1;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;206;-1216,320;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;198;-1216,-416;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;-1216,448;Inherit;False;2;2;0;FLOAT3x3;0,0,0,0,1,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;77;-1568,-1184;Inherit;False;959.9028;475.1613;simply apply vertex transformation;7;56;312;15;306;294;290;307;new vertex position;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-1072,-224;Inherit;False;121;ObjectToTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;-1024,-368;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;309;-784,-96;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;289;-768,-176;Inherit;False;287;amplitude;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;291;-1868.269,-358.6044;Float;False;frequency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;311;-800,640;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;209;-1024,368;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;208;-1072,528;Inherit;False;121;ObjectToTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.GetLocalVarNode;288;-800,560;Inherit;False;287;amplitude;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;290;-1456,-960;Inherit;False;287;amplitude;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;307;-1472,-880;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;-1232,-960;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;310;-592,528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-784,368;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,0,1,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;293;-768,-256;Inherit;False;291;frequency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;15;-1520,-1104;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;-736,-368;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,0,1,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;308;-560,-192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;-800,480;Inherit;False;291;frequency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;-1332.203,-1039.546;Inherit;False;291;frequency;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;313;-480,368;Inherit;True;Waving Vertex;-1;;18;872b3757863bb794c96291ceeebfb188;0;3;1;FLOAT3;0,0,0;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;312;-1056,-1104;Inherit;False;Waving Vertex;-1;;17;872b3757863bb794c96291ceeebfb188;0;3;1;FLOAT3;0,0,0;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;314;-432,-368;Inherit;True;Waving Vertex;-1;;16;872b3757863bb794c96291ceeebfb188;0;3;1;FLOAT3;0,0,0;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-832,-1104;Float;True;newVertexPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-240,368;Float;False;yDeviation;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-191.2741,-293.0372;Float;False;xDeviation;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;297;657.8127,-173.1141;Inherit;False;927.4102;507.1851;calculated new normal by derivation;8;223;107;224;108;88;93;96;97;new normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;707.4468,193.0864;Inherit;False;56;newVertexPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;224;707.4468,113.0864;Inherit;False;114;yDeviation;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;223;707.4468,-78.91376;Inherit;False;113;xDeviation;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;707.8127,-6.447388;Inherit;False;56;newVertexPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;979.4468,-62.91375;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;93;979.4468,113.0864;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;318;1155.447,-846.9138;Inherit;False;461.3383;368.4299;Fix normals for back side faces;3;315;317;316;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;317;1171.447,-638.9138;Float;False;Constant;_Backnormalvector;Back normal vector;4;0;Create;True;0;0;0;False;0;False;0,0,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;316;1171.447,-798.9138;Float;False;Constant;_Frontnormalvector;Front normal vector;4;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CrossProductOpNode;96;1171.447,17.08633;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;19;1379.447,-462.9138;Float;False;Constant;_Smoothness;Smoothness;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;315;1459.447,-718.9138;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;305;1325.821,-1067.025;Inherit;True;Property;_Flagalbedo;Flag albedo;3;0;Create;True;0;0;0;False;0;False;-1;None;8aba6bb20faf8824d9d81946542f1ce1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;109;1363.447,-366.9138;Inherit;False;56;newVertexPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;97;1395.447,17.08633;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1742.518,-706.5498;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ASESampleShaders/VertexNormalReconstruction;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;125;0;117;0
WireConnection;125;1;118;0
WireConnection;116;0;125;0
WireConnection;116;1;118;0
WireConnection;116;2;117;0
WireConnection;199;0;130;0
WireConnection;121;0;116;0
WireConnection;194;0;192;0
WireConnection;194;1;201;0
WireConnection;287;0;112;0
WireConnection;206;1;203;0
WireConnection;198;0;200;0
WireConnection;207;0;204;0
WireConnection;207;1;205;0
WireConnection;195;0;198;0
WireConnection;195;1;194;0
WireConnection;291;0;127;0
WireConnection;209;0;206;0
WireConnection;209;1;207;0
WireConnection;306;0;290;0
WireConnection;306;1;307;1
WireConnection;310;0;288;0
WireConnection;310;1;311;1
WireConnection;210;0;209;0
WireConnection;210;1;208;0
WireConnection;197;0;195;0
WireConnection;197;1;196;0
WireConnection;308;0;289;0
WireConnection;308;1;309;1
WireConnection;313;1;210;0
WireConnection;313;12;292;0
WireConnection;313;13;310;0
WireConnection;312;1;15;0
WireConnection;312;12;294;0
WireConnection;312;13;306;0
WireConnection;314;1;197;0
WireConnection;314;12;293;0
WireConnection;314;13;308;0
WireConnection;56;0;312;0
WireConnection;114;0;313;0
WireConnection;113;0;314;0
WireConnection;88;0;223;0
WireConnection;88;1;107;0
WireConnection;93;0;224;0
WireConnection;93;1;108;0
WireConnection;96;0;93;0
WireConnection;96;1;88;0
WireConnection;315;0;316;0
WireConnection;315;1;317;0
WireConnection;97;0;96;0
WireConnection;0;0;305;0
WireConnection;0;1;315;0
WireConnection;0;4;19;0
WireConnection;0;11;109;0
WireConnection;0;12;97;0
WireConnection;0;15;97;0
ASEEND*/
//CHKSM=573B9596DD55C5189255EE0EDF5644A112031060