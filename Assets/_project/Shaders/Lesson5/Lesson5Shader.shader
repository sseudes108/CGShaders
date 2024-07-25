Shader "ShaderCourse/Lesson5Shader"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}

        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor("Src Factor", float) = 5

        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor("Dst Factor", float) = 10

        [Enum(UnityEngine.Rendering.BlendOp)]
        _Opp("Operation", float) = 0

        _SecundaryTex("Secundary Texture", 2D) = "white" {}
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
                float4 uv1_uv2 : TEXCOORD0;
                // float2 uv2 : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _SecundaryTex;
            float4 _SecundaryTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv1_uv2.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv1_uv2.zw = TRANSFORM_TEX(v.uv, _SecundaryTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 mainTex = tex2D(_MainTex, i.uv1_uv2.xy);
                fixed4 secTex = tex2D(_SecundaryTex, i.uv1_uv2.zw);
                
                fixed3 color = mainTex * secTex.a + secTex * (1 - secTex.a);
                fixed alpha = mainTex.a;

                return fixed4(color, alpha);
            }
            ENDCG
        }
    }
}
