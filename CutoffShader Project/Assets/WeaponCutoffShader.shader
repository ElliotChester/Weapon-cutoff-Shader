Shader "Transitions/LocalSpaceTransparentTransitionShader"
{
	Properties
	{
		[Header(Texture 1)]
		Texture1("Texture", 2D) = "white" {}
		Color1("Tint", Color) = (1,1,1,1)
		Glossiness1("Smoothness", Range(0,1)) = 0.5
		Metallic1("Metallic", Range(0,1)) = 0.0

		[Header(Transition Texture)]
		TransitionTexture("Texture" , 2D) = "white" {}
		TransitionColor("Transition Color", Color) = (1,1,1,1)
		TransitionEmission("Transition Emission", Range(0,1)) = 1
		TransitionScale("Transition Scale", Float) = 1
		TransitionOffset("Transition Offset", Vector) = (0,0,0,0)

		[Header(Texture 2)]
		Texture2("Texture", 2D) = "white" {}
		Color2("Tint", Color) = (1,1,1,1)
		Glossiness2("Smoothness", Range(0,1)) = 0.5
		Metallic2("Metallic", Range(0,1)) = 0.0

		[Space(20)]

		DissolveAmount("Dissolve Amount", Range(0,1)) = 1
	}

		SubShader
	{

		Tags{ "RenderType" = "Opaque" }
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite on

		CGPROGRAM

#pragma surface surf Standard fullforwardshadows vertex:vert

#pragma target 3.0

		float4 Color1;
	sampler2D Texture1;

	half Glossiness1;
	half Metallic1;

	sampler2D TransitionTexture;
	float TransitionScale;

	float4 TransitionOffset;

	float DissolveAmount;

	struct Input
	{
		float2 uvTexture1;
		float3 localPos;
	};

	void vert(inout appdata_full v, out Input o)
	{
		UNITY_INITIALIZE_OUTPUT(Input,o);
		o.localPos = v.vertex.xyz + ((float3(0.5,0.5,0) * TransitionScale) + TransitionOffset.xyz);
	}

	void surf(Input IN, inout SurfaceOutputStandard o)
	{
		float3 localPosUV = IN.localPos;
		localPosUV /= TransitionScale;
		half4 dissolveColor = tex2D(TransitionTexture, localPosUV);

		clip(dissolveColor.rgb - DissolveAmount);

		half4 c1 = tex2D(Texture1, IN.uvTexture1) * Color1;
		o.Albedo = c1.rgb;
		o.Metallic = Metallic1;
		o.Smoothness = Glossiness1;
		o.Alpha = c1.a;
	}

	ENDCG 
	}
		//FallBack "Diffuse"
}