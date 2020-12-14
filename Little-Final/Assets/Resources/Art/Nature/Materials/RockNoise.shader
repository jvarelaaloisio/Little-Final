// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RockNoise"
{
	Properties
	{
		_Ashuda_1("Ashuda_1", Color) = (0.7989943,0.8962264,0.877612,0)
		_LEvels("LEvels", Vector) = (0,1,0,0.39)
		_Ashuda_2("Ashuda_2", Color) = (0.3331257,0.3584906,0.3536347,0)
		_Tiling("Tiling", Vector) = (12,2,0,0)
		_Float0("Float 0", Range( 0 , 15)) = 0
		_Scale("Scale", Float) = 0
		_AO("AO", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Ashuda_1;
		uniform float4 _Ashuda_2;
		uniform float2 _Tiling;
		uniform float _Scale;
		uniform float4 _LEvels;
		uniform float _Float0;
		uniform float4 _AO;


		float2 voronoihash18( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi18( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash18( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
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
			float time18 = 0.0;
			float2 uv_TexCoord3 = i.uv_texcoord * ( _Tiling * _Scale );
			float2 coords18 = uv_TexCoord3 * 1.0;
			float2 id18 = 0;
			float voroi18 = voronoi18( coords18, time18,id18, 0 );
			float temp_output_10_0 = saturate( (_LEvels.z + (voroi18 - _LEvels.x) * (_LEvels.w - _LEvels.z) / (_LEvels.y - _LEvels.x)) );
			float4 lerpResult6 = lerp( _Ashuda_1 , _Ashuda_2 , temp_output_10_0);
			o.Albedo = saturate( lerpResult6 ).rgb;
			o.Metallic = saturate( (( _Float0 * -1.0 ) + (( 1.0 - voroi18 ) - 0.0) * (_Float0 - ( _Float0 * -1.0 )) / (1.72 - 0.0)) );
			o.Smoothness = temp_output_10_0;
			o.Occlusion = saturate( (_AO.z + (temp_output_10_0 - _AO.x) * (_AO.w - _AO.z) / (_AO.y - _AO.x)) );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
107;373;1055;693;741.6055;66.88898;1.563032;True;False
Node;AmplifyShaderEditor.RangedFloatNode;29;-1578.418,-0.03704834;Inherit;False;Property;_Scale;Scale;5;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;15;-1585.694,97.65726;Inherit;False;Property;_Tiling;Tiling;3;0;Create;True;0;0;False;0;12,2;12,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1364.418,19.96295;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1153.201,46.1937;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;18;-876.6624,23.64413;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.Vector4Node;9;-862.9549,270.2858;Inherit;False;Property;_LEvels;LEvels;1;0;Create;True;0;0;False;0;0,1,0,0.39;0,1,-0.26,2.26;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-947.6057,671.8925;Inherit;False;Property;_Float0;Float 0;4;0;Create;True;0;0;False;0;0;1.122521;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;8;-545.3803,114.8955;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;34;27.37036,285.2198;Inherit;False;Property;_AO;AO;6;0;Create;True;0;0;False;0;0,0,0,0;0,1.1,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;-737.7267,-195.1006;Inherit;False;Property;_Ashuda_2;Ashuda_2;2;0;Create;True;0;0;False;0;0.3331257,0.3584906,0.3536347,0;0.6476059,0.703648,0.7264151,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-734.619,-362.7418;Inherit;False;Property;_Ashuda_1;Ashuda_1;0;0;Create;True;0;0;False;0;0.7989943,0.8962264,0.877612,0;0.2924528,0.2924528,0.2924528,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;10;-240.6814,170.7516;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-591.7965,339.9736;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-667.064,554.0237;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-679.8086,460.2545;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;False;0;1.72;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;-5.308375,-63.56185;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;19;-425.4177,388.8259;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;31;235.5332,269.3768;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;17;335.164,-32.32985;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;20;-148.9963,395.7047;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-1243.571,229.3367;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;35;511.9464,250.4066;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;666.8331,2.447858;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;RockNoise;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;15;0
WireConnection;28;1;29;0
WireConnection;3;0;28;0
WireConnection;18;0;3;0
WireConnection;8;0;18;0
WireConnection;8;1;9;1
WireConnection;8;2;9;2
WireConnection;8;3;9;3
WireConnection;8;4;9;4
WireConnection;10;0;8;0
WireConnection;26;0;18;0
WireConnection;24;0;22;0
WireConnection;6;0;7;0
WireConnection;6;1;1;0
WireConnection;6;2;10;0
WireConnection;19;0;26;0
WireConnection;19;2;27;0
WireConnection;19;3;24;0
WireConnection;19;4;22;0
WireConnection;31;0;10;0
WireConnection;31;1;34;1
WireConnection;31;2;34;2
WireConnection;31;3;34;3
WireConnection;31;4;34;4
WireConnection;17;0;6;0
WireConnection;20;0;19;0
WireConnection;2;0;3;0
WireConnection;35;0;31;0
WireConnection;0;0;17;0
WireConnection;0;3;20;0
WireConnection;0;4;10;0
WireConnection;0;5;35;0
ASEEND*/
//CHKSM=2EA2A738CE077B1C249E3C975A3CE2A9C5F56CD8