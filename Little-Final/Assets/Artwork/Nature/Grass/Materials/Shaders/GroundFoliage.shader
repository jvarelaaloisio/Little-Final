// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Nature/GroundFoliage"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[NoScaleOffset]_GrassAlpha("Grass Alpha", 2D) = "white" {}
		_ColorMultiplierBottom("Color Multiplier Bottom", Color) = (0,0,0,0)
		_ColorMultiplierTop("Color Multiplier Top", Color) = (0,0,0,0)
		_Smootheness("Smootheness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float WindSpeed;
		uniform float WindTurbulence;
		uniform float WindIntensity;
		uniform float WindDirX;
		uniform float WindDirZ;
		uniform float BigWindFactor;
		uniform float BigWindSpeed;
		uniform float BigWindScale;
		uniform sampler2D _GrassAlpha;
		uniform float4 _ColorMultiplierBottom;
		uniform float4 _ColorMultiplierTop;
		uniform float _Smootheness;
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
			float mulTime11 = _Time.y * WindSpeed;
			float4 appendResult14 = (float4(mulTime11 , 0.0 , 0.0 , 0.0));
			float2 uv_TexCoord17 = v.texcoord.xy + appendResult14.xy;
			float simplePerlin2D19 = snoise( uv_TexCoord17*(0.5 + (WindTurbulence - 0.0) * (0.7 - 0.5) / (1.0 - 0.0)) );
			simplePerlin2D19 = simplePerlin2D19*0.5 + 0.5;
			float temp_output_21_0 = (0.0 + (simplePerlin2D19 - 0.0) * (WindIntensity - 0.0) / (1.0 - 0.0));
			float3 appendResult18 = (float3(WindDirX , ( ( ( abs( WindDirX ) + abs( WindDirZ ) ) / 4.0 ) * -1.0 ) , WindDirZ));
			float3 break22 = appendResult18;
			float3 appendResult30 = (float3(( temp_output_21_0 + break22.x ) , break22.y , ( break22.z + temp_output_21_0 )));
			float4 transform34 = mul(unity_WorldToObject,float4( ( appendResult30 * v.color.r ) , 0.0 ));
			float2 temp_cast_2 = (BigWindSpeed).xx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult26 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner10_g1 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult26 * BigWindScale ));
			float simplePerlin2D11_g1 = snoise( panner10_g1 );
			simplePerlin2D11_g1 = simplePerlin2D11_g1*0.5 + 0.5;
			float temp_output_36_0 = ( BigWindFactor * simplePerlin2D11_g1 );
			float4 lerpResult38 = lerp( transform34 , float4( 0,0,0,0 ) , temp_output_36_0);
			float4 OUT_VertexOffset198 = lerpResult38;
			v.vertex.xyz += OUT_VertexOffset198.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_GrassAlpha35 = i.uv_texcoord;
			float4 tex2DNode35 = tex2D( _GrassAlpha, uv_GrassAlpha35 );
			float4 lerpResult182 = lerp( _ColorMultiplierBottom , _ColorMultiplierTop , saturate( ( i.vertexColor.r + -0.3 ) ));
			float4 temp_output_177_0 = saturate( ( tex2DNode35 * lerpResult182 ) );
			float4 temp_output_21_0_g25 = temp_output_177_0;
			float4 color20_g25 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_0 = (0.1).xx;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5_g25 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g25 = ( 0.01 * 1.5 );
			float2 panner10_g26 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult5_g25 * temp_output_2_0_g25 ));
			float simplePerlin2D11_g26 = snoise( panner10_g26 );
			simplePerlin2D11_g26 = simplePerlin2D11_g26*0.5 + 0.5;
			float temp_output_8_0_g25 = simplePerlin2D11_g26;
			float2 temp_cast_1 = (0.1).xx;
			float2 panner10_g28 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g25 * 0.01 ));
			float simplePerlin2D11_g28 = snoise( panner10_g28 );
			simplePerlin2D11_g28 = simplePerlin2D11_g28*0.5 + 0.5;
			float2 temp_cast_2 = (0.1).xx;
			float2 panner10_g27 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g25 * ( temp_output_2_0_g25 * 4.0 ) ));
			float simplePerlin2D11_g27 = snoise( panner10_g27 );
			simplePerlin2D11_g27 = simplePerlin2D11_g27*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g25 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g25 * simplePerlin2D11_g28 ) + ( 1.0 - simplePerlin2D11_g27 ) ) * temp_output_8_0_g25 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g25 = lerp( temp_output_21_0_g25 , saturate( ( temp_output_21_0_g25 * color20_g25 ) ) , ( temp_output_16_0_g25 * 1.0 ));
			float4 OUT_BaseColor197 = lerpResult24_g25;
			o.Albedo = OUT_BaseColor197.rgb;
			o.Smoothness = _Smootheness;
			o.Alpha = 1;
			float OUT_Opacity110 = tex2DNode35.a;
			clip( OUT_Opacity110 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.CommentaryNode;1;-3046.242,251.0551;Inherit;False;994.9999;442.4537;Wind direction;8;18;15;12;10;9;8;6;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2;-3460.109,-141.2107;Inherit;False;1415.002;363.6343;Indiviudual Animation;9;21;20;19;17;16;14;13;11;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2991.242,444.5092;Inherit;False;Global;WindDirX;Wind Dir X;3;0;Create;True;0;0;0;False;0;False;0;0.1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2998.86,578.8185;Inherit;False;Global;WindDirZ;Wind Dir Z;4;0;Create;True;0;0;0;False;0;False;0;0.2;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;8;-2836.013,301.0552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;9;-2823.013,370.0552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3410.109,-4.978752;Inherit;False;Global;WindSpeed;Wind Speed;0;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-3134.244,-3.968742;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-2692.242,321.5091;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-2936.313,-91.21068;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;-2548.242,319.5091;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3407.625,105.3251;Inherit;False;Global;WindTurbulence;Wind Turbulence;0;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2788.244,-81.96861;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2404.242,321.5091;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;16;-2936.218,50.52122;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;19;-2578.968,-76.69066;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;145;-1074.289,335.8098;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;18;-2212.242,417.5092;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2668.292,78.42316;Inherit;False;Global;WindIntensity;WindIntensity;0;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;22;-1819.439,253.3982;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;3;-1387.339,745.7778;Inherit;False;1160.323;331.917;World Noise Mask;8;36;32;33;29;28;26;24;156;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;186;-1061.27,-338.4187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;21;-2342.105,-86.21068;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;187;-916.7853,-308.7509;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;152;-1569.366,-571.7554;Inherit;False;Property;_ColorMultiplierBottom;Color Multiplier Bottom;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.009211458,0.216981,0.04313292,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;188;-1568.055,-375.677;Inherit;False;Property;_ColorMultiplierTop;Color Multiplier Top;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.0933779,0.589,0.103508,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1531.439,173.3982;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-1531.439,381.3982;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;24;-1337.339,939.7767;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;30;-1307.439,253.3982;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1336.339,783.7778;Inherit;False;Global;BigWindSpeed;BigWindSpeed;1;0;Create;True;0;0;0;False;0;False;1;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1336.339,859.7778;Inherit;False;Global;BigWindScale;BigWindScale;2;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-1129.338,987.7767;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;182;-793.3932,-460.5916;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;35;-1340.21,-769.6939;Inherit;True;Property;_GrassAlpha;Grass Alpha;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;0b4fa66ba8525c14db71975a0b784d48;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-874.211,-716.6939;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;32;-937.3391,875.7767;Inherit;False;WorldNoise;-1;;1;f17c4c9c155f92e4cb0e3f353a46552a;0;3;14;FLOAT2;0,0;False;13;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-780.572,255.728;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-947.4885,783.1777;Inherit;False;Global;BigWindFactor;BigWindFactor;0;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-667.4898,784.1777;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;177;-737.4132,-704.8626;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;34;-562.9089,253.3982;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;38;-306.909,253.3982;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;180;-123.6026,-527.4822;Inherit;False;CloudsPattern;-1;;25;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;-450.2317,856.1078;Inherit;False;BigWindMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;194;-571.3267,0.3740768;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;-717.8115,-12.29375;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;196;-176.4896,-345.8166;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-1039,-594;Inherit;False;OUT_Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;87.69258,-236.0688;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-294.2093,31.81444;Inherit;False;Property;_Smootheness;Smootheness;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;192;-368.4299,-226.7824;Inherit;False;Global;_GrabScreen0;Grab Screen 0;4;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;111;-279.4337,132.6106;Inherit;False;110;OUT_Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;221;436.5948,-89.18446;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Nature/GroundFoliage;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;198;83.72791,192.2908;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
WireConnection;8;0;6;0
WireConnection;9;0;5;0
WireConnection;11;0;7;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;14;0;11;0
WireConnection;12;0;10;0
WireConnection;17;1;14;0
WireConnection;15;0;12;0
WireConnection;16;0;13;0
WireConnection;19;0;17;0
WireConnection;19;1;16;0
WireConnection;18;0;6;0
WireConnection;18;1;15;0
WireConnection;18;2;5;0
WireConnection;22;0;18;0
WireConnection;186;0;145;1
WireConnection;21;0;19;0
WireConnection;21;4;20;0
WireConnection;187;0;186;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;25;0;22;2
WireConnection;25;1;21;0
WireConnection;30;0;23;0
WireConnection;30;1;22;1
WireConnection;30;2;25;0
WireConnection;26;0;24;1
WireConnection;26;1;24;3
WireConnection;182;0;152;0
WireConnection;182;1;188;0
WireConnection;182;2;187;0
WireConnection;151;0;35;0
WireConnection;151;1;182;0
WireConnection;32;14;29;0
WireConnection;32;13;28;0
WireConnection;32;2;26;0
WireConnection;92;0;30;0
WireConnection;92;1;145;1
WireConnection;36;0;33;0
WireConnection;36;1;32;0
WireConnection;177;0;151;0
WireConnection;34;0;92;0
WireConnection;38;0;34;0
WireConnection;38;2;36;0
WireConnection;180;21;177;0
WireConnection;156;0;36;0
WireConnection;194;0;195;0
WireConnection;195;0;145;1
WireConnection;196;0;192;0
WireConnection;196;1;177;0
WireConnection;196;2;194;0
WireConnection;110;0;35;4
WireConnection;197;0;180;0
WireConnection;221;0;197;0
WireConnection;221;4;220;0
WireConnection;221;10;111;0
WireConnection;221;11;198;0
WireConnection;198;0;38;0
ASEEND*/
//CHKSM=446E949A2B37B3A594CFD8C856404416B4124210