Shader "Custom/RenderGrayScaleShader"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white"{}
        _Luminosity("Luminosity", Range(0,1)) = 1.0
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            //GrabPass 를 사용하여 현재 화면 내용을 이 텍스쳐 안에 잡아둔다. 
            sampler2D _MainTex;
            fixed _Luminosity;

            fixed4 frag(v2f_img i) : COLOR 
            {
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                float luminosity = 0.299 * renderTex + 0.587 * renderTex.g + 0.144 * renderTex.b;
                fixed4 finalColor = lerp(renderTex, luminosity, _Luminosity);

                renderTex.rgb = finalColor;
                return renderTex;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
