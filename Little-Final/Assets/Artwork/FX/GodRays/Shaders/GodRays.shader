// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/FX/GodRays"
{
	Properties
	{
		_Emission("Emission", Color) = (0,0,0,0)
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_Fresnel__Scale("Fresnel__Scale", Float) = 1.1
		_Fresnel__Power("Fresnel__Power", Float) = 0.26
		_VolumenMask__Factor("VolumenMask__Factor", Float) = 5.5
		_DistanceMask__Length("DistanceMask__Length", Float) = 8
		_DistanceMask_LvMin("DistanceMask_LvMin", Float) = -1.7
		_DistanceMask_LvMax("DistanceMask_LvMax", Float) = 1.8
		_VerticalGrad__LvMin("VerticalGrad__LvMin", Float) = 0
		_VerticalGrad__LvMax("VerticalGrad__LvMax", Float) = 7.76
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float4 screenPosition50;
			float eyeDepth;
		};

		uniform float4 _Emission;
		uniform float _Fresnel__Scale;
		uniform float _Fresnel__Power;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _VolumenMask__Factor;
		uniform float _DistanceMask__Length;
		uniform float _DistanceMask_LvMin;
		uniform float _DistanceMask_LvMax;
		uniform float _VerticalGrad__LvMin;
		uniform float _VerticalGrad__LvMax;
		uniform float BigWindFactor;
		uniform float BigWindSpeed;
		uniform float WindIntensity;
		uniform float _Opacity;


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
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos50 = ase_vertex3Pos;
			float4 ase_screenPos50 = ComputeScreenPos( UnityObjectToClipPos( vertexPos50 ) );
			o.screenPosition50 = ase_screenPos50;
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_output_21_0_g2 = _Emission;
			float4 color20_g2 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_0 = (0.1).xx;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5_g2 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g2 = ( 0.01 * 1.5 );
			float2 panner10_g8 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult5_g2 * temp_output_2_0_g2 ));
			float simplePerlin2D11_g8 = snoise( panner10_g8 );
			simplePerlin2D11_g8 = simplePerlin2D11_g8*0.5 + 0.5;
			float temp_output_8_0_g2 = simplePerlin2D11_g8;
			float2 temp_cast_1 = (0.1).xx;
			float2 panner10_g12 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g2 * 0.01 ));
			float simplePerlin2D11_g12 = snoise( panner10_g12 );
			simplePerlin2D11_g12 = simplePerlin2D11_g12*0.5 + 0.5;
			float2 temp_cast_2 = (0.1).xx;
			float2 panner10_g11 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g2 * ( temp_output_2_0_g2 * 4.0 ) ));
			float simplePerlin2D11_g11 = snoise( panner10_g11 );
			simplePerlin2D11_g11 = simplePerlin2D11_g11*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g2 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g2 * simplePerlin2D11_g12 ) + ( 1.0 - simplePerlin2D11_g11 ) ) * temp_output_8_0_g2 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g2 = lerp( temp_output_21_0_g2 , saturate( ( temp_output_21_0_g2 * color20_g2 ) ) , ( temp_output_16_0_g2 * 1.0 ));
			o.Emission = lerpResult24_g2.rgb;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV16 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode16 = ( 0.0 + _Fresnel__Scale * pow( max( 1.0 - fresnelNdotV16 , 0.0001 ), _Fresnel__Power ) );
			float4 ase_screenPos50 = i.screenPosition50;
			float4 ase_screenPosNorm50 = ase_screenPos50 / ase_screenPos50.w;
			ase_screenPosNorm50.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm50.z : ase_screenPosNorm50.z * 0.5 + 0.5;
			float screenDepth50 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm50.xy ));
			float distanceDepth50 = abs( ( screenDepth50 - LinearEyeDepth( ase_screenPosNorm50.z ) ) / ( _VolumenMask__Factor ) );
			float cameraDepthFade54 = (( i.eyeDepth -_ProjectionParams.y - 0.0 ) / _DistanceMask__Length);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float2 temp_cast_4 = (BigWindSpeed).xx;
			float3 appendResult43 = (float3(ase_worldPos.x , 0.0 , ase_worldPos.z));
			float2 panner10_g1 = ( 1.0 * _Time.y * temp_cast_4 + ( appendResult43 * WindIntensity ).xy);
			float simplePerlin2D11_g1 = snoise( panner10_g1 );
			simplePerlin2D11_g1 = simplePerlin2D11_g1*0.5 + 0.5;
			o.Alpha = ( saturate( ( 1.0 - fresnelNode16 ) ) * saturate( distanceDepth50 ) * saturate( (_DistanceMask_LvMin + (cameraDepthFade54 - 0.0) * (_DistanceMask_LvMax - _DistanceMask_LvMin) / (1.0 - 0.0)) ) * saturate( (_VerticalGrad__LvMin + (ase_vertex3Pos.z - 0.0) * (_VerticalGrad__LvMax - _VerticalGrad__LvMin) / (1.0 - 0.0)) ) * ( BigWindFactor * simplePerlin2D11_g1 ) * _Opacity );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1284;1191;1780;908;727.7418;244.3858;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;78;-1666.4,1230;Inherit;False;807.8;429.1;Wind Mask;7;42;43;35;40;39;38;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;76;-1668,398;Inherit;False;809;371;Distance Mask;6;61;57;54;59;58;55;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;74;-1667,-178;Inherit;False;808;244;Fresnel Mask;5;52;22;16;19;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;77;-1663,784;Inherit;False;805;401;Vertical Gradient;5;71;72;73;70;68;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;75;-1667,112;Inherit;False;805;274;Objects Mask;4;47;50;48;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;42;-1632,1472;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;55;-1649,448;Inherit;False;Property;_DistanceMask__Length;DistanceMask__Length;5;0;Create;True;0;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1632,-32;Inherit;False;Property;_Fresnel__Power;Fresnel__Power;3;0;Create;True;0;0;0;False;0;False;0.26;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1632,-128;Inherit;False;Property;_Fresnel__Scale;Fresnel__Scale;2;0;Create;True;0;0;0;False;0;False;1.1;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1632,992;Inherit;False;Property;_VerticalGrad__LvMin;VerticalGrad__LvMin;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;54;-1424,448;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-1632,1072;Inherit;False;Property;_VerticalGrad__LvMax;VerticalGrad__LvMax;9;0;Create;True;0;0;0;False;0;False;7.76;7.76;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1472,656;Inherit;False;Property;_DistanceMask_LvMax;DistanceMask_LvMax;7;0;Create;True;0;0;0;False;0;False;1.8;1.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-1472,576;Inherit;False;Property;_DistanceMask_LvMin;DistanceMask_LvMin;6;0;Create;True;0;0;0;False;0;False;-1.7;-1.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1632,1280;Inherit;False;Global;BigWindSpeed;BigWindSpeed;3;0;Create;True;0;0;0;False;0;False;1;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;49;-1632,160;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-1632,304;Inherit;False;Property;_VolumenMask__Factor;VolumenMask__Factor;4;0;Create;True;0;0;0;False;0;False;5.5;5.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-1456,1504;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1632,1376;Inherit;False;Global;WindIntensity;WindIntensity;3;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;68;-1632,832;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;16;-1424,-128;Inherit;False;Standard;WorldNormal;ViewDir;False;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;35;-1296,1424;Inherit;False;WorldNoise;-1;;1;f17c4c9c155f92e4cb0e3f353a46552a;0;3;14;FLOAT2;0,0;False;13;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;22;-1184,-128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;72;-1280,832;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;57;-1184,448;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1344,1280;Inherit;False;Global;BigWindFactor;BigWindFactor;3;0;Create;True;0;0;0;False;0;False;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;50;-1408,160;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-314,-85;Inherit;False;Property;_Emission;Emission;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.9959494,1,0.75,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;-768,272;Inherit;False;Property;_Opacity;Opacity;1;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;52;-1024,-128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;61;-1008,448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;71;-1072,832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-992,1280;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;-1168,160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;95;6.258179,-64.3858;Inherit;False;CloudsPattern;-1;;2;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-64,160;Inherit;False;6;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;94;365.8739,-57.23719;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/FX/GodRays;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;54;0;55;0
WireConnection;43;0;42;1
WireConnection;43;2;42;3
WireConnection;16;2;19;0
WireConnection;16;3;28;0
WireConnection;35;14;36;0
WireConnection;35;13;38;0
WireConnection;35;2;43;0
WireConnection;22;0;16;0
WireConnection;72;0;68;3
WireConnection;72;3;70;0
WireConnection;72;4;73;0
WireConnection;57;0;54;0
WireConnection;57;3;58;0
WireConnection;57;4;59;0
WireConnection;50;1;49;0
WireConnection;50;0;48;0
WireConnection;52;0;22;0
WireConnection;61;0;57;0
WireConnection;71;0;72;0
WireConnection;40;0;39;0
WireConnection;40;1;35;0
WireConnection;47;0;50;0
WireConnection;95;21;1;0
WireConnection;45;0;52;0
WireConnection;45;1;47;0
WireConnection;45;2;61;0
WireConnection;45;3;71;0
WireConnection;45;4;40;0
WireConnection;45;5;46;0
WireConnection;94;2;95;0
WireConnection;94;9;45;0
ASEEND*/
//CHKSM=0FDEE66A432CAE913C1866C1E4CE4F72FB37E005