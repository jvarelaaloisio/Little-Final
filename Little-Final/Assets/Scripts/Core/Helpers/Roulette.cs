using System;
using System.Collections.Generic;
using System.Linq;
using Random = UnityEngine.Random;

namespace Core.Helpers
{
	public class Roulette<T>
	{
		private readonly Dictionary<T, int> _weightedResults;

		public Roulette(Dictionary<T, int> weightedResults)
		{
			_weightedResults = weightedResults;
		}

		public T Spin()
		{
			int maxWeight = _weightedResults
				.Aggregate(0, (acum, chance) => acum + chance.Value);
			int random = Random.Range(0, maxWeight);
			foreach (var current in _weightedResults)
			{
				random -= current.Value;
				if (random >= 0)
					continue;
				return current.Key;
			}

			throw new ArgumentOutOfRangeException("outcomesWithChance",
												"Roulette couldn't make a decision");
		}
	}
}
