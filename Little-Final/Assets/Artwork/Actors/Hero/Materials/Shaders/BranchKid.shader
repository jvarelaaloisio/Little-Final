// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BranchKid"
{
	Properties
	{
		[NoScaleOffset]_PBRBaseColor("PBR BaseColor", 2D) = "white" {}
		[NoScaleOffset][Normal]_PBRNormal("PBR Normal", 2D) = "bump" {}
		[NoScaleOffset]_PBREmissive("PBR Emissive", 2D) = "white" {}
		_MagicActiveValue("Magic ActiveValue", Range( 0 , 1)) = 1
		[NoScaleOffset]_MagicMaskTex("Magic Mask Tex", 2D) = "white" {}
		_MagicActiveColor("Magic ActiveColor", Color) = (0,1,0.8446779,0)
		_MagicInactiveColor("Magic InactiveColor", Color) = (0,1,0.8446779,0)
		[NoScaleOffset][Normal]_MagicDistortion("Magic Distortion", 2D) = "bump" {}
		_DistortionFactor("Distortion Factor", Float) = 1
		_DistortionSpeed("Distortion Speed", Float) = 0.0001
		_DistortionScale("Distortion Scale", Float) = 1
		_SparksColor("Sparks Color", Color) = (1,0,0.9479666,0)
		_SparksSpeed("Sparks Speed", Float) = 1
		_SparksScale("Sparks Scale", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _PBRNormal;
		uniform sampler2D _PBRBaseColor;
		uniform sampler2D _PBREmissive;
		uniform float4 _MagicInactiveColor;
		uniform sampler2D _MagicMaskTex;
		uniform sampler2D _MagicDistortion;
		uniform float _DistortionSpeed;
		uniform float _DistortionScale;
		uniform float _DistortionFactor;
		uniform float _MagicActiveValue;
		uniform float _SparksScale;
		uniform float _SparksSpeed;
		uniform float4 _MagicActiveColor;
		uniform float4 _SparksColor;


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


		float2 voronoihash208( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi208( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash208( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_PBRNormal6 = i.uv_texcoord;
			float3 OUT_NormalMap87 = UnpackNormal( tex2D( _PBRNormal, uv_PBRNormal6 ) );
			o.Normal = OUT_NormalMap87;
			float2 uv_PBRBaseColor1 = i.uv_texcoord;
			float4 temp_output_21_0_g10 = tex2D( _PBRBaseColor, uv_PBRBaseColor1 );
			float4 color20_g10 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_0 = (0.1).xx;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5_g10 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g10 = ( 0.01 * 1.5 );
			float2 panner10_g11 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult5_g10 * temp_output_2_0_g10 ));
			float simplePerlin2D11_g11 = snoise( panner10_g11 );
			simplePerlin2D11_g11 = simplePerlin2D11_g11*0.5 + 0.5;
			float temp_output_8_0_g10 = simplePerlin2D11_g11;
			float2 temp_cast_1 = (0.1).xx;
			float2 panner10_g13 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g10 * 0.01 ));
			float simplePerlin2D11_g13 = snoise( panner10_g13 );
			simplePerlin2D11_g13 = simplePerlin2D11_g13*0.5 + 0.5;
			float2 temp_cast_2 = (0.1).xx;
			float2 panner10_g12 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g10 * ( temp_output_2_0_g10 * 4.0 ) ));
			float simplePerlin2D11_g12 = snoise( panner10_g12 );
			simplePerlin2D11_g12 = simplePerlin2D11_g12*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g10 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g10 * simplePerlin2D11_g13 ) + ( 1.0 - simplePerlin2D11_g12 ) ) * temp_output_8_0_g10 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g10 = lerp( temp_output_21_0_g10 , saturate( ( temp_output_21_0_g10 * color20_g10 ) ) , ( temp_output_16_0_g10 * 1.0 ));
			float4 OUT_BaseColor84 = lerpResult24_g10;
			o.Albedo = OUT_BaseColor84.rgb;
			float2 uv_PBREmissive9 = i.uv_texcoord;
			float2 appendResult184 = (float2(0.0 , _DistortionSpeed));
			float2 appendResult152 = (float2(ase_worldPos.x , ase_worldPos.y));
			float2 UV_GlobalCordinates154 = appendResult152;
			float2 panner183 = ( 1.0 * _Time.y * appendResult184 + ( UV_GlobalCordinates154 * _DistortionScale ));
			float Activate72 = _MagicActiveValue;
			float Magic__Mask61 = tex2D( _MagicMaskTex, ( float3( i.uv_texcoord ,  0.0 ) + UnpackScaleNormal( tex2D( _MagicDistortion, panner183 ), ( _DistortionFactor * Activate72 ) ) ).xy ).r;
			float time208 = 0.0;
			float2 voronoiSmoothId208 = 0;
			float2 appendResult136 = (float2(0.0 , -_SparksSpeed));
			float2 panner138 = ( 1.0 * _Time.y * appendResult136 + UV_GlobalCordinates154);
			float2 coords208 = panner138 * _SparksScale;
			float2 id208 = 0;
			float2 uv208 = 0;
			float voroi208 = voronoi208( coords208, time208, id208, uv208, 0, voronoiSmoothId208 );
			float grayscale209 = Luminance(float3( id208 ,  0.0 ));
			float MASK_Sparks160 = grayscale209;
			float4 lerpResult41 = lerp( ( _MagicInactiveColor * Magic__Mask61 ) , saturate( ( ( saturate( ( Magic__Mask61 - MASK_Sparks160 ) ) * _MagicActiveColor ) + ( _SparksColor * ( MASK_Sparks160 * Magic__Mask61 ) ) ) ) , Activate72);
			float4 COLOR_MagicEfffect92 = lerpResult41;
			float4 OUT_Emissive94 = ( tex2D( _PBREmissive, uv_PBREmissive9 ) + COLOR_MagicEfffect92 );
			o.Emission = OUT_Emissive94.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.CommentaryNode;197;-6656,-1024;Inherit;False;1858;566;;15;192;182;178;183;187;184;188;185;186;195;194;179;10;180;61;Magic Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;177;-6656,-1536;Inherit;False;585;375;;4;191;72;189;71;Properties;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;176;-4226.768,313.5373;Inherit;False;754.0001;358.0001;;4;14;94;93;9;Emissive Blend;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;175;-6656,-400;Inherit;False;1602;950.0001;;18;169;168;170;73;90;91;34;70;162;163;164;171;172;174;167;62;41;92;Magic Effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;161;-6656,624;Inherit;False;1922;565;;9;155;138;136;140;100;137;160;208;209;Sparks Animation Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;157;-4224,-608;Inherit;False;644;233;;3;151;152;154;Global Cordinates;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;88;-4226.768,-6.462762;Inherit;False;667.847;280;;2;6;87;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;86;-4226.768,-326.4628;Inherit;False;854;280;;3;1;83;84;Base Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-6272,672;Inherit;False;154;UV_GlobalCordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;138;-5984,672;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;136;-6176,752;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;140;-6304,752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;-4960,912;Inherit;False;MASK_Sparks;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;168;-6368,-128;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;170;-6208,-128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-6048,-352;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-6016,0;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-6016,160;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;-6592,352;Inherit;False;160;MASK_Sparks;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-6592,432;Inherit;False;61;Magic__Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-6288,368;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;174;-5824,64;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;167;-5696,64;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-5696,160;Inherit;False;72;Activate;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;-5552,-880;Inherit;False;191;TEX_MagicMAsk;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;-5552,-784;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;183;-6160,-880;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-6320,-912;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;184;-6320,-816;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;186;-6608,-976;Inherit;False;154;UV_GlobalCordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-6160,-624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;194;-6400,-576;Inherit;False;72;Activate;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-5328,-880;Inherit;True;Property;_MagicMask;MagicMask;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;4c51f2036ac9ae74a9a6b0299220edf7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;180;-5904,-880;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-5024,-880;Inherit;False;Magic__Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-6592,-80;Inherit;False;160;MASK_Sparks;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-6592,-160;Inherit;False;61;Magic__Mask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-3602.768,-278.4628;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-6288,-1280;Inherit;False;Activate;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;191;-6304,-1472;Inherit;False;TEX_MagicMAsk;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.FunctionNode;83;-3858.768,-278.4628;Inherit;False;CloudsPattern;-1;;10;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-3794.768,73.53723;Inherit;False;OUT_NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-3840,-560;Inherit;False;UV_GlobalCordinates;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-3826.768,361.5372;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-3698.768,361.5372;Inherit;False;OUT_Emissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;151;-4176,-560;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;152;-3984,-560;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-4162.768,553.5372;Inherit;False;92;COLOR_MagicEfffect;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-3072,-256;Inherit;False;84;OUT_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-3072,-160;Inherit;False;87;OUT_NormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;41;-5504,32;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-5344,32;Inherit;False;COLOR_MagicEfffect;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-6608,832;Inherit;False;Property;_SparksSpeed;Sparks Speed;12;0;Create;True;0;0;0;False;0;False;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-6608,0;Inherit;False;Property;_MagicActiveColor;Magic ActiveColor;5;0;Create;True;0;0;0;False;0;False;0,1,0.8446779,0;0,1,0.8446779,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;162;-6608,176;Inherit;False;Property;_SparksColor;Sparks Color;11;0;Create;True;0;0;0;False;0;False;1,0,0.9479666,0;1,0.2891653,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;185;-6608,-784;Inherit;False;Property;_DistortionSpeed;Distortion Speed;9;0;Create;True;0;0;0;False;0;False;0.0001;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-6400,-656;Inherit;False;Property;_DistortionFactor;Distortion Factor;8;0;Create;True;0;0;0;False;0;False;1;0.003;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;178;-5904,-720;Inherit;True;Property;_MagicDistortion;Magic Distortion;7;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;1a8de9010eebe93458719b1d94480e00;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;90;-6592,-352;Inherit;False;Property;_MagicInactiveColor;Magic InactiveColor;6;0;Create;True;0;0;0;False;0;False;0,1,0.8446779,0;0,1,0.8446779,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;189;-6608,-1472;Inherit;True;Property;_MagicMaskTex;Magic Mask Tex;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;4c51f2036ac9ae74a9a6b0299220edf7;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;188;-6609,-881;Inherit;False;Property;_DistortionScale;Distortion Scale;10;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-6608,-1280;Inherit;False;Property;_MagicActiveValue;Magic ActiveValue;3;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-4178.768,361.5372;Inherit;True;Property;_PBREmissive;PBR Emissive;2;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;9e8e306d5b8e2794587eb5031502a77c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-4178.768,41.53723;Inherit;True;Property;_PBRNormal;PBR Normal;1;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;3d22ecf38274270428c1139ffca03e44;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-4178.768,-278.4628;Inherit;True;Property;_PBRBaseColor;PBR BaseColor;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;0d823bc15b3011f4fa70263c4b9da4a2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;95;-3074.149,-64;Inherit;False;94;OUT_Emissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.VoronoiNode;208;-5675.327,865.6059;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TFHCGrayscale;209;-5486.369,879.3992;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-5991.143,890.8201;Inherit;False;Property;_SparksScale;Sparks Scale;13;0;Create;True;0;0;0;False;0;False;2;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;210;-2752,-176;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;BranchKid;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;138;0;155;0
WireConnection;138;2;136;0
WireConnection;136;1;140;0
WireConnection;140;0;137;0
WireConnection;160;0;209;0
WireConnection;168;0;73;0
WireConnection;168;1;169;0
WireConnection;170;0;168;0
WireConnection;91;0;90;0
WireConnection;91;1;73;0
WireConnection;70;0;170;0
WireConnection;70;1;34;0
WireConnection;163;0;162;0
WireConnection;163;1;172;0
WireConnection;172;0;164;0
WireConnection;172;1;171;0
WireConnection;174;0;70;0
WireConnection;174;1;163;0
WireConnection;167;0;174;0
WireConnection;182;0;180;0
WireConnection;182;1;178;0
WireConnection;183;0;187;0
WireConnection;183;2;184;0
WireConnection;187;0;186;0
WireConnection;187;1;188;0
WireConnection;184;1;185;0
WireConnection;195;0;179;0
WireConnection;195;1;194;0
WireConnection;10;0;192;0
WireConnection;10;1;182;0
WireConnection;61;0;10;1
WireConnection;84;0;83;0
WireConnection;72;0;71;0
WireConnection;191;0;189;0
WireConnection;83;21;1;0
WireConnection;87;0;6;0
WireConnection;154;0;152;0
WireConnection;14;0;9;0
WireConnection;14;1;93;0
WireConnection;94;0;14;0
WireConnection;152;0;151;1
WireConnection;152;1;151;2
WireConnection;41;0;91;0
WireConnection;41;1;167;0
WireConnection;41;2;62;0
WireConnection;92;0;41;0
WireConnection;178;1;183;0
WireConnection;178;5;195;0
WireConnection;208;0;138;0
WireConnection;208;2;100;0
WireConnection;209;0;208;1
WireConnection;210;0;85;0
WireConnection;210;1;89;0
WireConnection;210;2;95;0
ASEEND*/
//CHKSM=AFEB3AD2D1663A1904E4BE442F27FF4848BC131C