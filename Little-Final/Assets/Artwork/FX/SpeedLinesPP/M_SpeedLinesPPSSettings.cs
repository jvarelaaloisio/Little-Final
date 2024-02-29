// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( M_SpeedLinesPPSRenderer ), PostProcessEvent.AfterStack, "M_SpeedLines", true )]
public sealed class M_SpeedLinesPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Line Qty" )]
	public FloatParameter _LineQty = new FloatParameter { value = 5f };
	[Tooltip( "Center" )]
	public Vector4Parameter _Center = new Vector4Parameter { value = new Vector4(0.5f,0.5f,0f,0f) };
	[Tooltip( "Center Mask Size" )]
	public FloatParameter _CenterMaskSize = new FloatParameter { value = 0.06f };
	[Tooltip( "Center Mask Edge" )]
	public FloatParameter _CenterMaskEdge = new FloatParameter { value = 0.5f };
	[Tooltip( "Line Density" )]
	public FloatParameter _LineDensity = new FloatParameter { value = 0.5f };
	[Tooltip( "Line Falloff" )]
	public FloatParameter _LineFalloff = new FloatParameter { value = 0.1836318f };
	[Tooltip( "Speed" )]
	public FloatParameter _Speed = new FloatParameter { value = 1f };
}

public sealed class M_SpeedLinesPPSRenderer : PostProcessEffectRenderer<M_SpeedLinesPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "M_SpeedLines" ) );
		sheet.properties.SetFloat( "_LineQty", settings._LineQty );
		sheet.properties.SetVector( "_Center", settings._Center );
		sheet.properties.SetFloat( "_CenterMaskSize", settings._CenterMaskSize );
		sheet.properties.SetFloat( "_CenterMaskEdge", settings._CenterMaskEdge );
		sheet.properties.SetFloat( "_LineDensity", settings._LineDensity );
		sheet.properties.SetFloat( "_LineFalloff", settings._LineFalloff );
		sheet.properties.SetFloat( "_Speed", settings._Speed );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
