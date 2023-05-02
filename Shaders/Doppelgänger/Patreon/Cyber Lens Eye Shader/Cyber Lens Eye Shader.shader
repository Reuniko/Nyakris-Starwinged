//v 1.1
Shader "Doppels shaders/Eye Shaders/Cyber Lens Eye Shader 1.1"
{
    Properties
    {
        _Color0("Pupil Inner (RGBA)", color) = (0.2, 0.2, 0.2, 1.0)
        _Color1("Pupil Background (RGB)", color) = (0.4, 0.4, 0.4, 1.0)
        _Color2("Pupil Inner Ring (RGB)", color) = (0.3, 0.3, 0.3, 1.0)
        _Color3("Lines 1 (RGB)", color) = (0.5, 0.5, 0.5, 1.0)
        _Color4("Lines 2 (RGB)", color) = (0.3, 0.3, 0.3, 1.0)
        _Color5("Outer Background (RGB)", color) = (0.2, 0.2, 0.2, 1.0)
        _Color6("Pupil Outer Ring (RGB)", color) = (0.1, 0.1, 0.1, 1.0)
        _Color7("Outer Ring Inner (RGB)", color) = (0.1, 0.1, 0.1, 1.0)
        _Color8("Outer Ring Glow (RGB)", color) = (0.5, 0.5, 0.5, 1.0)
        _Color9("Pupil Glow (RGB)", color) = (0.5, 0.5, 0.5, 1.0)
        _Color10("HighLights (RGBA)", color) = (1.0, 1.0, 1.0, 0.2)
        [Enum(Off, 0, On, 1)]HUE("Use Hue", int) = 0
        _hue("Hue", range(0, 1)) = 0
        _hueo("Hue Offset", float) = 0
        _huespeed("Hue Speed", float) = 0
        _hueoc("Offset Original Colors", range(0, 1)) = 0
        _plt("Pupil Lines Thickness", range(0, 1)) = 0.5
        _s1("Scaling Speed", range(0, 1)) = 0.2
        _s2("Rotation Speed", range(0, 1)) = 0.4
        _s3("Outer Ring Blinking Speed", range(0, 1)) = 0.5
        _s4("Pupil Glow Speed", range(0, 1)) = 0.1
        //FallBack Texture and default color
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo", 2D) = "white" {}
    }
    CustomEditor "CyberLensEyeGUI"
    SubShader
    {
        Tags { "RenderType"="Opaque" "PreviewType"="Plane" }
        AlphaToMask On
        Pass
        {
            CGPROGRAM
            #pragma target 3.0
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma vertex DoppelgangerEyeShaderVert
            #pragma fragment DoppelgangerEyeShaderFrag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex       : POSITION;
                float3 normal       : NORMAL;
                float4 tangent      : TANGENT;
                float2 uv           : TEXCOORD0;
            };

            struct v2f 
            {
                float4 vertex       : SV_POSITION;
                float2 uv           : TEXCOORD0;
                float3 normalDir    : TEXCOORD1;
                float3 tangentDir   : TEXCOORD2;
                float3 bitangentDir : TEXCOORD3;
                float3 worldDir     : TEXCOORD4;
                UNITY_FOG_COORDS(5)
            };

            float4 _Color10, _Color0;
            float3 _Color1, _Color2, _Color3, _Color4, _Color5, _Color6, _Color7, _Color8, _Color9;
            float _s1, _s2, _s3, _s4, _plt;
            
            v2f DoppelgangerEyeShaderVert (appdata i)
            {
                v2f o;
                o.uv = i.uv;
                o.normalDir = UnityObjectToWorldNormal(i.normal);
                o.tangentDir = normalize(UnityObjectToWorldDir(i.tangent.xyz));
                o.bitangentDir = cross(o.normalDir, o.tangentDir) * i.tangent.w;
                o.vertex = UnityObjectToClipPos(i.vertex);
                o.worldDir = WorldSpaceViewDir(i.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            int HUE;
            float _hue, _hueo, _huespeed, _hueoc;

            inline float3 HSVToRGB(float3 c)
            {
                float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
                float3 p = saturate(abs(frac(c.xxx + K.xyz) * 6.0 - K.www) - K.xxx);
                return c.z * lerp(K.xxx, p, c.y);
            }

            inline float3 RGBToHSV(float3 c)
            {
                float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
                float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
                float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
                float d = q.x - min( q.w, q.y );
                float e = 1.0e-10;
                return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
            }

            inline float mod(float x, float y)
            {
                return x - y * floor(x / y);
            }

            inline float2 p(float2 p, int c)
            {
                p = float2(atan2(p.x, p.y), length(p));
                p.x = mod(p.x, 2.0 * UNITY_PI / float(c)) - UNITY_PI / float(c);
                return float2(p.y * sin(p.x), p.y * cos(p.x));
            }

            inline float hexd(float2 p)
            {
                return max(abs(p.y), dot(abs(p), normalize(float2(1.732, 1.0))));
            }

            inline float aastep0(float aa, float d)
            {
                aa *= 0.5;
                return smoothstep(-aa, aa, d);
            }

            inline float2 rotate(float2 p, float a)
            {
                float s, c;
                sincos(a, s, c);
                return mul(p, float2x2(c, s, -s, c));
            }

            float D(float2 p)
            {
                float r = lerp(0.05, 0.08, 1.0 - pow(saturate(pow(sin((_Time.y * 0.5 * _s1) * 0.95 + sin((_Time.y * 0.5 * _s1) * 2.5 + cos((_Time.y * 0.5 * _s1) * 3.5))) * 2.0, 2.0)), 6.0));
                p = rotate(p, (floor(_Time.y * 0.7 * _s2) + smoothstep(0.0, 1.0, frac(_Time.y * 0.7 * _s2) * 10.0 * (1.0 + _s2))) * UNITY_PI);
                float d = hexd(p) - r;
                for (int i = 0; i < 3; i++)
                {
                    float ld = max(abs(abs(p.y) - r + 0.008 * (0.25 + 0.75 * _plt)) - 0.008 * (0.25 + 0.75 * _plt), p.x * sign(p.y));
                    d = min(d, ld);
                    p = rotate(p, UNITY_PI/3.0);
                }
                return d;
            }

            fixed4 DoppelgangerEyeShaderFrag (v2f i) : SV_Target
            {
                fixed3 c = lerp(lerp(lerp(lerp(lerp(lerp(lerp(lerp(lerp(lerp(_Color0, _Color1, aastep0(length(fwidth(i.uv - 0.5)), D((i.uv - 0.5) - (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.05))), _Color9 * 5.0, saturate((0.0005 + length(fwidth(i.uv - 0.5)) * 0.1)/abs(D((i.uv - 0.5) - (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.05))) * (sin(length((i.uv - 0.5) - (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.05) * 30.0 - _s4*10*_Time.y)*0.5+0.5)) * lerp(1.0, 0.05, saturate(4.0 * ((i.uv - 0.5).y + 0.1 - (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z).y * 0.05))) * smoothstep(0.25, 0.1, length((i.uv - 0.5) - (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.05)), _Color2, aastep0(length(fwidth(i.uv - 0.5)), -(abs(length((i.uv - 0.5)) - 0.16 + 0.005) - 0.006))), _Color3, aastep0(length(fwidth(i.uv - 0.5)), length((i.uv - 0.5)) - 0.16)), _Color4, aastep0(length(fwidth(i.uv - 0.5)), -max(abs(p((i.uv - 0.5) - (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.05, 128).x) - 0.0025, -(length((i.uv - 0.5)) - 0.16)))) * lerp(1.0, 0.05, saturate(4.0 * ((i.uv - 0.5).y - (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z).y * 0.05))), _Color5 * (1 - exp(-(length((i.uv - 0.5) - (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.03) - 0.26) * 50.0)), aastep0(length(fwidth(i.uv - 0.5)), (length((i.uv - 0.5)) - 0.25))), _Color6, aastep0(length(fwidth(i.uv - 0.5)), -abs((length((i.uv - 0.5)) - 0.25)) + 0.01)), _Color7, aastep0(length(fwidth(i.uv - 0.5)), -max(abs(length((i.uv - 0.5) + (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.03) - 0.315) - 0.005, -abs((i.uv - 0.5).y) + 0.02)) * (_s3 ? (sin(length((i.uv - 0.5)) * 30.0 - _s3 * 3.0 * _Time.y) * 0.5 + 0.5) : 1)), _Color8 * 5.0, saturate((0.0005 + length(fwidth(i.uv - 0.5)) * 0.1)/abs(max(abs(length((i.uv - 0.5) + (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.03) - 0.315) - 0.005, -abs((i.uv - 0.5).y) + 0.02))) * (_s3 ? (sin(hexd((i.uv - 0.5)) * 30.0 - _s3 * 6.0*_Time.y)*0.5+0.5) : 1)), _Color10, _Color10.w * aastep0(length(fwidth(i.uv - 0.5)), -min(length(float2(abs(rotate((i.uv - 0.5) + float2(-0.03, 0.12) + (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.3 * smoothstep(0.8, 0.0, length((i.uv - 0.5))), -0.6).x - rotate((i.uv - 0.5) + float2(-0.03, 0.12) + (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.3 * smoothstep(0.8, 0.0, length((i.uv - 0.5))), -0.6).y*0.1) - 0.14, rotate((i.uv - 0.5) + float2(-0.03, 0.12) + (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.3 * smoothstep(0.8, 0.0, length((i.uv - 0.5))), -0.6).y)) - 0.05, length(((i.uv - 0.5) - float2(-0.04, 0.11) + (mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).xy/mul(float3x3(i.tangentDir, i.bitangentDir, i.normalDir), normalize(i.worldDir)).z) * 0.3 * smoothstep(0.8, 0.0, length((i.uv - 0.5))))*float2(0.4,1.0)) - 0.06))) * smoothstep(0.28,0.17,length((i.uv - 0.5)) - 0.16);
                UNITY_BRANCH if (HUE) { c = RGBToHSV(c); c = HSVToRGB(float3(_hue + _hueo + lerp(0.0, c.r, _hueoc) + _Time.y* _huespeed, c.g, c.b)); }
                UNITY_APPLY_FOG(i.fogCoord, c);
                return fixed4(c, _Color0.w);
            }
            ENDCG
        }
        Pass
        {
            Name "ShadowCaster"
            Tags{ "LightMode" = "ShadowCaster" }
            CGPROGRAM
            #pragma vertex vertShadowCaster
            #pragma fragment fragShadowCaster
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"

            struct v2f_shadow
            {
                V2F_SHADOW_CASTER;
            };

            v2f_shadow vertShadowCaster(appdata_base v)
            {
                v2f_shadow o;
                TRANSFER_SHADOW_CASTER_NOPOS(o, o.pos)
                return o;
            }

            float4 fragShadowCaster(v2f_shadow i) : SV_TARGET
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
