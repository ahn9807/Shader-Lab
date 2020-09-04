Shader "Custom/ChromakeyShader" {
    Properties {
         _MainTex ("Base (RGB)", 2D) = "white" {}
         _Sens ("Sensiblity", Range (0,1)) = 0.3
         _Cutoff("Cutoff", Range(0, 1)) = 0.1
         _Color ("Chroma", Color) = (0, 0, 0)
    }
    
    SubShader {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 200
        
        CGPROGRAM
        #pragma surface surf NoLighting alpha 

        sampler2D _MainTex;
        float _Cutoff;
        float _Sens;
        half3 _Color;


        struct Input {
            float2 uv_MainTex;
        };

        fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            fixed4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
        }

        void surf (Input IN, inout SurfaceOutput o) {
            //Inverse ChromaKey
            half4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            
            float aR = abs(c.r - _Color.r) < _Sens ? abs(c.r - _Color.r) : 1;
            float aG = abs(c.g - _Color.g) < _Sens ? abs(c.g - _Color.g) : 1;
            float aB = abs(c.b - _Color.b) < _Sens ? abs(c.b - _Color.b) : 1; 

            float a = 1- (aR + aG + aB) / 3; 

            if(_Cutoff == 0) {
                o.Alpha = a;
            } else {
                if (a < _Cutoff) {
                    o.Alpha = 0;
                } else {
                    o.Alpha = 1;
                }
            }
        }
        ENDCG
    }
    FallBack "Diffuse"
}
