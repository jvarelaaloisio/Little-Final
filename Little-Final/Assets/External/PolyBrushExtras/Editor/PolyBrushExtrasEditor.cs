using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace External.PolyBrushExtras.Editor
{
    [CustomEditor(typeof(PolyBrushExtras))]
    public class PolyBrushExtrasEditor : UnityEditor.Editor
    {
        private List<GameObject> _clones;
        private PolyBrushExtras _target;

        private void OnEnable()
        {
            _target = (PolyBrushExtras)target;
        }

        public override void OnInspectorGUI()
        {
            ResetRotation_Callback();
            RandomRotation_Callback();
        }

        private void ResetRotation_Callback()
        {
            if (GUILayout.Button("Reset Rotation"))
            {
                foreach (Transform child in _target.transform)
                {
                    child.rotation = Quaternion.identity;
                }
            }
        }
        
        

        
        private void RandomRotation_Callback()
        {
            const float minLimit = 0;
            const float maxLimit = 360;
            float minVal = 0;
            float maxVal = 360;
            
            EditorGUILayout.Space();
            GUILayout.BeginHorizontal();
            EditorGUILayout.LabelField("Min: " + (int)minVal,GUILayout.MaxWidth(50));
            EditorGUILayout.MinMaxSlider(ref minVal, ref maxVal, minLimit, maxLimit);
            EditorGUILayout.LabelField("Max: " + (int)maxVal, GUILayout.MaxWidth(70));
            
            GUILayout.EndHorizontal();
            if (GUILayout.Button("Random Rotation"))
            {
                foreach (Transform child in _target.transform)
                {
                    var random = Random.Range(minVal, maxVal);
                    child.transform.Rotate(0,random,0);
                }
            }
        }
    }
}
