using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GunCutoffScript : MonoBehaviour {

	public Transform rayOrigin;
	public float gunLength;
	public float cutoffPoint;
	public LayerMask cutoffLayers;
	
	Material thisMaterial;

	void Start ()
	{
		thisMaterial = this.GetComponent<MeshRenderer>().materials[0];
	}

	void Update () 
	{
		Debug.DrawRay(rayOrigin.position, rayOrigin.forward * gunLength);
		RaycastHit hit;
		if(Physics.Raycast(rayOrigin.position, rayOrigin.forward, out hit, gunLength,cutoffLayers))
		{
			float distanceToCutoff = Vector3.Distance(rayOrigin.position, hit.point);
			cutoffPoint = 1 - (distanceToCutoff / gunLength);
		}
		else
		{
			cutoffPoint = 0;
		}

		thisMaterial.SetFloat("DissolveAmount", cutoffPoint);
	}
}
