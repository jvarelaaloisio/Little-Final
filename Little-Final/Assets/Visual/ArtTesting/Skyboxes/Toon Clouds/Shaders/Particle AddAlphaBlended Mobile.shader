Shader "Unluck Software/Particle AddAlphaBlended Mobile" {
Properties {
	_MainTex ("Additive Texture", 2D) = "white" {}
	_MainTex2 ("Alpha Texture", 2D) = "white" {}
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
	
	Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
	
	BindChannels {
		Bind "Color", color
		Bind "Vertex", vertex
		Bind "TexCoord", texcoord
	}
	
	SubShader {
		Pass {
		Blend SrcAlpha One
			SetTexture [_MainTex] {
				combine texture * primary
			}
		}
		Pass {
		Blend SrcAlpha OneMinusSrcAlpha
			SetTexture [_MainTex2] {
				combine texture * primary
			}
		}
	}
}
}