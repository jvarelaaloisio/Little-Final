using System;
using System.Collections.Generic;
using System.Linq;
using Random = UnityEngine.Random;

namespace AI.DecisionTree
{
	public class TreeRoulette : IQuestion
	{
		public event Action<INode> ChangeNode;
		private readonly Dictionary<INode, int> _outcomesWithChance;

		public string Name
		{
			get
			{
				string outcomes = _outcomesWithChance
					.Aggregate(string.Empty,
								(current, outcome) => current + $" {outcome.Key.Name} ");
				return $"Roulette: ({outcomes})";
			}
		}

		public TreeRoulette(Dictionary<INode, int> outcomesWithChance)
		{
			_outcomesWithChance = outcomesWithChance;
		}

		public void Execute()
		{
			int maxWeight = _outcomesWithChance
				.Aggregate(0, (acum, chance) => acum + chance.Value);
			int random = Random.Range(0, maxWeight);
			foreach (var current in _outcomesWithChance)
			{
				random -= current.Value;
				if (random >= 0)
					continue;
				ChangeNode(current.Key);
				return;
			}

			throw new ArgumentOutOfRangeException(nameof(_outcomesWithChance),
												"Roulette couldn't make a decision");
		}
	}
}