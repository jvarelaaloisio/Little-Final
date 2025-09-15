using System;
using System.Linq;
using Core.Gameplay;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.Search;
using UnityEngine;
using VarelaAloisio.Editor;

namespace Input.Editor
{
    public class InputReaderDebuggerWindow : UnityEditor.EditorWindow
    {
        [SerializeField] private UnityEngine.Object _lastSelection;
        private IInputReader _reader;
        private Vector2 _moveInput = Vector2.zero;
        private bool _climbInput = false;
        private bool _runInput = false;

        private bool IsFocused => focusedWindow == this;

        [MenuItem("Tools/Debugger/Input")]
        public static void OpenWindow()
        {
            var context = SearchUtil.GetContextFor(typeof(IInputReader));


            SearchService.ShowPicker(context, HandleInputReaderSelected);
            void HandleInputReaderSelected(SearchItem item, bool wasCanceled)
            {
                if (wasCanceled)
                    return;
                var selection = item.ToObject(typeof(IInputReader));
                if (!selection)
                    return;
                IInputReader reader = null;
                if (selection is GameObject gameObject)
                {
                    if (!gameObject.TryGetComponent(out IInputReader candidate))
                    {
                        Debug.LogError($"Cannot find component of type {nameof(IInputReader)} in GameObject {gameObject.name}");
                        return;
                    }
                    reader = candidate;
                }
                else if (selection is IInputReader candidate)
                    reader = candidate;

                if (reader == null)
                {
                    Debug.LogError($"Couldn't cast selection to {nameof(IInputReader)}");
                    return;
                }
                var w = GetWindow<InputReaderDebuggerWindow>();
                w._reader = reader;
                w._lastSelection = item.ToObject();
                if (EditorApplication.isPlaying)
                    w.HandlePlayModeChanged(PlayModeStateChange.EnteredPlayMode);
                EditorApplication.playModeStateChanged += w.HandlePlayModeChanged;
                string readerLabel = item.label;
                w.titleContent = new GUIContent($"Input Debugger", readerLabel);
                
            }
        }

        [DidReloadScripts]
        private static void HandleReloadedScripts()
        {
            var window = Resources.FindObjectsOfTypeAll<InputReaderDebuggerWindow>().FirstOrDefault();
            if (!window)
                return;
            if (window._lastSelection)
            {
                EditorApplication.playModeStateChanged -= window.HandlePlayModeChanged;
                EditorApplication.playModeStateChanged += window.HandlePlayModeChanged;
            }
            else
            {
                window.Close();
                OpenWindow();
            }
        }

        private void HandlePlayModeChanged(PlayModeStateChange state)
        {
            if (state is PlayModeStateChange.EnteredEditMode or PlayModeStateChange.ExitingEditMode)
                return;

            if (_lastSelection is GameObject gameObject
                && gameObject.TryGetComponent(out IInputReader candidate))
                _reader = candidate;

            switch (state)
            {
                case PlayModeStateChange.EnteredPlayMode:
                    _reader.OnMoveInput += HandleMoveInput;
                    _reader.OnClimbPressed += HandleClimbPressed;
                    _reader.OnClimbReleased += HandleClimbReleased;
                    _reader.OnRunInput += HandleRunInput;
                    break;
                case PlayModeStateChange.ExitingPlayMode:
                    _reader.OnMoveInput -= HandleMoveInput;
                    _reader.OnClimbPressed -= HandleClimbPressed;
                    _reader.OnClimbReleased -= HandleClimbReleased;
                    _reader.OnRunInput -= HandleRunInput;
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(state), state, null);
            }
        }

        private void OnGUI()
        {
            EditorGUILayout.LabelField("Movement", _moveInput.ToString());
            EditorGUILayout.LabelField("Climb", _climbInput.ToString());
            EditorGUILayout.LabelField("Run", _runInput.ToString());
        }

        private void OnDestroy()
        {
            EditorApplication.playModeStateChanged -= HandlePlayModeChanged;
            if (_reader == null)
                return;
            _reader.OnMoveInput -= HandleMoveInput;
            _reader.OnClimbPressed -= HandleClimbPressed;
            _reader.OnClimbReleased -= HandleClimbReleased;
            _reader.OnRunInput -= HandleRunInput;
        }

        private void HandleMoveInput(Vector2 input)
        {
            _moveInput = input;
            Repaint();
        }

        private void HandleClimbPressed()
        {
            _climbInput = true;
            ForceRepaintNotFocused();
        }

        private void HandleClimbReleased()
        {
            _climbInput = false;
            ForceRepaintNotFocused();
        }

        private void HandleRunInput(bool value)
        {
            _runInput = value;
            ForceRepaintNotFocused();
        }

        private void ForceRepaintNotFocused()
        {
            if (!IsFocused)
                Repaint();
        }
    }
}
