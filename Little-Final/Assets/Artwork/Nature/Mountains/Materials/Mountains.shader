// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Mountains"
{
	Properties
	{
		[NoScaleOffset]_BaseColor("Base Color", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _BaseColor;
		uniform float _Smoothness;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BaseColor23 = i.uv_texcoord;
			float4 tex2DNode23 = tex2D( _BaseColor, uv_BaseColor23 );
			float4 temp_output_21_0_g1 = tex2DNode23;
			float4 color20_g1 = IsGammaSpace() ? float4(0.509434,0.509434,0.509434,0) : float4(0.2228772,0.2228772,0.2228772,0);
			float2 temp_cast_0 = (0.1).xx;
			float3 ase_worldPos = i.worldPos;
			float2 appendResult5_g1 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_2_0_g1 = ( 0.01 * 1.5 );
			float2 panner10_g8 = ( 1.0 * _Time.y * temp_cast_0 + ( appendResult5_g1 * temp_output_2_0_g1 ));
			float simplePerlin2D11_g8 = snoise( panner10_g8 );
			simplePerlin2D11_g8 = simplePerlin2D11_g8*0.5 + 0.5;
			float temp_output_8_0_g1 = simplePerlin2D11_g8;
			float2 temp_cast_1 = (0.1).xx;
			float2 panner10_g12 = ( 1.0 * _Time.y * temp_cast_1 + ( appendResult5_g1 * 0.01 ));
			float simplePerlin2D11_g12 = snoise( panner10_g12 );
			simplePerlin2D11_g12 = simplePerlin2D11_g12*0.5 + 0.5;
			float2 temp_cast_2 = (0.1).xx;
			float2 panner10_g11 = ( 1.0 * _Time.y * temp_cast_2 + ( appendResult5_g1 * ( temp_output_2_0_g1 * 4.0 ) ));
			float simplePerlin2D11_g11 = snoise( panner10_g11 );
			simplePerlin2D11_g11 = simplePerlin2D11_g11*0.5 + 0.5;
			float3 _Vector2 = float3(0,-1.6,1);
			float temp_output_16_0_g1 = saturate( (_Vector2.y + (( ( ( temp_output_8_0_g1 * simplePerlin2D11_g12 ) + ( 1.0 - simplePerlin2D11_g11 ) ) * temp_output_8_0_g1 ) - 0.0) * (_Vector2.z - _Vector2.y) / (1.0 - 0.0)) );
			float4 lerpResult24_g1 = lerp( temp_output_21_0_g1 , saturate( ( temp_output_21_0_g1 * color20_g1 ) ) , ( temp_output_16_0_g1 * 1.0 ));
			float4 OUT_BaseColor25 = lerpResult24_g1;
			o.Albedo = OUT_BaseColor25.rgb;
			float grayscale38 = Luminance(tex2DNode23.rgb);
			o.Smoothness = ( grayscale38 * _Smoothness );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.SamplerNode;23;-473.368,-84.06703;Inherit;True;Property;_BaseColor;Base Color;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;e49eaddf99fa9b4419ab824b0874440f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;24;-102.9318,-63.60095;Inherit;False;CloudsPattern;-1;;1;bc2eb12446620194aa304028cc3322f4;0;1;21;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;29
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;165.6855,19.79833;Inherit;False;OUT_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;99.90454,161.5163;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-193.7837,207.5649;Inherit;False;Property;_Smoothness;Smoothness;1;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;38;-136.4787,86.81509;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;39;412.0275,-12.14258;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Mountains;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;21;23;0
WireConnection;25;0;24;0
WireConnection;37;0;38;0
WireConnection;37;1;36;0
WireConnection;38;0;23;0
WireConnection;39;0;25;0
WireConnection;39;4;37;0
ASEEND*/
//CHKSM=05E5E1E00BC9E2855B3CE2A37EC8584EEE771A1E