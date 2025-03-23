using UnityEngine.UIElements;

namespace Editor.UIToolkit
{
    public static class VisualElementExtensions
    {
        public static bool TryFindChild<T>(this VisualElement target, string name, out T child) where T : VisualElement
            => (child = target.Q<T>(name)) != null;
    }
}