// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "S_Bush"
{
	Properties
	{
		_BaseColor("Base Color", Color) = (0.5508001,0.8773585,0.5173104,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_EffectBlend("EffectBlend", Range( 0 , 1)) = 0
		[NoScaleOffset]_StandarTreeLeaves("StandarTreeLeaves", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_LigthingColor("Ligthing Color", Color) = (0,0,0,0)
		_BilbordScale("BilbordScale", Float) = 0
		_Inflate("Inflate", Float) = 0
		_WindSpeed("Wind Speed", Float) = 0
		_WindTurbulence("Wind Turbulence", Float) = 1
		_WindIntensity("Wind Intensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
		};

		uniform float _WindSpeed;
		uniform float _WindIntensity;
		uniform float _WindTurbulence;
		uniform float _BilbordScale;
		uniform float _Inflate;
		uniform float _EffectBlend;
		uniform float4 _BaseColor;
		uniform float4 _LigthingColor;
		uniform float _Smoothness;
		uniform sampler2D _StandarTreeLeaves;
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float Prop_Wind_Speed124 = _WindSpeed;
			float mulTime45 = _Time.y * Prop_Wind_Speed124;
			float Prop_WindIntensity131 = _WindIntensity;
			float mulTime51 = _Time.y * ( Prop_Wind_Speed124 * 0.6 );
			float mulTime61 = _Time.y * ( Prop_Wind_Speed124 * 2.0 );
			float mulTime66 = _Time.y * ( Prop_Wind_Speed124 * 0.2 );
			float A_RotationSpeed136 = ( ( sin( mulTime45 ) * Prop_WindIntensity131 ) + ( sin( mulTime51 ) * ( Prop_WindIntensity131 * 0.2 ) ) + ( sin( mulTime61 ) * ( Prop_WindIntensity131 * 0.6 ) ) + ( sin( mulTime66 ) * ( Prop_WindIntensity131 * 0.8 ) ) );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 RAW_WorldPosition112 = ase_worldPos;
			float mulTime96 = _Time.y * ( Prop_Wind_Speed124 * 0.2 );
			float Prop_WindTurbulece116 = _WindTurbulence;
			float simplePerlin3D86 = snoise( ( RAW_WorldPosition112 + mulTime96 )*Prop_WindTurbulece116 );
			simplePerlin3D86 = simplePerlin3D86*0.5 + 0.5;
			float simplePerlin3D98 = snoise( ( RAW_WorldPosition112 + ( mulTime96 * 0.5 ) )*( Prop_WindTurbulece116 * 2.0 ) );
			simplePerlin3D98 = simplePerlin3D98*0.5 + 0.5;
			float simplePerlin3D106 = snoise( ( RAW_WorldPosition112 + ( mulTime96 * 0.1 ) )*( Prop_WindTurbulece116 * 0.5 ) );
			simplePerlin3D106 = simplePerlin3D106*0.5 + 0.5;
			float AM_RotatorMask121 = saturate( ( ( simplePerlin3D86 + ( simplePerlin3D86 * simplePerlin3D98 ) ) * simplePerlin3D106 ) );
			float cos43 = cos( ( A_RotationSpeed136 * AM_RotatorMask121 ) );
			float sin43 = sin( ( A_RotationSpeed136 * AM_RotatorMask121 ) );
			float2 rotator43 = mul( (float2( -1,-1 ) + (v.texcoord.xy - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 ))) - float2( 0,0 ) , float2x2( cos43 , -sin43 , sin43 , cos43 )) + float2( 0,0 );
			float3 appendResult14 = (float3(rotator43 , 0.0));
			float3 normalizeResult18 = normalize( mul( float4( mul( float4( appendResult14 , 0.0 ), UNITY_MATRIX_V ).xyz , 0.0 ), unity_ObjectToWorld ).xyz );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 lerpResult20 = lerp( float3( 0,0,0 ) , ( ( normalizeResult18 * _BilbordScale ) + ( ase_vertexNormal * _Inflate ) ) , _EffectBlend);
			float3 OUT_VertexOffset144 = lerpResult20;
			v.vertex.xyz += OUT_VertexOffset144;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 OUT_BaseColor148 = _BaseColor;
			o.Albedo = OUT_BaseColor148.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV25 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode25 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV25, 5.0 ) );
			float4 OUT_Emissive146 = ( _LigthingColor * saturate( fresnelNode25 ) );
			o.Emission = OUT_Emissive146.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			float2 uv_StandarTreeLeaves23 = i.uv_texcoord;
			float OUT_Opacity151 = tex2D( _StandarTreeLeaves, uv_StandarTreeLeaves23 ).r;
			clip( OUT_Opacity151 - _Cutoff );
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
				float2 customPack1 : TEXCOORD1;
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
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;153;224,-288;Inherit;False;676;547;;6;149;147;24;152;145;0;Shader;1,1,1,0.5019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;150;-1440,-768;Inherit;False;1109.974;642.6805;;9;23;148;19;29;146;28;27;25;151;Emissive And Base Color;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;143;-6272,-512;Inherit;False;511.9998;510.9999;;8;131;129;112;94;124;116;87;48;Properties;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;142;-1440,0;Inherit;False;771;321;;4;144;20;22;36;Vertex Position Blend;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;141;-2400,384;Inherit;False;419;320;;3;34;32;33;Inflate Effect;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;140;-3200,384;Inherit;False;740;259;;4;137;122;88;43;Rotation Animation;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;139;-3200,0;Inherit;False;1668;291;;10;1;9;30;31;14;12;15;13;16;18;Bilbord contruction;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;138;-6272,128;Inherit;False;1922.2;767.1;TODO Mejorar el este random sine wave;25;136;54;135;69;68;66;65;67;46;64;53;130;132;44;45;134;63;62;61;60;56;133;52;51;55;Rotation Animation Speed;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.CommentaryNode;120;-6272,1024;Inherit;False;2805.107;707.0586;;24;125;123;121;104;111;103;105;107;119;118;106;99;98;117;86;108;109;115;96;100;114;113;101;95;Rotator Mask;1,1,1,0.1019608;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;256,-224;Inherit;False;148;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;256,-128;Inherit;False;146;OUT_Emissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;256,-32;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;152;256,64;Inherit;False;151;OUT_Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;256,160;Inherit;False;144;OUT_VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;608,-224;Float;False;True;-1;4;ASEMaterialInspector;0;0;Standard;S_Bush;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-6240,1088;Inherit;False;124;Prop_Wind Speed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-5984,1088;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-5312,1088;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-5568,1376;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-5568,1088;Inherit;False;112;RAW_WorldPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-5568,1280;Inherit;False;112;RAW_WorldPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;-5312,1280;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-5568,1504;Inherit;False;112;RAW_WorldPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-5568,1600;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-5312,1504;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;86;-4672,1088;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-4928,1152;Inherit;False;116;Prop_WindTurbulece;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;98;-4672,1280;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-4864,1344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;106;-4672,1504;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-5120,1344;Inherit;False;116;Prop_WindTurbulece;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-5120,1568;Inherit;False;116;Prop_WindTurbulece;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-4864,1568;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-4448,1184;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-4288,1088;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-4128,1248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;104;-3968,1248;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;121;-3808,1248;Inherit;False;AM_RotatorMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;96;-5824,1184;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-5920,352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;51;-5728,352;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;52;-5536,352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-5408,416;Inherit;False;131;Prop_WindIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-5120,416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-5920,512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;61;-5728,512;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;62;-5536,512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-5120,576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-5408,608;Inherit;False;131;Prop_WindIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;45;-5728,192;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;44;-5536,192;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;-5408,256;Inherit;False;131;Prop_WindIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-6240,192;Inherit;False;124;Prop_Wind Speed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-4928,352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-4928,512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-4928,192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;67;-5536,704;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-5920,704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;66;-5728,704;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-5120,768;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-4928,704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;-5408,800;Inherit;False;131;Prop_WindIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-4704,384;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-4576,384;Inherit;False;A_RotationSpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-6240,-352;Inherit;False;Property;_WindSpeed;Wind Speed;8;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-6240,-256;Inherit;False;Property;_WindTurbulence;Wind Turbulence;9;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-6016,-256;Inherit;False;Prop_WindTurbulece;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-6016,-352;Inherit;False;Prop_Wind Speed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;94;-6240,-160;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-6016,-160;Inherit;False;RAW_WorldPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-6240,-448;Inherit;False;Property;_WindIntensity;Wind Intensity;10;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;-6016,-448;Inherit;False;Prop_WindIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1;-3168,64;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;9;-2912,64;Inherit;False;5;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1728,64;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1920,160;Inherit;False;Property;_BilbordScale;BilbordScale;6;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-2464,64;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewMatrixNode;12;-2464,192;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.ObjectToWorldMatrixNode;15;-2272,192;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2272,64;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2080,64;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;18;-1920,64;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-3168,448;Inherit;False;136;A_RotationSpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-3168,544;Inherit;False;121;AM_RotatorMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-2912,448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;43;-2688,448;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-2144,448;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;32;-2368,448;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-2368,608;Inherit;False;Property;_Inflate;Inflate;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1232,64;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1392,224;Inherit;False;Property;_EffectBlend;EffectBlend;2;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;-1072,64;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-897,65;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;25;-1408,-512;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;-1184,-512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1024,-704;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;-864,-704;Inherit;False;OUT_Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;29;-1408,-704;Inherit;False;Property;_LigthingColor;Ligthing Color;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5570361,0.6320754,0.2116856,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;19;-1408,-320;Inherit;False;Property;_BaseColor;Base Color;0;0;Create;True;0;0;0;False;0;False;0.5508001,0.8773585,0.5173104,0;0.3034481,0.6698113,0.2685564,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;148;-1152,-320;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;151;-608,-320;Inherit;False;OUT_Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-896,-320;Inherit;True;Property;_StandarTreeLeaves;StandarTreeLeaves;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;b1371bd5f93f9854d8893b8f22eb73d0;ffba334276e7701479ca39d8bb15ff0e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;149;0
WireConnection;0;2;147;0
WireConnection;0;4;24;0
WireConnection;0;10;152;0
WireConnection;0;11;145;0
WireConnection;123;0;125;0
WireConnection;95;0;113;0
WireConnection;95;1;96;0
WireConnection;101;0;96;0
WireConnection;100;0;114;0
WireConnection;100;1;101;0
WireConnection;109;0;96;0
WireConnection;108;0;115;0
WireConnection;108;1;109;0
WireConnection;86;0;95;0
WireConnection;86;1;117;0
WireConnection;98;0;100;0
WireConnection;98;1;99;0
WireConnection;99;0;118;0
WireConnection;106;0;108;0
WireConnection;106;1;107;0
WireConnection;107;0;119;0
WireConnection;105;0;86;0
WireConnection;105;1;98;0
WireConnection;103;0;86;0
WireConnection;103;1;105;0
WireConnection;111;0;103;0
WireConnection;111;1;106;0
WireConnection;104;0;111;0
WireConnection;121;0;104;0
WireConnection;96;0;123;0
WireConnection;55;0;130;0
WireConnection;51;0;55;0
WireConnection;52;0;51;0
WireConnection;56;0;133;0
WireConnection;60;0;130;0
WireConnection;61;0;60;0
WireConnection;62;0;61;0
WireConnection;63;0;134;0
WireConnection;45;0;130;0
WireConnection;44;0;45;0
WireConnection;53;0;52;0
WireConnection;53;1;56;0
WireConnection;64;0;62;0
WireConnection;64;1;63;0
WireConnection;46;0;44;0
WireConnection;46;1;132;0
WireConnection;67;0;66;0
WireConnection;65;0;130;0
WireConnection;66;0;65;0
WireConnection;68;0;135;0
WireConnection;69;0;67;0
WireConnection;69;1;68;0
WireConnection;54;0;46;0
WireConnection;54;1;53;0
WireConnection;54;2;64;0
WireConnection;54;3;69;0
WireConnection;136;0;54;0
WireConnection;116;0;87;0
WireConnection;124;0;48;0
WireConnection;112;0;94;0
WireConnection;131;0;129;0
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
WireConnection;43;2;88;0
WireConnection;33;0;32;0
WireConnection;33;1;34;0
WireConnection;36;0;30;0
WireConnection;36;1;33;0
WireConnection;20;1;36;0
WireConnection;20;2;22;0
WireConnection;144;0;20;0
WireConnection;27;0;25;0
WireConnection;28;0;29;0
WireConnection;28;1;27;0
WireConnection;146;0;28;0
WireConnection;148;0;19;0
WireConnection;151;0;23;1
ASEEND*/
//CHKSM=3C604A7C3C84E7551B1464F5188765DC3FF96F57