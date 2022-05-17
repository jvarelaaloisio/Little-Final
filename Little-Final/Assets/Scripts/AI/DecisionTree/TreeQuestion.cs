using System;

namespace AI.DecisionTree
{
	public class TreeQuestion : IQuestion
	{
		public event Action<INode> ChangeNode;
		private readonly Func<bool> _question;

		private readonly INode _trueOutcome;
		private readonly INode _falseOutcome;

		public string Name => _question.Method.Name;
		
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