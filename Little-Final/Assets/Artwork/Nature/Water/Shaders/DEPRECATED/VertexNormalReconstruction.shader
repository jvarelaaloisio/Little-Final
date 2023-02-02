// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VertexNormalReconstruction"
{
	Properties
	{
		_Displacement("Displacement", Float) = 0
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 20
		_Float0("Float 0", Float) = 0.7
		_Deviation("Deviation", Float) = 0
		_Freq("Freq", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			half filler;
		};

		uniform float _Freq;
		uniform float _Displacement;
		uniform float _Deviation;
		uniform float _Float0;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float VAR_Frec94 = _Freq;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_vertexNormal = v.normal.xyz;
			float VAR_DisplacementValue97 = _Displacement;
			float3 VertexOffset65 = ( ( sin( ( ( VAR_Frec94 * ase_vertex3Pos.x ) + _Time.y ) ) * ( ase_vertexNormal * VAR_DisplacementValue97 ) ) + ase_vertex3Pos );
			v.vertex.xyz = VertexOffset65;
			v.vertex.w = 1;
			float4 ase_vertexTangent = v.tangent;
			float3 ase_vertexBitangent = cross( ase_vertexNormal, ase_vertexTangent) * v.tangent.w * unity_WorldTransformParams.w;
			float3x3 ObjectToTangent6 = float3x3(ase_vertexTangent.xyz, ase_vertexBitangent, ase_vertexNormal);
			float Deviation26 = _Deviation;
			float3 appendResult48 = (float3(0.0 , Deviation26 , 0.0));
			float3 VAR_VertexPosRecY103 = mul( ( mul( ObjectToTangent6, ase_vertex3Pos ) + appendResult48 ), ObjectToTangent6 );
			float3 DevY60 = ( VAR_VertexPosRecY103 + ( sin( ( ( VAR_Frec94 * VAR_VertexPosRecY103.x ) + _Time.y ) ) * ( ase_vertexNormal * VAR_DisplacementValue97 ) ) );
			float3 appendResult24 = (float3(Deviation26 , 0.0 , 0.0));
			float3 VAR_VertexPosRecX102 = mul( ( mul( ObjectToTangent6, ase_vertex3Pos ) + appendResult24 ), ObjectToTangent6 );
			float3 DevX29 = ( ( sin( ( ( VAR_Frec94 * VAR_VertexPosRecX102.x ) + _Time.y ) ) * ( ase_vertexNormal * VAR_DisplacementValue97 ) ) + VAR_VertexPosRecX102 );
			float3 normalizeResult74 = normalize( cross( ( DevY60 - VertexOffset65 ) , ( DevX29 - VertexOffset65 ) ) );
			float3 NormalReconstructed75 = normalizeResult74;
			v.normal = NormalReconstructed75;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Smoothness = _Float0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
1679;801;2154;1204;3487.238;-153.5264;2.680443;True;False
Node;AmplifyShaderEditor.CommentaryNode;7;-1850.45,208.2986;Inherit;False;876.8165;499.8514;Matrix;5;1;3;2;5;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;63;-3490.649,834.4689;Inherit;False;460.927;168.4709;Devi;2;25;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BitangentVertexDataNode;2;-1800.151,394.15;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TangentVertexDataNode;1;-1800.45,258.2985;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;3;-1791.151,529.15;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-3440.649,887.9398;Inherit;False;Property;_Deviation;Deviation;7;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;44;-4052.444,2327.854;Inherit;False;3080.634;844.9127;Y Deviation;15;104;105;60;59;58;90;56;55;91;100;54;53;101;62;111;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-4054.587,1464.756;Inherit;False;3083.359;861.2618;X Deviation;15;107;106;99;88;39;37;38;35;96;29;34;40;89;61;110;;1,1,1,1;0;0
Node;AmplifyShaderEditor.MatrixFromVectors;5;-1518.998,360.0068;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-1237.634,354.2921;Inherit;True;ObjectToTangent;-1;True;1;0;FLOAT3x3;0,0,0,0,1,1,1,0,1;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.CommentaryNode;62;-4025.878,2666.682;Inherit;False;972.3784;481.9541;Reconstructed Vertex pos from Matrix;8;103;51;50;48;49;47;46;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-3272.721,884.4689;Inherit;False;Deviation;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;61;-4040.096,1830.188;Inherit;False;935.1746;476.6008;Reconstructed Vertex Pos from Matrix;8;22;27;20;24;21;23;28;102;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-3855.957,3016.236;Inherit;False;26;Deviation;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;45;-3939.777,2826.365;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;20;-3990.096,1920.256;Inherit;False;6;ObjectToTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-3866.961,2142.74;Inherit;False;26;Deviation;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;22;-3957.781,1989.87;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;47;-3978.092,2756.752;Inherit;False;6;ObjectToTangent;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-3715.308,1880.188;Inherit;True;2;2;0;FLOAT3x3;0,0,0,0,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-3703.305,2716.682;Inherit;True;2;2;0;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;-3657.111,2987.283;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-3661.389,2150.787;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-3435.196,2733.741;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-3489.199,1880.246;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-3273.923,1911.461;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,0,1,1,1,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-3261.918,2747.956;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;64;-3356.784,1194.758;Inherit;False;411;173;Freq;2;94;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-3306.784,1244.758;Inherit;False;Property;_Freq;Freq;8;0;Create;True;0;0;0;False;0;False;0;3.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;-3382.114,2116.539;Inherit;False;VAR_VertexPosRecX;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-3388.087,3004.297;Inherit;False;VAR_VertexPosRecY;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-2736,1616;Inherit;False;102;VAR_VertexPosRecX;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-2800,2464;Inherit;False;103;VAR_VertexPosRecY;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;19;-2703.366,949.6024;Inherit;False;1739.196;469.1622;Displacement;13;84;12;65;79;86;80;8;13;14;9;95;83;98;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-3152,1248;Inherit;False;VAR_Frec;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;-2580.184,2381.5;Inherit;False;94;VAR_Frec;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;111;-2576,2464;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;85;-2009.773,843.1375;Inherit;False;Property;_Displacement;Displacement;0;0;Create;True;0;0;0;False;0;False;0;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;110;-2512,1616;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;95;-2560,1024;Inherit;False;94;VAR_Frec;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-2560,1536;Inherit;False;94;VAR_Frec;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;12;-2560,1104;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-2336,1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-2336,1536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;38;-2336,1632;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-2313.421,2377.854;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-2336,1120;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-1808,848;Inherit;False;VAR_DisplacementValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;53;-2269.085,2553.593;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;91;-2070.079,2743.728;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-2160,1536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;88;-2160,1632;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-2050.849,2458.012;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;83;-2160,1120;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-2160,1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-2088.59,2910.486;Inherit;False;97;VAR_DisplacementValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-2160,1776;Inherit;False;97;VAR_DisplacementValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-2160,1264;Inherit;False;97;VAR_DisplacementValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1920,1152;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1920,1664;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;56;-1882.65,2507.906;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;8;-2048,1024;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-1811.706,2750.791;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;39;-2048,1536;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-1792,1536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;80;-1920,1248;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-1792,1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-1920,1776;Inherit;False;102;VAR_VertexPosRecX;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-1774.414,2404.192;Inherit;False;103;VAR_VertexPosRecY;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1668.61,2511.031;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-1408.567,2658.244;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-1632,1024;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1632,1536;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-1504,1536;Inherit;False;DevX;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-1505,1023;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-1214.809,2639.087;Inherit;True;DevY;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;93;-720.5836,2297.732;Inherit;False;1425.622;542.7009;Cross Product to obtain Z;9;68;72;69;71;70;67;73;74;75;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-661.6585,2567.193;Inherit;False;60;DevY;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-646.7598,2429.251;Inherit;False;65;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-670.5836,2648.712;Inherit;False;65;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-637.8347,2347.732;Inherit;False;29;DevX;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;70;-388.5502,2587.433;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;67;-388.7264,2374.972;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode;73;-97.55674,2466.126;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;74;142.1432,2465.727;Inherit;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;405.0382,2463.21;Inherit;False;NormalReconstructed;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;18;130.0464,1320.964;Inherit;False;Property;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;0.7;0.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;159.6856,1564.913;Inherit;False;75;NormalReconstructed;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;218.22,1482.492;Inherit;False;65;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;517.9901,1224.469;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;VertexNormalReconstruction;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;20;10;25;False;1;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;-1;-1;-1;1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;1;0
WireConnection;5;1;2;0
WireConnection;5;2;3;0
WireConnection;6;0;5;0
WireConnection;26;0;25;0
WireConnection;21;0;20;0
WireConnection;21;1;22;0
WireConnection;49;0;47;0
WireConnection;49;1;45;0
WireConnection;48;1;46;0
WireConnection;24;0;27;0
WireConnection;50;0;49;0
WireConnection;50;1;48;0
WireConnection;23;0;21;0
WireConnection;23;1;24;0
WireConnection;28;0;23;0
WireConnection;28;1;20;0
WireConnection;51;0;50;0
WireConnection;51;1;47;0
WireConnection;102;0;28;0
WireConnection;103;0;51;0
WireConnection;94;0;15;0
WireConnection;111;0;104;0
WireConnection;110;0;107;0
WireConnection;14;0;95;0
WireConnection;14;1;12;1
WireConnection;35;0;96;0
WireConnection;35;1;110;0
WireConnection;54;0;101;0
WireConnection;54;1;111;0
WireConnection;97;0;85;0
WireConnection;37;0;35;0
WireConnection;37;1;38;0
WireConnection;55;0;54;0
WireConnection;55;1;53;0
WireConnection;13;0;14;0
WireConnection;13;1;9;0
WireConnection;84;0;83;0
WireConnection;84;1;98;0
WireConnection;89;0;88;0
WireConnection;89;1;99;0
WireConnection;56;0;55;0
WireConnection;8;0;13;0
WireConnection;90;0;91;0
WireConnection;90;1;100;0
WireConnection;39;0;37;0
WireConnection;40;0;39;0
WireConnection;40;1;89;0
WireConnection;86;0;8;0
WireConnection;86;1;84;0
WireConnection;58;0;56;0
WireConnection;58;1;90;0
WireConnection;59;0;105;0
WireConnection;59;1;58;0
WireConnection;79;0;86;0
WireConnection;79;1;80;0
WireConnection;34;0;40;0
WireConnection;34;1;106;0
WireConnection;29;0;34;0
WireConnection;65;0;79;0
WireConnection;60;0;59;0
WireConnection;70;0;71;0
WireConnection;70;1;72;0
WireConnection;67;0;68;0
WireConnection;67;1;69;0
WireConnection;73;0;70;0
WireConnection;73;1;67;0
WireConnection;74;0;73;0
WireConnection;75;0;74;0
WireConnection;0;4;18;0
WireConnection;0;11;66;0
WireConnection;0;12;76;0
ASEEND*/
//CHKSM=BD20CADE7C21B64A96B0928DD5E8364C4ED291E6