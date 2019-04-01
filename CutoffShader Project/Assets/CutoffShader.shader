Shader "Custom/CutoffShader"
{
	Properties
	{
		[Header(Texture 1)]
		_Texture("Texture", 2D) = "white" {}
		_texColor("Tint", Color) = (1,1,1,1)
		_NormalMap("Normal Map", 2D) = "bump" {}
		_MetallicMap("Metallic Texture", 2D) = "white" {}
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Smoothness("Smoothness", Range(0,1)) = 0.5


		[Space(20)]

		_DissolveAmount("Dissolve Amount", Range(-2,2)) = 0
	}

		SubShader
	{

		Tags{ "RenderType" = "Transparent" }
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite on

		CGPROGRAM

#pragma surface surf Standard fullforwardshadows vertex:vert

#pragma target 3.0

		float4 _texColor;
		sampler2D _Texture, _NormalMap, _MetallicMap;

		half _Smoothness;
		half _Metallic;

		sampler2D _TransitionTexture;
		float _TransitionScale;

		float4 _TransitionOffset;

		float _DissolveAmount;

		struct Input
		{
			float2 uv_Texture;
			float2 uv_NormalMap;
			float2 uv_MetallicMap;
			float3 localPos;
		};

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			o.localPos = v.vertex.xyz + ((float3(1,0,0) * _TransitionScale) + _DissolveAmount);
		}

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			clip(IN.localPos.x + 0.01);

			half4 c = tex2D(_Texture, IN.uv_Texture) * _texColor;
			o.Albedo = c.rgb;
			
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));

			half4 m = tex2D(_MetallicMap, IN.uv_MetallicMap) * _Metallic;
			o.Metallic = _Metallic;
			
			o.Smoothness = _Smoothness;
		}
		ENDCG 
	}
	FallBack "Diffuse"
}