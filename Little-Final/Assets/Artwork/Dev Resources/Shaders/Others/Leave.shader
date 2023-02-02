// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Drimys/Nature/TEST/Leave"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[NoScaleOffset]_BaseColor1("Base Color", 2D) = "white" {}
		_BaseColorHue1("Base Color Hue", Range( -1 , 1)) = 0
		_BaseColorSaturation1("Base Color Saturation", Range( -1 , 1)) = 0
		_BaseColorValue1("Base Color Value", Range( -1 , 1)) = 0
		_LocalWindMask1("Local Wind Mask", Range( -1 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma exclude_renderers vulkan xbox360 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows nolightmap  nodirlightmap vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float WindSpeed1;
		uniform float WindTurbulence1;
		uniform float WindIntensity1;
		uniform float WindDirX1;
		uniform float WindDirZ1;
		uniform float _LocalWindMask1;
		uniform float WindMaskGlobal1;
		uniform float WindSpeedGlobal1;
		uniform float WindIntensityGlobal1;
		uniform sampler2D _BaseColor1;
		uniform float _BaseColorHue1;
		uniform float _BaseColorSaturation1;
		uniform float _BaseColorValue1;
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


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime959 = _Time.y * WindSpeed1;
			float4 appendResult961 = (float4(mulTime959 , 0.0 , 0.0 , 0.0));
			float2 uv_TexCoord965 = v.texcoord.xy + appendResult961.xy;
			float simplePerlin2D968 = snoise( uv_TexCoord965*(0.5 + (WindTurbulence1 - 0.0) * (0.7 - 0.5) / (1.0 - 0.0)) );
			simplePerlin2D968 = simplePerlin2D968*0.5 + 0.5;
			float temp_output_971_0 = (0.0 + (simplePerlin2D968 - 0.0) * (WindIntensity1 - 0.0) / (1.0 - 0.0));
			float3 appendResult966 = (float3(WindDirX1 , ( ( ( abs( WindDirX1 ) + abs( WindDirZ1 ) ) / 4.0 ) * -1.0 ) , WindDirZ1));
			float3 break970 = appendResult966;
			float3 appendResult985 = (float3(( temp_output_971_0 + break970.x ) , break970.y , ( break970.z + temp_output_971_0 )));
			float4 transform993 = mul(unity_WorldToObject,float4( ( appendResult985 * (0.0 + (v.color.r - 0.0) * (_LocalWindMask1 - 0.0) / (1.0 - 0.0)) ) , 0.0 ));
			float2 temp_cast_2 = (WindSpeedGlobal1).xx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult979 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner10_g1 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult979 * WindIntensityGlobal1 ));
			float simplePerlin2D11_g1 = snoise( panner10_g1 );
			simplePerlin2D11_g1 = simplePerlin2D11_g1*0.5 + 0.5;
			float4 lerpResult1001 = lerp( transform993 , float4( 0,0,0,0 ) , ( WindMaskGlobal1 * simplePerlin2D11_g1 ));
			v.vertex.xyz += lerpResult1001.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BaseColor1977 = i.uv_texcoord;
			float4 tex2DNode977 = tex2D( _BaseColor1, uv_BaseColor1977 );
			float3 hsvTorgb980 = RGBToHSV( tex2DNode977.rgb );
			float3 hsvTorgb994 = HSVToRGB( float3(( hsvTorgb980.x + _BaseColorHue1 ),( hsvTorgb980.y + _BaseColorSaturation1 ),( hsvTorgb980.z + _BaseColorValue1 )) );
			o.Albedo = saturate( hsvTorgb994 );
			float temp_output_1000_0 = 0.0;
			o.Metallic = temp_output_1000_0;
			o.Smoothness = temp_output_1000_0;
			o.Alpha = 1;
			clip( tex2DNode977.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18500
433;862;1721;777;-3539.409;-615.6719;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;951;1332.624,1651.995;Inherit;False;994.9999;442.4537;Wind direction;8;966;963;960;958;957;955;953;952;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;952;1387.624,1845.449;Inherit;False;Global;WindDirX1;Wind Dir X;3;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;953;1380.006,1979.758;Inherit;False;Global;WindDirZ1;Wind Dir Z;4;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;954;918.7573,1259.729;Inherit;False;1415.002;363.6343;Indiviudual Animation;9;971;968;967;965;964;962;961;959;956;;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;955;1542.854,1701.995;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;956;968.7573,1395.961;Inherit;False;Global;WindSpeed1;Wind Speed;6;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;957;1543.854,1766.995;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;958;1686.625,1722.449;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;959;1244.622,1396.971;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;961;1442.553,1309.729;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;960;1830.625,1720.449;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;962;971.2415,1506.265;Inherit;False;Global;WindTurbulence1;Wind Turbulence;7;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;964;1442.648,1451.461;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;965;1590.623,1318.971;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;963;1975.625,1721.449;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;966;2166.625,1818.449;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;967;1710.574,1479.363;Inherit;False;Global;WindIntensity1;Wind Intensity;5;0;Create;True;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;968;1799.899,1324.249;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;969;2935.61,1877.832;Inherit;False;917;338;World Noise;7;996;990;987;984;979;978;975;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;970;2701.855,1378.385;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TFHCRemapNode;971;2036.761,1314.729;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;976;2989.855,1298.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;977;2530.427,717.1143;Inherit;True;Property;_BaseColor1;Base Color;1;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;1b809707a40e00848b713afa7b55bbe6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;975;2985.61,2071.83;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;974;2980.855,1486.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;973;2640.02,1547.161;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;972;2616.535,1731.001;Inherit;False;Property;_LocalWindMask1;Local Wind Mask;7;0;Create;True;0;0;False;0;False;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;984;2986.611,1915.832;Inherit;False;Global;WindSpeedGlobal1;Wind Speed (Global);1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;979;3193.611,2119.83;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;981;3156.534,1579.033;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;986;3253.454,917.2249;Inherit;False;Property;_BaseColorValue1;Base Color Value;4;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;980;3254.132,637.7343;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;978;2986.611,1991.832;Inherit;False;Global;WindIntensityGlobal1;Wind Intensity(Global);2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;985;3213.855,1378.385;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;983;3253.57,847.6741;Inherit;False;Property;_BaseColorSaturation1;Base Color Saturation;3;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;982;3252.953,776.8793;Inherit;False;Property;_BaseColorHue1;Base Color Hue;2;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;992;3670.338,864.0525;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;990;3385.61,2007.83;Inherit;False;WorldNoise;-1;;1;f17c4c9c155f92e4cb0e3f353a46552a;0;3;14;FLOAT;0;False;13;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;989;3670.338,672.0526;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;991;3458.765,1361.09;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;987;3375.46,1915.232;Inherit;False;Global;WindMaskGlobal1;Wind Mask (Global);0;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;988;3670.338,768.0526;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;993;3916.687,1372.483;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.HSVToRGBNode;994;3814.338,736.0526;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;996;3655.459,1916.232;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1000;4480.268,1123.058;Inherit;False;Constant;_Float2;Float 1;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1005;3014.262,37.74989;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;999;3519.401,-208.2804;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1001;4172.687,1372.483;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;1004;3201.381,31.16868;Inherit;True;Global;_CameraGBufferTexture1;_CameraGBufferTexture0;6;0;Create;True;0;0;False;0;False;-1;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;1003;3011.868,-195.3531;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1002;4177.151,193.8636;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;1006;4133.273,864.9236;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;998;3245.965,-102.0737;Inherit;False;Property;_GroundBlend1;GroundBlend;5;0;Create;True;0;0;False;0;False;0;4.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4713.688,1054.534;Float;False;True;-1;2;;0;0;Standard;Drimys/Nature/TEST/Leave;False;False;False;False;False;False;True;False;True;False;False;False;False;False;False;False;True;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;9;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;xboxone;ps4;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;892;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;955;0;952;0
WireConnection;957;0;953;0
WireConnection;958;0;955;0
WireConnection;958;1;957;0
WireConnection;959;0;956;0
WireConnection;961;0;959;0
WireConnection;960;0;958;0
WireConnection;964;0;962;0
WireConnection;965;1;961;0
WireConnection;963;0;960;0
WireConnection;966;0;952;0
WireConnection;966;1;963;0
WireConnection;966;2;953;0
WireConnection;968;0;965;0
WireConnection;968;1;964;0
WireConnection;970;0;966;0
WireConnection;971;0;968;0
WireConnection;971;4;967;0
WireConnection;976;0;971;0
WireConnection;976;1;970;0
WireConnection;974;0;970;2
WireConnection;974;1;971;0
WireConnection;979;0;975;1
WireConnection;979;1;975;3
WireConnection;981;0;973;1
WireConnection;981;4;972;0
WireConnection;980;0;977;0
WireConnection;985;0;976;0
WireConnection;985;1;970;1
WireConnection;985;2;974;0
WireConnection;992;0;980;3
WireConnection;992;1;986;0
WireConnection;990;14;984;0
WireConnection;990;13;978;0
WireConnection;990;2;979;0
WireConnection;989;0;980;1
WireConnection;989;1;982;0
WireConnection;991;0;985;0
WireConnection;991;1;981;0
WireConnection;988;0;980;2
WireConnection;988;1;983;0
WireConnection;993;0;991;0
WireConnection;994;0;989;0
WireConnection;994;1;988;0
WireConnection;994;2;992;0
WireConnection;996;0;987;0
WireConnection;996;1;990;0
WireConnection;999;0;1003;1
WireConnection;999;4;998;0
WireConnection;1001;0;993;0
WireConnection;1001;2;996;0
WireConnection;1004;1;1005;0
WireConnection;1002;0;1004;0
WireConnection;1002;1;994;0
WireConnection;1002;2;999;0
WireConnection;1006;0;994;0
WireConnection;0;0;1006;0
WireConnection;0;3;1000;0
WireConnection;0;4;1000;0
WireConnection;0;10;977;4
WireConnection;0;11;1001;0
ASEEND*/
//CHKSM=A2FBC3F0E799B280C5CB8AD2C2E2832839F42F98