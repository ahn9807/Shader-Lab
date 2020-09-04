Shader "Custom/WaterShader"
{
    Properties
    {
        _NoiseTex ("Noise Tex", 2D) = "white"{}
        _Color ("Color", Color) = (1,1,1,1)
        _Period ("Period", Range(0,50)) = 1
        _Magnitude ("Magnitude", Range(0,0.5)) = 0.05
        _Scale("Scale", Range(0,10)) = 1
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
            sampler2D _NoiseTex;
            fixed4 _Color;
            float _Period;
            float _Magnitude;
            float _Scale;

            struct vertInput 
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct vertOutput
            {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
                float4 uvgrab : TEXCOORD2;
            };

            vertOutput vert(vertInput input) {
                vertOutput o;
                o.vertex = UnityObjectToClipPos(input.vertex);
                o.color = input.color;
                o.texcoord = input.texcoord;

                o.worldPos = mul(unity_ObjectToWorld, input.vertex);
                o.uvgrab = ComputeGrabScreenPos(o.vertex);
                return o;
            }

            half4 frag(vertOutput output) : COLOR 
            {
                float sinT = sin(_Time.w / _Period);

                float distX = tex2D(_NoiseTex, output.worldPos.xy / _Scale + float2(sinT, 0)).r - 0.5;
                float distY = tex2D(_NoiseTex, output.worldPos.xy / _Scale + float2(0, sinT)).r - 0.5;

                float2 distortion = float2(distX, distY);
                output.uvgrab.xy += distortion * _Magnitude;
                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(output.uvgrab));
                
                return col * _Color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
