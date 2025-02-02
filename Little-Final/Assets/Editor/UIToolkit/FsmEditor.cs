using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;

public class FsmEditor : EditorWindow
{
    [SerializeField]
    private VisualTreeAsset m_VisualTreeAsset = default;
    [SerializeField]
    private VisualTreeAsset node = default;

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
        if (node)
        {
            var nodeChild = node.Instantiate();
            nodeChild.style.position = new StyleEnum<UnityEngine.UIElements.Position>(UnityEngine.UIElements.Position.Absolute);
            root.Add(nodeChild);
        }
    }
}
