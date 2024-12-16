using UnityEngine;

namespace Core.Extensions
{
    public static class ObjectExtensions
    {
        [HideInCallstack]
        public static void Log(this UnityEngine.Object writer, object message)
            => Debug.Log(GetFormattedMessage(writer, message), writer);
        [HideInCallstack]
        public static void Log(this UnityEngine.Object writer, object message, Object context)
            => Debug.Log(GetFormattedMessage(writer, message), context);
        [HideInCallstack]
        public static void LogError(this UnityEngine.Object writer, object message)
            => Debug.LogError(GetFormattedMessage(writer, message), writer);
        [HideInCallstack]
        public static void LogError(this UnityEngine.Object writer, object message, Object context)
            => Debug.LogError(GetFormattedMessage(writer, message), context);
        [HideInCallstack]
        public static void LogWarning(this UnityEngine.Object writer, object message)
            => Debug.LogWarning(GetFormattedMessage(writer, message), writer);
        [HideInCallstack]
        public static void LogWarning(this UnityEngine.Object writer, object message, Object context)
            => Debug.LogWarning(GetFormattedMessage(writer, message), context);
        
        private static string GetFormattedMessage(Object writer, object message) => $"{writer.name}: {message}";
        
        /// <summary>
        /// Checks if target is null and logs if needed.
        /// </summary>
        /// <param name="caller">The object that is calling this method</param>
        /// <param name="target">The object to null-check</param>
        /// <param name="shouldLogErrorIfNull">If the target is null, should an error be logged</param>
        /// <typeparam name="TCaller">The Type of the object that is calling this method</typeparam>
        /// <typeparam name="TTarget">The type of the object to null-check</typeparam>
        /// <returns><para>False if target is null</para>
        /// <para>True if target is <b>not</b> null</para>
        /// </returns>
        [HideInCallstack]
        public static bool IsNotNull<TCaller, TTarget>(this TCaller caller, TTarget target, bool shouldLogErrorIfNull = true)
        {
            var isNull = target == null;
            if (isNull && shouldLogErrorIfNull)
                if (caller is UnityEngine.Object sourceUnityObject)
                    sourceUnityObject.LogError($"{nameof(TTarget)} is null!");
                else
                    Debug.LogError($"{nameof(TCaller)}: {nameof(TTarget)} is null!");
            return !isNull;
        }
    }
}
