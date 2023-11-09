using System;
using System.Collections.Generic;
using System.Linq;
using Core.Debugging;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace Textures.Editor
{
    public class TexturePaintWindow : EditorWindow
    {
        private static class MessageIds
        {
            public const string NoTarget = "There is no active GameObject selected.";
            public const string NoMeshFilter = "The target gameObject doesn't have a " + nameof(MeshFilter);
            public const string NoMeshRenderer = "the target gameObject doesn't have a "+nameof(_target.meshRenderer);
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
            public GameObject gameObject;
            public MeshFilter meshFilter;
            public MeshRenderer meshRenderer;
            public Mesh mesh;
            public Material defaultMaterial;
        }

        private const string WindowTitle = "Paint Texture";
        private const string UnlitFixIslandEdges = "Unlit/FixIlsandEdges";
        private const string UnlitTexturePaintShader = "Shader Graphs/TexturePaintURP";
        private const string BrushShader = "Unlit/BrushShader";
        private const string MainTexName = "_BaseMap";
        private const string MarkingIslandsBufferName = "markingIslands";
        private const string MouseGlobalShaderParam = "_Mouse";

        /// <summary>
        /// the shader used to draw in the texture of the mesh
        /// </summary>
        private Shader _paintShader;

        private Shader _fixIslandEdgesShader;
        private Material _paintMaterial;
        private RenderTexture _markedIslands;
        private PaintTexture _paintTexture;

        private Target _target;

        //Export
        private string _exportPath = "Assets/Textures/text.png";

        //Window Control
        private List<Message> messages = new(); 
        
        //Paint process
        private bool _isPaintingOnSceneView;
        private int _numberOfFrames;
        private Camera _camera;
        private CommandBuffer _markingIslandsBuffer;
        private Transform _mouseRepresentation;
        private Material _mouseMaterial;
        private Color _paintColor = Color.white;
        private static readonly int ColorPropertyID = Shader.PropertyToID("_Color");
        private Event _currentEvent;
        
        [MenuItem("Tools/" + WindowTitle)]
        private static void OpenWindow()
        {
            var window = GetWindow<TexturePaintWindow>();
            window.titleContent = new GUIContent(WindowTitle);
            var initReport = window.TryInitialize();
            if (!initReport.Item1)
            {
                var message = new Message(MessageType.Error, initReport.Item2, null);
                window.messages.Add(message);
            }
            else
            {
                Debug.LogError($"{WindowTitle.Colored("grey")}: <color=#FF3300>Error</color> encountered while opening window." +
                               $"\n{initReport.Item2}");
                window.Close();
            }
            window.Show();
        }

        [MenuItem("Tools/" + WindowTitle, true)]
        private static bool OpenWindow_Validate()
        {
            return true;
        }

        private void OnSelectionChange()
        {
            if (_target.gameObject == Selection.activeGameObject)
                return;
            Debug.Log($"{name}: Selection changed");
            if (_target.gameObject)
                ResetTargetToDefault(_target);
            var initReport = TryInitialize();
            if (!initReport.Item1)
            {
                Debug.LogError($"{WindowTitle.Colored("grey")}: {"Error".Colored("#FF3300")} encountered on selection change." +
                               $"\n{initReport.Item2}");
                Close();
            }
        }

        private void OnEnable()
        {
            SceneView.beforeSceneGui += CaptureMouseEvent;
            SceneView.duringSceneGui += HandleSceneViewGUI;
            _mouseRepresentation   = GameObject.CreatePrimitive(PrimitiveType.Sphere).transform;
            DestroyImmediate(_mouseRepresentation.GetComponent<SphereCollider>());
            _mouseMaterial = new Material(Shader.Find(BrushShader));
            _mouseRepresentation.GetComponent<Renderer>().material = _mouseMaterial;
        }

        private void OnDisable()
        {
            SceneView.beforeSceneGui -= CaptureMouseEvent;
            SceneView.duringSceneGui -= HandleSceneViewGUI;
            DestroyImmediate(_mouseRepresentation.gameObject);
        }

        private void OnDestroy()
        {
            ResetTargetToDefault(_target);
        }

        private void CaptureMouseEvent(SceneView obj)
        {
            _currentEvent = Event.current;
            var mouseIsOverSceneView = mouseOverWindow && mouseOverWindow.titleContent.text == "Scene";
            //Prevent target deselection
            _isPaintingOnSceneView = _target.gameObject && (UserKeepsPainting() || UserStartsPainting());

            if (_isPaintingOnSceneView)
            {
                _currentEvent.Use();
            }

            bool UserKeepsPainting() =>
                _isPaintingOnSceneView
                && _currentEvent.type is EventType.MouseUp
                && MouseIsOverTarget();

            bool MouseIsOverTarget() =>
                GUIRaycast(_currentEvent.mousePosition, _target.gameObject.layer, out var hit)
                && hit.transform.gameObject == _target.gameObject;

            bool UserStartsPainting() =>
                !_isPaintingOnSceneView
                && _currentEvent.type is EventType.MouseDown
                && mouseIsOverSceneView;
        }

        private void HandleSceneViewGUI(SceneView obj)
        {
            if (!_camera)
            {
                return;
            }
            if (_numberOfFrames > 0)
                _camera.RemoveCommandBuffer(CameraEvent.AfterDepthTexture, _markingIslandsBuffer);
            _numberOfFrames++;
            
            if (!_target.gameObject)
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
            
            mouseWorldPosition.w = (Event.current.type == EventType.MouseDown && Event.current.button == 0) ? 1 : 0;

            Shader.SetGlobalVector(MouseGlobalShaderParam, mouseWorldPosition);
            _mouseRepresentation.position = mouseWorldPosition;
        }

        private static bool GUIRaycast(Vector2 mousePosition, int layer, out RaycastHit hit)
        {
            Ray ray = HandleUtility.GUIPointToWorldRay(mousePosition);

            var targetLayer = LayerMask.GetMask(LayerMask.LayerToName(layer));
            bool raycast = Physics.Raycast(ray, out hit, float.PositiveInfinity, targetLayer);
            return raycast;
        }

        private void OnGUI()
        {
            _paintColor = EditorGUILayout.ColorField(_paintColor);
            if (messages.Count > 0)
            {
                var lastMessage = messages[^1];
                EditorGUILayout.HelpBox(lastMessage.message, lastMessage.messageType);
            }
            Shader.SetGlobalColor("_BrushColor", _paintColor);
            Shader.SetGlobalFloat("_BrushSize", 1);
            Shader.SetGlobalFloat("_BrushOpacity", 1);
            Shader.SetGlobalFloat("_BrushHardness", 1);
            _mouseMaterial.SetColor(ColorPropertyID, _paintColor);
        }

        private (bool, string) TryInitialize()
        {
            var targetSetResult = TrySetTargetToSelection(Selection.activeGameObject);
            if (!targetSetResult.Item1)
                return targetSetResult;

            var defaultTexture = _target.defaultMaterial.mainTexture;
            if (!defaultTexture)
            {
                return (false, $"the target material has no main texture");
            }

            _paintMaterial = new Material(_target.defaultMaterial);
            _markedIslands = new RenderTexture(defaultTexture.width, defaultTexture.height, 0, RenderTextureFormat.R8);

            _paintShader = Shader.Find(UnlitTexturePaintShader);
            _fixIslandEdgesShader = Shader.Find(UnlitFixIslandEdges);
            _paintTexture = new PaintTexture(Color.white, defaultTexture.width, defaultTexture.height, MainTexName
                                             , _paintShader, _target.mesh, _fixIslandEdgesShader, _markedIslands);

            _paintMaterial.SetTexture(_paintTexture.id, _paintTexture.runTimeTexture);

            _paintMaterial.shader = _paintShader;
            _target.meshRenderer.sharedMaterial = _paintMaterial;

            // Command buffer initialization ------------------------------------------------

            _markingIslandsBuffer = new CommandBuffer();
            _markingIslandsBuffer.name = MarkingIslandsBufferName;

            _markingIslandsBuffer.SetRenderTarget(_markedIslands);
            Material islandMarker = new Material(_paintShader);
            _markingIslandsBuffer.DrawMesh(_target.mesh, Matrix4x4.identity, islandMarker);
            
            if (!TryToInitializeMainCamera())
                return (false, "There is no scene view camera");

            _camera.AddCommandBuffer(CameraEvent.AfterDepthTexture, _markingIslandsBuffer);
            _paintTexture.SetActiveTexture(_camera);
            
            return (true, string.Empty);
        }

        private (bool, string) TrySetTargetToSelection(GameObject activeGameObject)
        {
            _target.gameObject = activeGameObject;
            if (!_target.gameObject)
                return (false, MessageIds.NoTarget);

            if (_target.gameObject.TryGetComponent(out _target.meshFilter))
                _target.mesh = _target.meshFilter.sharedMesh;
            else
                return (false, MessageIds.NoMeshFilter);

            if (_target.gameObject.TryGetComponent(out _target.meshRenderer))
                _target.defaultMaterial = _target.meshRenderer.sharedMaterial;
            else
            {
                return (false, MessageIds.NoMeshRenderer);
            }

            return (true, string.Empty);
        }

        private bool TryToInitializeMainCamera()
        {
            _camera = SceneView.lastActiveSceneView.camera;

            return _camera;
        }

        private static void ResetTargetToDefault(Target target)
        {
            if (target.meshRenderer)
                target.meshRenderer.sharedMaterial = target.defaultMaterial;
        }
    }
}