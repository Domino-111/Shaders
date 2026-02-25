Shader "Unlit/HealthBar"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Health ("Health", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Health; //= sin(_Time.y * 1) * 0.5 + 0.5;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float healthbarMask = _Health > i.uv.x;
                                                    //Clamp01 = saturate    
                float3 barColor = float3(0, 0.6, 0) * saturate(0.2 + i.uv.x);
                float3 bgColor = (0.1).xxx * (1 - i.uv.x);
                float3 outColor = lerp(bgColor, barColor, healthbarMask);
                
                return float4 (outColor, 1);
            }
            ENDCG
        }
    }
}
