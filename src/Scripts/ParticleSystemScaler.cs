using UnityEngine;
using System.Collections;

public class ParticleSystemScaler : MonoBehaviour
{

	private Vector3 scale = new Vector3(1,1,1);
	private Vector4 center;
	private ParticleSystem myParticleSystem = null;
	private bool isSystemRoot = false;
	private bool isInitialized = false;

	private Material material;

	public Vector3 ParticleSystemScale
	{
		set
		{
			Scale = value;
			if ( isSystemRoot )
			{
				setChildScale(transform,value);
			}
		}
	}

	private Vector3 Scale
	{
		set
		{
			scale = value;
			if ( material != null )
			{
				material.SetMatrix( "_ParticleSystemScale", Matrix4x4.Scale(scale) );
			}
		}
	}
	private Vector4 Center
	{
		set
		{
			center = value;
			if ( material != null )
			{
				material.SetVector( "_ParticleSystemLocation", new Vector4(center.x, center.y, center.z, 1.0f) );
			}
		}
	}

	private static void setChildScale( Transform root, Vector3 scale )
	{
		for ( int i = 0; i < root.childCount; ++i )
		{
			Transform child = root.GetChild(i);
			ParticleSystemScaler pss = child.GetComponent<ParticleSystemScaler>();
			if ( pss != null )
			{
				pss.Scale = scale;
			}
			setChildScale( child.transform, scale );
		}
	}
	private static void setChildCenters( Transform root, Vector4 center )
	{
		for ( int i = 0; i < root.childCount; ++i )
		{
			Transform child = root.GetChild(i);
			ParticleSystemScaler pss = child.GetComponent<ParticleSystemScaler>();
			if ( pss != null )
			{
				pss.Center = center;
			}
			setChildCenters( child.transform, center );
		}
	}

	void UpdatePosition()
	{
		if ( !isSystemRoot || myParticleSystem == null )
		{
			return;
		}

		Matrix4x4 localToWorld = myParticleSystem.transform.localToWorldMatrix;
		Vector4 curPosition = localToWorld.GetColumn(3);
		if ( center == curPosition )
			return;

		Center = curPosition;
		setChildCenters( transform, center );
	}

	bool checkIfRoot()
	{
		Transform p = transform.parent;
		while ( p != null )
		{
			if ( p.GetComponent<ParticleSystem>() != null )
			{
				return false;
			}
			p = transform.parent;
		}

		return true;
	}

	// Use this for initialization
	void Start ()
	{
		isSystemRoot = checkIfRoot();

		myParticleSystem = GetComponent<ParticleSystem>();
		if ( myParticleSystem != null )
		{
			material = myParticleSystem.renderer.material;
		}
	}
	
	// Update is called once per frame
	void Update ()
	{
		if ( !isInitialized )
		{
			if ( isSystemRoot )
			{
				ParticleSystemScale = scale;
			}
			isInitialized = true;
		}

		UpdatePosition();
	}
}
