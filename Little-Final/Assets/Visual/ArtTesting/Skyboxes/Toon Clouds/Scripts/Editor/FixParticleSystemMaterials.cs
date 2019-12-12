using UnityEngine;
using System;
using UnityEditor;
[System.Serializable]
public class FixParticleSystemMaterials: EditorWindow {    
    public ParticleSystem systemParent;
    public Material material0;
    public Material material1;
    public float scaleMultiplier = 1.0f;
    
    [MenuItem("Window/Unluck Software/Fix Particle System Materials")]
    
    public static void ShowWindow() {
        EditorWindow.GetWindow (typeof(FixParticleSystemMaterials));
    }
      
    public void OnGUI() {
    	EditorGUILayout.LabelField("Fix Particle Systems that have 2 materials");
        if (GUILayout.Button("Fix Particle System Materials"))
        {
            FixMaterials();
        } 
    }
    
    public void FixMaterials() {
					if(Selection.activeTransform.GetComponent<ParticleSystemRenderer>()!=null){
						Selection.activeTransform.GetComponent<ParticleSystemRenderer>().sharedMaterials[1] = null;				
					}		
    }
    

}