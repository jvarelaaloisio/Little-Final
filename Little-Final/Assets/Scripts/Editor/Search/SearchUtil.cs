using System;
using System.Linq;
using Core.Extensions;
using Editor.Search;
using UnityEditor;
using UnityEditor.Search;

namespace VarelaAloisio.Editor
{
	public static class SearchUtil
	{
		public static SearchContext GetContextFor(Type type)
		{
			var typesDerivedFrom = TypeCache.GetTypesDerivedFrom(type);
			if (!typesDerivedFrom.Any())
			{
				throw new
					TypeLoadException($"{nameof(SearchUtil)}: No types found that derive from {type.FullName.Colored(C.Red)}");
			}
			var query = typesDerivedFrom.Select(type => $"t:{type.FullName}").Aggregate((current, next) => $"{current} or {next}");
			return SearchService.CreateContext(SearchService.Providers, query, SearchProjectSettings.SearchFlags);
		}
	}
}