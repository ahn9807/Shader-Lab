Shader "Custom/SobelLineShader" {

	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DeltaX ("Delta X", Float) = 0.01
		_DeltaY ("Delta Y", Float) = 0.01

        _LineColor ("Main Line Color", Color) = (1,1,1,1)
        _EmissionColor ("Emission Color", Color) = (0,0,1,1)

        _MinDenoiseOffset("MinDenoise Offset", Range(0,1)) = 0
        _MaxDenoiseOffset("MaxDenoise Offset", Range(0,1)) = 1
	}
	SubShader 
    {
		Tags 
        { 
            "Queue"="Transparent" 
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
        }
		LOD 200
		
		CGPROGRAM
		
		#include "UnityCG.cginc"
        #pragma surface surf NoLighting alpha:fade
		
		sampler2D _MainTex;
		float _DeltaX;
		float _DeltaY;
        float4 _LineColor;
        float4 _EmissionColor;
        float _MinDenoiseOffset;
        float _MaxDenoiseOffset;

        struct Input
        {
            float2 uv_MainTex;
        };
		
		float sobel (sampler2D tex, float2 uv) {
			float2 delta = float2(_DeltaX, _DeltaY);
			
			float4 hr = float4(0, 0, 0, 0);
			float4 vt = float4(0, 0, 0, 0);
			
			hr += tex2D(tex, (uv + float2(-1.0, -1.0) * delta)) *  1.0;
			hr += tex2D(tex, (uv + float2( 0.0, -1.0) * delta)) *  0.0;
			hr += tex2D(tex, (uv + float2( 1.0, -1.0) * delta)) * -1.0;
			hr += tex2D(tex, (uv + float2(-1.0,  0.0) * delta)) *  2.0;
			hr += tex2D(tex, (uv + float2( 0.0,  0.0) * delta)) *  0.0;
			hr += tex2D(tex, (uv + float2( 1.0,  0.0) * delta)) * -2.0;
			hr += tex2D(tex, (uv + float2(-1.0,  1.0) * delta)) *  1.0;
			hr += tex2D(tex, (uv + float2( 0.0,  1.0) * delta)) *  0.0;
			hr += tex2D(tex, (uv + float2( 1.0,  1.0) * delta)) * -1.0;
			
			vt += tex2D(tex, (uv + float2(-1.0, -1.0) * delta)) *  1.0;
			vt += tex2D(tex, (uv + float2( 0.0, -1.0) * delta)) *  2.0;
			vt += tex2D(tex, (uv + float2( 1.0, -1.0) * delta)) *  1.0;
			vt += tex2D(tex, (uv + float2(-1.0,  0.0) * delta)) *  0.0;
			vt += tex2D(tex, (uv + float2( 0.0,  0.0) * delta)) *  0.0;
			vt += tex2D(tex, (uv + float2( 1.0,  0.0) * delta)) *  0.0;
			vt += tex2D(tex, (uv + float2(-1.0,  1.0) * delta)) * -1.0;
			vt += tex2D(tex, (uv + float2( 0.0,  1.0) * delta)) * -2.0;
			vt += tex2D(tex, (uv + float2( 1.0,  1.0) * delta)) * -1.0;
			
			return sqrt(hr * hr + vt * vt);
		}

        fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            fixed4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            float s = sobel(_MainTex, IN.uv_MainTex);
            o.Albedo =  s * _LineColor.rgb;
            o.Emission = (1-s) * _EmissionColor.rgb;
            float a = s > _MinDenoiseOffset ? s : 0;
            a = a > _MaxDenoiseOffset ? 1 : a;

            o.Alpha = a;
        }
		ENDCG		
	} 
	FallBack "Diffuse"
}