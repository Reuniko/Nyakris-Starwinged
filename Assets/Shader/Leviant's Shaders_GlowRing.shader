Shader "Leviant's Shaders/GlowRing" {
	Properties {
		[HDR] _Emissioncolor ("Color", Vector) = (0.3,0.6,2,1)
		_OffsetX ("Offset X", Float) = -0.15
		_OffsetY ("Offset Y", Float) = -0.14
		_ScaleX ("Scale X", Float) = 1.28
		_ScaleY ("Scale Y", Float) = 1.28
		_Compressing ("Compressing", Range(0, 1)) = 0.79
		_Attenuation ("Fire Attenuation", Range(0, 1)) = 0.53
		_Speed ("Speed", Float) = 1
		[Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _SourceBlend ("Source Blend", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DestinationBlend ("Destination Blend", Float) = 1
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType" = "Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			o.Albedo = 1;
		}
		ENDCG
	}
}