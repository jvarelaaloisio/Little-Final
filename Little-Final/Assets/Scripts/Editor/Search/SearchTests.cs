using System.Linq;
using Core.Gameplay;
using Core.Providers;
using Core.References;
using DataProviders.Async;
using UnityEditor;
using UnityEditor.Search;
using UnityEngine;

namespace VarelaAloisio.Editor
{
	//TODO: Check this and remove when done.
	public static class SearchTests
	{
		private static string[] _providerIds = { "asset", "scene" };

		[MenuItem("Search/Show picker for all of interface")]
		public static async void Test1()
		{
			var options = await SearchCache.QueryAll(typeof(InterfaceRef<IDataProviderAsync<IInputReader>>));
			// SearchService.Providers.Add(new SearchProvider("interface refs",));
			var context = SearchService.CreateContext("");
			var subset = options.Where(data => data.Original != null).Select(data => data.Original);
			SearchService.ShowPicker(context, HandleSelect,subset:subset);
			return;

			void HandleSelect(SearchItem selected, bool isCanceled) { }
		}

		//This is the best way I've found to search for multiple typed objects, for the time.
		//I need to do some tests regarding how long it takes.
		[MenuItem("Search/Use TypeCache")]
		public static void Test2()
		{
			var typesDerivedFrom = TypeCache.GetTypesDerivedFrom(typeof(IDataProvider<Camera>));
			var providers = _providerIds.Select(SearchService.GetProvider);
			var query = typesDerivedFrom.Select(type => $"t:{type.FullName}").Aggregate((current, next) => $"{current} or {next}");
			var context = SearchService.CreateContext(providers, query);
			ISearchView picker = SearchService.ShowPicker(context, HandleSelection);
		}

		private static void HandleSelection(SearchItem arg1, bool arg2)
		{
			Debug.Log($"Selected {arg1}, {arg2}");
		}

		[MenuItem("Search/Log Providers")]
		public static void LogProviders()
		{
			foreach (var provider in SearchService.Providers)
			{
				Debug.Log($"{provider.name}({provider.id}): type{provider.type}");
			}
		}
	}
}