﻿using System;
using System.Linq;
using Core.Extensions;
using Editor.Search;
using UnityEditor;
using UnityEditor.Search;
using UnityEngine;

namespace VarelaAloisio.Editor
{
	public static class SearchUtil
	{
		/// <summary>
		/// Used to facilitate searches via interfaces
		/// </summary>
		/// <param name="type">The type in question</param>
		/// <returns>A <see cref="SearchContext"/> with a query containing every type derived from the one given.</returns>
		/// <exception cref="TypeLoadException">If the type has no inheritors</exception>
		public static SearchContext GetContextFor(Type type)
		{
			var typesDerivedFrom = TypeCache.GetTypesDerivedFrom(type);
			if (!typesDerivedFrom.Any())
			{
				string formattedName = type.ToString()
				                           .Replace("`1[", "<")
				                           .Replace("`2[", "<")
				                           .Replace("`3[", "<")
				                           .Replace("]", ">");
				throw new
					TypeLoadException($"{nameof(SearchUtil)}: No types found that derive from {type.Name.Colored("#dd3333").Bold()}" +
					                  $"\nFull name: {formattedName}".Colored("#888888"));
			}
			var query = typesDerivedFrom.Select(type => $"t:{type.FullName}").Aggregate((current, next) => $"{current} or {next}");
			return SearchService.CreateContext(SearchService.Providers, query, SearchProjectSettings.SearchFlags);
		}
	}
}