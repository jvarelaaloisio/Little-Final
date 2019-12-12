using UnityEngine;
using System;
using System.IO;
using UnityEditor;

[CustomEditor(typeof(CloudScapeGenerator))]

[System.Serializable]
public class CloudScapeGeneratorEditor : Editor
{
	public string generatedOutputFolder = "Toon Clouds/GeneratedCloudScapes/";
	public CloudScapeGenerator tar;

	public override void OnInspectorGUI()
	{
		tar = (CloudScapeGenerator)target;
		Texture tex = (Texture)Resources.Load("CloudScapeGeneratorTitle");
		GUILayout.Label(tex);
		DrawDefaultInspector();
		EditorGUILayout.Space();
		EditorGUILayout.Space();
		EditorGUILayout.LabelField("Generate Cloud Scape");



		if (GUILayout.Button("Generate"))
		{
			DestroyAllImmediate();
			generateClouds();
		}
		EditorGUILayout.LabelField("(You can move,scale and rotate gameObjects manually after generating)");
		EditorGUILayout.Space();
		EditorGUILayout.Space();
		EditorGUILayout.LabelField("Clear Cloud Scape GameObjects");
		if (GUILayout.Button("Clear"))
		{
			DestroyAllImmediate();
		}
		EditorGUILayout.Space();
		EditorGUILayout.Space();
		if (!tar.multipleParticleSystems)
		{

			EditorGUILayout.LabelField("Save Mesh to Asset Folder");

			if (GUILayout.Button("Save"))
			{
				Vector3 posBuffer = tar.transform.position;
				tar.transform.position = Vector3.zero;
				combineMeshes();
				tar.transform.position = posBuffer;
			}
			EditorGUILayout.LabelField("(Automaticly replaces mesh emitter in tar Particle System)");
			EditorGUILayout.LabelField("Manually adjust Max Particles, Emission Rate and Start Size");
			EditorGUILayout.Space();
			EditorGUILayout.Space();
			EditorGUILayout.LabelField("Output Folder Path");
			generatedOutputFolder = EditorGUILayout.TextField(generatedOutputFolder);
			EditorGUILayout.LabelField("(Folder must exist)");
		}
		else
		{
			EditorGUILayout.LabelField("Save Prefab to Asset Folder");
			if (GUILayout.Button("Save"))
			{
				string[] f = Directory.GetFiles(UnityEngine.Application.dataPath + "/" + generatedOutputFolder);
				UnityEngine.Object prefab = PrefabUtility.SaveAsPrefabAsset(tar.gameObject, "Assets/" + generatedOutputFolder + "GeneratedCloudScape" + f.Length + ".prefab");
				//UnityEngine.Object prefab = PrefabUtility.CreateEmptyPrefab("Assets/" + generatedOutputFolder + "GeneratedCloudScape" + f.Length + ".prefab");
				PrefabUtility.SaveAsPrefabAsset(tar.gameObject, f.ToString());
				//PrefabUtility.ReplacePrefab(tar.gameObject, prefab, ReplacePrefabOptions.ReplaceNameBased);
			}
			EditorGUILayout.LabelField("(Multiple Particle Systems requires more CPU)");
			EditorGUILayout.LabelField("(Manually move systems to prevent sort popping)");
		}
	}

	public void DestroyAllImmediate()
	{
		while (tar.transform.childCount > 0)
		{
			DestroyImmediate(tar.transform.GetChild(0).gameObject);
		}
	}

	public void combineMeshes()
	{
		GameObject combinedFrags = new GameObject();
		combinedFrags.AddComponent<MeshFilter>();
		combinedFrags.AddComponent<MeshRenderer>();

		MeshFilter[] meshFilters = tar.transform.GetComponentsInChildren<MeshFilter>();
		//combinedFrags.GetComponent(MeshRenderer).sharedMaterial = meshFilters[0].transform.gameObject.GetComponent(MeshRenderer).sharedMaterial;
		CombineInstance[] combine = new CombineInstance[meshFilters.Length];
		for (int i = 0; i < meshFilters.Length; i++)
		{
			combine[i].mesh = meshFilters[i].sharedMesh;
			combine[i].transform = meshFilters[i].transform.localToWorldMatrix;
		}
		combinedFrags.GetComponent<MeshFilter>().mesh = new Mesh();
		combinedFrags.GetComponent<MeshFilter>().sharedMesh.CombineMeshes(combine);
		Mesh newMesh = combinedFrags.GetComponent<MeshFilter>().sharedMesh;
		string[] f = Directory.GetFiles(UnityEngine.Application.dataPath + "/" + generatedOutputFolder);
		AssetDatabase.CreateAsset(newMesh, "Assets/" + generatedOutputFolder + "GeneratedCloudScape" + f.Length + ".asset");
		Debug.Log("Created Asset : " + generatedOutputFolder + f.Length + ".asset");
		AssetDatabase.SaveAssets();
		if (tar.targetParticleSystem != null)
		{
			ParticleSystem ps = tar.targetParticleSystem.GetComponent<ParticleSystem>();
			SerializedObject psSerial = new SerializedObject(ps);
			psSerial.FindProperty("ShapeModule.m_Mesh").objectReferenceValue = combinedFrags.GetComponent<MeshFilter>().sharedMesh;
			psSerial.ApplyModifiedProperties();
			ps.Stop();
			ps.Play();
			Debug.Log("Replaced Mesh Emitter in " + tar.targetParticleSystem.name);
		}
		else
		{
			Debug.LogWarning("No tar Particle System Selected");

		}
		DestroyImmediate(combinedFrags.gameObject);
	}




	public void ScalePs(GameObject __parent_cs1, ParticleSystem __particles_cs1)
	{

		if (__parent_cs1 != __particles_cs1.gameObject)
		{
			__particles_cs1.transform.localPosition *= tar._scaleMultiplier;
		}
		SerializedObject serializedParticles = new SerializedObject(__particles_cs1);
		serializedParticles.FindProperty("InitialModule.startSize.scalar").floatValue *= tar._scaleMultiplier;


		serializedParticles.FindProperty("InitialModule.gravityModifier.scalar").floatValue *= tar._scaleMultiplier;

		serializedParticles.FindProperty("InitialModule.startSpeed.scalar").floatValue *= tar._scaleMultiplier;

		serializedParticles.FindProperty("NoiseModule.strength.scalar").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("LightsModule.rangeCurve.scalar").floatValue *= tar._scaleMultiplier;


		serializedParticles.FindProperty("ShapeModule.boxX").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("ShapeModule.boxY").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("ShapeModule.boxZ").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("ShapeModule.radius").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("VelocityModule.x.scalar").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("VelocityModule.y.scalar").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("VelocityModule.z.scalar").floatValue *= tar._scaleMultiplier;
		ScaleCurve(serializedParticles.FindProperty("VelocityModule.x.minCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("VelocityModule.x.maxCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("VelocityModule.y.minCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("VelocityModule.y.maxCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("VelocityModule.z.minCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("VelocityModule.z.maxCurve").animationCurveValue);
		serializedParticles.FindProperty("ClampVelocityModule.x.scalar").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("ClampVelocityModule.y.scalar").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("ClampVelocityModule.z.scalar").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("ClampVelocityModule.magnitude.scalar").floatValue *= tar._scaleMultiplier;
		ScaleCurve(serializedParticles.FindProperty("ClampVelocityModule.x.minCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ClampVelocityModule.x.maxCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ClampVelocityModule.y.minCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ClampVelocityModule.y.maxCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ClampVelocityModule.z.minCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ClampVelocityModule.z.maxCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ClampVelocityModule.magnitude.minCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ClampVelocityModule.magnitude.maxCurve").animationCurveValue);
		serializedParticles.FindProperty("ForceModule.x.scalar").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("ForceModule.y.scalar").floatValue *= tar._scaleMultiplier;
		serializedParticles.FindProperty("ForceModule.z.scalar").floatValue *= tar._scaleMultiplier;
		ScaleCurve(serializedParticles.FindProperty("ForceModule.x.minCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ForceModule.x.maxCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ForceModule.y.minCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ForceModule.y.maxCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ForceModule.z.minCurve").animationCurveValue);
		ScaleCurve(serializedParticles.FindProperty("ForceModule.z.maxCurve").animationCurveValue);
		serializedParticles.ApplyModifiedProperties();
	}

	public void ScaleCurve(AnimationCurve curve)
	{
		for (int i = 0; i < curve.keys.Length; i++)
		{
			var tmp_cs1 = curve.keys[i];
			tmp_cs1.value *= tar._scaleMultiplier;
			curve.keys[i] = tmp_cs1;
		}
	}
	public void generateClouds()
	{
		//Detect particle system
		bool multipleParticleSystems = false;
		bool fixedScale = false;
		if (tar.cloudMeshes[0].GetComponent<ParticleSystem>() != null)
		{
			multipleParticleSystems = true;
			Debug.Log("Detected Particle System in Cloud Meshes array; Generating multiple particles systems (!Performance)(Manually move systems to prevent sort popping)");
			fixedScale = true;
		}
		else
		{
			multipleParticleSystems = false;
		}

		for (int i = 0; i < tar.cloudAmount; i++)
		{
			GameObject newCloud = (GameObject)Instantiate(tar.cloudMeshes[(int)UnityEngine.Random.Range(tar.cloudMeshes.Length - .501f, -1)], tar.transform.position + new Vector3(UnityEngine.Random.Range(-tar.areaScale, tar.areaScale), UnityEngine.Random.Range(-tar.areaHeight, tar.areaHeight), UnityEngine.Random.Range(-tar.areaScale, tar.areaScale)), tar.transform.rotation);
			newCloud.transform.Rotate(new Vector3(0.0f, (float)UnityEngine.Random.Range(0, 360), 0.0f));
			newCloud.transform.parent = tar.transform;
			tar._scaleMultiplier = UnityEngine.Random.Range(tar.minScale, tar.maxScale);
			if (!fixedScale)
			{
				newCloud.transform.localScale = new Vector3(UnityEngine.Random.Range(tar.minScale, tar.maxScale), UnityEngine.Random.Range(tar.minScale, tar.maxScale), UnityEngine.Random.Range(tar.minScale, tar.maxScale));
			}
			else
			{
				newCloud.transform.localScale = new Vector3(tar._scaleMultiplier, tar._scaleMultiplier, tar._scaleMultiplier);
				if (multipleParticleSystems)
				{
					newCloud.GetComponent<ParticleSystem>().Stop();
					ScalePs(newCloud, newCloud.GetComponent<ParticleSystem>());
					newCloud.GetComponent<ParticleSystem>().Play();
				}
			}
		}
	}
}
