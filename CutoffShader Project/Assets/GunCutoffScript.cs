using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GunCutoffScript : MonoBehaviour {

	public Transform rayOrigin;
    [Range (-2, 2)]
	public float fullModelDissolveAmt = 1;
    [Range (-2, 2)]
	public float noModelDissolveAmt = -1;

	float cutoffPoint;
	public LayerMask cutoffLayers;
	
	Material thisMaterial;

	void Start ()
	{
		thisMaterial = this.GetComponent<MeshRenderer>().materials[0];
	}

	void Update () 
	{
		float differenceBetweenPoints = noModelDissolveAmt - fullModelDissolveAmt;
		float gunLength = differenceBetweenPoints;
		if(gunLength < 0){
			gunLength *= -1;
		}

		Debug.Log("GunLength is " + gunLength);

		//Debug.DrawRay(rayOrigin.position, rayOrigin.forward * gunLength);

		RaycastHit hit;
		if(Physics.Raycast(rayOrigin.position, rayOrigin.forward, out hit, gunLength, cutoffLayers))
		{
			Debug.Log("Hit a Wall");
			float distanceToCutoff = Vector3.Distance(rayOrigin.position, hit.point);
			cutoffPoint = fullModelDissolveAmt - (gunLength - distanceToCutoff);
		}
		else
		{
			cutoffPoint = fullModelDissolveAmt;
		}

		thisMaterial.SetFloat("_DissolveAmount", cutoffPoint);
	}
}
