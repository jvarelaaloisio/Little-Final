using Core.Attributes;
using UnityEditor;
using UnityEngine;

namespace Editor
{
    [CustomPropertyDrawer(typeof(SerializeReadOnlyAttribute))]
    public class SerializeReadOnlyDrawer : PropertyDrawer
    {
        public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
        {
            bool isReadOnly = ((SerializeReadOnlyAttribute)attribute) != null;

            EditorGUI.BeginDisabledGroup(isReadOnly);
            EditorGUI.PropertyField(position, property, label, true);
            EditorGUI.EndDisabledGroup();
        }
    }
}
