#ifndef LIL_INPUT_BASE_INCLUDED
#define LIL_INPUT_BASE_INCLUDED

#if !defined(lilBool)
    #define lilBool uint
#endif

//------------------------------------------------------------------------------------------------------------------------------
// Vector
#define _LightDirectionOverride float4(0.001,0.002,0.001,0)
#define _BackfaceColor float4(0,0,0,0)
#if LIL_RENDER == 2 && !defined(LIL_FUR) && !defined(LIL_GEM) && !defined(LIL_REFRACTION)
    float4  _PreColor;
#endif
// Main
float4  _Color;
#define _MainTex_ST float4(1,1,0,0)
#if defined(LIL_FEATURE_ANIMATE_MAIN_UV)
    #define _MainTex_ScrollRotate float4(0,0,0,0)
#endif
#if defined(LIL_FEATURE_MAIN_TONE_CORRECTION)
    #define _MainTexHSVG float4(0,1,1,1)
#endif

// Main2nd
#if defined(LIL_FEATURE_MAIN2ND)
    #define _Color2nd float4(1,1,1,1)
    #define _Main2ndTex_ST float4(1,1,0,0)
    #define _Main2ndTex_ScrollRotate float4(0,0,0,0)
    #define _Main2ndDistanceFade float4(0.1,0.01,0,0)
    #if defined(LIL_FEATURE_DECAL) && defined(LIL_FEATURE_ANIMATE_DECAL)
        #define _Main2ndTexDecalAnimation float4(1,1,1,30)
        #define _Main2ndTexDecalSubParam float4(1,1,0,1)
    #endif
    #if defined(LIL_FEATURE_LAYER_DISSOLVE)
        #define _Main2ndDissolveMask_ST float4(1,1,0,0)
        #define _Main2ndDissolveColor float4(1,1,1,1)
        #define _Main2ndDissolveParams float4(0,0,0.5,0.1)
        #define _Main2ndDissolvePos float4(0,0,0,0)
        #if defined(LIL_FEATURE_Main2ndDissolveNoiseMask)
            #define _Main2ndDissolveNoiseMask_ST float4(1,1,0,0)
            #define _Main2ndDissolveNoiseMask_ScrollRotate float4(0,0,0,0)
        #endif
    #endif
#endif

// Main3rd
#if defined(LIL_FEATURE_MAIN3RD)
    #define _Color3rd float4(1,1,1,1)
    #define _Main3rdTex_ST float4(1,1,0,0)
    #define _Main3rdTex_ScrollRotate float4(0,0,0,0)
    #define _Main3rdDistanceFade float4(0.1,0.01,0,0)
    #if defined(LIL_FEATURE_DECAL) && defined(LIL_FEATURE_ANIMATE_DECAL)
        #define _Main3rdTexDecalAnimation float4(1,1,1,30)
        #define _Main3rdTexDecalSubParam float4(1,1,0,1)
    #endif
    #if defined(LIL_FEATURE_LAYER_DISSOLVE)
        #define _Main3rdDissolveMask_ST float4(1,1,0,0)
        #define _Main3rdDissolveColor float4(1,1,1,1)
        #define _Main3rdDissolveParams float4(0,0,0.5,0.1)
        #define _Main3rdDissolvePos float4(0,0,0,0)
        #if defined(LIL_FEATURE_Main3rdDissolveNoiseMask)
            #define _Main3rdDissolveNoiseMask_ST float4(1,1,0,0)
            #define _Main3rdDissolveNoiseMask_ScrollRotate float4(0,0,0,0)
        #endif
    #endif
#endif

// Shadow
#if defined(LIL_FEATURE_SHADOW)
    float4  _ShadowColor;
    float4  _Shadow2ndColor;
    #if defined(LIL_FEATURE_SHADOW_3RD)
        #define _Shadow3rdColor float4(0,0,0,0)
    #endif
    #define _ShadowBorderColor float4(1,0.01002281,0,1)
    #define _ShadowAOShift float4(1,0,1,0)
    #if defined(LIL_FEATURE_SHADOW_3RD)
        #define _ShadowAOShift2 float4(1,0,1,0)
    #endif
#endif

// Backlight
#if defined(LIL_FEATURE_BACKLIGHT)
    #define _BacklightColor float4(0.6920712,0.6038274,0.4479884,1)
    #define _BacklightColorTex_ST float4(1,1,0,0)
#endif

// Emission
#if defined(LIL_FEATURE_EMISSION_1ST)
    #define _EmissionColor float4(0,0,0,1)
    #define _EmissionBlink float4(0,0,3.141593,0)
    #define _EmissionMap_ST float4(1,1,0,0)
    #if defined(LIL_FEATURE_ANIMATE_EMISSION_UV)
        #define _EmissionMap_ScrollRotate float4(0,0,0,0)
    #endif
    #define _EmissionBlendMask_ST float4(1,1,0,0)
    #if defined(LIL_FEATURE_ANIMATE_EMISSION_MASK_UV)
        #define _EmissionBlendMask_ScrollRotate float4(0,0,0,0)
    #endif
#endif

// Emission 2nd
#if defined(LIL_FEATURE_EMISSION_2ND)
    #define _Emission2ndColor float4(1,1,1,1)
    #define _Emission2ndBlink float4(0,0,3.141593,0)
    #define _Emission2ndMap_ST float4(1,1,0,0)
    #if defined(LIL_FEATURE_ANIMATE_EMISSION_UV)
        #define _Emission2ndMap_ScrollRotate float4(0,0,0,0)
    #endif
    #define _Emission2ndBlendMask_ST float4(1,1,0,0)
    #if defined(LIL_FEATURE_ANIMATE_EMISSION_MASK_UV)
        #define _Emission2ndBlendMask_ScrollRotate float4(0,0,0,0)
    #endif
#endif

// Normal Map
#if defined(LIL_FEATURE_NORMAL_1ST)
    #define _BumpMap_ST float4(1,1,0,0)
#endif

// Normal Map 2nd
#if defined(LIL_FEATURE_NORMAL_2ND)
    #define _Bump2ndMap_ST float4(1,1,0,0)
    #define _Bump2ndScaleMask_ST float4(1,1,0,0)
#endif

// Anisotropy
#if defined(LIL_FEATURE_ANISOTROPY)
    #define _AnisotropyTangentMap_ST float4(1,1,0,0)
    #define _AnisotropyScaleMask_ST float4(1,1,0,0)
    #define _AnisotropyShiftNoiseMask_ST float4(1,1,0,0)
#endif

// Reflection
#if defined(LIL_FEATURE_REFLECTION)
    #define _ReflectionColor float4(1,1,1,1)
    #define _MetallicGlossMap_ST float4(1,1,0,0)
    #define _ReflectionColorTex_ST float4(1,1,0,0)
#endif
#if defined(LIL_FEATURE_REFLECTION) || defined(LIL_REFRACTION_BLUR2)
    #define _SmoothnessTex_ST float4(1,1,0,0)
#endif
#if defined(LIL_FEATURE_REFLECTION) || defined(LIL_GEM)
    #define _ReflectionCubeColor float4(0,0,0,1)
    float4  _ReflectionCubeTex_HDR;
#endif

// MatCap
#if defined(LIL_FEATURE_MATCAP)
    #define _MatCapColor float4(1,1,1,1)
    #define _MatCapTex_ST float4(1,1,0,0)
    #define _MatCapBlendMask_ST float4(1,1,0,0)
    #define _MatCapBlendUV1 float4(0,0,0,0)
    #if defined(LIL_FEATURE_MatCapBumpMap)
        #define _MatCapBumpMap_ST float4(1,1,0,0)
    #endif
#endif

// MatCap 2nd
#if defined(LIL_FEATURE_MATCAP_2ND)
    #define _MatCap2ndColor float4(1,1,1,1)
    #define _MatCap2ndTex_ST float4(1,1,0,0)
    #define _MatCap2ndBlendMask_ST float4(1,1,0,0)
    #define _MatCap2ndBlendUV1 float4(0,0,0,0)
    #if defined(LIL_FEATURE_MatCap2ndBumpMap)
        #define _MatCap2ndBumpMap_ST float4(1,1,0,0)
    #endif
#endif

// Rim Light
#if defined(LIL_FEATURE_RIMLIGHT)
    #define _RimColor float4(0.3931231,0.2140411,0.1959942,1)
    #define _RimColorTex_ST float4(1,1,0,0)
    #if defined(LIL_FEATURE_RIMLIGHT_DIRECTION)
        #define _RimIndirColor float4(1,1,1,1)
    #endif
#endif

// Glitter
#if defined(LIL_FEATURE_GLITTER)
    #define _GlitterColor float4(1,1,1,1)
    #define _GlitterColorTex_ST float4(1,1,0,0)
    #define _GlitterParams1 float4(256,256,0.16,50)
    #define _GlitterParams2 float4(0.25,0,0,0)
    #if defined(LIL_FEATURE_GlitterShapeTex)
        #define _GlitterShapeTex_ST float4(1,1,0,0)
        #define _GlitterAtras float4(1,1,0,0)
    #endif
#endif

// Distance Fade
#if defined(LIL_FEATURE_DISTANCE_FADE)
    #define _DistanceFade float4(0.1,0.01,0,0)
    #define _DistanceFadeColor float4(0,0,0,1)
    #define _DistanceFadeRimColor float4(0,0,0,0)
#endif

// Dither
#if defined(LIL_FEATURE_DITHER)
    float4  _DitherTex_TexelSize;
#endif

// AudioLink
#if defined(LIL_FEATURE_AUDIOLINK)
    #define _AudioLinkMask_ST float4(1,1,0,0)
    #define _AudioLinkMask_ScrollRotate float4(0,0,0,0)
    #define _AudioLinkDefaultValue float4(0,0,2,0.75)
    #define _AudioLinkUVParams float4(0.25,0,0,0.125)
    #define _AudioLinkStart float4(0,0,0,0)
    #if defined(LIL_FEATURE_AUDIOLINK_VERTEX)
        #define _AudioLinkVertexUVParams float4(0.25,0,0,0.125)
        #define _AudioLinkVertexStart float4(0,0,0,0)
        #define _AudioLinkVertexStrength float4(0,0,0,1)
    #endif
    #if defined(LIL_FEATURE_AUDIOLINK_LOCAL)
        #define _AudioLinkLocalMapParams float4(120,1,0,0)
    #endif
#endif

// Dissolve
#if defined(LIL_FEATURE_DISSOLVE)
    #define _DissolveMask_ST float4(1,1,0,0)
    #define _DissolveColor float4(1,1,1,1)
    #define _DissolveParams float4(0,0,0.5,0.1)
    #define _DissolvePos float4(0,0,0,0)
    #if defined(LIL_FEATURE_DissolveNoiseMask)
        #define _DissolveNoiseMask_ST float4(1,1,0,0)
        #define _DissolveNoiseMask_ScrollRotate float4(0,0,0,0)
    #endif
#endif

// Encryption
#if defined(LIL_FEATURE_ENCRYPTION)
    #define _Keys float4(0,0,0,0)
#endif

// Outline
#if !defined(LIL_FUR) && !defined(LIL_REFRACTION) && !defined(LIL_GEM)
    #define _OutlineColor float4(0.3185468,0.2738385,0.4919051,1)
    #define _OutlineLitColor float4(1,0.03310476,0,0)
    #define _OutlineTex_ST float4(1,1,0,0)
    #if defined(LIL_FEATURE_ANIMATE_OUTLINE_UV)
        #define _OutlineTex_ScrollRotate float4(0,0,0,0)
    #endif
    #if defined(LIL_FEATURE_OutlineTex)
        #if defined(LIL_FEATURE_OUTLINE_TONE_CORRECTION)
            #define _OutlineTexHSVG float4(0,1,1,1)
        #endif
    #endif
#endif

// Fur
#if defined(LIL_FUR)
    float4  _FurNoiseMask_ST;
    float4  _FurVector;
#endif

// Refraction
#if defined(LIL_REFRACTION)
    float4  _RefractionColor;
#endif

// Gem
#if defined(LIL_GEM)
    float4  _GemParticleColor;
    float4  _GemEnvColor;
#endif

//------------------------------------------------------------------------------------------------------------------------------
// Float
#define _AsUnlit (0)
#define _Cutoff (0.001)
#if LIL_RENDER == 2 && !defined(LIL_FUR) && !defined(LIL_GEM) && !defined(LIL_REFRACTION)
    float   _PreCutoff;
#endif
#define _SubpassCutoff (0.5)
#define _FlipNormal (0)
#define _ShiftBackfaceUV (0)
#define _VertexLightStrength (0)
#define _LightMinLimit (0.05)
#define _LightMaxLimit (1)
#define _MonochromeLighting (0)
#define _AAStrength (1)
#if defined(LIL_BRP)
    #define _AlphaBoostFA (10)
#endif
#if defined(LIL_HDRP)
    #define _BeforeExposureLimit (10000)
    #define _lilDirectionalLightStrength (1)
#endif
#if defined(LIL_FEATURE_MAIN_GRADATION_MAP)
    #define _MainGradationStrength (0)
#endif
#if defined(LIL_FEATURE_MAIN2ND)
    #define _Main2ndTexAngle (0)
    #define _Main2ndEnableLighting (1)
    #if defined(LIL_FEATURE_Main2ndDissolveNoiseMask)
        #define _Main2ndDissolveNoiseStrength (0.1)
    #endif
#endif
#if defined(LIL_FEATURE_MAIN3RD)
    #define _Main3rdTexAngle (0)
    #define _Main3rdEnableLighting (1)
    #if defined(LIL_FEATURE_Main3rdDissolveNoiseMask)
        #define _Main3rdDissolveNoiseStrength (0.1)
    #endif
#endif
#if defined(LIL_FEATURE_ALPHAMASK)
    #define _AlphaMask_ST float4(1,1,0,0)
    #define _AlphaMaskScale (1)
    #define _AlphaMaskValue (0)
#endif
#if defined(LIL_FEATURE_SHADOW)
    #define _BackfaceForceShadow (0)
    #define _ShadowStrength (1)
    #define _ShadowNormalStrength (1)
    #define _ShadowBorder (0.5)
    #define _ShadowBlur (0.1)
    #define _ShadowStrengthMaskLOD (0)
    #define _ShadowBorderMaskLOD (0)
    #define _ShadowBlurMaskLOD (0)
    #define _Shadow2ndNormalStrength (1)
    #define _Shadow2ndBorder (0.15)
    #define _Shadow2ndBlur (0.1)
    #if defined(LIL_FEATURE_SHADOW_3RD)
        #define _Shadow3rdNormalStrength (1)
        #define _Shadow3rdBorder (0.25)
        #define _Shadow3rdBlur (0.1)
    #endif
    #define _ShadowMainStrength (0)
    #define _ShadowEnvStrength (0)
    #define _ShadowBorderRange (0.08)
    #if defined(LIL_FEATURE_RECEIVE_SHADOW)
        #define _ShadowReceive (0)
        #define _Shadow2ndReceive (0)
        #define _Shadow3rdReceive (0)
    #endif
    #define _ShadowFlatBlur (1)
    #define _ShadowFlatBorder (1)
#endif
#if defined(LIL_FEATURE_BACKLIGHT)
    #define _BacklightNormalStrength (1)
    #define _BacklightBorder (0.35)
    #define _BacklightBlur (0.05)
    #define _BacklightDirectivity (5)
    #define _BacklightViewStrength (1)
    #define _BacklightBackfaceMask (1)
    #define _BacklightMainStrength (0)
#endif
#if defined(LIL_FEATURE_NORMAL_1ST)
    #define _BumpScale (1)
#endif
#if defined(LIL_FEATURE_NORMAL_2ND)
    #define _Bump2ndScale (1)
#endif
#if defined(LIL_FEATURE_ANISOTROPY)
    #define _AnisotropyScale (1)
    #define _AnisotropyTangentWidth (1)
    #define _AnisotropyBitangentWidth (1)
    #define _AnisotropyShift (0)
    #define _AnisotropyShiftNoiseScale (0)
    #define _AnisotropySpecularStrength (1)
    #define _Anisotropy2ndTangentWidth (1)
    #define _Anisotropy2ndBitangentWidth (1)
    #define _Anisotropy2ndShift (0)
    #define _Anisotropy2ndShiftNoiseScale (0)
    #define _Anisotropy2ndSpecularStrength (0)
#endif
#if defined(LIL_FEATURE_REFLECTION) || defined(LIL_GEM)
    #define _Reflectance (0.003095975)
    #define _SpecularNormalStrength (1)
    #define _SpecularBorder (0.5)
    #define _SpecularBlur (0)
    #define _ReflectionNormalStrength (1)
    #define _ReflectionCubeEnableLighting (1)
#endif
#if defined(LIL_FEATURE_REFLECTION) || defined(LIL_GEM) || defined(LIL_REFRACTION_BLUR2)
    #define _Smoothness (1)
#endif
#if defined(LIL_FEATURE_REFLECTION)
    #define _Metallic (0)
    #define _GSAAStrength (0)
#endif
#if defined(LIL_FEATURE_MATCAP)
    #define _MatCapBlend (1)
    #define _MatCapEnableLighting (1)
    #define _MatCapShadowMask (0)
    #define _MatCapVRParallaxStrength (1)
    #define _MatCapBackfaceMask (0)
    #define _MatCapLod (0)
    #define _MatCapNormalStrength (1)
    #define _MatCapMainStrength (0)
    #if defined(LIL_FEATURE_MatCapBumpMap)
        #define _MatCapBumpScale (1)
    #endif
#endif
#if defined(LIL_FEATURE_MATCAP_2ND)
    #define _MatCap2ndBlend (1)
    #define _MatCap2ndEnableLighting (1)
    #define _MatCap2ndShadowMask (0)
    #define _MatCap2ndVRParallaxStrength (1)
    #define _MatCap2ndBackfaceMask (0)
    #define _MatCap2ndLod (0)
    #define _MatCap2ndNormalStrength (1)
    #define _MatCap2ndMainStrength (0)
    #if defined(LIL_FEATURE_MatCap2ndBumpMap)
        #define _MatCap2ndBumpScale (1)
    #endif
#endif
#if defined(LIL_FEATURE_RIMLIGHT)
    #define _RimNormalStrength (1)
    #define _RimBorder (0.5)
    #define _RimBlur (0.65)
    #define _RimFresnelPower (3.5)
    #define _RimEnableLighting (1)
    #define _RimShadowMask (0.5)
    #define _RimVRParallaxStrength (1)
    #define _RimBackfaceMask (1)
    #define _RimMainStrength (0)
    #if defined(LIL_FEATURE_RIMLIGHT_DIRECTION)
        #define _RimDirStrength (0)
        #define _RimDirRange (0)
        #define _RimIndirRange (0)
        #define _RimIndirBorder (0.5)
        #define _RimIndirBlur (0.1)
    #endif
#endif
#if defined(LIL_FEATURE_GLITTER)
    #define _GlitterMainStrength (0)
    #define _GlitterPostContrast (1)
    #define _GlitterSensitivity (0.25)
    #define _GlitterNormalStrength (1)
    #define _GlitterEnableLighting (1)
    #define _GlitterShadowMask (0)
    #define _GlitterVRParallaxStrength (0)
    #define _GlitterBackfaceMask (0)
    #define _GlitterScaleRandomize (0)
#endif
#if defined(LIL_FEATURE_DISTANCE_FADE)
    #define _DistanceFadeRimFresnelPower (5)
#endif
#if defined(LIL_FEATURE_EMISSION_1ST)
    #define _EmissionBlend (1)
    #define _EmissionParallaxDepth (0)
    #define _EmissionFluorescence (0)
    #define _EmissionMainStrength (0)
    #if defined(LIL_FEATURE_EMISSION_GRADATION)
        #define _EmissionGradSpeed (1)
    #endif
#endif
#if defined(LIL_FEATURE_EMISSION_2ND)
    #define _Emission2ndBlend (1)
    #define _Emission2ndParallaxDepth (0)
    #define _Emission2ndFluorescence (0)
    #define _Emission2ndMainStrength (0)
    #if defined(LIL_FEATURE_EMISSION_GRADATION)
        #define _Emission2ndGradSpeed (1)
    #endif
#endif
#if defined(LIL_FEATURE_PARALLAX)
    #define _Parallax (0.02)
    #define _ParallaxOffset (0.5)
#endif
#if defined(LIL_FEATURE_DITHER)
    #define _DitherMaxValue (255)
#endif
#if defined(LIL_FEATURE_AUDIOLINK)
    #define _AudioLink2EmissionGrad (0)
    #define _AudioLink2Emission2ndGrad (0)
#endif
#if defined(LIL_FEATURE_DISSOLVE) &&  defined(LIL_FEATURE_DissolveNoiseMask)
    #define _DissolveNoiseStrength (0.1)
#endif
#if defined(LIL_FEATURE_IDMASK)
    #define _IDMask1 (0)
    #define _IDMask2 (0)
    #define _IDMask3 (0)
    #define _IDMask4 (0)
    #define _IDMask5 (0)
    #define _IDMask6 (0)
    #define _IDMask7 (0)
    #define _IDMask8 (0)
#endif
#define _lilShadowCasterBias (0)

#if !defined(LIL_FUR) && !defined(LIL_REFRACTION) && !defined(LIL_GEM)
    #define _OutlineLitScale (10)
    #define _OutlineLitOffset (-8)
    #define _OutlineWidth (0.08)
    #define _OutlineEnableLighting (1)
    #define _OutlineVectorScale (1)
    #define _OutlineFixWidth (0.5)
    #define _OutlineZBias (0)
#endif

#if defined(LIL_FUR)
    #define _FurVectorScale (1)
    #define _FurGravity (0.25)
    #define _FurAO (0)
    #define _FurRootOffset (-1)
    #define _FurRandomize (0)
    #define _FurCutoutLength (0.8)
    #if defined(LIL_FEATURE_FUR_COLLISION)
        #define _FurTouchStrength (0)
    #endif
#endif
#if defined(LIL_REFRACTION)
    float   _RefractionStrength;
    float   _RefractionFresnelPower;
#endif
#if defined(LIL_TESSELLATION)
    #define _TessEdge (10)
    #define _TessStrength (0.5)
    #define _TessShrink (0)
    #define _TessFactorMax (3)
#endif
#if defined(LIL_GEM)
    float   _GemChromaticAberration;
    float   _GemParticleLoop;
    float   _RefractionStrength;
    float   _RefractionFresnelPower;
    float   _GemEnvContrast;
    float   _GemVRParallaxStrength;
#endif

//------------------------------------------------------------------------------------------------------------------------------
// Int
#if defined(LIL_FEATURE_IDMASK)
    int     _IDMaskIndex1;
    int     _IDMaskIndex2;
    int     _IDMaskIndex3;
    int     _IDMaskIndex4;
    int     _IDMaskIndex5;
    int     _IDMaskIndex6;
    int     _IDMaskIndex7;
    int     _IDMaskIndex8;
    #define _IDMaskFrom (8)
#endif
#define _Cull (2)
#if !defined(LIL_FUR) && !defined(LIL_REFRACTION) && !defined(LIL_GEM)
    uint    _OutlineCull;
#endif
#if LIL_RENDER == 2 && !defined(LIL_FUR) && !defined(LIL_GEM) && !defined(LIL_REFRACTION)
    uint    _PreOutType;
#endif
#if defined(LIL_FEATURE_MAIN2ND)
    #define _Main2ndTexBlendMode (0)
    #define _Main2ndTexAlphaMode (0)
    #define _Main2ndTex_UVMode (0)
    #define _Main2ndTex_Cull (0)
#endif
#if defined(LIL_FEATURE_MAIN3RD)
    #define _Main3rdTexBlendMode (0)
    #define _Main3rdTexAlphaMode (0)
    #define _Main3rdTex_UVMode (0)
    #define _Main3rdTex_Cull (0)
#endif
#if defined(LIL_FEATURE_ALPHAMASK)
    uint    _AlphaMaskMode;
#endif
#if defined(LIL_FEATURE_SHADOW)
    #define _ShadowColorType (0)
    #define _ShadowMaskType (0)
#endif
#if defined(LIL_FEATURE_NORMAL_2ND)
    #define _Bump2ndMap_UVMode (0)
#endif
#if defined(LIL_FEATURE_REFLECTION)
    #define _ReflectionBlendMode (1)
#endif
#if defined(LIL_FEATURE_MATCAP)
    #define _MatCapBlendMode (1)
#endif
#if defined(LIL_FEATURE_MATCAP_2ND)
    #define _MatCap2ndBlendMode (1)
#endif
#if defined(LIL_FEATURE_RIMLIGHT)
    #define _RimBlendMode (1)
#endif
#if defined(LIL_FEATURE_GLITTER)
    #define _GlitterUVMode (0)
#endif
#if defined(LIL_FEATURE_EMISSION_1ST)
    #define _EmissionMap_UVMode (0)
    #define _EmissionBlendMode (1)
#endif
#if defined(LIL_FEATURE_EMISSION_2ND)
    #define _Emission2ndMap_UVMode (0)
    #define _Emission2ndBlendMode (1)
#endif
#if defined(LIL_FEATURE_AUDIOLINK)
    #define _AudioLinkUVMode (1)
    #define _AudioLinkMask_UVMode (0)
    #if defined(LIL_FEATURE_AUDIOLINK_VERTEX)
        #define _AudioLinkVertexUVMode (1)
    #endif
#endif
#if defined(LIL_FEATURE_DISTANCE_FADE)
    #define _DistanceFadeMode (0)
#endif
#if defined(LIL_FEATURE_DITHER)
    #define _UseDither (0)
#endif
#if !defined(LIL_FUR) && !defined(LIL_REFRACTION) && !defined(LIL_GEM)
    #define _OutlineVertexR2Width (0)
    #define _OutlineVectorUVMode (0)
#endif
#if defined(LIL_FUR)
    #define _FurLayerNum (3)
    #define _FurMeshType (0)
#endif

//------------------------------------------------------------------------------------------------------------------------------
// Bool
#define _Invisible (0)
#if defined(LIL_FEATURE_MAIN2ND)
    #define _UseMain2ndTex (0)
    #define _Main2ndTexIsMSDF (0)
    #if defined(LIL_FEATURE_DECAL)
        #define _Main2ndTexIsDecal (0)
        #define _Main2ndTexIsLeftOnly (0)
        #define _Main2ndTexIsRightOnly (0)
        #define _Main2ndTexShouldCopy (0)
        #define _Main2ndTexShouldFlipMirror (0)
        #define _Main2ndTexShouldFlipCopy (0)
    #endif
#endif
#if defined(LIL_FEATURE_MAIN3RD)
    #define _UseMain3rdTex (0)
    #define _Main3rdTexIsMSDF (0)
    #if defined(LIL_FEATURE_DECAL)
        #define _Main3rdTexIsDecal (0)
        #define _Main3rdTexIsLeftOnly (0)
        #define _Main3rdTexIsRightOnly (0)
        #define _Main3rdTexShouldCopy (0)
        #define _Main3rdTexShouldFlipMirror (0)
        #define _Main3rdTexShouldFlipCopy (0)
    #endif
#endif
#if defined(LIL_FEATURE_SHADOW)
    #define _UseShadow (1)
    #define _ShadowPostAO (0)
#endif
#if defined(LIL_FEATURE_BACKLIGHT)
    #define _UseBacklight (0)
    #define _BacklightReceiveShadow (1)
#endif
#if defined(LIL_FEATURE_NORMAL_1ST)
    #define _UseBumpMap (0)
#endif
#if defined(LIL_FEATURE_NORMAL_2ND)
    #define _UseBump2ndMap (0)
#endif
#if defined(LIL_FEATURE_ANISOTROPY)
    #define _UseAnisotropy (0)
    #define _Anisotropy2Reflection (0)
    #define _Anisotropy2MatCap (0)
    #define _Anisotropy2MatCap2nd (0)
#endif
#if defined(LIL_FEATURE_REFLECTION)
    #define _UseReflection (0)
    #define _ApplySpecular (1)
    #define _ApplySpecularFA (1)
    #define _ApplyReflection (0)
    #define _SpecularToon (1)
    #define _ReflectionApplyTransparency (1)
#endif
#if defined(LIL_FEATURE_REFLECTION) || defined(LIL_GEM)
    #define _ReflectionCubeOverride (0)
#endif
#if defined(LIL_FEATURE_MATCAP)
    #define _UseMatCap (0)
    #define _MatCapApplyTransparency (1)
    #define _MatCapPerspective (1)
    #define _MatCapZRotCancel (1)
    #if defined(LIL_FEATURE_MatCapBumpMap)
        #define _MatCapCustomNormal (0)
    #endif
#endif
#if defined(LIL_FEATURE_MATCAP_2ND)
    #define _UseMatCap2nd (0)
    #define _MatCap2ndApplyTransparency (1)
    #define _MatCap2ndPerspective (1)
    #define _MatCap2ndZRotCancel (1)
    #if defined(LIL_FEATURE_MatCap2ndBumpMap)
        #define _MatCap2ndCustomNormal (0)
    #endif
#endif
#if defined(LIL_FEATURE_RIMLIGHT)
    #define _UseRim (0)
    #define _RimApplyTransparency (1)
#endif
#if defined(LIL_FEATURE_GLITTER)
    #define _UseGlitter (0)
    #define _GlitterColorTex_UVMode (0)
    #define _GlitterApplyTransparency (1)
    #if defined(LIL_FEATURE_GlitterShapeTex)
        #define _GlitterApplyShape (0)
        #define _GlitterAngleRandomize (0)
    #endif
#endif
#if defined(LIL_FEATURE_EMISSION_1ST)
    #define _UseEmission (0)
    #if defined(LIL_FEATURE_EMISSION_GRADATION)
        #define _EmissionUseGrad (0)
    #endif
#endif
#if defined(LIL_FEATURE_EMISSION_2ND)
    #define _UseEmission2nd (0)
    #if defined(LIL_FEATURE_EMISSION_GRADATION)
        #define _Emission2ndUseGrad (0)
    #endif
#endif
#if defined(LIL_FEATURE_PARALLAX)
    #define _UseParallax (0)
    #if defined(LIL_FEATURE_POM)
        #define _UsePOM (0)
    #endif
#endif
#if defined(LIL_FEATURE_AUDIOLINK)
    #define _UseAudioLink (0)
    #if defined(LIL_FEATURE_MAIN2ND)
        #define _AudioLink2Main2nd (0)
    #endif
    #if defined(LIL_FEATURE_MAIN3RD)
        #define _AudioLink2Main3rd (0)
    #endif
    #if defined(LIL_FEATURE_EMISSION_1ST)
        #define _AudioLink2Emission (0)
    #endif
    #if defined(LIL_FEATURE_EMISSION_2ND)
        #define _AudioLink2Emission2nd (0)
    #endif
    #if defined(LIL_FEATURE_AUDIOLINK_VERTEX)
        #define _AudioLink2Vertex (0)
    #endif
    #if defined(LIL_FEATURE_AUDIOLINK_LOCAL)
        #define _AudioLinkAsLocal (0)
    #endif
#endif
#if defined(LIL_FEATURE_ENCRYPTION)
    #define _IgnoreEncryption (0)
#endif

#if !defined(LIL_FUR) && !defined(LIL_REFRACTION) && !defined(LIL_GEM)
    #define _OutlineLitApplyTex (0)
    #define _OutlineLitShadowReceive (0)
    #define _OutlineDeleteMesh (0)
    #define _OutlineDisableInVR (0)
#endif

#if defined(LIL_FUR)
    #define _VertexColor2FurVector (0)
#endif
#if defined(LIL_REFRACTION)
    lilBool _RefractionColorFromMain;
#endif

#endif
