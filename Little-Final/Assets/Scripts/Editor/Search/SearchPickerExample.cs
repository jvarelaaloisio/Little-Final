using System;
using System.Collections.Generic;
using System.Reflection;
using Core.Providers;
using UnityEditor;
using UnityEditor.Search;
using UnityEngine;
using UnityEngine.Search;
using Object = UnityEngine.Object;

namespace VarelaAloisio.Editor
{
	//TODO: Check this and remove when done.
	public class SearchPickerExample
	{
		private static List<SearchItemData> items = new ();
		[MenuItem("Examples/Search Picker/Material Picker")]
		public static void ShowMaterialPicker()
		{
			// Create search context for materials
			var context = SearchService.CreateContext("asset", "Provider", SearchFlags.WantsMore | SearchFlags.Default);

			SearchService.Request(context, HandleIncomingItem, HandleSearchCompleted,
			                      SearchFlags.WantsMore | SearchFlags.Default);
			return;
			SearchService.ShowPicker(context,
			                         pickerSelectHandler,
			                         pickerTrackingHandler,
			                         PickerFilterHandler);
			// Configure view state
			var viewState = new SearchViewState(context)
			                {
				                windowTitle = new GUIContent("Material Selector"),
				                title = "Materials",
				                selectHandler = OnMaterialSelected,
				                trackingHandler = OnMaterialTracked,
				                position = SearchUtils.GetMainWindowCenteredPosition(new Vector2(600, 400)),
				                flags = SearchViewFlags.GridView | SearchViewFlags.DisableSavedSearchQuery
			                };
        
			SearchService.ShowPicker(viewState);
		}

		private static void HandleSearchCompleted(SearchContext context)
		{
			foreach (var item in items)
			{
				Debug.Log(item.Path);
			}
		}

		private static void HandleIncomingItem(SearchContext context, IEnumerable<SearchItem> searchItems)
		{
			foreach (var item in searchItems)
			{
				var data = item.ExtractData();
				if (data.Type.Implements(typeof(IDataProvider<>)))
					items.Add(data);
			}
		}

		private static bool PickerFilterHandler(SearchItem item)
		{
			if (item.data is null)
				return true;
			return GetItemType(item).Implements(typeof(IDataProvider<>));
		}

		private static Type GetItemType(SearchItem item)
		{
			var assemblyType = typeof(UnityEditor.Search.Providers.SceneQueryEngineFilterAttribute);
			var parentType = assemblyType.Assembly
			                             .GetType("UnityEditor.Search.Providers.AssetProvider");
			var dataType = parentType.GetNestedType("AssetMetaInfo", BindingFlags.NonPublic);
			var typeProperty = dataType.GetProperty("type");
			var castedObject = Convert.ChangeType(item.data, dataType);
			return typeProperty.GetMethod.Invoke(castedObject, null) as Type;
		}

		private static void pickerTrackingHandler(SearchItem obj)
		{
			return;
		}

		private static void pickerSelectHandler(SearchItem arg1, bool arg2)
		{
			return;
		}

		static void OnMaterialSelected(SearchItem item, bool canceled)
		{
			if (!canceled)
			{
				var material = item.ToObject<Material>();
				Debug.Log($"Selected material: {material.name}");
			}
		}

		static void OnMaterialTracked(SearchItem item)
		{
			Debug.Log($"Previewing material: {item.label}");
		}
		
//----------------------------------------------------------------------------------------------------------------------
		
		[MenuItem("Examples/Show Object Picker")]
		public static void ShowPicker()
		{
			SearchService.ShowObjectPicker(
			                               SelectHandler,
			                               TrackHandler,
			                               "", // initial search text
			                               "Material", // type filter
			                               typeof(UnityEngine.Object), // alternative type filter
			                               600, // window width
			                               400, // window height
			                               SearchFlags.Dockable
			                              );
		}

		private static void TrackHandler(Object obj)
		{
			Debug.Log($"Tracking {obj.name}");
		}

		private static void SelectHandler(Object obj, bool canceled)
		{
			if (!canceled && obj)
				Debug.Log($"Selected: {obj.name}");
		}
	}
}