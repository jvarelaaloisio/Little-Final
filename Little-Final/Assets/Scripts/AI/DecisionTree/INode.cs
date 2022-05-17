namespace AI.DecisionTree
{
	public interface INode
	{
		void Execute();
		string Name { get; }
	}
}