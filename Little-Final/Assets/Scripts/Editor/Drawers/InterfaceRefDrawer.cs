using System;
using System.Collections;
using System.Linq;
using Core.Extensions;
using Core.References;
using Editor.Search;
using UnityEditor;
using UnityEditor.Search;
using UnityEngine;
using VarelaAloisio.Editor;
using Debug = UnityEngine.Debug;
using Object = UnityEngine.Object;

namespace JVarelaAloisio.Editor.Drawers
{
	[CustomPropertyDrawer(typeof(InterfaceRef<>), true)]
	public class InterfaceRefDrawer : PropertyDrawer
	{
		private enum State
		{
			Uninitialized,
			Initializing,
			Initialized,
		}
		private State _state = State.Uninitialized;

		private Type _interfaceType;
		private SerializedProperty _referenceProperty;
		private SearchContext _searchContext;
		private Exception _exception;

		public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
		{
			if (_state == State.Uninitialized)
				Initialize(property);
			EditorGUI.BeginDisabledGroup(_state is not State.Initialized);
			_referenceProperty = property.FindPropertyRelative("reference");
			ObjectField.DoObjectField(position, _referenceProperty, typeof(Object), label, _searchContext, SearchProjectSettings.SearchViewFlags);
			EditorGUI.EndDisabledGroup();
			if (_exception != null)
			{
				//TODO: Encapsulate this HelpBox behaviour for reusability
				var content = EditorGUIUtility.IconContent("console.erroricon");
				content.text = _exception.Message;
				content.tooltip = "Click to open source.";
				var style = EditorStyles.helpBox;
				style.richText = true;
				if (GUILayout.Button(content, style))
				{
					var rect = GUILayoutUtility.GetLastRect();
					rect.y = position.height + style.CalcSize(content).y + EditorGUIUtility.singleLineHeight;
					PopupWindow.Show(rect, new StackTraceFramesPopup(_exception));
				}
			}
		}

		private void Initialize(SerializedProperty property)
		{
#if BENCHMARK_EDITOR
			var stopwatch = Stopwatch.StartNew();
#endif
			_state = State.Initializing;
#if BENCHMARK_EDITOR
			var fetchPropertySpan = stopwatch.Elapsed;
			stopwatch.Restart();
#endif
			var fieldType = fieldInfo.FieldType;
			_interfaceType = fieldType.IsArray
				                 ? fieldType?.GetElementType()?.GetGenericArguments().FirstOrDefault()
				                 : fieldType.Implements(typeof(ICollection))
					                 ? fieldType.GetGenericArguments()?.FirstOrDefault()?.GetGenericArguments()?.FirstOrDefault()
					                 : fieldType?.GetGenericArguments()?.FirstOrDefault();
#if BENCHMARK_EDITOR
			var getTypeSpan = stopwatch.Elapsed;
			stopwatch.Restart();
#endif
			try
			{
				_searchContext = SearchUtil.GetContextFor(_interfaceType);
			}
			catch (Exception e)
			{
				_exception = e;
				Debug.LogException(_exception);
#if BENCHMARK_EDITOR
				stopwatch.Stop();
#endif
				return;
			}
#if BENCHMARK_EDITOR
			stopwatch.Stop();
			var totalMs = fetchPropertySpan.TotalMilliseconds + getTypeSpan.TotalMilliseconds + stopwatch.ElapsedMilliseconds;
			var totalTicks = fetchPropertySpan.Ticks + getTypeSpan.Ticks + stopwatch.ElapsedTicks;
			var totalMsColor = totalMs < 100 ? C.Green : totalMs < 150 ? C.Blue : C.Red;
			Debug.Log($"Init method on drawer for {property.name?.Colored(C.Black)} took {totalMs.Colored(totalMsColor)}ms ({totalTicks} ticks)" +
			          $"\nTarget object: {property.serializedObject?.targetObject?.Colored(C.Black)}" +
			          $"\nFetch property: {fetchPropertySpan.TotalMilliseconds}ms ({fetchPropertySpan.Ticks} ticks)" +
			          $"\nGet Type: {getTypeSpan.TotalMilliseconds}ms ({getTypeSpan.Ticks} ticks)" +
			          $"\nGet Context: {stopwatch.Elapsed.TotalMilliseconds}ms ({stopwatch.ElapsedTicks} ticks)",
			          property.serializedObject?.targetObject);
#endif
			_state = State.Initialized;
		}
	}
}