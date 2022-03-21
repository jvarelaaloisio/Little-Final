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
    }
}
