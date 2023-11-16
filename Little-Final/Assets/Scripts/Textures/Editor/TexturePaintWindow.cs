using System.Collections.Generic;
using Core.Debugging;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace Textures.Editor
{
    public class TexturePaintWindow : EditorWindow, IHasCustomMenu
    {
        private class Settings
        {
            private const string prefsPrefix = "texturePaint_";
            private const string PaintColorPref = prefsPrefix + "paintColor";
            public Color paintColor = Color.white;
            private const string BrushSizePref = prefsPrefix + "brushSize";
            public float brushSize = 1f;
            private const string BrushOpacityPref = prefsPrefix + "brushOpacity";
            public float brushOpacity = 1f;
            private const string BrushHardnessPref = prefsPrefix + "brushHardness";
            public float brushHardness = 1f;
            public const string ExportPathPref = prefsPrefix + "exportPath";
            public string exportPath = "Assets/Textures/paintTexture.png";

            public void Load()
            {
                if (EditorPrefs.HasKey(PaintColorPref)
                    && !ColorUtility.TryParseHtmlString("#" + EditorPrefs.GetString(PaintColorPref), out paintColor)
                    )
                    Debug.LogError($"{_fadedTitle}: Cannot parse paint color");
                if (EditorPrefs.HasKey(PaintColorPref))
                    brushSize = EditorPrefs.GetFloat(BrushSizePref);
                if (EditorPrefs.HasKey(BrushOpacityPref))
                    brushOpacity = EditorPrefs.GetFloat(BrushOpacityPref);
                if (EditorPrefs.HasKey(BrushHardnessPref))
                    brushHardness = EditorPrefs.GetFloat(BrushHardnessPref);
                if (EditorPrefs.HasKey(ExportPathPref))
                    exportPath = EditorPrefs.GetString(ExportPathPref);
            }

            public void Save()
            {
                EditorPrefs.SetString(PaintColorPref, ColorUtility.ToHtmlStringRGB(paintColor));
                EditorPrefs.SetFloat(BrushSizePref, brushSize);
                EditorPrefs.SetFloat(BrushOpacityPref, brushOpacity);
                EditorPrefs.SetFloat(BrushHardnessPref, brushHardness);
                EditorPrefs.SetString(ExportPathPref, exportPath);
            }
        }

        private static class Shaders
        {
            public const string MainTexParamName = "_MainTex";
            
            public static readonly int ColorParam = Shader.PropertyToID("_Color");
            public static readonly int MouseParam = Shader.PropertyToID("_Mouse");
            public static readonly int BrushColorParam = Shader.PropertyToID("_BrushColor");
            public static readonly int BrushSizeParam = Shader.PropertyToID("_BrushSize");
            public static readonly int BrushOpacityParam = Shader.PropertyToID("_BrushOpacity");
            public static readonly int BrushHardnessParam = Shader.PropertyToID("_BrushHardness");
            
            public static readonly Shader FixRiftsShader = Shader.Find("Unlit/FixIslandEdges");
            public static readonly Shader PaintShader = Shader.Find("Unlit/TexturePaint");
            public static readonly Shader BrushShader = Shader.Find("Unlit/BrushShader");
        }

        private struct Message
        {
            public readonly MessageType messageType;
            public readonly string message;
            public object Context { get; set; }
            public Message(MessageType messageType, string message, object context)
            {
                this.messageType = messageType;
                this.message = message;
                Context = context;
            }
        }

        private struct Target
        {
            private static class Messages
            {
                public const string NoTarget = "There is no active GameObject selected.";
                public const string NoMeshFilter = "The target gameObject doesn't have a " + nameof(MeshFilter);
                public const string NoMeshRenderer = "the target gameObject doesn't have a " + nameof(_target.meshRenderer);
            }
            
            public GameObject gameObject;
            public MeshFilter meshFilter;
            public Mesh mesh;
            public bool hadMeshBeforeSelection;
            public MeshRenderer meshRenderer;
            public Material defaultMaterial;

            public bool TrySet(GameObject activeGameObject, out string resultReport)
            {
                resultReport = string.Empty;
                gameObject = activeGameObject;
                if (!gameObject)
                {
                    resultReport = Messages.NoTarget;
                    return false;
                }

                if (gameObject.TryGetComponent(out meshFilter))
                    mesh = meshFilter.sharedMesh;
                else
                {
                    resultReport = Messages.NoMeshFilter;
                    return false;
                }

                if (gameObject.TryGetComponent(out meshRenderer))
                    defaultMaterial = meshRenderer.sharedMaterial;
                else
                {
                    resultReport = Messages.NoMeshRenderer;
                    return false;
                }

                return true;
            }
            public void Reset()
            {
                if (meshRenderer)
                    meshRenderer.sharedMaterial = defaultMaterial;
            }
        }

        private const string WindowTitle = "Paint Texture";
        
        private const string MarkingIslandsBufferName = "markingIslands";

        private static readonly string _fadedTitle = WindowTitle.Colored("grey");

        private Material _paintMaterial;

        private RenderTexture _markedIslands;

        private PaintTexture _paintTexture;

        private Target _target;

        //Window Control

        //TODO: Finish setup or delete variable

        private List<Message> messages = new();

        //Paint process

        private bool _isPaintingOnSceneView;

        private int _numberOfFrames;

        private Camera _camera;

        private CommandBuffer _markingIslandsBuffer;

        private Transform _mouseBrush;

        private Material _brushMaterial;

        private Settings _settings = new();
        private Event _currentEvent;

        private static TexturePaintWindow _window;

        [MenuItem("Tools/" + WindowTitle)]
        private static void OpenWindow()
        {
            if (_window != null)
                _window.Close();
            
            _window = GetWindow<TexturePaintWindow>();
            _window.titleContent = new GUIContent(WindowTitle);
            if(!_window.TryInitialize(out var report))
            {
                Debug.LogError($"{_fadedTitle}: <color=#FF3300>Error</color> encountered while opening window." +
                               $"\n{report}");
                _window.Close();
            }
            else
                _window.Show();
        }

        private void OnSelectionChange()
        {
            if (_target.gameObject == Selection.activeGameObject)
                return;
            Debug.Log($"{_fadedTitle}: Selection changed");
            
            _target.Reset();
            
            if(TryInitialize(out var report))
            {
                Debug.LogError($"{_fadedTitle}: {"Error".Colored("#FF3300")} encountered on selection change." +
                               $"\n{report}");
                Close();
            }
        }

        private void OnEnable()
        {
            SceneView.beforeSceneGui += CaptureMouseEvent;
            SceneView.duringSceneGui += HandleSceneViewGUI;
            CreateBrush(out _mouseBrush, ref _brushMaterial);
            _settings.Load();
        }

        private void OnDisable()
        {
            SceneView.beforeSceneGui -= CaptureMouseEvent;
            SceneView.duringSceneGui -= HandleSceneViewGUI;
            if (_mouseBrush.gameObject)
                DestroyImmediate(_mouseBrush.gameObject);
            _settings.Save();
        }

        private void OnDestroy()
        {
            _target.Reset();
            if (_camera)
            {
                _paintTexture.SetInactiveTexture(_camera);
            }

            if (_markedIslands != null)
            {
                _markedIslands.Release();
            }

            if (_paintTexture != null)
            {
                _paintTexture.Release();
            }
        }

        private void OnGUI()
        {
            if (messages.Count > 0)
            {
                var lastMessage = messages[^1];
                EditorGUILayout.HelpBox(lastMessage.message, lastMessage.messageType);
            }
            _settings.paintColor = EditorGUILayout.ColorField("Color", _settings.paintColor);
            _brushMaterial.SetColor(Shaders.ColorParam, _settings.paintColor);
            Shader.SetGlobalColor(Shaders.BrushColorParam, _settings.paintColor);
            
            _settings.brushSize = EditorGUILayout.FloatField("Size", _settings.brushSize);
            Shader.SetGlobalFloat(Shaders.BrushSizeParam, _settings.brushSize);
            _settings.brushOpacity = EditorGUILayout.FloatField(nameof(_settings.brushOpacity), _settings.brushOpacity);
            Shader.SetGlobalFloat(Shaders.BrushOpacityParam, _settings.brushOpacity);
            // Brush size is doubled for the mouse representation so it shows the correct size sphere in editor.
            _mouseBrush.localScale = _settings.brushSize * 2f *Vector3.one;
            
            _settings.brushHardness = EditorGUILayout.FloatField(nameof(_settings.brushHardness), _settings.brushHardness);
            Shader.SetGlobalFloat(Shaders.BrushHardnessParam, _settings.brushHardness);

            using (new EditorGUILayout.HorizontalScope("Button"))
            {
                _settings.exportPath = EditorGUILayout.TextField("Path", _settings.exportPath);
                if (GUILayout.Button("Export"))
                {
                    var tempPath = EditorUtility.SaveFilePanelInProject("Save Texture", "paintTexture", "png", "Save the painted texture", _settings.exportPath);
                    var userCanceled = string.IsNullOrEmpty(tempPath);
                    if (!userCanceled)
                    {
                        _settings.exportPath = tempPath;
                        Export(_paintTexture, tempPath);
                        AssetDatabase.ImportAsset(tempPath);
                    }
                }
            }
        }

        public void AddItemsToMenu(GenericMenu menu)
        {
            menu.AddItem(new GUIContent("Reset EditorPrefs"), true, ResetEditorPrefs);
        }

        private static void ResetEditorPrefs()
        {
            EditorPrefs.DeleteAll();
        }

        private void CaptureMouseEvent(SceneView obj)
        {
            _currentEvent = Event.current;
            var mouseIsOverSceneView = mouseOverWindow != null && mouseOverWindow.titleContent.text == "Scene";
            //Prevent target deselection
            _isPaintingOnSceneView = (_target.gameObject != null)
                                     && (UserStartsPainting()
                                         || (!UserStoppedPainting() && _isPaintingOnSceneView));
            
            if (_isPaintingOnSceneView && _currentEvent.isMouse)
            {
                _currentEvent.Use();
            }
            
            bool UserStoppedPainting() =>
                _currentEvent.type is EventType.MouseUp;

            bool UserStartsPainting() =>
                _currentEvent.type is EventType.MouseDown
                && _currentEvent.button == 0
                && mouseIsOverSceneView
                && MouseIsOverTarget();

            bool MouseIsOverTarget() =>
                GUIRaycast(_currentEvent.mousePosition, _target.gameObject.layer, out var hit)
                && hit.transform.gameObject == _target.gameObject;
        }

        private void HandleSceneViewGUI(SceneView obj)
        {
            if (!_camera || !_target.gameObject)
                return;
            
            // This MUST be called to set up the painting with the mouse.
            _paintTexture.UpdateShaderParameters(_target.gameObject.transform.localToWorldMatrix);
            
            Vector4 mouseWorldPosition = Vector3.zero;
            
            if (_currentEvent != null
                && GUIRaycast(_currentEvent.mousePosition, _target.gameObject.layer, out var hit)
                && hit.collider.gameObject.GetInstanceID().Equals(_target.gameObject.GetInstanceID()))
            {
                mouseWorldPosition = hit.point;
            }
            
            mouseWorldPosition.w = _isPaintingOnSceneView ? 1 : 0;
            Shader.SetGlobalVector(Shaders.MouseParam, mouseWorldPosition);
            _mouseBrush.position = mouseWorldPosition;
        }

        private bool TryInitialize(out string report)
        {
            if (!_target.TrySet(Selection.activeGameObject, out report))
                return false;
            
            _paintMaterial = new Material(Resources.Load<Material>("PaintMat"));
            _markedIslands = new RenderTexture(512, 512, 0, RenderTextureFormat.R8);

            _paintTexture = new PaintTexture(Color.white, 512, 512, Shaders.MainTexParamName
                                             , Shaders.PaintShader, _target.mesh, Shaders.FixRiftsShader, _markedIslands);

            _paintMaterial.SetTexture(_paintTexture.id, _paintTexture.runTimeTexture);

            _target.meshRenderer.sharedMaterial = _paintMaterial;

            // Command buffer initialization ------------------------------------------------

            _markingIslandsBuffer = new CommandBuffer();
            _markingIslandsBuffer.name = MarkingIslandsBufferName;

            _markingIslandsBuffer.SetRenderTarget(_markedIslands);
            Material islandMarker = new Material(Shaders.PaintShader);
            _markingIslandsBuffer.DrawMesh(_target.mesh, Matrix4x4.identity, islandMarker);

            if (!TryGetSceneCamera(ref _camera, out report))
                return false;

            _camera.AddCommandBuffer(CameraEvent.AfterDepthTexture, _markingIslandsBuffer);
            _paintTexture.SetActiveTexture(_camera);
            
            return true;
        }

        private static void CreateBrush(out Transform mouseRepresentation, ref Material brushMaterial)
        {
            mouseRepresentation = GameObject.CreatePrimitive(PrimitiveType.Sphere).transform;
            DestroyImmediate(mouseRepresentation.GetComponent<SphereCollider>());
            if(!brushMaterial)
                brushMaterial = new Material(Shaders.BrushShader);
            mouseRepresentation.GetComponent<Renderer>().material = brushMaterial;
        }

        private static bool GUIRaycast(Vector2 mousePosition, int layer, out RaycastHit hit)
        {
            Ray ray = HandleUtility.GUIPointToWorldRay(mousePosition);

            var targetLayer = LayerMask.GetMask(LayerMask.LayerToName(layer));
            bool raycast = Physics.Raycast(ray, out hit, float.PositiveInfinity, targetLayer);
            return raycast;
        }

        private static bool TryGetSceneCamera(ref Camera camera, out string resultReport)
        {
            if (!camera && SceneView.lastActiveSceneView)
                camera = SceneView.lastActiveSceneView.camera;
            
            resultReport = camera ? string.Empty : "There is no scene view camera";
            return camera;
        }
        
        private static void Export(PaintTexture paintTexture, string exportPath)
        {
            paintTexture.paintedTexture.SaveToFile(exportPath);
        }
    }
}