// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "s_Grass"
{
	Properties
	{
		[NoScaleOffset]_GrassTexture("Grass Texture", 2D) = "white" {}
		_WindIntensity("Wind Intensity", Range( 0 , 1)) = 0
		_Speed("Speed", Float) = 0
		_Radius("Radius", Float) = 0
		_FallOff("FallOff", Float) = 0
		_Color("Color", Color) = (0,0,0,0)
		_WindPostion("Wind Postion", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float3 _WindPostion;
		uniform float _Speed;
		uniform float _WindIntensity;
		uniform float _Radius;
		uniform float _FallOff;
		uniform float4 _Color;
		uniform sampler2D _GrassTexture;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float VTextureCordinates58 = v.texcoord.xy.y;
			float3 temp_output_47_0 = ( ase_vertex3Pos.z * VTextureCordinates58 * _WindPostion );
			float3 appendResult39 = (float3(0.0 , temp_output_47_0.x , ( 1.0 - temp_output_47_0 ).x));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 appendResult34 = (float3(ase_worldPos.y , 0.0 , 0.0));
			float mulTime5 = _Time.y * _Speed;
			float3 temp_cast_2 = (0.0).xxx;
			float3 lerpResult35 = lerp( appendResult39 , ( appendResult34 * ( saturate( ( VTextureCordinates58 - 0.09 ) ) * ( sin( mulTime5 ) * ( _WindIntensity / 1000.0 ) ) ) ) , saturate( pow( ( distance( temp_cast_2 , ase_worldPos ) / _Radius ) , _FallOff ) ));
			v.vertex.xyz += lerpResult35;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_GrassTexture1 = i.uv_texcoord;
			float4 tex2DNode1 = tex2D( _GrassTexture, uv_GrassTexture1 );
			o.Albedo = ( _Color * tex2DNode1 ).rgb;
			o.Alpha = tex2DNode1.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
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
341;73;895;746;3418.893;1079.42;4.787525;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2251.611,237.308;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1968.135,252.0115;Inherit;False;VTextureCordinates;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2218.219,629.4098;Inherit;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-1540.282,796.4819;Inherit;False;Constant;_Position;Position;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;26;-1575.053,867.332;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1993.184,633.1658;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-1957.123,531.1664;Inherit;False;58;VTextureCordinates;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2037.316,729.2996;Inherit;False;Property;_WindIntensity;Wind Intensity;1;0;Create;True;0;0;False;0;0;0.189;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;42;-1501.681,58.24226;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;78;-1769.635,727.6735;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1000;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;4;-1754.733,632.3717;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;45;-1720.208,534.7112;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.09;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-1540.489,212.1647;Inherit;False;58;VTextureCordinates;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;57;-1486.894,293.2003;Inherit;False;Property;_WindPostion;Wind Postion;6;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;28;-1384.054,930.3319;Inherit;False;Property;_Radius;Radius;3;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;25;-1394.054,821.3323;Inherit;False;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;27;-1222.054,819.3323;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1283.465,177.6928;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;46;-1564.146,537.2201;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1549.315,630.2998;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1382.054,1005.332;Inherit;False;Property;_FallOff;FallOff;4;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;33;-1203.612,371.407;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;30;-1110.054,820.3323;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1412.591,535.8836;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;52;-1017.9,240.2935;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-1003.777,420.1695;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;36;-945.5229,820.2476;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;55;-457.631,-81.04391;Inherit;False;Property;_Color;Color;5;0;Create;True;0;0;False;0;0,0,0,0;0.07756301,0.7830188,0.4572659,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-539.4106,96.78519;Inherit;True;Property;_GrassTexture;Grass Texture;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;d7a8c8dcc701f58469e15eea210d609a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-826.6171,507.7887;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;39;-839.0973,193.1205;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-162.0772,0.7193782;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;35;-486.7865,317.251;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;s_Grass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;58;0;3;2
WireConnection;5;0;13;0
WireConnection;78;0;7;0
WireConnection;4;0;5;0
WireConnection;45;0;59;0
WireConnection;25;0;53;0
WireConnection;25;1;26;0
WireConnection;27;0;25;0
WireConnection;27;1;28;0
WireConnection;47;0;42;3
WireConnection;47;1;60;0
WireConnection;47;2;57;0
WireConnection;46;0;45;0
WireConnection;6;0;4;0
WireConnection;6;1;78;0
WireConnection;30;0;27;0
WireConnection;30;1;29;0
WireConnection;8;0;46;0
WireConnection;8;1;6;0
WireConnection;52;0;47;0
WireConnection;34;0;33;2
WireConnection;36;0;30;0
WireConnection;31;0;34;0
WireConnection;31;1;8;0
WireConnection;39;1;47;0
WireConnection;39;2;52;0
WireConnection;56;0;55;0
WireConnection;56;1;1;0
WireConnection;35;0;39;0
WireConnection;35;1;31;0
WireConnection;35;2;36;0
WireConnection;0;0;56;0
WireConnection;0;9;1;4
WireConnection;0;11;35;0
ASEEND*/
//CHKSM=732A2686F67BB9AF660D8FC6805A4018B2303812