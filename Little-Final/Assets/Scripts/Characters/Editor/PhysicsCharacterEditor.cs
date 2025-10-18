using System;
using System.Collections;
using System.Linq;
using System.Reflection;
using System.Text;
using Core.Acting;
using Core.Data;
using Core.Extensions;
using UnityEditor;
using UnityEngine;

namespace Characters.Editor
{
    [CustomEditor(typeof(PhysicsCharacter))]
    public class PhysicsCharacterEditor : UnityEditor.Editor
    {
        private Vector2 _scrollPosition = new();
        private float _cachedHeight;

        /// <inheritdoc />
        public override bool HasPreviewGUI()
            => true;

        /// <inheritdoc />
        public override void OnPreviewGUI(Rect r, GUIStyle background)
        {
            float initialHeight = r.y;
            _scrollPosition = GUI.BeginScrollView(r, _scrollPosition, new Rect(r.x, r.y, 1000, _cachedHeight));
            var fields = typeof(PhysicsCharacter).GetFields(BindingFlags.NonPublic | BindingFlags.Instance);
            RenderFields(fields, target, ref r);
            ReverseIndexStore reverseIndexStore = ((PhysicsCharacter)target).Actor?.Data;
            if (reverseIndexStore != null)
            {
                var reverseIndexStoreFields = typeof(ReverseIndexStore).GetFields(BindingFlags.NonPublic | BindingFlags.Instance);
                RenderFields(reverseIndexStoreFields, reverseIndexStore, ref r);
            }
            GUI.EndScrollView();

            _cachedHeight = r.y - initialHeight;
        }
        
        private static void RenderFields(FieldInfo[] fields, object target, ref Rect r)
        {
            foreach (var field in fields.Where(field => IsIEnumerable(field.FieldType)))
            {
                var formattedField = new StringBuilder();
                FormatIEnumerable(target, field, formattedField, out int count);

                var richTextStyle = new GUIStyle(GUI.skin.label)
                                    {
                                        richText = true,
                                        alignment = TextAnchor.UpperLeft
                                    };

                
                GUIContent text = new GUIContent(formattedField.ToString());
                GUI.Label(r, text, richTextStyle);
                r.y += richTextStyle.CalcHeight(text, 1000);
            }
        }

        private static void FormatIEnumerable(object target, FieldInfo field, StringBuilder info, out int count)
        {
            count = 0;
            info.Append(ObjectNames.NicifyVariableName(field.Name).Bold() + " {");
            if (field.GetValue(target) is IEnumerable enumerable)
                AppendIEnumerable(field, enumerable, info, out count);

            info.Append(count > 1 ? "\n}" : " }");
        }

        private static void AppendIEnumerable(FieldInfo field, IEnumerable enumerable, StringBuilder output, out int count)
        {
            bool isGeneric = field.FieldType.IsGenericType;
            var genericTypes = field.FieldType.GetGenericArguments();
            int originalLength = output.Length;
            count = 0;
            foreach (object item in enumerable)
            {
                InsertLineBreakRetroactivelyIfItsSecondLine(count, output, originalLength);
                if (count > 0)
                    output.Append(",\n");

                if (!isGeneric)
                {
                    output.Append($"\t{item}".Italic());
                    continue;
                }

                bool isKeyValuePair = genericTypes.Length == 2;
                if (isKeyValuePair)
                {
                    var keyFieldInfo = item.GetType().GetField("key", BindingFlags.NonPublic | BindingFlags.Instance);
                    var valueFieldInfo = item.GetType().GetField("value", BindingFlags.NonPublic | BindingFlags.Instance);
                    output.Append($"\t[ <b>Key</b> {{{keyFieldInfo.GetValue(item)}}} => ");
                    object Value = valueFieldInfo.GetValue(item);
                    if (typeof(IActor).IsAssignableFrom(Value.GetType()))
                    {
                        output.Append("<IActor> ]".Italic());
                        continue;
                    }
                    if (IsIEnumerable(genericTypes[1]))
                    {
                        FormatIEnumerable(item, valueFieldInfo, output, out int itemCount);
                        output.Append(itemCount > 1 ? "\n\t]" : " ]");
                    }
                    else
                        output.Append($"{valueFieldInfo.GetValue(item)} ]");
                }
                else if (genericTypes[0].IsAssignableFrom(item.GetType()))
                {
                    object genericTypedItem = Convert.ChangeType(item, genericTypes[0]);
                    output.AppendLine($"\t{genericTypedItem}");
                }
                else
                    output.AppendLine($"\t{item.Colored(C.Red)}");

                count++;
            }

            return;

            static void InsertLineBreakRetroactivelyIfItsSecondLine(int count, StringBuilder output, int position)
            {
                if (count == 1)
                    output.Insert(position, "\n");
            }
        }

        /// <inheritdoc />
        public override void OnPreviewSettings()
        {
            base.OnPreviewSettings();
        }

        private static bool IsIEnumerable(Type type)
            => typeof(IEnumerable).IsAssignableFrom(type);
    }
}
