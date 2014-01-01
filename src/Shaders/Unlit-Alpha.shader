// Unlit alpha-blended shader.
// - no lighting
// - no lightmap support
// - no per-material color

Shader "ParticleSystemScaler/Unlit/Transparent" {
Properties {
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_ParticleSystemLocation ("ParticleSystem Scale", Vector) = (0.0,0.0,0.0,1.0)
}

SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 100
	
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha 
	
	Pass {  
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _ParticleSystemLocation;
			uniform float4x4 _ParticleSystemScale;
			
			v2f vert (appdata_t v)
			{
				float4 localVertex = v.vertex - _ParticleSystemLocation;
				localVertex = mul(_ParticleSystemScale, localVertex);
				localVertex = localVertex + _ParticleSystemLocation;
				
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, localVertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR
			{
				fixed4 col = tex2D(_MainTex, i.texcoord);
				return col;
			}
		ENDCG
	}
}

}
