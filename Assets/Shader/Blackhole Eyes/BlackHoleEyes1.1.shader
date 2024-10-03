
// By purchasing this product you have agreed to be subject by the terms and conditions outlined in this TOS section:

// You are buying the rights to use this shader in accordance with this TOS. I (known as Zekk), as the author of the shader, retain full copyright of this shader. 

// You may not, under any circumstances, share or redistribute this shader in any form. To better define this condition, here are some common examples, along with if the action is allowed or not:

// 1. Share the shader files/unitypackage to a person who has not purchased the files themselves from here first: Not Allowed.

// 2. Upload a public or private avatar/world to VRChat that uses the shader: Allowed.

// 3. Include the shader files with an avatar that you are selling or giving away: Not Allowed.

// 4. Including the shader files with an avatar/asset that you were commissioned to make by a person who has not purchased the files themselves from here first: Not Allowed.

// I am not responsible for any damage caused by the use of this shader.

// You are allowed to use this shader in videos and streams, given that the shader files are not accessible to the public for download or use.

// You may not take credit for this shader. 

// These terms and conditions are subject to change at anytime without notice.

// Unfortunately, due to the nature of digital assets, no refunds will be accepted. 

// If you are unsure whether your usage of this product would violate these terms, please reach out to me via discord at Zekk#5814 or though the discord server linked on the product page!

Shader "Zekk/EyeShaders/BlackHoleEyes/1.1"
{
    Properties 
  { 
        [HideInInspector] shader_is_using_thry_editor("", Float)=0
        [HideInInspector] shader_master_label ("Zekk's Black Hole Eye Shader", Float) = 0
        [HideInInspector] m_NoiseSettings ("Main Settings", Float) = 0
        [BigTexture][NoScaleOffset]_Tex2 ("Swirl Noise", 2D) = "white" {}
        _Float20 ("Swirl Detail Level", range(0,100)) = 5
        _Float8 ("Swirl Speed", range(-10.,10.)) = 3
        _Float3 ("Parallax Layer", range(-.2, 2)) = .5
        _Float4 ("Pupil Size", range(0, 5)) = .4
        [HideInInspector] m_ColorSettings ("Color Settings", Float) = 0
        _Col1 ("Color", Color) = (1,1,1,1)
        _HueShift ("HueShift", range(0,1)) = 0
        _Float16 ("Additive Color", Range(0,1)) = .1
        _Float18 ("Bloom", Range(0,1)) = .1
        [HideInInspector] m_start_Advanced ("Advanced", Float) = 0
        _Rainbow ("Rainbow Shift Speed", float) = 0
        [Vector2] _SwirlRainbow ("Swirl Rainbow", Vector)= (0,0,0,0)
        [HideInInspector] m_end_Advanced ("Advanced", Float) = 0
        [HideInInspector] m_DotSettings ("Dot Settings", Float) = 0
        _Float6 ("Dot Size", Range(0,1)) = .1
        _Float15 ("Dots Density", Range(0,100)) = 33
        _DotSpeed ("Dot Swirl Speed", Range(-10, 10)) = 2
        _Float14 ("Dot Parallax Offset", Range(-2,2)) = 0
        [Toggle]_Float17 ("Invert Dot Color", Float) = 1
        [Helpbox]_InvertDotsHelpbox("Invert Dot Color inverts the contribution that the dots make to the overall color. This effectively inverts the vortex completely, however may be useful for a somewhat demonic effect.", Float)=0
        [HideInInspector] m_TheRest ("Misc", Float) = 0
        _Float1 ("Surface Vignette", float) = 1
        [Helpbox]_SurfaceVinHelpbox("This vignette is applied at parallax level 0, the surface of your eyes. Use it when you want a viewer to be able to see behind the vignette when looking from an angle.",Float)= 0
        _Float2 ("Parallax Vignette", float) = .2
        [Helpbox]_ParallaxVinHelpbox("This vignette is applied at a parallax level calculated from this value. Use it when you want to create a fog effect for the parallaxed background to help hide warping along the edges when viewed from an extreme angle.",Float)= 0
        [HideInInspector] m_FallbackTexture ("Fallback Texture", Float) = 0
        [BigTexture]_MainTex ("Fallback Albedo", 2D) = "white" {}
        _Color ("Fallback Color", color) = (1,1,1,1)
        [HideInInspector] m_StencilPassOptions ("Stencil", Float) = 0
        [IntRange] _StencilRef ("Stencil Reference Value", Range(0, 255)) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilPassOp ("Stencil Pass Op", Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilFailOp ("Stencil Fail Op", Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilZFailOp ("Stencil ZFail Op", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilCompareFunction ("Stencil Compare Function", Float) = 8
        [HideInInspector] footer_Discord ("{texture:{name:T_DiscordLogoZekk,height:16},action:{type:URL,data:https://discord.zekk.dev},hover:discord.zekk.dev}", Float) = 0
        [HideInInspector] footer_Gumroad ("{texture:{name:T_GumroadLogoZekk,height:16},action:{type:URL,data:https://shop.zekk.dev},hover:shop.zekk.dev}", Float) = 0
        [HideInInspector] footer_Github ("{texture:{name:T_GithubLogoZekk,height:16},action:{type:URL,data:https://github.com/ZekkVRC},hover:github.com/ZekkVRC}", Float) = 0
        [HideInInspector] footer_Youtube ("{texture:{name:T_YoutubeLogoZekk,height:16},action:{type:URL,data:https://www.youtube.com/@ZekkVRC},hover:Youtube.com/@ZekkVRC}", Float) = 0
        [HideInInspector] footer_Twitter ("{texture:{name:T_TwitterLogoZekk,height:16},action:{type:URL,data:https://twitter.com/ZekkVRC},hover:twitter.com/ZekkVRC}", Float) = 0
    }
    CustomEditor "Thry.ShaderEditor" 
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Stencil
        {
            Ref [_StencilRef]
            Comp [_StencilCompareFunction]
            Pass [_StencilPassOp]
            Fail [_StencilFailOp]
            ZFail [_StencilZFailOp]
        }
        Pass
        {

            CGPROGRAM
			#pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"            
            #include "hsv2rgbsmooth.cginc"
            float hash(float2 p) {return frac(sin(dot(p, float2(20.9898, 78.233))) * 43758.5453)+.01; }
			struct appdata
			{
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float3 wpos : TEXCOORD1;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 tangent : TANGENT;
				float3 wpos : TEXCOORD1;
				UNITY_FOG_COORDS(2)
				float3 normal : NORMAL;
	
				UNITY_VERTEX_OUTPUT_STEREO
			};

			sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Tex2;
            float4 _Col1;
            float _HueShift;
            float _Rainbow;
            float _Float1;
            float _Float2;
            float _Float3;
            float _Float4;
            float _Float6;
            float _Float8;
            float _Float14;
            float _Float15;
            float _Float16;
            float _Float17;
            float _Float18;
            float _DotSpeed;
            float _Float20;
            float4 _SwirlRainbow;

            v2f vert (appdata v)
            {
				v2f o;
				
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.wpos = mul(unity_ObjectToWorld, v.vertex);
				o.tangent = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);
				
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
            }

            float3 hsv2rgb( in float3 c )
            {
                return ((clamp(abs(frac(c.x+float3(0.,.666,.333))*6.-3.)-1.,0.,1.)-1.)*c.y+1.)*c.z;
            }

            float3 rgb2hsv(float3 c)
            {
                float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
                float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
                float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));

                float d = q.x - min(q.w, q.y);
                float e = 1.0e-10;
                return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
            }
            
            float2 polarUV (float2 uv){
                return float2(atan2(uv.x, uv.y), length(uv));
            }
			
            float4 frag (v2f i) : SV_Target
            {
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                _Float4 -= .25;
                float time = _Time.x;

				float4 col = float4(0,0,0,0);
    
                float3 view_dir = normalize(_WorldSpaceCameraPos - i.wpos);
				
				float3 bitangent = cross(i.normal, i.tangent.xyz) * i.tangent.w;
				float3 view_dir_tangent = float3(
					dot(_WorldSpaceCameraPos - i.wpos, i.tangent.xyz),
					dot(_WorldSpaceCameraPos - i.wpos, bitangent.xyz),
					dot(_WorldSpaceCameraPos - i.wpos, i.normal.xyz));
				float2 parallax_base = -((view_dir_tangent.xy)/view_dir_tangent.z);
                float2 OffsetUV = i.uv * 2 - 1;
                float c = length(OffsetUV);
                c = smoothstep(2, 0.0, c);
                float2 TempUV = float2(OffsetUV.x, OffsetUV.y+1);
                float h = length(OffsetUV * _Float1);
                h = smoothstep(1,.6,h);
                float h2 = length(OffsetUV + parallax_base * _Float2 * c);
                h2 = smoothstep(1,.6,h2);
                i.uv = i.uv*2-1;
                float2 PUV = polarUV(i.uv + parallax_base * _Float3 * c);
                float2 aPUV = float2(PUV.x/((UNITY_PI*2))+.5 / abs(sin(PUV.y))*1.1, (PUV.y + time*_Float8));
                col =  tex2Dlod(_Tex2, float4(aPUV*floor(_Float20),0,0));
                float2 uvval = (float2(fmod(PUV.x/((UNITY_PI*2))+.5/abs(sin(PUV.y))*1.1, 1), (PUV.y + time*_DotSpeed))) + parallax_base * _Float14;
                uvval *= _Float15;
                float2 id = floor(uvval);
                uvval = frac(uvval)-.5;
                for(int y=-1;y<=1;y++){
                    for(int x=-1;x<=1;x++){
                        float2 nbor = float2(x,y);
                        col -= smoothstep(.01,.005, length(uvval-nbor-hash(id+nbor)+.5)-_Float6*hash(id+nbor)*2)*5;
                    }
                }
                float adder = lerp(_Float17,lerp(1,0,_Float17),saturate(col.r));
                float temp = adder;
                for(float p = adder; p>0; p=(p-.04)){
                    float2 tuv = polarUV(i.uv + parallax_base * (_Float3 + p) * c);
                    tuv = float2( tuv.x/((UNITY_PI*2))+.5 / abs(sin(tuv.y))*1.1, ( tuv.y + time*(_Float8-1)));
                    temp += tex2Dlod(_Tex2, float4(tuv*floor(_Float20),0,0));
                }
                float3 Conv = rgb2hsv(_Col1);
                _Col1 = float4(hsv2rgb_smooth(float3((Conv.x+_HueShift+(time*_Rainbow)+((aPUV.x*floor(_SwirlRainbow.x)) + (aPUV.y*_SwirlRainbow.y))), Conv.y, Conv.z)),1);
                float Pupil = smoothstep(.3,.9, length(i.uv + parallax_base * _Float3) - _Float4);
                float lumin = 0.7126 * _Col1.r + 0.8152 * _Col1.g + 0.20+(.2*_Float16) * _Col1.b;
                return float4((((((_Col1+_Float16) * (1+1/(lumin/2)))) * adder * temp * h * h2 * Pupil).rgb)*(.1+_Float18), 1);
            }
            ENDCG
        }
    }
    Fallback "Standard"
}