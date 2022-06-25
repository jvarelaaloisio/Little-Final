using System;
using System.Collections.Generic;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Core.Debugging
{
	[CreateAssetMenu(menuName = "Debug/Debugger", fileName = "Debugger", order = 0)]
	public class Debugger : ScriptableObject, ILogger
	{
		private ILogger _logger;

		[Header("Log enabling")]
		[SerializeField]
		private bool enabled = true;

		[Space]
		[SerializeField]
		private bool allowLog = true;

		[SerializeField]
		private bool allowWarning = true;

		[SerializeField]
		private bool allowError = true;

		[SerializeField]
		private bool allowAssert = true;

		[SerializeField]
		private bool allowException = true;

		[Space]
		[SerializeField]
		private bool drawLines = true;

		[SerializeField]
		private bool drawRays = true;

		[Space]
		[SerializeField]
		[Tooltip("Tags to be excluded in logging")]
		private List<string> filteredTags;

		public ILogHandler logHandler { get; set; }

		private Dictionary<LogType, bool> _logTypesAllowed;

		//TODO: Esto solo funca en un DLL
		private static string CurrentClass
		{
			get {
				var st = new System.Diagnostics.StackTrace();
				
				var index = Mathf.Min(st.FrameCount - 1, 3);
 
				if (index < 0)
					return "{NoClass}";
 
				return "{" + st.GetFrame(index).GetMethod().DeclaringType.Name + "}";
			}
		}
		
		#region ILogger

		public bool logEnabled
		{
			get => enabled;
			set => enabled = value;
		}

		//TODO: Find out what this does
		public LogType filterLogType { get; set; }

		private void OnValidate()
		{
			SetupAllowedLogsDictionary();
		}

		private void SetupAllowedLogsDictionary()
		{
			_logTypesAllowed = new Dictionary<LogType, bool>()
								{
									{LogType.Log, allowLog},
									{LogType.Warning, allowWarning},
									{LogType.Error, allowError},
									{LogType.Assert, allowAssert},
									{LogType.Exception, allowException},
								};
		}

		private void OnEnable()
		{
			_logger = Debug.unityLogger;
			SetupAllowedLogsDictionary();
		}

		public bool IsLogTypeAllowed(LogType logType)
			=> _logTypesAllowed[logType];

		public void Log(LogType logType, string tag, object message, Object context)
			=> LogInternal(logType, tag, message, context);

		public void Log(string message)
			=> Log(LogType.Log, string.Empty, message);
		
		public void Log(object message)
			=> Log(LogType.Log, string.Empty, message);

		public void Log(string tag, object message)
			=> LogInternal(LogType.Log, tag, message);

		public void Log(string tag, object message, Object context)
			=> LogInternal(LogType.Log, tag, message, context);

		public void LogWarning(string tag, object message)
			=> LogInternal(LogType.Warning, tag, message);

		public void LogWarning(string tag, object message, Object context)
			=> LogInternal(LogType.Warning, tag, message, context);

		public void LogError(string tag, object message)
			=> Log(LogType.Error, tag, message);

		public void LogError(string tag, object message, Object context)
			=> LogInternal(LogType.Error, tag, message, context);

		public void Log(LogType logType, object message)
			=> LogInternal(logType, string.Empty, message);

		public void Log(LogType logType, string tag, object message)
			=> LogInternal(logType, tag, message);

		public void Log(LogType logType, object message, Object context)
			=> LogInternal(logType, string.Empty, message, context);

		//TODO: Try to get it to work with logInternal
		public void LogFormat(LogType logType, Object context, string format, params object[] args)
			=> _logger.LogFormat(logType, context, format, args);

		//TODO: Try to get it to work with logInternal
		public void LogFormat(LogType logType, string format, params object[] args)
			=> _logger.LogFormat(logType, format, args);

		//TODO: Try to get it to work with logInternal
		public void LogException(Exception exception, Object context)
			=> _logger.LogException(exception, context);

		public void LogException(Exception exception)
			=> _logger.LogException(exception);

		private void LogInternal(LogType logType, string tag, object message, Object context = null)
		{
			if (!enabled || !IsLogTypeAllowed(logType) || filteredTags.Contains(tag))
				return;
			bool tagIsEmpty = tag == string.Empty;
			switch (context != null)
			{
				case true when tagIsEmpty:
					_logger.Log(logType, tag, $"{message}:{CurrentClass}", context);
					break;
				case true:
					_logger.Log(logType, (object)$"{message}:{CurrentClass}", context);
					break;
				case false when tagIsEmpty:
					_logger.Log(logType, message);
					break;
				case false:
					_logger.Log(logType, tag, message);
					break;
			}
		}
		#endregion

		#region Draws

		public void DrawLine(string tag, Vector3 start, Vector3 end)
		{
			DrawLine(tag, start, end, Color.white);
		}

		public void DrawLine(string tag, Vector3 start, Vector3 end, Color color)
		{
			DrawLine(tag, start, end, color, 0);
		}

		public void DrawLine(string tag, Vector3 start, Vector3 end, Color color, float duration)
		{
			if (!enabled || !drawLines || filteredTags.Contains(tag))
				return;
			Debug.DrawLine(start, end, color, duration);
		}

		public void DrawRay(string tag, Vector3 start, Vector3 dir)
		{
			DrawRay(tag, start, dir, Color.white);
		}

		public void DrawRay(string tag, Vector3 start, Vector3 dir, Color color)
		{
			DrawRay(tag, start, dir, color, 0);
		}

		public void DrawRay(string tag, Vector3 start, Vector3 dir, Color color, float duration)
		{
			if (!enabled || !drawRays || filteredTags.Contains(tag))
				return;
			Debug.DrawRay(start, dir, color, duration);
		}

		#endregion
	}
}