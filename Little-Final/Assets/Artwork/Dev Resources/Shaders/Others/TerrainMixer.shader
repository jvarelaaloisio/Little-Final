// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Drimys/Nature/TerrainMixer"
{
	Properties
	{
		[NoScaleOffset]_BaseBaseColor("Base Base Color", 2D) = "white" {}
		[NoScaleOffset]_BaseHeight("Base Height", 2D) = "white" {}
		[NoScaleOffset]_BaseRoughness("Base Roughness", 2D) = "white" {}
		[NoScaleOffset][Normal]_BaseNormal("Base Normal", 2D) = "bump" {}
		[NoScaleOffset]_Texture_1("Texture_1", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal_1("Normal_1", 2D) = "bump" {}
		[NoScaleOffset]_Roughness_1("Roughness_1", 2D) = "white" {}
		[NoScaleOffset]_Height_1("Height_1", 2D) = "white" {}
		[NoScaleOffset]_Texture_2("Texture_2", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal_2("Normal_2", 2D) = "bump" {}
		[NoScaleOffset]_Roughness_2("Roughness_2", 2D) = "white" {}
		[NoScaleOffset]_Height_2("Height_2", 2D) = "white" {}
		[NoScaleOffset]_Texture_3("Texture_3", 2D) = "white" {}
		[NoScaleOffset][Normal]_Normal_3("Normal_3", 2D) = "bump" {}
		[NoScaleOffset]_Roughness_3("Roughness_3", 2D) = "white" {}
		[NoScaleOffset]_Height_3("Height_3", 2D) = "white" {}
		_Noseintensityval("Nose intensity val", Float) = 0
		_Noisescaleval("Noise scale val", Float) = 0
		_WhitNoiseLerpTex1("Whit Noise Lerp Tex 1", Range( 0 , 1)) = 0
		_WhitNoiseLerpTex2("Whit Noise Lerp Tex 2", Range( 0 , 1)) = 0
		_WhitNoiseLerpTex3("Whit Noise Lerp Tex 3", Range( 0 , 1)) = 0
		_WhitNoiseLerpTex4("Whit Noise Lerp Tex 3", Range( 0 , 1)) = 0
		_Tiling("Tiling", Float) = 0
		_Tesellationfactor("Tesellation factor", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _Tesellationfactor;
		uniform sampler2D _BaseHeight;
		SamplerState sampler_BaseHeight;
		uniform float _Tiling;
		uniform float _Noseintensityval;
		uniform float _Noisescaleval;
		uniform float _WhitNoiseLerpTex4;
		uniform sampler2D _Height_1;
		SamplerState sampler_Height_1;
		uniform sampler2D _Height_2;
		SamplerState sampler_Height_2;
		uniform sampler2D _Height_3;
		SamplerState sampler_Height_3;
		uniform sampler2D _BaseNormal;
		uniform float _WhitNoiseLerpTex2;
		uniform sampler2D _Normal_1;
		uniform sampler2D _Normal_2;
		uniform sampler2D _Normal_3;
		uniform sampler2D _BaseBaseColor;
		uniform float _WhitNoiseLerpTex1;
		uniform sampler2D _Texture_1;
		uniform sampler2D _Texture_2;
		uniform sampler2D _Texture_3;
		uniform sampler2D _BaseRoughness;
		SamplerState sampler_BaseRoughness;
		uniform float _WhitNoiseLerpTex3;
		uniform sampler2D _Roughness_1;
		SamplerState sampler_Roughness_1;
		uniform sampler2D _Roughness_2;
		SamplerState sampler_Roughness_2;
		uniform sampler2D _Roughness_3;
		SamplerState sampler_Roughness_3;


		float2 voronoihash2_g240( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g240( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g240( n + g );
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


		float2 voronoihash2_g242( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g242( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g242( n + g );
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


		float2 voronoihash2_g241( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g241( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g241( n + g );
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


		float2 voronoihash2_g248( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g248( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g248( n + g );
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


		float2 voronoihash2_g250( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g250( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g250( n + g );
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


		float2 voronoihash2_g249( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g249( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g249( n + g );
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


		float2 voronoihash2_g244( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g244( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g244( n + g );
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


		float2 voronoihash2_g246( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g246( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g246( n + g );
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


		float2 voronoihash2_g245( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g245( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g245( n + g );
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


		float2 voronoihash2_g236( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g236( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g236( n + g );
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


		float2 voronoihash2_g238( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g238( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g238( n + g );
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


		float2 voronoihash2_g237( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2_g237( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash2_g237( n + g );
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord170 = v.texcoord.xy * temp_cast_0;
			float2 UV171 = uv_TexCoord170;
			float4 VertexColor_var61 = v.color;
			float3 temp_output_20_0_g239 = VertexColor_var61.rgb;
			float3 break21_g239 = temp_output_20_0_g239;
			float temp_output_9_0_g240 = break21_g239.x;
			float NoiseIntensityval186 = _Noseintensityval;
			float temp_output_46_0_g239 = NoiseIntensityval186;
			float Noisescaleval190 = _Noisescaleval;
			float temp_output_47_0_g239 = Noisescaleval190;
			float temp_output_11_0_g240 = temp_output_47_0_g239;
			float time2_g240 = 0.0;
			float2 coords2_g240 = v.texcoord.xy * temp_output_11_0_g240;
			float2 id2_g240 = 0;
			float2 uv2_g240 = 0;
			float voroi2_g240 = voronoi2_g240( coords2_g240, time2_g240, id2_g240, uv2_g240, 0 );
			float simplePerlin2D12_g240 = snoise( v.texcoord.xy*temp_output_11_0_g240 );
			simplePerlin2D12_g240 = simplePerlin2D12_g240*0.5 + 0.5;
			float temp_output_53_0_g239 = _WhitNoiseLerpTex4;
			float lerpResult52_g239 = lerp( break21_g239.x , ( (0.0 + (temp_output_9_0_g240 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g240 + ( voroi2_g240 + simplePerlin2D12_g240 ) ) ) , temp_output_53_0_g239);
			float temp_output_3_0_g239 = saturate( lerpResult52_g239 );
			float temp_output_9_0_g242 = break21_g239.y;
			float temp_output_11_0_g242 = temp_output_47_0_g239;
			float time2_g242 = 0.0;
			float2 coords2_g242 = v.texcoord.xy * temp_output_11_0_g242;
			float2 id2_g242 = 0;
			float2 uv2_g242 = 0;
			float voroi2_g242 = voronoi2_g242( coords2_g242, time2_g242, id2_g242, uv2_g242, 0 );
			float simplePerlin2D12_g242 = snoise( v.texcoord.xy*temp_output_11_0_g242 );
			simplePerlin2D12_g242 = simplePerlin2D12_g242*0.5 + 0.5;
			float lerpResult56_g239 = lerp( break21_g239.y , ( (0.0 + (temp_output_9_0_g242 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g242 + ( voroi2_g242 + simplePerlin2D12_g242 ) ) ) , temp_output_53_0_g239);
			float temp_output_2_0_g239 = saturate( lerpResult56_g239 );
			float temp_output_9_0_g241 = break21_g239.z;
			float temp_output_11_0_g241 = temp_output_47_0_g239;
			float time2_g241 = 0.0;
			float2 coords2_g241 = v.texcoord.xy * temp_output_11_0_g241;
			float2 id2_g241 = 0;
			float2 uv2_g241 = 0;
			float voroi2_g241 = voronoi2_g241( coords2_g241, time2_g241, id2_g241, uv2_g241, 0 );
			float simplePerlin2D12_g241 = snoise( v.texcoord.xy*temp_output_11_0_g241 );
			simplePerlin2D12_g241 = simplePerlin2D12_g241*0.5 + 0.5;
			float lerpResult57_g239 = lerp( break21_g239.z , ( (0.0 + (temp_output_9_0_g241 - 0.0) * (temp_output_46_0_g239 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g241 + ( voroi2_g241 + simplePerlin2D12_g241 ) ) ) , temp_output_53_0_g239);
			float temp_output_4_0_g239 = saturate( lerpResult57_g239 );
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += ( ( _Tesellationfactor * ( ( tex2Dlod( _BaseHeight, float4( UV171, 0, 0.0) ).r * ( 1.0 - saturate( ( temp_output_3_0_g239 + temp_output_2_0_g239 + temp_output_4_0_g239 ) ) ) ) + ( ( ( tex2Dlod( _Height_1, float4( UV171, 0, 0.0) ).r * temp_output_3_0_g239 ) + ( tex2Dlod( _Height_2, float4( UV171, 0, 0.0) ).r * temp_output_2_0_g239 ) ) + ( tex2Dlod( _Height_3, float4( UV171, 0, 0.0) ).r * temp_output_4_0_g239 ) ) ) ) * ase_vertex3Pos );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord170 = i.uv_texcoord * temp_cast_0;
			float2 UV171 = uv_TexCoord170;
			float4 VertexColor_var61 = i.vertexColor;
			float3 temp_output_20_0_g247 = VertexColor_var61.rgb;
			float3 break21_g247 = temp_output_20_0_g247;
			float temp_output_9_0_g248 = break21_g247.x;
			float NoiseIntensityval186 = _Noseintensityval;
			float temp_output_46_0_g247 = NoiseIntensityval186;
			float Noisescaleval190 = _Noisescaleval;
			float temp_output_47_0_g247 = Noisescaleval190;
			float temp_output_11_0_g248 = temp_output_47_0_g247;
			float time2_g248 = 0.0;
			float2 coords2_g248 = i.uv_texcoord * temp_output_11_0_g248;
			float2 id2_g248 = 0;
			float2 uv2_g248 = 0;
			float voroi2_g248 = voronoi2_g248( coords2_g248, time2_g248, id2_g248, uv2_g248, 0 );
			float simplePerlin2D12_g248 = snoise( i.uv_texcoord*temp_output_11_0_g248 );
			simplePerlin2D12_g248 = simplePerlin2D12_g248*0.5 + 0.5;
			float temp_output_53_0_g247 = _WhitNoiseLerpTex2;
			float lerpResult52_g247 = lerp( break21_g247.x , ( (0.0 + (temp_output_9_0_g248 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g248 + ( voroi2_g248 + simplePerlin2D12_g248 ) ) ) , temp_output_53_0_g247);
			float temp_output_3_0_g247 = saturate( lerpResult52_g247 );
			float temp_output_9_0_g250 = break21_g247.y;
			float temp_output_11_0_g250 = temp_output_47_0_g247;
			float time2_g250 = 0.0;
			float2 coords2_g250 = i.uv_texcoord * temp_output_11_0_g250;
			float2 id2_g250 = 0;
			float2 uv2_g250 = 0;
			float voroi2_g250 = voronoi2_g250( coords2_g250, time2_g250, id2_g250, uv2_g250, 0 );
			float simplePerlin2D12_g250 = snoise( i.uv_texcoord*temp_output_11_0_g250 );
			simplePerlin2D12_g250 = simplePerlin2D12_g250*0.5 + 0.5;
			float lerpResult56_g247 = lerp( break21_g247.y , ( (0.0 + (temp_output_9_0_g250 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g250 + ( voroi2_g250 + simplePerlin2D12_g250 ) ) ) , temp_output_53_0_g247);
			float temp_output_2_0_g247 = saturate( lerpResult56_g247 );
			float temp_output_9_0_g249 = break21_g247.z;
			float temp_output_11_0_g249 = temp_output_47_0_g247;
			float time2_g249 = 0.0;
			float2 coords2_g249 = i.uv_texcoord * temp_output_11_0_g249;
			float2 id2_g249 = 0;
			float2 uv2_g249 = 0;
			float voroi2_g249 = voronoi2_g249( coords2_g249, time2_g249, id2_g249, uv2_g249, 0 );
			float simplePerlin2D12_g249 = snoise( i.uv_texcoord*temp_output_11_0_g249 );
			simplePerlin2D12_g249 = simplePerlin2D12_g249*0.5 + 0.5;
			float lerpResult57_g247 = lerp( break21_g247.z , ( (0.0 + (temp_output_9_0_g249 - 0.0) * (temp_output_46_0_g247 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g249 + ( voroi2_g249 + simplePerlin2D12_g249 ) ) ) , temp_output_53_0_g247);
			float temp_output_4_0_g247 = saturate( lerpResult57_g247 );
			o.Normal = ( ( UnpackNormal( tex2D( _BaseNormal, UV171 ) ) * ( 1.0 - saturate( ( temp_output_3_0_g247 + temp_output_2_0_g247 + temp_output_4_0_g247 ) ) ) ) + ( ( ( UnpackNormal( tex2D( _Normal_1, UV171 ) ) * temp_output_3_0_g247 ) + ( UnpackNormal( tex2D( _Normal_2, UV171 ) ) * temp_output_2_0_g247 ) ) + ( UnpackNormal( tex2D( _Normal_3, UV171 ) ) * temp_output_4_0_g247 ) ) );
			float3 temp_output_20_0_g243 = VertexColor_var61.rgb;
			float3 break21_g243 = temp_output_20_0_g243;
			float temp_output_9_0_g244 = break21_g243.x;
			float temp_output_46_0_g243 = NoiseIntensityval186;
			float temp_output_47_0_g243 = Noisescaleval190;
			float temp_output_11_0_g244 = temp_output_47_0_g243;
			float time2_g244 = 0.0;
			float2 coords2_g244 = i.uv_texcoord * temp_output_11_0_g244;
			float2 id2_g244 = 0;
			float2 uv2_g244 = 0;
			float voroi2_g244 = voronoi2_g244( coords2_g244, time2_g244, id2_g244, uv2_g244, 0 );
			float simplePerlin2D12_g244 = snoise( i.uv_texcoord*temp_output_11_0_g244 );
			simplePerlin2D12_g244 = simplePerlin2D12_g244*0.5 + 0.5;
			float temp_output_53_0_g243 = _WhitNoiseLerpTex1;
			float lerpResult52_g243 = lerp( break21_g243.x , ( (0.0 + (temp_output_9_0_g244 - 0.0) * (temp_output_46_0_g243 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g244 + ( voroi2_g244 + simplePerlin2D12_g244 ) ) ) , temp_output_53_0_g243);
			float temp_output_3_0_g243 = saturate( lerpResult52_g243 );
			float temp_output_9_0_g246 = break21_g243.y;
			float temp_output_11_0_g246 = temp_output_47_0_g243;
			float time2_g246 = 0.0;
			float2 coords2_g246 = i.uv_texcoord * temp_output_11_0_g246;
			float2 id2_g246 = 0;
			float2 uv2_g246 = 0;
			float voroi2_g246 = voronoi2_g246( coords2_g246, time2_g246, id2_g246, uv2_g246, 0 );
			float simplePerlin2D12_g246 = snoise( i.uv_texcoord*temp_output_11_0_g246 );
			simplePerlin2D12_g246 = simplePerlin2D12_g246*0.5 + 0.5;
			float lerpResult56_g243 = lerp( break21_g243.y , ( (0.0 + (temp_output_9_0_g246 - 0.0) * (temp_output_46_0_g243 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g246 + ( voroi2_g246 + simplePerlin2D12_g246 ) ) ) , temp_output_53_0_g243);
			float temp_output_2_0_g243 = saturate( lerpResult56_g243 );
			float temp_output_9_0_g245 = break21_g243.z;
			float temp_output_11_0_g245 = temp_output_47_0_g243;
			float time2_g245 = 0.0;
			float2 coords2_g245 = i.uv_texcoord * temp_output_11_0_g245;
			float2 id2_g245 = 0;
			float2 uv2_g245 = 0;
			float voroi2_g245 = voronoi2_g245( coords2_g245, time2_g245, id2_g245, uv2_g245, 0 );
			float simplePerlin2D12_g245 = snoise( i.uv_texcoord*temp_output_11_0_g245 );
			simplePerlin2D12_g245 = simplePerlin2D12_g245*0.5 + 0.5;
			float lerpResult57_g243 = lerp( break21_g243.z , ( (0.0 + (temp_output_9_0_g245 - 0.0) * (temp_output_46_0_g243 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g245 + ( voroi2_g245 + simplePerlin2D12_g245 ) ) ) , temp_output_53_0_g243);
			float temp_output_4_0_g243 = saturate( lerpResult57_g243 );
			o.Albedo = ( ( tex2D( _BaseBaseColor, UV171 ) * ( 1.0 - saturate( ( temp_output_3_0_g243 + temp_output_2_0_g243 + temp_output_4_0_g243 ) ) ) ) + ( ( ( tex2D( _Texture_1, UV171 ) * temp_output_3_0_g243 ) + ( tex2D( _Texture_2, UV171 ) * temp_output_2_0_g243 ) ) + ( tex2D( _Texture_3, UV171 ) * temp_output_4_0_g243 ) ) ).rgb;
			float4 color104 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			o.Metallic = color104.r;
			float3 temp_output_20_0_g235 = VertexColor_var61.rgb;
			float3 break21_g235 = temp_output_20_0_g235;
			float temp_output_9_0_g236 = break21_g235.x;
			float temp_output_46_0_g235 = NoiseIntensityval186;
			float temp_output_47_0_g235 = Noisescaleval190;
			float temp_output_11_0_g236 = temp_output_47_0_g235;
			float time2_g236 = 0.0;
			float2 coords2_g236 = i.uv_texcoord * temp_output_11_0_g236;
			float2 id2_g236 = 0;
			float2 uv2_g236 = 0;
			float voroi2_g236 = voronoi2_g236( coords2_g236, time2_g236, id2_g236, uv2_g236, 0 );
			float simplePerlin2D12_g236 = snoise( i.uv_texcoord*temp_output_11_0_g236 );
			simplePerlin2D12_g236 = simplePerlin2D12_g236*0.5 + 0.5;
			float temp_output_53_0_g235 = _WhitNoiseLerpTex3;
			float lerpResult52_g235 = lerp( break21_g235.x , ( (0.0 + (temp_output_9_0_g236 - 0.0) * (temp_output_46_0_g235 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g236 + ( voroi2_g236 + simplePerlin2D12_g236 ) ) ) , temp_output_53_0_g235);
			float temp_output_3_0_g235 = saturate( lerpResult52_g235 );
			float temp_output_9_0_g238 = break21_g235.y;
			float temp_output_11_0_g238 = temp_output_47_0_g235;
			float time2_g238 = 0.0;
			float2 coords2_g238 = i.uv_texcoord * temp_output_11_0_g238;
			float2 id2_g238 = 0;
			float2 uv2_g238 = 0;
			float voroi2_g238 = voronoi2_g238( coords2_g238, time2_g238, id2_g238, uv2_g238, 0 );
			float simplePerlin2D12_g238 = snoise( i.uv_texcoord*temp_output_11_0_g238 );
			simplePerlin2D12_g238 = simplePerlin2D12_g238*0.5 + 0.5;
			float lerpResult56_g235 = lerp( break21_g235.y , ( (0.0 + (temp_output_9_0_g238 - 0.0) * (temp_output_46_0_g235 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g238 + ( voroi2_g238 + simplePerlin2D12_g238 ) ) ) , temp_output_53_0_g235);
			float temp_output_2_0_g235 = saturate( lerpResult56_g235 );
			float temp_output_9_0_g237 = break21_g235.z;
			float temp_output_11_0_g237 = temp_output_47_0_g235;
			float time2_g237 = 0.0;
			float2 coords2_g237 = i.uv_texcoord * temp_output_11_0_g237;
			float2 id2_g237 = 0;
			float2 uv2_g237 = 0;
			float voroi2_g237 = voronoi2_g237( coords2_g237, time2_g237, id2_g237, uv2_g237, 0 );
			float simplePerlin2D12_g237 = snoise( i.uv_texcoord*temp_output_11_0_g237 );
			simplePerlin2D12_g237 = simplePerlin2D12_g237*0.5 + 0.5;
			float lerpResult57_g235 = lerp( break21_g235.z , ( (0.0 + (temp_output_9_0_g237 - 0.0) * (temp_output_46_0_g235 - 0.0) / (1.0 - 0.0)) * ( temp_output_9_0_g237 + ( voroi2_g237 + simplePerlin2D12_g237 ) ) ) , temp_output_53_0_g235);
			float temp_output_4_0_g235 = saturate( lerpResult57_g235 );
			float3 temp_cast_6 = (( 1.0 - ( ( tex2D( _BaseRoughness, UV171 ).r * ( 1.0 - saturate( ( temp_output_3_0_g235 + temp_output_2_0_g235 + temp_output_4_0_g235 ) ) ) ) + ( ( ( tex2D( _Roughness_1, UV171 ).r * temp_output_3_0_g235 ) + ( tex2D( _Roughness_2, UV171 ).r * temp_output_2_0_g235 ) ) + ( tex2D( _Roughness_3, UV171 ).r * temp_output_4_0_g235 ) ) ) )).xxx;
			float grayscale103 = Luminance(temp_cast_6);
			o.Smoothness = grayscale103;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
0;67;1906;962;4940.436;915.0344;4.499241;True;False
Node;AmplifyShaderEditor.RangedFloatNode;175;-2043.17,-771.9156;Inherit;False;Property;_Tiling;Tiling;22;0;Create;True;0;0;False;0;False;0;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-1840,-780;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;108;-1863.991,286.2975;Inherit;False;Property;_Noseintensityval;Nose intensity val;16;0;Create;True;0;0;False;0;False;0;2.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-1865.441,368.5565;Inherit;False;Property;_Noisescaleval;Noise scale val;17;0;Create;True;0;0;False;0;False;0;9000;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;25;-1862.368,473.0826;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;171;-1616,-780;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;174;-1448.62,1466.5;Inherit;False;171;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;186;-1557.812,274.361;Inherit;False;NoiseIntensityval;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;-1557.085,359.1781;Inherit;False;Noisescaleval;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;-1407.903,2484.216;Inherit;False;171;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-1658.809,461.2066;Inherit;False;VertexColor_var;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-1094.58,2117.69;Inherit;False;Property;_WhitNoiseLerpTex4;Whit Noise Lerp Tex 3;21;0;Create;True;0;0;False;0;False;0;0.541;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-1039.517,1967.243;Inherit;False;61;VertexColor_var;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-998.7996,2984.959;Inherit;False;61;VertexColor_var;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;182;-1094.799,2792.959;Inherit;True;Property;_Height_3;Height_3;15;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;180;-1094.799,2584.959;Inherit;True;Property;_Height_2;Height_2;11;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;08fd206ea80478e41b328d2a8447b734;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;188;-684.1547,1041.157;Inherit;False;186;NoiseIntensityval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;84;-1135.516,1775.243;Inherit;True;Property;_Roughness_3;Roughness_3;14;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;85;-1135.516,1567.243;Inherit;True;Property;_Roughness_2;Roughness_2;10;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;0bc3b089e74ab204aa6297adc6d212cd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;181;-1094.799,2392.958;Inherit;True;Property;_Height_1;Height_1;7;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;6a6929e18b003ae4491ee0fe1df76f1b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;194;-673.5852,2058.064;Inherit;False;190;Noisescaleval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;88;-1135.516,1375.242;Inherit;True;Property;_Roughness_1;Roughness_1;6;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;029e7b08c8ba92a40a4e11ea403bde80;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;87;-1135.516,1183.242;Inherit;True;Property;_BaseRoughness;Base Roughness;2;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;430e98685b47ed44dadf9e29fc239db1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;193;-684.8611,1121.354;Inherit;False;190;Noisescaleval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-1135.297,1099.974;Inherit;False;Property;_WhitNoiseLerpTex3;Whit Noise Lerp Tex 3;20;0;Create;True;0;0;False;0;False;0;0.541;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;-677.0509,1966.224;Inherit;False;186;NoiseIntensityval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;177;-1094.799,2200.958;Inherit;True;Property;_BaseHeight;Base Height;1;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;a19828c9cde838643af917a7c6d8847c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;183;-417.1389,2294;Inherit;False;TextureBlend;-1;;239;24e89ccf6f531df44bc7fec5ad48af13;0;8;53;FLOAT;0;False;46;FLOAT;0;False;47;FLOAT;0;False;22;FLOAT;0;False;23;FLOAT;0;False;26;FLOAT;0;False;27;FLOAT;0;False;20;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;-1442.969,490.761;Inherit;False;171;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;197;396.7304,1103.074;Inherit;False;Property;_Tesellationfactor;Tesellation factor;23;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;166;-457.8563,1276.284;Inherit;False;TextureBlend;-1;;235;24e89ccf6f531df44bc7fec5ad48af13;0;8;53;FLOAT;0;False;46;FLOAT;0;False;47;FLOAT;0;False;22;FLOAT;0;False;23;FLOAT;0;False;26;FLOAT;0;False;27;FLOAT;0;False;20;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-1486.342,-494.417;Inherit;False;171;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-1052.425,970.0065;Inherit;False;61;VertexColor_var;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;66;-1132.331,373.1783;Inherit;True;Property;_Normal_1;Normal_1;5;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;False;-1;None;7bb22a9c07ee6c04592d6bcf9609e938;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;64;-1132.331,773.1782;Inherit;True;Property;_Normal_3;Normal_3;13;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;192;-710.8112,-790.4068;Inherit;False;190;Noisescaleval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;67;-1132.331,181.1783;Inherit;True;Property;_BaseNormal;Base Normal;3;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;False;-1;None;4aa85b2bedd39dd42b3ab238d5e2bd71;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;185;-582.0657,107.9874;Inherit;False;186;NoiseIntensityval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;191;-574.7206,190.1258;Inherit;False;190;Noisescaleval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-717.6057,-877.2195;Inherit;False;186;NoiseIntensityval;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-1152,-592;Inherit;True;Property;_Texture_1;Texture_1;4;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;d7c7f73fe32c947469da8d07645ffe0b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;195;612.9168,1360.694;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;121;-1141.558,-874.7564;Inherit;False;Property;_WhitNoiseLerpTex1;Whit Noise Lerp Tex 1;18;0;Create;True;0;0;False;0;False;0;0.795;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-1134.277,101.5252;Inherit;False;Property;_WhitNoiseLerpTex2;Whit Noise Lerp Tex 2;19;0;Create;True;0;0;False;0;False;0;0.493;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-1152,-400;Inherit;True;Property;_Texture_2;Texture_2;8;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;b7eb23bb612e31846a713500511765ca;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;65;-1132.331,565.1782;Inherit;True;Property;_Normal_2;Normal_2;9;2;[NoScaleOffset];[Normal];Create;True;0;0;False;0;False;-1;None;c5a922c5cfe376a459625a1c3f58e009;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;93;-136.0642,1277.022;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;686.6303,1127.774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-1152,-192;Inherit;True;Property;_Texture_3;Texture_3;12;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;42;-1152,-784;Inherit;True;Property;_BaseBaseColor;Base Base Color;0;1;[NoScaleOffset];Create;True;0;0;False;0;False;-1;None;c2c2a1535b0b943449c00c5e71e1f05f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1056,0;Inherit;False;61;VertexColor_var;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;843.9304,1169.374;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;167;-221.2828,381.0264;Inherit;False;TextureBlend;-1;;247;24e89ccf6f531df44bc7fec5ad48af13;0;8;53;FLOAT;0;False;46;FLOAT;0;False;47;FLOAT;0;False;22;FLOAT3;0,0,0;False;23;FLOAT3;0,0,0;False;26;FLOAT3;0,0,0;False;27;FLOAT3;0,0,0;False;20;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCGrayscale;103;66.3687,1295.067;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;104;401.5211,696.976;Inherit;False;Constant;_Color0;Color 0;13;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;168;-471.2651,-528;Inherit;False;TextureBlend;-1;;243;24e89ccf6f531df44bc7fec5ad48af13;0;8;53;FLOAT;0;False;46;FLOAT;0;False;47;FLOAT;0;False;22;COLOR;0,0,0,0;False;23;COLOR;0,0,0,0;False;26;COLOR;0,0,0,0;False;27;COLOR;0,0,0,0;False;20;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1024.679,465.7168;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Drimys/Nature/TerrainMixer;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;170;0;175;0
WireConnection;171;0;170;0
WireConnection;186;0;108;0
WireConnection;190;0;109;0
WireConnection;61;0;25;0
WireConnection;182;1;176;0
WireConnection;180;1;176;0
WireConnection;84;1;174;0
WireConnection;85;1;174;0
WireConnection;181;1;176;0
WireConnection;88;1;174;0
WireConnection;87;1;174;0
WireConnection;177;1;176;0
WireConnection;183;53;178;0
WireConnection;183;46;189;0
WireConnection;183;47;194;0
WireConnection;183;22;177;1
WireConnection;183;23;181;1
WireConnection;183;26;180;1
WireConnection;183;27;182;1
WireConnection;183;20;179;0
WireConnection;166;53;129;0
WireConnection;166;46;188;0
WireConnection;166;47;193;0
WireConnection;166;22;87;1
WireConnection;166;23;88;1
WireConnection;166;26;85;1
WireConnection;166;27;84;1
WireConnection;166;20;86;0
WireConnection;66;1;173;0
WireConnection;64;1;173;0
WireConnection;67;1;173;0
WireConnection;7;1;172;0
WireConnection;8;1;172;0
WireConnection;65;1;173;0
WireConnection;93;0;166;0
WireConnection;198;0;197;0
WireConnection;198;1;183;0
WireConnection;26;1;172;0
WireConnection;42;1;172;0
WireConnection;196;0;198;0
WireConnection;196;1;195;0
WireConnection;167;53;128;0
WireConnection;167;46;185;0
WireConnection;167;47;191;0
WireConnection;167;22;67;0
WireConnection;167;23;66;0
WireConnection;167;26;65;0
WireConnection;167;27;64;0
WireConnection;167;20;63;0
WireConnection;103;0;93;0
WireConnection;168;53;121;0
WireConnection;168;46;187;0
WireConnection;168;47;192;0
WireConnection;168;22;42;0
WireConnection;168;23;7;0
WireConnection;168;26;8;0
WireConnection;168;27;26;0
WireConnection;168;20;62;0
WireConnection;0;0;168;0
WireConnection;0;1;167;0
WireConnection;0;3;104;0
WireConnection;0;4;103;0
WireConnection;0;11;196;0
ASEEND*/
//CHKSM=78A5BD46B91ED81104229479F83D9D18BF26CAD7