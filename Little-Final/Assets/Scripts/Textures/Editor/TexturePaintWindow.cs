using System.Collections.Generic;
using Core.Debugging;
using Prefs;
using Prefs.Editor;
using Prefs.Runtime;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using Object = UnityEngine.Object;

namespace Textures.Editor
{
    public class TexturePaintWindow : EditorWindow, IHasCustomMenu
    {
        private class Settings
        {
            private const string prefsPrefix = "texturePaint_";
            private static readonly IPrefs editorPrefs = new EditorPrefsWrapper();
            public PrefUnit<Color> paintColor = new ColorPref(editorPrefs, prefsPrefix + nameof(paintColor), Color.white);
            public PrefUnit<float> brushSize = new FloatPref(editorPrefs, prefsPrefix + nameof(brushSize)); 
            public PrefUnit<float> brushOpacity = new FloatPref(editorPrefs, prefsPrefix + nameof(brushOpacity)); 
            public PrefUnit<float> brushHardness = new FloatPref(editorPrefs, prefsPrefix + nameof(brushHardness)); 
            public PrefUnit<string> exportPath = new StringPref(editorPrefs, prefsPrefix + nameof(exportPath), "Assets/Textures/paintTexture.png");
            public PrefUnit<bool> autoSave = new BoolPref(editorPrefs, prefsPrefix + nameof(autoSave), false);

            public void Load()
            {
                paintColor.TryLoad();
                brushSize.TryLoad();
                brushOpacity.TryLoad();
                brushHardness.TryLoad();
                exportPath.TryLoad();
                autoSave.TryLoad();
            }

            public void Save()
            {
                paintColor.Save();
                brushSize.Save();
                brushOpacity.Save();
                brushHardness.Save();
                exportPath.Save();
                autoSave.Save();
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
            public Object Context { get; set; }
            public Message(MessageType messageType, string message, Object context = null)
            {
                this.messageType = messageType;
                this.message = message;
                Context = context;
            }
        }

        //TODO: Check if GO has meshCollider and add it if not/make it non-convex and have the needed flags to turn it back to it's original state
        private struct Target
        {
            private static class Messages
            {
                public const string NoTarget = "There is no active GameObject selected.";
                public const string NoMeshFilter = "The target gameObject doesn't have a " + nameof(MeshFilter);
                public const string NoMeshRenderer = "the target gameObject doesn't have a " + nameof(MeshRenderer);
            }
            
            public GameObject gameObject;
            public MeshFilter meshFilter;
            public Mesh mesh;
            public MeshRenderer meshRenderer;
            public Material defaultMaterial;
            public bool IsValid => gameObject && meshFilter && mesh && meshRenderer;

            public bool TrySet(GameObject activeGameObject, out Message resultReport)
            {
                resultReport = new Message();
                gameObject = activeGameObject;
                if (!gameObject)
                {
                    resultReport = new Message(MessageType.Error, Messages.NoTarget);
                    return false;
                }

                if (gameObject.TryGetComponent(out meshFilter))
                    mesh = meshFilter.sharedMesh;
                else
                {
                    resultReport = new Message(MessageType.Error, Messages.NoMeshFilter, gameObject);
                    return false;
                }

                if (gameObject.TryGetComponent(out meshRenderer))
                    defaultMaterial = meshRenderer.sharedMaterial;
                else
                {
                    resultReport = new Message(MessageType.Error, Messages.NoMeshRenderer, gameObject);
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

        private readonly Settings _settings = new();
        private Event _currentEvent;

        private static TexturePaintWindow _window;
        private Texture textureAsset;
        private Texture2D _blackTexture;

        [MenuItem("Tools/" + WindowTitle)]
        private static void OpenWindow()
        {
            if (_window != null)
                _window.Close();
            
            _window = GetWindow<TexturePaintWindow>();
            _window.titleContent = new GUIContent(WindowTitle);
            _window.Show();
        }

        private void OnSelectionChange()
        {
            if (_target.gameObject == Selection.activeGameObject)
                return;
            
            _target.Reset();

            var wasSuccessful = TryInitialize(out var report);
            messages.Add(wasSuccessful
                             ? new Message(MessageType.Info, "Selection changed")
                             : report);
            if (!wasSuccessful && _mouseBrush)
                TryDestroyGameObject(_mouseBrush);
            else if (wasSuccessful && !_mouseBrush)
                CreateBrush(out _mouseBrush, ref _brushMaterial);
            
            Repaint();
        }

        private void OnEnable()
        {
            SceneView.beforeSceneGui += CaptureMouseEvent;
            SceneView.duringSceneGui += HandleSceneViewGUI;
            TryInitialize(out var initReport);
            messages.Add(initReport);
            if (_target.IsValid)
            {
                CreateBrush(out _mouseBrush, ref _brushMaterial);
            }
            _settings.Load();

            _blackTexture = new Texture2D(1, 1);
            _blackTexture.SetPixel(0, 0, Color.black);
            _blackTexture.Apply();
        }

        private void OnDisable()
        {
            SceneView.beforeSceneGui -= CaptureMouseEvent;
            SceneView.duringSceneGui -= HandleSceneViewGUI;
            TryDestroyGameObject(_mouseBrush);
            if (_settings.autoSave)
            {
                _settings.Save();
            }
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

            _paintTexture?.Release();

            _markingIslandsBuffer?.Release();
        }

        private void OnGUI()
        {
            if (messages.Count > 0)
            {
                var lastMessage = messages[^1];
                EditorGUILayout.HelpBox(lastMessage.message, lastMessage.messageType);
                var userClickedHelpBox = Event.current.type == EventType.MouseDown
                                         && GUILayoutUtility.GetLastRect().Contains(Event.current.mousePosition);
                if (userClickedHelpBox && lastMessage.Context)
                    EditorGUIUtility.PingObject(lastMessage.Context);
            }

            _settings.paintColor.value = EditorGUILayout.ColorField("Color", _settings.paintColor);
            if (_brushMaterial)
                _brushMaterial.SetColor(Shaders.ColorParam, _settings.paintColor);
            Shader.SetGlobalColor(Shaders.BrushColorParam, _settings.paintColor);
            
            _settings.brushSize.value = EditorGUILayout.FloatField("Size", _settings.brushSize);
            Shader.SetGlobalFloat(Shaders.BrushSizeParam, _settings.brushSize);
            _settings.brushOpacity.value = EditorGUILayout.FloatField("Opacity", _settings.brushOpacity);
            Shader.SetGlobalFloat(Shaders.BrushOpacityParam, _settings.brushOpacity);
            if(_mouseBrush)
                // Brush size is doubled for the mouse representation so it shows the correct size sphere in editor.
                _mouseBrush.localScale = _settings.brushSize * 2f *Vector3.one;
            
            _settings.brushHardness.value = EditorGUILayout.FloatField("Hardness", _settings.brushHardness);
            Shader.SetGlobalFloat(Shaders.BrushHardnessParam, _settings.brushHardness);

            using (new EditorGUILayout.HorizontalScope("Button"))
            {
                _settings.exportPath.value = EditorGUILayout.TextField("Path", _settings.exportPath);
                if (GUILayout.Button("Export"))
                {
                    var tempPath = EditorUtility.SaveFilePanelInProject("Save Texture", "paintTexture", "png",
                                                                        "Save the painted texture",
                                                                        _settings.exportPath);
                    var userCanceled = string.IsNullOrEmpty(tempPath);
                    if (!userCanceled)
                    {
                        _settings.exportPath.value = tempPath;
                        Export(_paintTexture, tempPath);
                        AssetDatabase.ImportAsset(tempPath);
                    }
                }
            }

            GUI.DrawTexture(GUILayoutUtility.GetRect(position.width, 5),  _blackTexture, ScaleMode.StretchToFill);
            using (new EditorGUILayout.HorizontalScope("Button"))
            {
                textureAsset = (Texture)EditorGUILayout.ObjectField(textureAsset, typeof(Texture), false);
                if (GUILayout.Button("Use") && _paintTexture != null && textureAsset)
                {
                    _paintTexture.Blit(textureAsset);
                    SceneView.RepaintAll();
                }
            }
            if (GUILayout.Button("Save Settings"))
                _settings.Save();
            
            GUI.DrawTexture(GUILayoutUtility.GetRect(position.width - 100, position.width - 100), _paintTexture.paintedTexture);
        }

        public void AddItemsToMenu(GenericMenu menu)
        {
            menu.AddItem(new GUIContent("Toggle auto-save"), _settings.autoSave, ToggleAutoSave);
        }

        //TODO: Implement method
        private void ToggleAutoSave() => _settings.autoSave.value = !_settings.autoSave;

        private void CaptureMouseEvent(SceneView obj)
        {
            if(!_target.IsValid)
                return;
            _currentEvent = Event.current;
            //Prevent target deselection
            _isPaintingOnSceneView = _target.gameObject != null
                                     && (UserStartsPainting()
                                         || (!UserStoppedPainting() && _isPaintingOnSceneView));
            
            if (_isPaintingOnSceneView && _currentEvent.isMouse)
                _currentEvent.Use();

            bool UserStoppedPainting() =>
                _currentEvent.type is EventType.MouseUp;

            bool UserStartsPainting()
            {
                return _currentEvent.type is EventType.MouseDown
                       && _currentEvent.button == 0
                       && MouseIsOverSceneView()
                       && MouseIsOverTarget();

            }

            bool MouseIsOverSceneView() =>
                mouseOverWindow != null && mouseOverWindow.titleContent.text == "Scene";

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
            if (_mouseBrush)
                _mouseBrush.position = mouseWorldPosition;
        }

        private bool TryInitialize(out Message report)
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

        /// <summary>
        /// Destroys a given gameObject immediately
        /// </summary>
        /// <param name="component"></param>
        private static bool TryDestroyGameObject(Component component)
        {
            if (!component)
                return false;
            DestroyImmediate(component.gameObject);
            return true;

        }

        private static bool GUIRaycast(Vector2 mousePosition, int layer, out RaycastHit hit)
        {
            Ray ray = HandleUtility.GUIPointToWorldRay(mousePosition);

            var targetLayer = LayerMask.GetMask(LayerMask.LayerToName(layer));
            bool raycast = Physics.Raycast(ray, out hit, float.PositiveInfinity, targetLayer);
            return raycast;
        }

        private static bool TryGetSceneCamera(ref Camera camera, out Message resultReport)
        {
            if (!camera && SceneView.lastActiveSceneView)
                camera = SceneView.lastActiveSceneView.camera;
            
            resultReport = camera ? new Message() : new Message(MessageType.Error, "There is no scene view camera");
            return camera;
        }
        
        private static void Export(PaintTexture paintTexture, string exportPath)
        {
            paintTexture.paintedTexture.SaveToFile(exportPath);
        }
    }
}