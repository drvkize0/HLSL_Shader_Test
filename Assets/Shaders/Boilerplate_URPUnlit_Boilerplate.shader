// This shader visuzlizes the normal vector values on the mesh.
Shader "Custom/Shader_SimpleToon"
{
    Properties
    {
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Vin
            {
                float4 positionOS   : POSITION;
                half3 normal        : NORMAL;
            };

            struct Vout
            {
                float4 positionHCS  : SV_POSITION;
                half3 normal        : TEXCOORD0;
            };

            Vout vert( Vin In )
            {
                Vout Out = (Vout)0;

                Out.positionHCS = TransformObjectToHClip( In.positionOS.xyz );
                Out.normal = TransformObjectToWorld( In.normal );

                return Out;
            }

            half4 frag(Vout IN) : SV_Target
            {
                return half4( 1.0f, 0.0f, 0.0f, 1.0f );
            }

            ENDHLSL
        }
    }

    FallBack "Hidden/Shader Graph/FallbackError"
}