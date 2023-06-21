//// Amplify Shader Editor - Visual Shader Editing Tool
//// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
//#if UNITY_POST_PROCESSING_STACK_V2
//using System;
//using UnityEngine;
//using UnityEngine.Rendering.PostProcessing;

//[Serializable]
//[PostProcess( typeof( PP_RainDropsPPSRenderer ), PostProcessEvent.AfterStack, "PP_RainDrops", true )]
//public sealed class PP_RainDropsPPSSettings : PostProcessEffectSettings
//{
//	[Tooltip( "Noise__Normal" )]
//	public TextureParameter _Noise__Normal = new TextureParameter {  };
//	[Tooltip( "Drops__RenderTexture" )]
//	public TextureParameter _Drops__RenderTexture = new TextureParameter {  };
//	[Tooltip( "Drops__Normal Tiling" )]
//	public FloatParameter _Drops__NormalTiling = new FloatParameter { value = 1f };
//	[Tooltip( "Drops__Normal Scale" )]
//	[Range(0,1)]
//	public FloatParameter _Drops__NormalScale = new FloatParameter { value = 1f };
//	[Tooltip( "Border__Mask" )]
//	public TextureParameter _Border__Mask = new TextureParameter {  };
//	[Tooltip( "Border__WaterSpeed" )]
//	public FloatParameter _Border__WaterSpeed = new FloatParameter { value = 0.2f };
//	[Tooltip( "Border__WaterSpeedOffsetFactor" )]
//	public FloatParameter _Border__WaterSpeedOffsetFactor = new FloatParameter { value = 2f };
//	[Tooltip( "Border__Normal Tiling" )]
//	public FloatParameter _Border__NormalTiling = new FloatParameter { value = 1f };
//	[Tooltip( "Border__Normal Scale" )]
//	public FloatParameter _Border__NormalScale = new FloatParameter { value = 1f };
//}

//public sealed class PP_RainDropsPPSRenderer : PostProcessEffectRenderer<PP_RainDropsPPSSettings>
//{
//	public override void Render( PostProcessRenderContext context )
//	{
//		var sheet = context.propertySheets.Get( Shader.Find( "PP_RainDrops" ) );
//		if(settings._Noise__Normal.value != null) sheet.properties.SetTexture( "_Noise__Normal", settings._Noise__Normal );
//		if(settings._Drops__RenderTexture.value != null) sheet.properties.SetTexture( "_Drops__RenderTexture", settings._Drops__RenderTexture );
//		sheet.properties.SetFloat( "_Drops__NormalTiling", settings._Drops__NormalTiling );
//		sheet.properties.SetFloat( "_Drops__NormalScale", settings._Drops__NormalScale );
//		if(settings._Border__Mask.value != null) sheet.properties.SetTexture( "_Border__Mask", settings._Border__Mask );
//		sheet.properties.SetFloat( "_Border__WaterSpeed", settings._Border__WaterSpeed );
//		sheet.properties.SetFloat( "_Border__WaterSpeedOffsetFactor", settings._Border__WaterSpeedOffsetFactor );
//		sheet.properties.SetFloat( "_Border__NormalTiling", settings._Border__NormalTiling );
//		sheet.properties.SetFloat( "_Border__NormalScale", settings._Border__NormalScale );
//		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
//	}
//}
//#endif
