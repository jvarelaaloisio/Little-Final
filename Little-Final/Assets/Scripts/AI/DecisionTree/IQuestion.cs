using System;

namespace AI.DecisionTree
{
	public interface IQuestion : INode
	{
		event Action<INode> ChangeNode;
	}
}