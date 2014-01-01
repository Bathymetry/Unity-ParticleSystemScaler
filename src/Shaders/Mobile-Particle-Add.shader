Shader "ParticleSystemScaler/Mobile/Particles/Additive" {
Properties {
	_MainTex ("Particle Texture", 2D) = "white" {}
	_ParticleSystemLocation ("ParticleSystem Scale", Vector) = (0.0,0.0,0.0,1.0)
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend SrcAlpha One
	ColorMask RGB
	Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
	
	SubShader {
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_particles

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			
			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};
			
			float4 _MainTex_ST;
			float4 _ParticleSystemLocation;
			uniform float4x4 _ParticleSystemScale;

			v2f vert (appdata_t v)
			{
				float4 localVertex = mul(UNITY_MATRIX_MV, v.vertex);
				float4 localSystemLocation = mul(UNITY_MATRIX_V, _ParticleSystemLocation);
				
				localVertex = localVertex - localSystemLocation;
				localVertex = mul(_ParticleSystemScale, localVertex);
				localVertex = localVertex + localSystemLocation;
			
				v2f o;
				o.vertex = mul(UNITY_MATRIX_P, localVertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				return i.color * tex2D(_MainTex, i.texcoord);
			}
			ENDCG 
		}
	}	
}
}
