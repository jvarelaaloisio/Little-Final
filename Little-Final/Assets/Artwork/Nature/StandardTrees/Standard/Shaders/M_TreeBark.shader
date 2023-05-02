// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_TreeBark"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 1
		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.6
		_BarkTiling("Bark Tiling", Range( 0 , 10)) = 1
		_BarkAspectRelation("Bark Aspect Relation", Range( 1 , 10)) = 5
		_BarkExtrusion("Bark Extrusion", Range( 0 , 1)) = 0
		_BarkPattern2Seed("Bark Pattern 2 Seed", Range( 0 , 360)) = 0
		_BarkPattern2Tiling("Bark Pattern 2 Tiling", Range( 0 , 20)) = 5
		_BarkPattern2Strength("Bark Pattern 2 Strength", Range( 0 , 10)) = 2
		_CreviceBaseSize("Crevice Base Size", Range( 0 , 1)) = 0.5862549
		_BarkStrength("Bark Strength", Range( 0 , 10)) = 1
		_CreviceBaseStrength("Crevice Base Strength", Range( 0 , 1)) = 0.5
		_CreviceDetailsSize("Crevice Details Size", Range( 0 , 1)) = 0.91
		_CreviceDetailsStrength("Crevice Details Strength", Range( 0 , 1)) = 0.5
		_HighlightsSpread("Highlights Spread", Range( 0 , 1)) = 0.64
		_HighlightsStrength("Highlights Strength", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction tessphong:_TessPhongStrength 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _BarkTiling;
		uniform float _BarkAspectRelation;
		uniform float _BarkPattern2Tiling;
		uniform float _BarkPattern2Seed;
		sampler2D _Sampler6040;
		uniform float _BarkPattern2Strength;
		uniform float _BarkStrength;
		uniform float _BarkExtrusion;
		uniform float _CreviceDetailsSize;
		uniform float _CreviceDetailsStrength;
		uniform float _CreviceBaseSize;
		uniform float _CreviceBaseStrength;
		uniform float _HighlightsSpread;
		uniform float _HighlightsStrength;
		uniform float _TessValue;
		uniform float _TessPhongStrength;


		float2 voronoihash4( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi4( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash4( n + g );
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
			
F1 = 8.0;
for ( int j = -2; j <= 2; j++ )
{
for ( int i = -2; i <= 2; i++ )
{
float2 g = mg + float2( i, j );
float2 o = voronoihash4( n + g );
		o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
float d = dot( 0.5 * ( r + mr ), normalize( r - mr ) );
F1 = min( F1, d );
}
}
return F1;
		}


		float2 voronoihash38( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi38( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash38( n + g );
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
			
F1 = 8.0;
for ( int j = -2; j <= 2; j++ )
{
for ( int i = -2; i <= 2; i++ )
{
float2 g = mg + float2( i, j );
float2 o = voronoihash38( n + g );
		o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
float d = dot( 0.5 * ( r + mr ), normalize( r - mr ) );
F1 = min( F1, d );
}
}
return F1;
		}


		struct Gradient
		{
			int type;
			int colorsLength;
			int alphasLength;
			float4 colors[8];
			float2 alphas[8];
		};


		Gradient NewGradient(int type, int colorsLength, int alphasLength, 
		float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
		float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
		{
			Gradient g;
			g.type = type;
			g.colorsLength = colorsLength;
			g.alphasLength = alphasLength;
			g.colors[ 0 ] = colors0;
			g.colors[ 1 ] = colors1;
			g.colors[ 2 ] = colors2;
			g.colors[ 3 ] = colors3;
			g.colors[ 4 ] = colors4;
			g.colors[ 5 ] = colors5;
			g.colors[ 6 ] = colors6;
			g.colors[ 7 ] = colors7;
			g.alphas[ 0 ] = alphas0;
			g.alphas[ 1 ] = alphas1;
			g.alphas[ 2 ] = alphas2;
			g.alphas[ 3 ] = alphas3;
			g.alphas[ 4 ] = alphas4;
			g.alphas[ 5 ] = alphas5;
			g.alphas[ 6 ] = alphas6;
			g.alphas[ 7 ] = alphas7;
			return g;
		}


		float4 SampleGradient( Gradient gradient, float time )
		{
			float3 color = gradient.colors[0].rgb;
			UNITY_UNROLL
			for (int c = 1; c < 8; c++)
			{
			float colorPos = saturate((time - gradient.colors[c-1].w) / ( 0.00001 + (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1));
			color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
			}
			#ifndef UNITY_COLORSPACE_GAMMA
			color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
			#endif
			float alpha = gradient.alphas[0].x;
			UNITY_UNROLL
			for (int a = 1; a < 8; a++)
			{
			float alphaPos = saturate((time - gradient.alphas[a-1].y) / ( 0.00001 + (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1));
			alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
			}
			return float4(color, alpha);
		}


		float4 tessFunction( )
		{
			return _TessValue;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_vertexNormal = v.normal.xyz;
			float time4 = 0.0;
			float2 voronoiSmoothId4 = 0;
			float2 appendResult18 = (float2(_BarkTiling , ( _BarkTiling / _BarkAspectRelation )));
			float2 uv_TexCoord1 = v.texcoord.xy * appendResult18;
			float2 coords4 = uv_TexCoord1 * 10.0;
			float2 id4 = 0;
			float2 uv4 = 0;
			float fade4 = 0.5;
			float voroi4 = 0;
			float rest4 = 0;
			for( int it4 = 0; it4 <2; it4++ ){
			voroi4 += fade4 * voronoi4( coords4, time4, id4, uv4, 0,voronoiSmoothId4 );
			rest4 += fade4;
			coords4 *= 2;
			fade4 *= 0.5;
			}//Voronoi4
			voroi4 /= rest4;
			float Bark_Vertical184 = voroi4;
			float time38 = _BarkPattern2Seed;
			float2 voronoiSmoothId38 = 0;
			float2 temp_output_1_0_g2 = float2( 1,1 );
			float2 appendResult10_g2 = (float2(( (temp_output_1_0_g2).x * v.texcoord.xy.x ) , ( v.texcoord.xy.y * (temp_output_1_0_g2).y )));
			float2 temp_output_11_0_g2 = float2( 0,0 );
			float2 panner18_g2 = ( ( (temp_output_11_0_g2).x * _Time.y ) * float2( 1,0 ) + v.texcoord.xy);
			float2 panner19_g2 = ( ( _Time.y * (temp_output_11_0_g2).y ) * float2( 0,1 ) + v.texcoord.xy);
			float2 appendResult24_g2 = (float2((panner18_g2).x , (panner19_g2).y));
			float2 temp_output_47_0_g2 = float2( 0,0 );
			float2 uv_TexCoord234 = v.texcoord.xy + float2( 0.5,-1 );
			float2 temp_output_31_0_g2 = ( uv_TexCoord234 - float2( 1,1 ) );
			float2 appendResult39_g2 = (float2(frac( ( atan2( (temp_output_31_0_g2).x , (temp_output_31_0_g2).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g2 )));
			float2 panner54_g2 = ( ( (temp_output_47_0_g2).x * _Time.y ) * float2( 1,0 ) + appendResult39_g2);
			float2 panner55_g2 = ( ( _Time.y * (temp_output_47_0_g2).y ) * float2( 0,1 ) + appendResult39_g2);
			float2 appendResult58_g2 = (float2((panner54_g2).x , (panner55_g2).y));
			float2 coords38 = ( ( (tex2Dlod( _Sampler6040, float4( ( appendResult10_g2 + appendResult24_g2 ), 0, 0.0) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g2 ) ) * _BarkPattern2Tiling;
			float2 id38 = 0;
			float2 uv38 = 0;
			float fade38 = 0.5;
			float voroi38 = 0;
			float rest38 = 0;
			for( int it38 = 0; it38 <2; it38++ ){
			voroi38 += fade38 * voronoi38( coords38, time38, id38, uv38, 0,voronoiSmoothId38 );
			rest38 += fade38;
			coords38 *= 2;
			fade38 *= 0.5;
			}//Voronoi38
			voroi38 /= rest38;
			float Bark_Sum23 = saturate( ( Bark_Vertical184 * saturate( ( voroi38 * _BarkPattern2Strength ) ) * _BarkStrength ) );
			float ExtrudeMultilplier137 = ( _BarkExtrusion / 300.0 );
			float3 VertexOffset27 = ( ase_vertex3Pos + ( ase_vertexNormal * Bark_Sum23 * ExtrudeMultilplier137 ) );
			v.vertex.xyz = VertexOffset27;
			v.vertex.w = 1;
			float4 ase_vertexTangent = v.tangent;
			float3 ase_vertexBitangent = cross( ase_vertexNormal, ase_vertexTangent) * v.tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
			float3x3 ObjectTangent93 = float3x3(ase_vertexTangent.xyz, ase_vertexBitangent, ase_vertexNormal);
			float Deviation99 = 0.05;
			float3 appendResult101 = (float3(Deviation99 , 0.0 , 0.0));
			float3 DeconstructionX122 = mul( ( mul( ase_vertex3Pos, ObjectTangent93 ) + appendResult101 ), ObjectTangent93 );
			float3 OffsetDeviationX140 = ( DeconstructionX122 + ( ase_vertexNormal * Bark_Sum23 * ExtrudeMultilplier137 ) );
			float3 appendResult116 = (float3(0.0 , Deviation99 , 0.0));
			float3 DeconstructionY123 = mul( ( mul( ase_vertex3Pos, ObjectTangent93 ) + appendResult116 ), ObjectTangent93 );
			float3 OffsetDeviationY149 = ( DeconstructionY123 + ( ase_vertexNormal * Bark_Sum23 * ExtrudeMultilplier137 ) );
			float3 normalizeResult157 = normalize( cross( ( OffsetDeviationY149 - VertexOffset27 ) , ( OffsetDeviationX140 - VertexOffset27 ) ) );
			float3 appendResult165 = (float3(OffsetDeviationX140.x , OffsetDeviationY149.y , normalizeResult157.z));
			float3 normalizeResult163 = normalize( appendResult165 );
			float3 ReconstructedNormal158 = normalizeResult163;
			v.normal = ReconstructedNormal158;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			Gradient gradient8 = NewGradient( 0, 4, 2, float4( 0.1215686, 0.09817342, 0.06892941, 0 ), float4( 0.1686275, 0.1154125, 0.07638824, 0.3470665 ), float4( 0.234, 0.1782857, 0.1337143, 0.6323491 ), float4( 0.277, 0.1802169, 0.1168072, 1 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float time4 = 0.0;
			float2 voronoiSmoothId4 = 0;
			float2 appendResult18 = (float2(_BarkTiling , ( _BarkTiling / _BarkAspectRelation )));
			float2 uv_TexCoord1 = i.uv_texcoord * appendResult18;
			float2 coords4 = uv_TexCoord1 * 10.0;
			float2 id4 = 0;
			float2 uv4 = 0;
			float fade4 = 0.5;
			float voroi4 = 0;
			float rest4 = 0;
			for( int it4 = 0; it4 <2; it4++ ){
			voroi4 += fade4 * voronoi4( coords4, time4, id4, uv4, 0,voronoiSmoothId4 );
			rest4 += fade4;
			coords4 *= 2;
			fade4 *= 0.5;
			}//Voronoi4
			voroi4 /= rest4;
			float Bark_Vertical184 = voroi4;
			float time38 = _BarkPattern2Seed;
			float2 voronoiSmoothId38 = 0;
			float2 temp_output_1_0_g2 = float2( 1,1 );
			float2 appendResult10_g2 = (float2(( (temp_output_1_0_g2).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g2).y )));
			float2 temp_output_11_0_g2 = float2( 0,0 );
			float2 panner18_g2 = ( ( (temp_output_11_0_g2).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g2 = ( ( _Time.y * (temp_output_11_0_g2).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g2 = (float2((panner18_g2).x , (panner19_g2).y));
			float2 temp_output_47_0_g2 = float2( 0,0 );
			float2 uv_TexCoord234 = i.uv_texcoord + float2( 0.5,-1 );
			float2 temp_output_31_0_g2 = ( uv_TexCoord234 - float2( 1,1 ) );
			float2 appendResult39_g2 = (float2(frac( ( atan2( (temp_output_31_0_g2).x , (temp_output_31_0_g2).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g2 )));
			float2 panner54_g2 = ( ( (temp_output_47_0_g2).x * _Time.y ) * float2( 1,0 ) + appendResult39_g2);
			float2 panner55_g2 = ( ( _Time.y * (temp_output_47_0_g2).y ) * float2( 0,1 ) + appendResult39_g2);
			float2 appendResult58_g2 = (float2((panner54_g2).x , (panner55_g2).y));
			float2 coords38 = ( ( (tex2D( _Sampler6040, ( appendResult10_g2 + appendResult24_g2 ) )).rg * 1.0 ) + ( float2( 1,1 ) * appendResult58_g2 ) ) * _BarkPattern2Tiling;
			float2 id38 = 0;
			float2 uv38 = 0;
			float fade38 = 0.5;
			float voroi38 = 0;
			float rest38 = 0;
			for( int it38 = 0; it38 <2; it38++ ){
			voroi38 += fade38 * voronoi38( coords38, time38, id38, uv38, 0,voronoiSmoothId38 );
			rest38 += fade38;
			coords38 *= 2;
			fade38 *= 0.5;
			}//Voronoi38
			voroi38 /= rest38;
			float Bark_Sum23 = saturate( ( Bark_Vertical184 * saturate( ( voroi38 * _BarkPattern2Strength ) ) * _BarkStrength ) );
			float4 BaseColor30 = SampleGradient( gradient8, Bark_Sum23 );
			o.Albedo = BaseColor30.rgb;
			float Bark_Vertical_OneMinus189 = ( 1.0 - Bark_Vertical184 );
			float smoothstepResult178 = smoothstep( ( 1.0 - _CreviceDetailsSize ) , ( 1.3 - ( _CreviceDetailsStrength / 3.0 ) ) , Bark_Vertical_OneMinus189);
			float CreviceDetails221 = smoothstepResult178;
			o.Metallic = CreviceDetails221;
			float smoothstepResult175 = smoothstep( ( 1.0 - ( _CreviceBaseSize / 2.0 ) ) , ( 1.3 - ( _CreviceBaseStrength / 3.0 ) ) , Bark_Vertical_OneMinus189);
			float Smoothness215 = saturate( ( smoothstepResult175 + CreviceDetails221 ) );
			o.Smoothness = Smoothness215;
			float temp_output_266_0 = ( 1.0 - _HighlightsSpread );
			float smoothstepResult226 = smoothstep( temp_output_266_0 , max( temp_output_266_0 , ( 1.0 - ( _HighlightsStrength / 2.0 ) ) ) , Bark_Sum23);
			float AO232 = smoothstepResult226;
			o.Occlusion = AO232;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.CommentaryNode;242;-591.8733,632.2859;Inherit;False;1474.316;677.6213;Smoothness and Metallic;19;209;253;210;206;256;175;205;252;202;215;180;179;251;249;176;221;178;208;193;Crevices;0.2031417,0.5029308,0.5188679,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;241;-392.4835,98.0242;Inherit;False;1219.814;353.5127;Ambient Oclussion;9;227;269;267;266;228;229;231;232;226;AO;0.3301887,0.3301887,0.3301887,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;159;921.5737,1415.387;Inherit;False;1606.072;451.9106;Reconstructed Normal;14;158;163;165;164;166;167;157;156;153;155;154;152;151;150;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;141;-431.4072,1421.587;Inherit;False;1060;413.9026;Offset Deviation X;7;132;133;134;136;131;138;140;Dev X;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;103;-1826,1454;Inherit;False;1057.3;417.2999;Deconstructed Vertex position from matrix;8;122;97;95;111;96;101;102;98;X deconstruction;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;94;-2778.145,994.2704;Inherit;False;819;553;;5;89;90;92;93;91;Normal Matrix;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;61;-1857.079,89.55908;Inherit;False;528.674;553.7462;;7;0;28;233;222;216;160;31;Output;0.4811321,0.1565949,0.1565949,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;60;-3028.676,422.157;Inherit;False;1155.85;397.2913;;10;137;12;247;248;26;5;128;27;129;6;Vertex Offset;0.5943396,0.5943396,0.5943396,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;57;-2783.661,84.78191;Inherit;False;834;275;;4;8;9;24;30;Color;0.7169812,0.4307645,0.1860093,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;56;-2757.001,-439.6907;Inherit;False;2245.296;501.3418;;25;23;270;262;264;263;237;72;73;4;70;71;238;239;38;18;236;234;14;189;188;184;40;15;16;1;Bark Pattern;0.2735849,0.1243568,0,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2142.001,-389.6907;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,0.15;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;16;-2446.001,-309.6906;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2734.001,-293.6906;Inherit;False;Property;_BarkAspectRelation;Bark Aspect Relation;6;0;Create;True;0;0;0;False;0;False;5;7.87;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;8;-2733.661,134.7819;Inherit;False;0;4;2;0.1215686,0.09817342,0.06892941,0;0.1686275,0.1154125,0.07638824,0.3470665;0.234,0.1782857,0.1337143,0.6323491;0.277,0.1802169,0.1168072,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.GradientSampleNode;9;-2509.661,134.7819;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;24;-2733.661,214.782;Inherit;False;23;Bark_Sum;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-2173.661,134.7819;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;40;-2336,-240;Inherit;False;RadialUVDistortion;-1;;2;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6040;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;0,0;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TangentVertexDataNode;89;-2728.145,1044.27;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BitangentVertexDataNode;90;-2728.145,1198.171;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;91;-2719.771,1353.62;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-1328,1504;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-1776,1728;Inherit;False;99;Deviation;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;101;-1520,1712;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-1520,1504;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;112;-1824,1952;Inherit;False;1059.7;397.6;Deconstructed Vertex position from matrix;8;123;119;118;117;116;115;114;113;Y deconstruction;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-1152,1504;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;113;-1328,2000;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;114;-1776,2000;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;115;-1776,2224;Inherit;False;99;Deviation;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;116;-1520,2208;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1520,2000;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-1152,2000;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-1776,2144;Inherit;False;93;ObjectTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.MatrixFromVectors;92;-2448,1200;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-2192,1200;Inherit;False;ObjectTangent;-1;True;1;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.PosVertexDataNode;95;-1776,1504;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;97;-1776,1648;Inherit;False;93;ObjectTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;-2209.959,581.5435;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;132;-345.0834,1480.561;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-38.3124,1619.623;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;251.6337,1551.947;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;391.5928,1546.489;Inherit;False;OffsetDeviationX;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;142;-413.0342,1975.49;Inherit;False;1060;413.9026;Offset Deviation Y;7;149;148;147;146;145;144;143;Dev Y;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalVertexDataNode;143;-326.7103,2034.464;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-19.9392,2173.526;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;145;270.0068,2105.851;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;-328.6269,2189.903;Inherit;False;23;Bark_Sum;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;-363.0342,2273.393;Inherit;False;137;ExtrudeMultilplier;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;409.9659,2100.393;Inherit;False;OffsetDeviationY;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-970.884,1498.991;Inherit;False;DeconstructionX;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-968,1996;Inherit;False;DeconstructionY;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-347,1636;Inherit;False;23;Bark_Sum;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-381.4072,1719.489;Inherit;False;137;ExtrudeMultilplier;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-116.2299,1471.587;Inherit;False;122;DeconstructionX;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;146;-97.85682,2025.49;Inherit;False;123;DeconstructionY;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;972.6301,1465.387;Inherit;False;140;OffsetDeviationX;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;151;1248.263,1470.551;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;152;975.3914,1547.667;Inherit;False;27;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;154;1247.207,1670.796;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;974.3349,1747.912;Inherit;False;27;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;971.5737,1666.818;Inherit;False;149;OffsetDeviationY;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode;156;1471.305,1553.599;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;157;1646.028,1554.599;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;167;1824,1472;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;166;1824,1600;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;164;1824,1728;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;165;1984,1600;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;163;2128,1600;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;2288,1600;Inherit;False;ReconstructedNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;184;-1664,-384;Inherit;False;Bark_Vertical;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;188;-1456,-288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;189;-1296,-288;Inherit;False;Bark_Vertical_OneMinus;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-2564.134,1772.699;Inherit;False;Constant;_Deviation;Deviation;6;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-2391.69,1776.114;Inherit;False;Deviation;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2734.001,-389.6907;Inherit;False;Property;_BarkTiling;Bark Tiling;5;0;Create;True;0;0;0;False;0;False;1;3;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;234;-2553.045,-152.1918;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;236;-2733.905,-99.36867;Inherit;False;Constant;_Vector2;Vector 2;11;0;Create;True;0;0;0;False;0;False;0.5,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;18;-2286.001,-389.6907;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;38;-1778.633,-240;Inherit;False;0;0;1;4;2;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.WireNode;239;-1944.687,-51.6217;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;238;-2214.687,-32.6217;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;71;-1430,-129;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1558,-129;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;226;347.3302,141.1373;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;232;603.3302,141.1373;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;231;91.33018,141.1373;Inherit;False;23;Bark_Sum;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;229;203.3302,269.1372;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;228;59.33018,333.1372;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;208;-207.0745,1076.35;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-1824,144;Inherit;False;30;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;-1824,544;Inherit;False;158;ReconstructedNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;216;-1824,304;Inherit;False;215;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;222;-1824,224;Inherit;False;221;CreviceDetails;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;233;-1824,384;Inherit;False;232;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1808,464;Inherit;False;27;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VoronoiNode;4;-1906,-389;Inherit;False;0;0;1;4;2;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-2064,576;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;128;-2512,464;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;5;-2736,464;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2736,624;Inherit;False;23;Bark_Sum;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;248;-2543.448,592.02;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;247;-2736,704;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;300;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-3008,704;Inherit;False;Property;_BarkExtrusion;Bark Extrusion;7;0;Create;True;0;0;0;False;0;False;0;0.599;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-2608,704;Inherit;False;ExtrudeMultilplier;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-2384,608;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-2165,-12;Inherit;False;Property;_BarkPattern2Tiling;Bark Pattern 2 Tiling;9;0;Create;True;0;0;0;False;0;False;5;18.3;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-512.1718,769.4825;Inherit;False;Property;_CreviceBaseSize;Crevice Base Size;11;0;Create;True;0;0;0;False;0;False;0.5862549;0.538;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;249;-96,768;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;251;-224,768;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-512,896;Inherit;False;Property;_CreviceBaseStrength;Crevice Base Strength;13;0;Create;True;0;0;0;False;0;False;0.5;0.17;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;252;-224,896;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;205;-96,864;Inherit;False;2;0;FLOAT;1.3;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1568,144;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;M_TreeBark;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;1;1;10;25;True;0.6;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;-1;-1;-1;0;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-1835,-59;Inherit;False;Property;_BarkPattern2Strength;Bark Pattern 2 Strength;10;0;Create;True;0;0;0;False;0;False;2;7;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-2501.815,-21.41842;Inherit;False;Property;_BarkPattern2Seed;Bark Pattern 2 Seed;8;0;Create;True;0;0;0;False;0;False;0;52;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;175;160.2313,749.6888;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.69;False;2;FLOAT;1.52;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;266;36.49604,224.5246;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;267;-222.7959,220.0412;Inherit;False;Property;_HighlightsSpread;Highlights Spread;16;0;Create;True;0;0;0;False;0;False;0.64;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;269;-96.30391,338.9164;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-368,336;Inherit;False;Property;_HighlightsStrength;Highlights Strength;17;0;Create;True;0;0;0;False;0;False;1;0.563;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;263;-1360,-48;Inherit;False;Property;_BarkStrength;Bark Strength;12;0;Create;True;0;0;0;False;0;False;1;1.67;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;264;-848,-368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;-976,-368;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;270;-1125.706,-143.6408;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;256;-192,688;Inherit;False;189;Bark_Vertical_OneMinus;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;206;-475.0747,1071.35;Inherit;False;Property;_CreviceDetailsSize;Crevice Details Size;14;0;Create;True;0;0;0;False;0;False;0.91;0.164;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-576,1168;Inherit;False;Property;_CreviceDetailsStrength;Crevice Details Strength;15;0;Create;True;0;0;0;False;0;False;0.5;0.096;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;253;-304,1168;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;209;-192,1168;Inherit;False;2;0;FLOAT;1.3;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;-176,992;Inherit;False;189;Bark_Vertical_OneMinus;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;180;576,752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;215;704,752;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;179;464,752;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;221;256,1056;Inherit;False;CreviceDetails;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;178;96,1056;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.91;False;2;FLOAT;1.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-698,-380;Inherit;False;Bark_Sum;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
WireConnection;1;0;18;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;9;0;8;0
WireConnection;9;1;24;0
WireConnection;30;0;9;0
WireConnection;40;29;234;0
WireConnection;98;0;96;0
WireConnection;98;1;101;0
WireConnection;101;0;102;0
WireConnection;96;0;95;0
WireConnection;96;1;97;0
WireConnection;111;0;98;0
WireConnection;111;1;97;0
WireConnection;113;0;117;0
WireConnection;113;1;116;0
WireConnection;116;1;115;0
WireConnection;117;0;114;0
WireConnection;117;1;119;0
WireConnection;118;0;113;0
WireConnection;118;1;119;0
WireConnection;92;0;89;0
WireConnection;92;1;90;0
WireConnection;92;2;91;0
WireConnection;93;0;92;0
WireConnection;129;0;128;0
WireConnection;129;1;6;0
WireConnection;133;0;132;0
WireConnection;133;1;131;0
WireConnection;133;2;138;0
WireConnection;134;0;136;0
WireConnection;134;1;133;0
WireConnection;140;0;134;0
WireConnection;144;0;143;0
WireConnection;144;1;147;0
WireConnection;144;2;148;0
WireConnection;145;0;146;0
WireConnection;145;1;144;0
WireConnection;149;0;145;0
WireConnection;122;0;111;0
WireConnection;123;0;118;0
WireConnection;151;0;150;0
WireConnection;151;1;152;0
WireConnection;154;0;153;0
WireConnection;154;1;155;0
WireConnection;156;0;154;0
WireConnection;156;1;151;0
WireConnection;157;0;156;0
WireConnection;167;0;150;0
WireConnection;166;0;153;0
WireConnection;164;0;157;0
WireConnection;165;0;167;0
WireConnection;165;1;166;1
WireConnection;165;2;164;2
WireConnection;163;0;165;0
WireConnection;158;0;163;0
WireConnection;184;0;4;0
WireConnection;188;0;184;0
WireConnection;189;0;188;0
WireConnection;99;0;100;0
WireConnection;234;1;236;0
WireConnection;18;0;14;0
WireConnection;18;1;16;0
WireConnection;38;0;40;0
WireConnection;38;1;239;0
WireConnection;38;2;73;0
WireConnection;239;0;238;0
WireConnection;238;0;237;0
WireConnection;71;0;70;0
WireConnection;70;0;38;0
WireConnection;70;1;72;0
WireConnection;226;0;231;0
WireConnection;226;1;266;0
WireConnection;226;2;229;0
WireConnection;232;0;226;0
WireConnection;229;0;266;0
WireConnection;229;1;228;0
WireConnection;228;0;269;0
WireConnection;208;0;206;0
WireConnection;4;0;1;0
WireConnection;27;0;129;0
WireConnection;248;0;5;0
WireConnection;247;0;12;0
WireConnection;137;0;247;0
WireConnection;6;0;248;0
WireConnection;6;1;26;0
WireConnection;6;2;137;0
WireConnection;249;0;251;0
WireConnection;251;0;176;0
WireConnection;252;0;202;0
WireConnection;205;1;252;0
WireConnection;0;0;31;0
WireConnection;0;3;222;0
WireConnection;0;4;216;0
WireConnection;0;5;233;0
WireConnection;0;11;28;0
WireConnection;0;12;160;0
WireConnection;175;0;256;0
WireConnection;175;1;249;0
WireConnection;175;2;205;0
WireConnection;266;0;267;0
WireConnection;269;0;227;0
WireConnection;264;0;262;0
WireConnection;262;0;184;0
WireConnection;262;1;270;0
WireConnection;262;2;263;0
WireConnection;270;0;71;0
WireConnection;253;0;210;0
WireConnection;209;1;253;0
WireConnection;180;0;179;0
WireConnection;215;0;180;0
WireConnection;179;0;175;0
WireConnection;179;1;221;0
WireConnection;221;0;178;0
WireConnection;178;0;193;0
WireConnection;178;1;208;0
WireConnection;178;2;209;0
WireConnection;23;0;264;0
ASEEND*/
//CHKSM=3A396E24A91E24D30D8B181211D9AF9952CB53B9