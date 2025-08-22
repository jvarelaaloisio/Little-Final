using System;
using System.Collections;
using System.Linq;
using System.Reflection;
using System.Text;
using Core.Extensions;
using UnityEditor;
using UnityEngine;

namespace Characters.Editor
{
    [CustomEditor(typeof(PhysicsCharacter))]
    public class PhysicsCharacterEditor : UnityEditor.Editor
    {
        /// <inheritdoc />
        public override bool HasPreviewGUI()
            => true;

        /// <inheritdoc />
        public override void OnInteractivePreviewGUI(Rect r, GUIStyle background)
        {
            var fields = typeof(PhysicsCharacter).GetFields(BindingFlags.NonPublic | BindingFlags.Instance);
            foreach (var field in fields.Where(f => typeof(IEnumerable).IsAssignableFrom(f.FieldType)))
            {
                var info = new StringBuilder(ObjectNames.NicifyVariableName(field.Name).Bold() + " {");
                if (field.GetValue(target) is not IEnumerable enumerable)
                    continue;
                var genericType = field.FieldType.IsGenericType ? field.FieldType.GetGenericArguments()[0] : null;
                var isEmpty = true;
                foreach (var item in enumerable)
                {
                    if (genericType != null && genericType.IsAssignableFrom(item.GetType()))
                    {
                        var genericTypedItem = Convert.ChangeType(item, genericType);
                        info.AppendLine($"\n\t{genericTypedItem}");
                    }
                    else
                        info.AppendLine($"\n\t{item.GetType().Name}".Italic());
                    isEmpty = false;
                }

                info.Append(isEmpty ? " }" : "}");

                var richTextStyle = new GUIStyle(GUI.skin.label)
                                    {
                                        richText = true
                                    };

                GUILayout.Label(info.ToString(), richTextStyle);
            }
        }

        /// <inheritdoc />
        public override void OnPreviewSettings()
        {
            base.OnPreviewSettings();
        }
    }
}
