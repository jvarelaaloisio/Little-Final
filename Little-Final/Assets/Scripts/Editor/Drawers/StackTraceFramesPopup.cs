using System;
using System.Diagnostics;
using System.Linq;
using Core.Extensions;
using UnityEditor;
using UnityEngine;
using Debug = UnityEngine.Debug;

namespace JVarelaAloisio.Editor.Drawers
{
	public class StackTraceFramesPopup : PopupWindowContent
	{
		private readonly StackFrame[] _frames;
		private readonly GUIStyle _buttonStyle;

		public Exception Exception { get; }

		public StackTraceFramesPopup(Exception e)
		{
			Exception = e;
			var stackTrace = new StackTrace(e, true);
			_frames = stackTrace.GetFrames();
			_buttonStyle = new GUIStyle(GUI.skin.button)
			               {
				               richText = true,
				               alignment = TextAnchor.MiddleLeft
			               };
		}

		/// <inheritdoc />
		public override Vector2 GetWindowSize()
		{
			if (_frames == null || _frames.Length < 1)
				return base.GetWindowSize();
			
			const float characterWidth = 5.5f;
			const float lineHeightMultiplier = 1.25f;
			var frame = _frames.OrderBy(f => f.GetFileName()!.Length).First();
			const int colonPlusSpaceLength = 2;
			var width = (frame.GetFileName()!.Length + frame.GetFileLineNumber() + colonPlusSpaceLength) * characterWidth;
			var height = _frames.Length * EditorGUIUtility.singleLineHeight * lineHeightMultiplier;
			return new Vector2(width, height);
		}

		public override void OnGUI(Rect rect)
		{
			if (_frames == null)
			{
				editorWindow.Close();
				Debug.LogError($"{nameof(StackTraceFramesPopup)}: frames is null!");
				return;
			}

			foreach (var frame in _frames)
			{
				if (GUILayout.Button($"{frame.GetFileName().Bold()}: {frame.GetFileLineNumber().Colored(C.Black).Bold()}", _buttonStyle))
				{
					UnityEditorInternal.InternalEditorUtility
					                   .OpenFileAtLineExternal(frame.GetFileName(),
					                                           frame.GetFileLineNumber(),
					                                           frame.GetFileColumnNumber());
				}
			}

			if (Event.current.type == EventType.KeyUp && Event.current.keyCode == KeyCode.Escape)
				editorWindow.Close();
		}
	}
}