// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LeafParticles"
{
	Properties
	{
		_pos("pos", Vector) = (0,0,0,0)
		_radius("radius", Float) = 0
		_Gradient("Gradient", Float) = 0
		_dist("dist", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float3 _pos;
		uniform float _radius;
		uniform float _Gradient;
		uniform float _dist;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 OUT_VertexOffset40 = ( ( saturate( ( ase_worldPos - _pos ) ) * ( 1.0 - saturate( pow( ( distance( ase_worldPos , _pos ) / _radius ) , _Gradient ) ) ) ) * _dist );
			v.vertex.xyz += OUT_VertexOffset40;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.OneMinusNode;10;-673.2687,492.3979;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1434.269,464.3979;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;11;-1055.269,497.3979;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-862.2687,492.3979;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;6.48;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;9;-1192.269,494.3979;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-384.2687,451.3979;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;24;-1798.272,-6.208703;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;17;-1533.484,76.11234;Inherit;False;Property;_pos;pos;0;0;Create;True;0;0;0;False;0;False;0,0,0;-216.95,3.47,-270.24;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;30;-828.5075,-3.683951;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;31;-686.6832,-7.911735;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;13;-664.9452,727.2993;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-487.0619,193.1695;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-638.3122,283.3648;Inherit;False;Property;_dist;dist;3;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;5;-879.6613,-316.4877;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;-1488.764,-259.4319;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0,0.9301295,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1090.207,-223.1205;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-1163.107,300.6036;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceOpNode;18;-1279.578,20.26585;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1280.505,109.623;Inherit;False;Property;_radius;radius;1;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1118.341,109.623;Inherit;False;Property;_Gradient;Gradient;2;0;Create;True;0;0;0;False;0;False;0;39.99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;27;-973.0598,5.53239;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;25;-1109.741,25.22376;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;36;-930.6367,249.5196;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-750.0015,238.5244;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;51;-12,-63;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;LeafParticles;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;-290.8998,188.0796;Inherit;False;OUT_VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
WireConnection;10;0;12;0
WireConnection;11;0;9;0
WireConnection;12;0;11;0
WireConnection;9;0;7;0
WireConnection;9;1;7;0
WireConnection;14;0;10;0
WireConnection;14;1;13;4
WireConnection;30;0;27;0
WireConnection;31;0;30;0
WireConnection;33;0;39;0
WireConnection;33;1;34;0
WireConnection;19;1;21;0
WireConnection;35;0;24;0
WireConnection;35;1;17;0
WireConnection;18;0;24;0
WireConnection;18;1;17;0
WireConnection;27;0;25;0
WireConnection;27;1;28;0
WireConnection;25;0;18;0
WireConnection;25;1;26;0
WireConnection;36;0;35;0
WireConnection;39;0;36;0
WireConnection;39;1;31;0
WireConnection;51;11;40;0
WireConnection;40;0;33;0
ASEEND*/
//CHKSM=E9A5F86E174C6F181B6616F9CC40E2A484B77969