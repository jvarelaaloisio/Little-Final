using System;
using System.Collections.Generic;
using System.Linq;
using Core.Extensions;
using Core.Helpers;

namespace Core.Data
{
	public class ReverseIndexStore
	{
		private readonly Dictionary<IIdentifier, object> _allObjects = new(comparer:new IIdentifier.Comparer());
		private readonly Dictionary<Type, Dictionary<IIdentifier, object>> _typeIndex = new();

		public void Set<T>(IIdentifier id, T obj, bool replaceIfDuplicate = true)
		{
#if BENCHMARK_DATA
			var stopwatch = System.Diagnostics.Stopwatch.StartNew();
#endif
			_allObjects[id] = obj;
			AddToAllTypes(id, obj, _typeIndex, replaceIfDuplicate);
#if BENCHMARK_DATA
			stopwatch.Stop();
			var ms = stopwatch.Elapsed.TotalMilliseconds;
			var color = ms < 0.001f ? C.Green : ms < 1 ? C.Blue : C.Red;
			UnityEngine.Debug.Log($"Set: {id.name} ({obj}) took {ms.Colored(color)}ms ({stopwatch.ElapsedTicks} ticks)");
#endif
		}

		public IEnumerable<KeyValuePair<IIdentifier, T>> Query<T>()
		{
			return _typeIndex.TryGetValue(typeof(T), out var dictionary)
				       ? dictionary.Select(kvp => new KeyValuePair<IIdentifier,T>(kvp.Key, (T)kvp.Value))
				       : Enumerable.Empty<KeyValuePair<IIdentifier, T>>();
		}
		
		public bool TryGetFirst<T>(out T result)
		{
			result = Query<T>().Select(kvp => kvp.Value).FirstOrDefault();
			return result != null;
		}

		public bool TryGet<T>(IIdentifier id, out T result)
		{
			result = default!;
			if (_allObjects.TryGetValue(id, out var obj) && obj is T t)
			{
				result = t;
				return true;
			}
			return false;
		}
		
		public bool Remove(IIdentifier id)
		{
			if (!_allObjects.TryGetValue(id, out var obj))
				return false;
			
			foreach (var type in GetAllTypes(obj.GetType()))
			{
				if (!_typeIndex.TryGetValue(type, out var dictionary))
					continue;
				
				dictionary.Remove(id);
				if (dictionary.Count == 0)
					_typeIndex.Remove(type);
			}

			return _allObjects.Remove(id);

		}

		public object this[Type type, IIdentifier id]
			=> _typeIndex[type][id];

		public object this[Type type]
			=> _typeIndex[type];

		private static void AddToAllTypes<T>(IIdentifier id,
		                                     T obj,
		                                     in Dictionary<Type, Dictionary<IIdentifier, object>> typeIndex,
		                                     bool replaceIfDuplicate)
		{
			foreach (var type in GetAllTypes(typeof(T)))
			{
				if (!typeIndex.TryGetValue(type, out var dictionary))
				{
					dictionary = new Dictionary<IIdentifier, object>(comparer:new IIdentifier.Comparer());
					typeIndex.Add(type, dictionary);
				}

				if (!dictionary.TryAdd(id, obj) && replaceIfDuplicate)
					dictionary[id] = obj;
			}
		}

		private static IEnumerable<Type> GetAllTypes(Type type)
		{
			if (type == null) yield break;

			yield return type;

			foreach (var @interface in type.GetInterfaces())
				yield return @interface;

			var baseType = type.BaseType;
			while (baseType != null)
			{
				yield return baseType;
				baseType = baseType.BaseType;
			}
		}
	}
}