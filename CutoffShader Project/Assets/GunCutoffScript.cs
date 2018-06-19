using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GunCutoffScript : MonoBehaviour {

	public Transform rayOrigin;
	public float fullModel;
	public float noModel;

	public float cutoffPoint;
	public LayerMask cutoffLayers;
	
	Material thisMaterial;

	void Start ()
	{
		thisMaterial = this.GetComponent<MeshRenderer>().materials[0];
	}

	void Update () 
	{
		float differenceBetweenPoints = noModel - fullModel;
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
			cutoffPoint = fullModel - (gunLength - distanceToCutoff);
		}
		else
		{
			cutoffPoint = fullModel;
		}

		thisMaterial.SetFloat("_DissolveAmount", cutoffPoint);
	}
}
