// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( M_ScreenDirtPPSRenderer ), PostProcessEvent.AfterStack, "PP_ScreenDirt", true )]
public sealed class PP_ScreenDirtPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Flowmap" )]
	public TextureParameter _Flowmap = new TextureParameter {  };
	[Tooltip( "Center Mask Size" )]
	public FloatParameter _CenterMaskSize = new FloatParameter { value = 0.06f };
	[Tooltip( "Center Mask Edge" )]
	public FloatParameter _CenterMaskEdge = new FloatParameter { value = 0.5f };
	[Tooltip( "NoiseScale" )]
	public FloatParameter _NoiseScale = new FloatParameter { value = 50f };
	[Tooltip( "Speed" )]
	public FloatParameter _Speed = new FloatParameter { value = 1f };
	[Tooltip( "DirtColor" )]
	public ColorParameter _DirtColor = new ColorParameter { value = new Color(1f,1f,1f,1f) };
}

public sealed class M_ScreenDirtPPSRenderer : PostProcessEffectRenderer<PP_ScreenDirtPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "M_ScreenDirt" ) );
		if(settings._Flowmap.value != null) sheet.properties.SetTexture( "_Flowmap", settings._Flowmap );
		sheet.properties.SetFloat( "_CenterMaskSize", settings._CenterMaskSize );
		sheet.properties.SetFloat( "_CenterMaskEdge", settings._CenterMaskEdge );
		sheet.properties.SetFloat( "_NoiseScale", settings._NoiseScale );
		sheet.properties.SetFloat( "_Speed", settings._Speed );
		sheet.properties.SetColor( "_DirtColor", settings._DirtColor );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
