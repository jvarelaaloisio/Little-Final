using System;
using System.Linq;
using UnityEditor;
using UnityEditor.Search;

namespace VarelaAloisio.Editor
{
	public static class SearchUtil
	{
		public static readonly string[] DefaultProviderIds = { "asset", "scene" };

		public static SearchContext GetContextFor(Type type)
			=> GetContextFor(type, DefaultProviderIds);

		public static SearchContext GetContextFor(Type type, string[] providerIds)
		{
			var typesDerivedFrom = TypeCache.GetTypesDerivedFrom(type);
			var providers = providerIds.Select(SearchService.GetProvider);
			var query = typesDerivedFrom.Select(type => $"t:{type.FullName}").Aggregate((current, next) => $"{current} or {next}");
			return SearchService.CreateContext(providers, query);
		}
	}
}