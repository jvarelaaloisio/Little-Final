// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lemu/Nature/Cave"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "white" {}
		_Tiling("Tiling", Float) = 5
		_LevelsMin("Levels Min ", Float) = 0
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
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _Tiling;
		uniform float _LevelsMin;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;


		float2 voronoihash3( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi3( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
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
			 		float2 o = voronoihash3( n + g );
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
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = tex2D( _NormalMap, uv_NormalMap ).rgb;
			float4 color12 = IsGammaSpace() ? float4(0,1,0.756779,0) : float4(0,1,0.5331445,0);
			float time3 = _Time.y;
			float2 voronoiSmoothId3 = 0;
			float2 temp_cast_1 = (_Tiling).xx;
			float2 uv_TexCoord4 = i.uv_texcoord * temp_cast_1;
			float2 coords3 = uv_TexCoord4 * 0.31;
			float2 id3 = 0;
			float2 uv3 = 0;
			float voroi3 = voronoi3( coords3, time3, id3, uv3, 0, voronoiSmoothId3 );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = ( ( color12 * saturate( (_LevelsMin + (voroi3 - 0.0) * (1.0 - _LevelsMin) / (1.0 - 0.0)) ) ) * tex2D( _Albedo, uv_Albedo ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.RangedFloatNode;5;-1057.908,-245.5592;Inherit;False;Property;_Tiling;Tiling;2;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1051.727,-119.5973;Inherit;False;Constant;_Speed;Speed;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-884.0653,-287.4484;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-844.3572,-58.7007;Inherit;False;Constant;_VoronoidScale;Voronoid Scale;3;0;Create;True;0;0;0;False;0;False;0.31;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-847.7271,-152.5973;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-366.2139,-108.9231;Inherit;False;Property;_LevelsMin;Levels Min ;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-358.2139,-28.9231;Inherit;False;Constant;_LevelsMax;Levels Max;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;3;-526.8267,-227.1706;Inherit;True;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TFHCRemapNode;8;-198.3327,-214.3089;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;119.2554,-144.8546;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-157.6222,-421.2021;Inherit;False;Constant;_Color0;Color 0;4;0;Create;True;0;0;0;False;0;False;0,1,0.756779,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-932.2249,34.39409;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;336.1581,-205.8577;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-918.5541,374.1815;Inherit;True;Property;_NormalMap;Normal Map;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;476.0433,-22.55444;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;27;619.9024,5.653436;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lemu/Nature/Cave;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;5;0
WireConnection;15;0;16;0
WireConnection;3;0;4;0
WireConnection;3;1;15;0
WireConnection;3;2;7;0
WireConnection;8;0;3;0
WireConnection;8;3;9;0
WireConnection;8;4;10;0
WireConnection;11;0;8;0
WireConnection;13;0;12;0
WireConnection;13;1;11;0
WireConnection;14;0;13;0
WireConnection;14;1;1;0
WireConnection;27;0;14;0
WireConnection;27;1;2;0
ASEEND*/
//CHKSM=628C4D60EEA43F76ED822F7F0B6D591614485A98