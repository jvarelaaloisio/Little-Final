using System;
using System.Collections.Generic;
using System.Linq;

namespace Editor.UIToolkit
{
    public static class TypeExtensions
    {
        public static IEnumerable<Type> GetTypeHierarchy(this Type type)
        {
            while (type != null)
            {
                yield return type;
                type = type.BaseType;
            }
        }

        public static bool InheritsFrom(this Type type, Type parent)
        {
            var inheritsFrom = type.GetTypeHierarchy().Any(t => t.IsGenericType && t.GetGenericTypeDefinition() == parent);
            return inheritsFrom;
        }
    }
}