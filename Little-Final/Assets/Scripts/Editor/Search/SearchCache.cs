using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Cysharp.Threading.Tasks;
using UnityEditor.Search;
using Debug = UnityEngine.Debug;

namespace VarelaAloisio.Editor
{
	public static class SearchCache
	{
		private static Dictionary<Type, List<SearchItemData>> _cache = new ();

		private static readonly SearchContext projectCtx = SearchService.CreateContext("asset", "*.asset", SearchFlags.WantsMore | SearchFlags.Default);

		public static async UniTask<List<SearchItemData>> QueryAll(Type @interface,
		                                                 bool forceNewFetch = false,
		                                                 bool includeNone = true)
		{
			if (!forceNewFetch && _cache.TryGetValue(@interface, out var result))
				return result;

			var genericTypeArguments = @interface.GenericTypeArguments.Select(t => t.Name).Aggregate((accum, next) => $"{accum}, {next}");
			if (!forceNewFetch)
			{
				Debug.Log($"Query for {@interface.Name}<{genericTypeArguments}> was not cached. Performing request");
			}

			var stopwatch = Stopwatch.StartNew();
			var isFinished = false;
			result = new List<SearchItemData>();
			SearchService.Request(projectCtx, HandleIncomingItem, HandleSearchComplete,
			                      SearchFlags.WantsMore | SearchFlags.Default);

			await UniTask.WaitUntil(() => isFinished);
			Debug.Log($"Query for {@interface.Name}<{genericTypeArguments}> took: {stopwatch.ElapsedMilliseconds}ms");
			return result;

			void HandleIncomingItem(SearchContext context, IEnumerable<SearchItem> searchItems)
			{
				if (includeNone)
					result.Add(new SearchItemData(typeof(void), "none"));
				foreach (var item in searchItems)
				{
					var data = item.ExtractData();
					if (data.Type.Implements(@interface))
						result.Add(data);
				}

				isFinished = true;
			}
			void HandleSearchComplete(SearchContext context) { }
		}

		public static async void QueryAll(Type @interface,
		                                          Action<List<SearchItemData>> onFinish,
		                                          bool forceNewFetch = false,
		                                          bool includeNone = true)
		{
			var result = await QueryAll(@interface, forceNewFetch, includeNone);
			_cache.TryAdd(@interface, result);
			onFinish(result);
		}
	}
}