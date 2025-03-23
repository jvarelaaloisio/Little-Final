using FSM;
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
            var states = new State<string>[] {new WalkState<string>("walk"), new JumpState<string>("jump")};
            if (nodePrefab)
            {
                for (int i = 0; i < 2; i++)
                {

                    var nodeChild = nodePrefab.Instantiate();
                    nodeChild.style.width = 200;
                    nodeChild.style.height = 200;
                    nodeChild.style.position = UnityEngine.UIElements.Position.Absolute;
                    nodeChild.transform.position = new Vector3(100 * i, 100);
                    var data = new Node.Data
                    {
                        GrabCursor = GrabCursor,
                        Title = i.ToString(),
                        targetObject = states[i],
                    };
                    _node = new Node(nodeChild, root, data);
                    slots.Add(nodeChild);
                    _node.SetupGUI();
                }
            }
        }
    }
}