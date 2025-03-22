using UnityEditor;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UIElements;

namespace Editor.UIToolkit
{
    public class FsmEditor : EditorWindow
    {
        [SerializeField] private VisualTreeAsset m_VisualTreeAsset = default;
        [SerializeField] private VisualTreeAsset nodePrefab = default;
        [field: SerializeField] public Texture2D GrabCursor { get; set; }

        private Node _node;

        [MenuItem("Window/UI Toolkit/FsmEditor")]
        public static void ShowExample()
        {
            FsmEditor wnd = GetWindow<FsmEditor>();
            wnd.titleContent = new GUIContent("FsmEditor");
        }

        public void CreateGUI()
        {
            // Each editor window contains a root VisualElement object
            VisualElement root = rootVisualElement;

            // VisualElements objects can contain other VisualElement following a tree hierarchy.
            VisualElement label = new Label("Hello World! From C#");
            root.Add(label);

            // Instantiate UXML
            VisualElement labelFromUXML = m_VisualTreeAsset.Instantiate();
            root.Add(labelFromUXML);
            var slots = root.Q<VisualElement>("slots");
            if (nodePrefab)
            {
                var nodeChild = nodePrefab.Instantiate();
                nodeChild.style.width = 200;
                nodeChild.style.height = 200;
                nodeChild.style.position = new StyleEnum<UnityEngine.UIElements.Position>(UnityEngine.UIElements.Position.Absolute);
                _node = new Node(nodeChild, root, new Node.Data {GrabCursor = GrabCursor});
                slots.Add(nodeChild);
            }
        }
    }
}