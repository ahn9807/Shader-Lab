Shader "Custom/GrabPassShader"
{
    Properties
    {

    }
    SubShader
    {
        Tags{ "Queue" = "Transparent" }
        GrabPass
        {

        }
        Pass
        {
            CGPROGRAM
            // Physically based Standard lighting model, and enable shadows on all light types
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            //GrabPass 를 사용하여 현재 화면 내용을 이 텍스쳐 안에 잡아둔다. 
            sampler2D _GrabTexture;

            struct vertInput 
            {
                float4 pos : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct vertOutput
            {
                float4 vertex : SV_POSITION;
                float4 uvgrab : TEXCOORD1;
            };

            vertOutput vert(vertInput input) {
                vertOutput o;
                o.vertex = UnityObjectToClipPos(input.pos);
                o.uvgrab = ComputeGrabScreenPos(o.vertex);
                return o;
            }

            half4 frag(vertOutput output) : COLOR 
            {
                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(output.uvgrab));
                return col + half4(0.5,0,0,0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
