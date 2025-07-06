using System;
using System.Linq;
using System.Reflection;
using UnityEditor.Search;

namespace VarelaAloisio.Editor
{
	public static class SearchItemExtensions
	{
		/// <summary>
		/// Validates if a Type implements an interface
		/// </summary>
		/// <param name="type">The target</param>
		/// <param name="interface">The interface to look for</param>
		/// <returns>true if Type implements the given interface</returns>
		public static bool Implements(this Type type, Type @interface)
		{
			return type.GetInterfaces()
			               .Any(i => i == @interface
			                         || i.IsGenericType && @interface.IsGenericType &&
			                         i.GetGenericTypeDefinition() == @interface.GetGenericTypeDefinition()
			                         && i.GenericTypeArguments.SequenceEqual(@interface.GenericTypeArguments));
		}
		
		/// <summary>
		/// Extracts the data from a searchItem into a custom struct for later use.
		/// </summary>
		/// <param name="item">The target item</param>
		/// <returns>The extracted data</returns>
		public static SearchItemData ExtractData(this SearchItem item)
		{
			var assemblyType = typeof(UnityEditor.Search.Providers.SceneQueryEngineFilterAttribute);
			var parentType = assemblyType.Assembly
			                             .GetType("UnityEditor.Search.Providers.AssetProvider");
			var dataType = parentType.GetNestedType("AssetMetaInfo", BindingFlags.NonPublic);
			var castedObject = Convert.ChangeType(item.data, dataType);
			var typeProperty = dataType.GetProperty("type");
			var pathField = dataType.GetField("path");
			return new SearchItemData
			       {
				       Type = typeProperty.GetMethod.Invoke(castedObject, null) as Type,
				       Path = pathField.GetValue(castedObject) as string,
				       Original = item,
			       };
		}
	}

	/// <summary>
	/// Rasterized version of <see cref="UnityEditor"/>.<see cref="UnityEditor.Search"/>.<see cref="SearchItem"/>
	/// </summary>
	public struct SearchItemData
	{
		public SearchItemData(Type type,
		                      string path,
		                      SearchItem original = null)
		{
			Type = type;
			Path = path;
			Original = original;
		}

		public Type Type { get; set; }
		public string Path { get; set; }
		public SearchItem Original { get; set; }
	}
}