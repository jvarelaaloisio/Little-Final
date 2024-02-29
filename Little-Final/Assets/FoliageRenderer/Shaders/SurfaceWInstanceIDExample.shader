// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SurfaceWInstanceIDExample"
{
	Properties
	{
		_Color0("Color 0", Color) = (1,0,0,0)
		_Mas("Mas", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 5.0
		#pragma only_renderers d3d11 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			half filler;
		};

		uniform float4 _Color0;
		uniform float _Mas;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			uint currInstanceId = 0;
			#ifdef UNITY_INSTANCING_ENABLED
			currInstanceId = unity_InstanceID;
			#endif
			float2 temp_cast_0 = currInstanceId;
			float dotResult4_g1 = dot( temp_cast_0 , float2( 12.9898,78.233 ) );
			float lerpResult10_g1 = lerp( 0.5 , 1.0 , frac( ( sin( dotResult4_g1 ) * 43758.55 ) ));
			v.vertex.xyz += ( ase_vertexNormal * lerpResult10_g1 * float3( v.texcoord.xy ,  0.0 ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = saturate( ( _Color0 + _Mas ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;7;ASEMaterialInspector;0;0;Standard;SurfaceWInstanceIDExample;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;1;d3d11;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-304.623,481.2387;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;8;-1111.119,-131.3482;Inherit;False;Property;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;5;-780.6389,169.6426;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.InstanceIdNode;7;-929.1307,403.9474;Inherit;False;False;0;1;INT;0
Node;AmplifyShaderEditor.FunctionNode;10;-706.3293,397.5284;Inherit;False;Random Range;-1;;1;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0.5;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-772.3193,544.8962;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-803.3356,-61.45639;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1081.336,34.54361;Inherit;False;Property;_Mas;Mas;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;15;-628.3356,-24.45639;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
WireConnection;0;0;15;0
WireConnection;0;11;6;0
WireConnection;6;0;5;0
WireConnection;6;1;10;0
WireConnection;6;2;12;0
WireConnection;10;1;7;0
WireConnection;13;0;8;0
WireConnection;13;1;14;0
WireConnection;15;0;13;0
ASEEND*/
//CHKSM=6E778065CA8F9F9E581FD825765C36AA51EB6025