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
    }
}
