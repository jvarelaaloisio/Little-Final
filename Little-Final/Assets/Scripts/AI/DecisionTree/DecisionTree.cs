using System;
using System.Collections.Generic;
using UnityEngine;

namespace AI.DecisionTree
{
	public class DecisionTree<T>
	{
		public event Action<T> OnResponse;
		private readonly INode _start;
		private string _trace;
		private T _lastResponse;
		private readonly ILogger _logger;
		public string Tag { get; set; } = "";

		public bool LogTrace { get; set; }
		public bool LogRepeatedResponses { get; set; } = true;

		public DecisionTree(IEnumerable<IQuestion> questions,
							IEnumerable<TreeAction<T>> actions,
							Action<T> onResponse,
							INode start,
							ILogger logger,
							bool logTrace = true)
		{
			foreach (IQuestion question in questions)
				question.ChangeNode += ChangeNode;
			foreach (TreeAction<T> action in actions)
				action.OnResponse += GiveResponse;
			OnResponse = onResponse;
			_start = start;
			_logger = logger;
			LogTrace = logTrace;
		}

		public void RunTree()
		{
			_trace = "Tree Trace";
			ChangeNode(_start);
		}

		private void ChangeNode(INode newNode)
		{
			if (LogTrace) _trace += $" -> {newNode.Name}";
			newNode.Execute();
		}

		private void GiveResponse(T response)
		{
			if (LogTrace && (LogRepeatedResponses || !response.Equals(_lastResponse)))
			{
				_trace += $"\nResponse: <color=green>{response.ToString()}</color>";
				_logger.Log(Tag, _trace);
			}

			_lastResponse = response;

			OnResponse(response);
		}
	}
}