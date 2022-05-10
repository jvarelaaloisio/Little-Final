using System;
using AI.DecisionTree;

namespace IA.DecisionTree
{
	public class TreeQuestion : IQuestion
	{
		public event Action<INode> ChangeNode;
		private readonly Func<bool> _question;

		private readonly INode _trueOutcome;
		private readonly INode _falseOutcome;

		public TreeQuestion(Func<bool> question,
							INode trueOutcome,
							INode falseOutcome)
		{
			_question = question;
			_trueOutcome = trueOutcome;
			_falseOutcome = falseOutcome;
		}

		public void Execute()
		{
			ChangeNode(_question()
							? _trueOutcome
							: _falseOutcome);
		}
	}
}