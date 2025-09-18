Shader "Water/Gerstner"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
                
        _WaveA("Wave A (dir(x, y), steepness(z), wavelength(x))", Vector) = (1, 0, 0.5, 10)
        _WaveB("Wave B", Vector) = (1, 0, 0.5, 10)
        _WaveC("Wave C", Vector) = (1, 0, 0.5, 10)
    }
    
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow
        #pragma target 3.0

        #define TAU 6.283185307179586
        #define HALF_TAU TAU / 2

        sampler2D _MainTex;
        // float4 _MainTex_ST;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float4 _WaveA, _WaveB, _WaveC;

        float3 GerstnerWave(float4 wave, float3 pos, inout float3 tangent, inout float3 binormal)
        {
            float steepness = wave.z;
            float wavelength = wave.w;

            float waveLen = TAU / wavelength;
            float speed = sqrt(9.8 / waveLen);
            float2 dir = normalize(wave.xy);
            float f = (dot(dir, pos.xz) - speed * _Time.y) * waveLen;
            float amplitude = steepness / waveLen;

            tangent += float3(1 - dir.x * dir.x * (steepness * sin(f)), dir.x * (steepness * cos(f)), -dir.x * dir.y * (steepness * sin(f))); 
            binormal += float3(-dir.x * dir.y * (steepness * sin(f)), dir.y * (steepness * cos(f)), 1 - dir.y * dir.y * (steepness * sin(f)));

            return float3((cos(f) * amplitude) * dir.x, sin(f) * amplitude, (cos(f) * amplitude) * dir.y);
        }

        void vert(inout appdata_full vertexData)
        {
            float3 vertex = vertexData.vertex.xyz;
            float3 tangent = float3(1, 0, 0);
            float3 binormal = float3(0, 0, 1);
            float3 p = vertex;
            p += GerstnerWave(_WaveA, vertex, tangent, binormal);
            p += GerstnerWave(_WaveB, vertex, tangent, binormal);
            p += GerstnerWave(_WaveC, vertex, tangent, binormal);
            
            float3 normal = normalize(cross(binormal, tangent));
            
            vertexData.vertex.xyz = p;
            vertexData.normal = normal;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}