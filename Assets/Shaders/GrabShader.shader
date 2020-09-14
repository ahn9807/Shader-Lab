Shader "Custom/GrabShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Noise Text", 2D)= "bump"{}
        _Magnitude("Magnitude", Range(0,1))=0.05
    }
    SubShader
    {
        GrabPass
        {
            
        }
        Pass
        {
            sampler2D _MainTex;
            fixed4 _Color;
            sampler2D _BumpMap;
            float _Magnitude;

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            sampler2D _GrabTexture;

            struct vertInput
            {
                float4 vertex : POSITION;
            };

            struct vertOutput
            {
                float4 vertex : POSITION;
                float4 uvgrab : TEXCOORD1;
            };

            vertOutput vert(vertInput v) 
            {
                vertOutput o;

                return o;
            }

            half4 frag(vertOutput i) : COLOR
            {
                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PORJ_COORD(i.uvgrab));
                return col + half4(0.5,0,0,0);
            }
            ENDCG

        }
    }
    FallBack "Diffuse"
}
