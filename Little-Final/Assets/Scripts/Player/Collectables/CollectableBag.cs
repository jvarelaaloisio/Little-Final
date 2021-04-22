using System;
using System.Collections.Generic;
using Player.Collectables;

public class CollectableBag
{
	private List<CollectableRotator> _collectables;
	public int quantityForReward;
	private readonly Action _giveReward;
	private readonly Action<float> _onCollectableAdded = delegate { };
	public int Quantity => _collectables.Count;

	public CollectableBag(
		int quantityForReward,
		Action onGiveReward)
	{
		this.quantityForReward = quantityForReward;
		_giveReward = onGiveReward;
		_collectables = new List<CollectableRotator>();
	}

	public CollectableBag(
		int quantityForReward,
		Action onGiveReward,
		Action<float> onCollectableAdded): this(quantityForReward, onGiveReward)
	{
		_onCollectableAdded = onCollectableAdded;
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
		_onCollectableAdded.Invoke(_collectables.Count);
	}
}