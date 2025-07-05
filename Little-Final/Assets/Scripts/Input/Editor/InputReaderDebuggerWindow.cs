using System;
using Core.Gameplay;
using UnityEditor;
using UnityEditor.Search;
using UnityEngine;
using VarelaAloisio.Editor;

namespace Input.Editor
{
    public class InputReaderDebuggerWindow : UnityEditor.EditorWindow
    {
        private IInputReader _reader;
        private Vector2 _moveInput = Vector2.zero;

        [MenuItem("Tools/Input/Debugger")]
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
                if (EditorApplication.isPlaying)
                    w.HandlePlayModeChanged(PlayModeStateChange.EnteredPlayMode);
                EditorApplication.playModeStateChanged += w.HandlePlayModeChanged;
                w.titleContent = new GUIContent($"Input Debugger", item.label);
            }
        }

        private void HandlePlayModeChanged(PlayModeStateChange state)
        {
            if (_reader == null)
                return;
            if (state == PlayModeStateChange.EnteredPlayMode)
            {
                _reader.OnMoveInput += HandleMoveInput;
            }
            else if (state == PlayModeStateChange.ExitingPlayMode)
            {
                _reader.OnMoveInput -= HandleMoveInput;
            }
        }

        private void OnGUI()
        {
            EditorGUILayout.LabelField("Movement", _moveInput.ToString());
        }

        private void OnDestroy()
        {
            EditorApplication.playModeStateChanged -= HandlePlayModeChanged;
            if (_reader == null)
                return;
            _reader.OnMoveInput -= HandleMoveInput;
        }

        private void HandleMoveInput(Vector2 input)
        {
            _moveInput = input;
            Repaint();
        }
    }
}
