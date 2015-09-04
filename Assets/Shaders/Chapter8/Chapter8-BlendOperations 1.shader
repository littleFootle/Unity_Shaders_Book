﻿Shader "Unity Shader Book/Chapter8-Blend Operations 1" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_AlphaScale ("Alpha Scale", Range(0, 1)) = 1
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		
		Pass {
			Tags { "LightMode"="ForwardBase" }
			
			ZWrite Off
			
//			// Normal
//			Blend SrcAlpha OneMinusSrcAlpha
//			
//			// Soft Additive
//			Blend OneMinusDstColor One
//			
//			// Multiply
			Blend DstColor Zero
//			
//			// 2x Multiply
//			Blend DstColor SrcColor
//			
//			// Darken
//			BlendOp Min
//			Blend One One	// When using Min operation, these factors are ignored
//			
//			//  Lighten
//			BlendOp Max
//			Blend One One // When using Max operation, these factors are ignored
//			
//			// Screen
//			Blend OneMinusDstColor One
			// Or
//			Blend One OneMinusSrcColor
//			
//			// Linear Dodge
			Blend One One
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"
			
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed _AlphaScale;
			
			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 position : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPosition : TEXCOORD1;
				float2 uv : TEXCOORD2;
			};
			
			v2f vert(a2v v) {
			 	v2f o;
			 	// Transform the vertex from object space to projection space
			 	o.position = mul(UNITY_MATRIX_MVP, v.vertex);

			 	o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
			 	
			 	return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {				
				fixed4 texColor = tex2D(_MainTex, i.uv);
			 	
				return fixed4(texColor.rgb * _Color.rgb, texColor.a * _AlphaScale);
			}
			
			ENDCG
		}
	} 
	FallBack "Diffuse"
}