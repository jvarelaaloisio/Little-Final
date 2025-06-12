using System;
using System.Collections;
using System.Diagnostics;
using System.Linq;
using Core.Extensions;
using Core.References;
using Editor.Search;
using UnityEditor;
using UnityEditor.Search;
using UnityEngine;
using Debug = UnityEngine.Debug;
using Object = UnityEngine.Object;

namespace VarelaAloisio.Editor
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

		public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
		{
			if (_state == State.Uninitialized)
				Initialize(property);
			EditorGUI.BeginDisabledGroup(_state is not State.Initialized);
			_referenceProperty = property.FindPropertyRelative("reference");
			ObjectField.DoObjectField(position, _referenceProperty, typeof(Object), label, _searchContext, SearchProjectSettings.SearchViewFlags);
			EditorGUI.EndDisabledGroup();
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
			_searchContext = SearchUtil.GetContextFor(_interfaceType);
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