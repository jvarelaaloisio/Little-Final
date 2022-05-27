using System;

namespace AI.DecisionTree
{
	public class TreeAction<T> : INode
	{
		private readonly T _key;
		public event Action<T> OnResponse = delegate { };

		public string Name => _key.ToString();

		public TreeAction(T key)
		{
			_key = key;
		}

		public void Execute()
		{
			OnResponse(_key);
		}
	}
}