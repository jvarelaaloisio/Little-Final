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
		[Tooltip("Tags to be excluded in logging")]
		private List<string> filteredTags;

		public ILogHandler logHandler { get; set; }

		private Dictionary<LogType, bool> _logTypesAllowed;

		public bool logEnabled
		{
			get => enabled;
			set => enabled = value;
		}

		//TODO: Find out what this does
		public LogType filterLogType { get; set; }

		private void OnValidate()
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
		}

		public bool IsLogTypeAllowed(LogType logType)
			=> _logTypesAllowed[logType];

		public void Log(LogType logType, string tag, object message, Object context)
			=> LogInternal(logType, tag, message, context);

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

		private void LogInternal(LogType logType, string tag, object message, Object context = null)
		{
			bool tagIsEmpty = tag == string.Empty;
			if (!tagIsEmpty)
				message = tag + ": " + message;
			if (enabled && filteredTags.Contains(tag))
				return;
			switch (context != null)
			{
				case true when tagIsEmpty:
					_logger.Log(logType, tag, message, context);
					break;
				case true:
					_logger.Log(logType, message, context);
					break;
				case false when tagIsEmpty:
					_logger.Log(logType, message);
					break;
				case false:
					_logger.Log(logType, tag, message);
					break;
			}
		}

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
	}
}