using System;
using System.Collections.Generic;

namespace Player.Collectables
{
	public class CollectableBag
	{
		public Action<float> OnCollectableAdded = delegate { };
		public int quantityForReward;
		private readonly Action _giveReward;
		private List<CollectableRotator> _collectables;
		public int Quantity => _collectables.Count;

		public CollectableBag(
			int quantityForReward,
			Action onGiveReward)
		{
			this.quantityForReward = quantityForReward;
			_giveReward = onGiveReward;
			_collectables = new List<CollectableRotator>();
		}

		public void ValidateNewReward()
		{
			if (!(_collectables.Count >= quantityForReward))
				return;
			for (int i = 0; i < quantityForReward; i++)
			{
				_collectables[i].OnRewardGiven();
			}

			_collectables.RemoveRange(0, quantityForReward);
			_giveReward();
		}

		public void AddCollectable(CollectableRotator collectable)
		{
			_collectables.Add(collectable);
			OnCollectableAdded.Invoke(_collectables.Count);
		}
	}
}