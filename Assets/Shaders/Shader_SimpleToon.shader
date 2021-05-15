// This shader visuzlizes the normal vector values on the mesh.
Shader "Custom/Shader_SimpleToon"
{
    Properties
    {
        _IntensityMap ( "IntensityMap", 2D ) = "black"
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            Tags
            {
                "LightMode" = "UniversalForward"
                //"LightMode" = "SRPDefaultUnlit"
            }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Vin
            {
                float4 positionOS   : POSITION;
                half3 normalOS      : NORMAL;
            };

            struct Vout
            {
                float4 positionHCS : SV_POSITION;
                float2 intensityUV : TEXCOORD0;
                half3 normal : COLOR;
            };

            TEXTURE2D(_IntensityMap);
            SAMPLER(sampler_IntensityMap);

            Vout vert( Vin In )
            {
                Light mainLight = GetMainLight();

                float3 lightDir = mainLight.direction;
                float3 normalWS = TransformObjectToWorldNormal( In.normalOS );
                float2 intensityUV = float2( saturate( dot( normalWS, lightDir ) ), 0.0f );

                Vout Out = (Vout)0;
                Out.positionHCS = TransformObjectToHClip( In.positionOS.xyz );
                Out.intensityUV = intensityUV;
                //Out.normal = half3( intensityUV, 0.0f );
                return Out;
            }

            half4 frag(Vout In) : SV_Target
            {
                half4 Out = SAMPLE_TEXTURE2D( _IntensityMap, sampler_IntensityMap, In.intensityUV );
                //half4 Out = half4( In.normal, 1.0f );

                return Out;
            }

            ENDHLSL
        }
    }

    FallBack "Hidden/Shader Graph/FallbackError"
}