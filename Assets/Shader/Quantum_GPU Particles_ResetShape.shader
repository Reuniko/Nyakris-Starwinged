Shader "Quantum/GPU Particles/ResetShape" {
	Properties {
		_Scale ("Scale", Vector) = (1,1,1,1)
		_Position ("Position", Vector) = (0,0,0,0)
		_DataTex ("Data", 2D) = "white" {}
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
	//CustomEditor "ResetInspector"
}