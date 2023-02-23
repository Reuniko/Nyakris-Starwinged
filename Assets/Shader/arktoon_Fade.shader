Shader "arktoon/Fade" {
	Properties {
		[ATSToggle] _UseDoubleSided ("Double Sided", Float) = 0
		[ATSToggle] _DoubleSidedFlipBackfaceNormal ("Flip backface normal", Float) = 0
		_DoubleSidedBackfaceLightIntensity ("Backface Light intensity", Range(0, 2)) = 0.5
		[ATSToggle] _DoubleSidedBackfaceUseColorShift ("Backface Use Color Shift", Float) = 0
		[PowerSlider(2.0)] _DoubleSidedBackfaceHueShiftFromBase ("Backface Hue Shift From Base", Range(-0.5, 0.5)) = 0
		_DoubleSidedBackfaceSaturationFromBase ("Backface Saturation From Base", Range(0, 2)) = 1
		_DoubleSidedBackfaceValueFromBase ("Backface Value From Base", Range(0, 2)) = 1
		_ShadowCasterCulling ("[hidden] Shadow Caster Culling", Float) = 2
		[Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0
		_MainTex ("[Common] Base Texture", 2D) = "white" {}
		_Color ("[Common] Base Color", Vector) = (1,1,1,1)
		_BumpMap ("[Common] Normal map", 2D) = "bump" {}
		_BumpScale ("[Common] Normal scale", Range(0, 2)) = 1
		_EmissionMap ("[Common] Emission map", 2D) = "white" {}
		[HDR] _EmissionColor ("[Common] Emission Color", Vector) = (0,0,0,1)
		_AlphaMask ("[Alpha] AlphaMask", 2D) = "white" {}
		[ATSToggle] _UseEmissionParallax ("[Emission Parallax] Use Emission Parallax", Float) = 0
		_EmissionParallaxTex ("[Emission Parallax] Texture", 2D) = "black" {}
		[HDR] _EmissionParallaxColor ("[Emission Parallax] Color", Vector) = (1,1,1,1)
		_EmissionParallaxMask ("[Emission Parallax] Emission Mask", 2D) = "white" {}
		_EmissionParallaxDepth ("[Emission Parallax] Depth", Range(-1, 1)) = 0
		_EmissionParallaxDepthMask ("[Emission Parallax] Depth Mask", 2D) = "white" {}
		[ATSToggle] _EmissionParallaxDepthMaskInvert ("[Emission Parallax] Invert Depth Mask", Float) = 0
		_Shadowborder ("[Shadow] border ", Range(0, 1)) = 0.6
		_ShadowborderBlur ("[Shadow] border Blur", Range(0, 1)) = 0.05
		_ShadowborderBlurMask ("[Shadow] border Blur Mask", 2D) = "white" {}
		_ShadowStrength ("[Shadow] Strength", Range(0, 1)) = 0.5
		_ShadowStrengthMask ("[Shadow] Strength Mask", 2D) = "white" {}
		_ShadowIndirectIntensity ("[Shadow] Indirect face Intensity", Range(0, 0.5)) = 0.25
		[ATSToggle] _ShadowUseStep ("[Shadow] use step", Float) = 0
		_ShadowSteps ("[Shadow] steps between borders", Range(2, 10)) = 4
		_PointAddIntensity ("[PointShadow] Light Intensity", Range(0, 1)) = 1
		_PointShadowStrength ("[PointShadow] Strength", Range(0, 1)) = 0.5
		_PointShadowborder ("[PointShadow] border ", Range(0, 1)) = 0.5
		_PointShadowborderBlur ("[PointShadow] border Blur", Range(0, 1)) = 0.01
		_PointShadowborderBlurMask ("[PointShadow] border Blur Mask", 2D) = "white" {}
		[ATSToggle] _PointShadowUseStep ("[PointShadow] use step", Float) = 0
		_PointShadowSteps ("[PointShadow] steps between borders", Range(2, 10)) = 2
		[ATSToggle] _ShadowPlanBUsePlanB ("[Plan B] Use Plan B", Float) = 0
		_ShadowPlanBDefaultShadowMix ("[Plan B] Shadow mix", Range(0, 1)) = 1
		[ATSToggle] _ShadowPlanBUseCustomShadowTexture ("[Plan B] Use Custom Shadow Texture", Float) = 0
		[PowerSlider(2.0)] _ShadowPlanBHueShiftFromBase ("[Plan B] Hue Shift From Base", Range(-0.5, 0.5)) = 0
		_ShadowPlanBSaturationFromBase ("[Plan B] Saturation From Base", Range(0, 2)) = 1
		_ShadowPlanBValueFromBase ("[Plan B] Value From Base", Range(0, 2)) = 1
		_ShadowPlanBCustomShadowTexture ("[Plan B] Custom Shadow Texture", 2D) = "black" {}
		_ShadowPlanBCustomShadowTextureRGB ("[Plan B] Custom Shadow Texture RGB", Vector) = (1,1,1,1)
		[ATSToggle] _CustomShadow2nd ("[Plan B-2] CustomShadow2nd", Float) = 0
		_ShadowPlanB2border ("[Plan B-2] border ", Range(0, 1)) = 0.55
		_ShadowPlanB2borderBlur ("[Plan B-2] border Blur", Range(0, 1)) = 0.55
		[ATSToggle] _ShadowPlanB2UseCustomShadowTexture ("[Plan B-2] Use Custom Shadow Texture", Float) = 0
		[PowerSlider(2.0)] _ShadowPlanB2HueShiftFromBase ("[Plan B-2] Hue Shift From Base", Range(-0.5, 0.5)) = 0
		_ShadowPlanB2SaturationFromBase ("[Plan B-2] Saturation From Base", Range(0, 2)) = 1
		_ShadowPlanB2ValueFromBase ("[Plan B-2] Value From Base", Range(0, 2)) = 1
		_ShadowPlanB2CustomShadowTexture ("[Plan B-2] Custom Shadow Texture", 2D) = "black" {}
		_ShadowPlanB2CustomShadowTextureRGB ("[Plan B-2] Custom Shadow Texture RGB", Vector) = (1,1,1,1)
		[ATSToggle] _UseGloss ("[Gloss] Enabled", Float) = 0
		_GlossBlend ("[Gloss] Smoothness", Range(0, 1)) = 0.5
		_GlossBlendMask ("[Gloss] Smoothness Mask", 2D) = "white" {}
		_GlossPower ("[Gloss] Metallic", Range(0, 1)) = 0.5
		_GlossColor ("[Gloss] Color", Vector) = (1,1,1,1)
		[ATSToggle] _UseOutline ("[Outline] Enabled", Float) = 0
		_OutlineWidth ("[Outline] Width", Range(0, 20)) = 0.1
		_OutlineMask ("[Outline] Outline Mask", 2D) = "white" {}
		_OutlineCutoffRange ("[Outline] Cutoff Range", Range(0, 1)) = 0.5
		_OutlineColor ("[Outline] Color", Vector) = (0,0,0,1)
		_OutlineTexture ("[Outline] Texture", 2D) = "white" {}
		_OutlineShadeMix ("[Outline] Shade Mix", Range(0, 1)) = 0
		_OutlineTextureColorRate ("[Outline] Texture Color Rate", Range(0, 1)) = 0.05
		_OutlineWidthMask ("[Outline] Outline Width Mask", 2D) = "white" {}
		[Enum(Add,0, Lighten,1, Screen,2, Unused,3)] _MatcapBlendMode ("[MatCap] Blend Mode", Float) = 3
		[ATSToggle] _OutlineUseColorShift ("[Outline] Use Outline Color Shift", Float) = 0
		[PowerSlider(2.0)] _OutlineHueShiftFromBase ("[Outline] Hue Shift From Base", Range(-0.5, 0.5)) = 0
		_OutlineSaturationFromBase ("[Outline] Saturation From Base", Range(0, 2)) = 1
		_OutlineValueFromBase ("[Outline] Value From Base", Range(0, 2)) = 1
		_MatcapBlend ("[MatCap] Blend", Range(0, 3)) = 1
		_MatcapBlendMask ("[MatCap] Blend Mask", 2D) = "white" {}
		_MatcapNormalMix ("[MatCap] Normal map mix", Range(0, 2)) = 1
		_MatcapShadeMix ("[MatCap] Shade Mix", Range(0, 1)) = 0
		_MatcapTexture ("[MatCap] Texture", 2D) = "black" {}
		_MatcapColor ("[MatCap] Color", Vector) = (1,1,1,1)
		[ATSToggle] _UseReflection ("[Reflection] Enabled", Float) = 0
		[ATSToggle] _UseReflectionProbe ("[Reflection] Use Reflection Probe", Float) = 1
		_ReflectionReflectionPower ("[Reflection] Reflection Power", Range(0, 1)) = 1
		_ReflectionReflectionMask ("[Reflection] Reflection Mask", 2D) = "white" {}
		_ReflectionNormalMix ("[Reflection] Normal Map Mix", Range(0, 2)) = 1
		_ReflectionShadeMix ("[Reflection] Shade Mix", Range(0, 1)) = 0
		_ReflectionSuppressBaseColorValue ("[Reflection] Suppress Base Color", Range(0, 1)) = 1
		_ReflectionCubemap ("[Reflection] Cubemap", Cube) = "" {}
		[ATSToggle] _UseRim ("[Rim] Enabled", Float) = 0
		_RimBlend ("[Rim] Blend", Range(0, 3)) = 1
		_RimBlendMask ("[Rim] Blend Mask", 2D) = "white" {}
		_RimShadeMix ("[Rim] Shade Mix", Range(0, 1)) = 0
		[PowerSlider(3.0)] _RimFresnelPower ("[Rim] Fresnel Power", Range(0, 200)) = 1
		_RimUpperSideWidth ("[Rim] Upper width", Range(0, 1)) = 0
		[HDR] _RimColor ("[Rim] Color", Vector) = (1,1,1,1)
		_RimTexture ("[Rim] Texture", 2D) = "white" {}
		[ATSToggle] _RimUseBaseTexture ("[Rim] Use Base Texture", Float) = 0
		[Enum(Darken,0, Multiply,1, Light Shutter,2, Unused,3)] _ShadowCapBlendMode ("[ShadowCap] Blend Mode", Float) = 3
		_ShadowCapBlend ("[ShadowCap] Blend", Range(0, 3)) = 1
		_ShadowCapBlendMask ("[ShadowCap] Blend Mask", 2D) = "white" {}
		_ShadowCapNormalMix ("[ShadowCap] Normal map mix", Range(0, 2)) = 1
		_ShadowCapTexture ("[ShadowCap] Texture", 2D) = "white" {}
		_VertexColorBlendDiffuse ("[VertexColor] Blend to diffuse", Range(0, 1)) = 0
		_VertexColorBlendEmissive ("[VertexColor] Blend to emissive", Range(0, 1)) = 0
		_OtherShadowAdjust ("[Advanced] Other Mesh Shadow Adjust", Range(-0.2, 0.2)) = -0.1
		_OtherShadowBorderSharpness ("[Advanced] Other Mesh Shadow Border Sharpness", Range(1, 5)) = 3
		[ATSToggle] _UseVertexLight ("[Advanced] Use Per-vertex Lighting", Float) = 1
		[Enum(Arktoon,0, Cubed,1)] _LightSampling ("[Light] Sampling Style", Float) = 0
		[ATSToggle] _UsePositionRelatedCalc ("[Mat/ShadowCap] Use Position Related Calc (Experimental)", Float) = 0
		[HideInInspector] _Version ("[hidden] Version", Float) = 0
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		sampler2D _MainTex;
		fixed4 _Color;
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	Fallback "Standard"
	//CustomEditor "ArktoonShaders.ArktoonInspector"
}