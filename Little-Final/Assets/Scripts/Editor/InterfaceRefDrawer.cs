using System;
using System.Collections;
using System.Diagnostics;
using System.Linq;
using Core.Extensions;
using Core.References;
using Cysharp.Threading.Tasks;
using Editor.Search;
using UnityEditor;
using UnityEditor.Search;
using UnityEngine;
using UnityEngine.Search;
using Debug = UnityEngine.Debug;
using Object = UnityEngine.Object;

namespace VarelaAloisio.Editor
{
	[CustomPropertyDrawer(typeof(InterfaceRef<>), true)]
	public class InterfaceRefDrawer : PropertyDrawer
	{
		private bool _isInitialized = false;
		private bool _isInitializing = false;

		private Type _interfaceType;
		private SerializedProperty _referenceProperty;
		private SearchContext _searchContext;

		public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
		{
			if (!_isInitialized && !_isInitializing)
				Initialize(property).Forget();
			EditorGUI.BeginDisabledGroup(_isInitializing);
			ObjectField.DoObjectField(position, _referenceProperty, typeof(Object), label, _searchContext, SearchProjectSettings.SearchViewFlags);
			EditorGUI.EndDisabledGroup();
		}

		private async UniTaskVoid Initialize(SerializedProperty property)
		{
#if BENCHMARK_EDITOR
			var stopwatch = Stopwatch.StartNew();
#endif
			_isInitializing = true;
			_referenceProperty = property.FindPropertyRelative("reference");
#if BENCHMARK_EDITOR
			var fetchPropertySpan = stopwatch.Elapsed;
			stopwatch.Restart();
#endif
			//BUG: When Collection is an array, all references are copied.
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
			_isInitializing = false;
			_isInitialized = true;
		}
	}
}