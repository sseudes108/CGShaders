Shader "ShaderCourse/Lesson4Shader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _Color("Tint Color", COLOR) = (1,0,0,1)

        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor("Src Factor", float) = 5

        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor("Dst Factor", float) = 10

        [Enum(UnityEngine.Rendering.BlendOp)]
        _Opp("Operation", float) = 0

        _Speed("Speed", Range(0.0, 10.0)) = 0

        _Scale("Scale", Range(0.1, 10)) = 0

        _Interval("Interval", Range(0.1, 10)) = 0
        _Amp("Amplitude", Range(0.1, 10)) = 0
        _Offset("Offset", Range(0.1, 10)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Blend [_SrcFactor] [_DstFactor]
        BlendOp [_Opp]
        
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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Speed;
            float _Scale;
            float _Interval;
            float _Amp;
            float _Offset;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // o.uv += float2(_Time.x * _Speed, _Time.x * _Speed) * _MainTex_ST.xy;
                float scale = sin(_Interval *_Time.x)/1/_Amp + _Offset;
                o.uv = (o.uv - 0.5) * 1/scale + 0.5;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv);
                return tex;
            }
            ENDCG
        }
    }
}
