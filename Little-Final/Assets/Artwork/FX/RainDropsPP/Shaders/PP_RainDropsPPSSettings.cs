// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( PP_RainDropsPPSRenderer ), PostProcessEvent.AfterStack, "PP_RainDrops", true )]
public sealed class PP_RainDropsPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Noise Normal" )]
	public TextureParameter _NoiseNormal = new TextureParameter {  };
	[Tooltip( "Drops RenderTexture" )]
	public TextureParameter _DropsRenderTexture = new TextureParameter {  };
	[Tooltip( "Drops Normal Tiling" )]
	public FloatParameter _DropsNormalTiling = new FloatParameter { value = 1f };
	[Tooltip( "Drops Normal Scale" )]
	public FloatParameter _DropsNormalScale = new FloatParameter { value = 1f };
	[Tooltip( "Border Mask" )]
	public TextureParameter _BorderMask = new TextureParameter {  };
	[Tooltip( "Border WaterSpeed" )]
	public FloatParameter _BorderWaterSpeed = new FloatParameter { value = 0.2f };
	[Tooltip( "Border WaterSpeedOffsetFactor" )]
	public FloatParameter _BorderWaterSpeedOffsetFactor = new FloatParameter { value = 2f };
	[Tooltip( "Border Normal Tiling" )]
	public FloatParameter _BorderNormalTiling = new FloatParameter { value = 1f };
	[Tooltip( "Border Normal Scale" )]
	public FloatParameter _BorderNormalScale = new FloatParameter { value = 1f };
}

public sealed class PP_RainDropsPPSRenderer : PostProcessEffectRenderer<PP_RainDropsPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "PP_RainDrops" ) );
		if(settings._NoiseNormal.value != null) sheet.properties.SetTexture( "_NoiseNormal", settings._NoiseNormal );
		if(settings._DropsRenderTexture.value != null) sheet.properties.SetTexture( "_DropsRenderTexture", settings._DropsRenderTexture );
		sheet.properties.SetFloat( "_DropsNormalTiling", settings._DropsNormalTiling );
		sheet.properties.SetFloat( "_DropsNormalScale", settings._DropsNormalScale );
		if(settings._BorderMask.value != null) sheet.properties.SetTexture( "_BorderMask", settings._BorderMask );
		sheet.properties.SetFloat( "_BorderWaterSpeed", settings._BorderWaterSpeed );
		sheet.properties.SetFloat( "_BorderWaterSpeedOffsetFactor", settings._BorderWaterSpeedOffsetFactor );
		sheet.properties.SetFloat( "_BorderNormalTiling", settings._BorderNormalTiling );
		sheet.properties.SetFloat( "_BorderNormalScale", settings._BorderNormalScale );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
