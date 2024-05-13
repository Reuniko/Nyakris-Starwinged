// License: http://opensource.org/licenses/MIT
// Version: 1.1 (16.05.2020)

Shader "Leviant's Shaders/GlowRing"
{
	Properties
	{
		[HDR]_Color("Color", Color) = (0.3, 0.6, 2.0, 1.0)
		_OffsetX("Offset X", Float) = -0.5
		_OffsetY("Offset Y", Float) = -0.5
		_ScaleX("Scale X", Float) = 2
		_ScaleY("Scale Y", Float) = 2
		_Compressing ("Compressing", Range(0, 1)) = 0.79
		_Attenuation ("Fire Attenuation", Range(0, 1)) = 0.53
		_Speed("Speed", Float) = 1
		//[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Int) = 4
		[Enum(Off, 0, On, 1)] _ZWrite("ZWrite", Int) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _SourceBlend("Source Blend", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DestinationBlend("Destination Blend", Float) = 1
	}
	SubShader
	{
		Tags { "Queue" = "Transparent"  "RenderType" = "Transparent" }
		ZWrite [_ZWrite]
		Cull Off
		Blend [_SourceBlend] [_DestinationBlend]
		BlendOp Add
		Pass
		{
			CGPROGRAM
			#pragma target 5.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			uniform float4 _Color;
			uniform float _OffsetX;
			uniform float _OffsetY;
			uniform float _ScaleX;
			uniform float _ScaleY;
			uniform float _Compressing;
			uniform float _Attenuation;
			uniform float _Speed;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv * float2(_ScaleX, _ScaleY) + float2(_OffsetX, _OffsetY);
				UNITY_TRANSFER_FOG(o, o.vertex);
				return o;
			}

			//glow shader test 2 
			//https://www.shadertoy.com/view/4dSfDK

			float rand(float2 n) 
			{
				return frac(sin(dot(n, float2(12.9898, 12.1414))) * 83758.5453);
			}

			float noise(float2 n) 
			{
				const float2 d = float2(0, 1);
				float2 b = floor(n);
				float2 f = smoothstep(0, 1, frac(n));
				return lerp(lerp(rand(b), rand(b + d.yx), f.x), lerp(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
			}

			float4 ramp(float t) 
			{
				return _Color / t;
				//return t <= .5 ? float3(1. - t * 1.4, .2, 1.05) / t : float3(.3 * (1. - t) * 2., .2, 1.05) / t;
			}
			float2 polarMap(float2 uv, float shift, float inner) 
			{
				uv = 0.5 - uv;

				float px = 1 - frac(atan2(uv.y, uv.x) / radians(360) + 0.25) + shift;
				float py = (length(uv) * (1 + inner * 2) - inner) * 2;

				return float2(px, py);
			}
			float fire(float2 n) 
			{
				return noise(n) + noise(n * 2.1) * 0.6 + noise(n * 5.4) * 0.42;
			}

			float shade(float2 uv, float t) 
			{
				uv.x += uv.y < 0.5 ? 23.0 + t * 0.035 : -11.0 + t * 0.03;
				uv.y = abs(uv.y - 0.5);
				uv.x *= 35.0;

				float q = fire(uv - t * 0.013) / 2;
				float2 r = float2(fire(uv + q / 2 + t - uv.x - uv.y), fire(uv + q - t));

				return pow((r.y + r.y) * max(0, uv.y) + 0.1, 4);
			}

			float4 color(float grad) 
			{
				//return 1 - grad;
				float m2 = _Attenuation;
				grad = sqrt(grad);
				float4 color;// = float3(1.0 / (pow(_Color.xyz + 2.61, 2.0)));
				color = ramp(grad);
				color /= (m2 + max(0, color));
				return color;
			}

			float4 frag(v2f i) : SV_Target
			{
				_Compressing = 1 / (1 - _Compressing) - 1;
				_Attenuation = 1 / (1 - _Attenuation) - 1;
				float t = _Time.y * _Speed;
				float2 uv = i.uv;
				float ff = 1 - uv.y;
				float2 uv2 = uv;
				uv2.y = 1 - uv2.y;
				uv = polarMap(uv, 1.3, _Compressing);
				uv2 = polarMap(uv2, 1.9, _Compressing);

				float4 col = lerp(color(shade(uv2, t)), color(shade(uv, t)), ff);
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
