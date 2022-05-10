using System;
using System.Collections.Generic;

namespace AI.DecisionTree
{
	public class DecisionTree<T>
	{
		private readonly INode _start;

		public DecisionTree(IEnumerable<IQuestion> questions,
					IEnumerable<TreeAction<T>> actions,
					Action<T> onResponse,
					INode start)
		{
			_start = start;
			foreach (IQuestion question in questions)
				question.ChangeNode += ChangeNode;
			foreach (TreeAction<T> action in actions)
				action.OnResponse += onResponse;
		}

		public void RunTree()
			=> ChangeNode(_start);

		public void ChangeNode(INode newNode)
		{
			newNode.Execute();
		}
	}
}