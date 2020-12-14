using System;
using System.Collections.Generic;
public class CollectableBag
{
	List<CollectableRotator> collectables;
	public int quantityForReward;
	private Action giveReward;
	private Action<float> onCollectableAdded;
	public int Quantity => collectables.Count;

	public CollectableBag(int quantityForReward, Action onGiveReward, Action<float> onCollectableAdded = null)
	{
		this.quantityForReward = quantityForReward;
		this.giveReward = onGiveReward;
		this.onCollectableAdded = onCollectableAdded;
		collectables = new List<CollectableRotator>();
	}

	public void ValidateNewReward()
	{
		if (!(collectables.Count >= quantityForReward))
			return;
		for (int i = 0; i < quantityForReward; i++)
		{
			collectables[i].OnRewardGiven();
		}
		collectables.RemoveRange(0, quantityForReward);
		giveReward();
	}

	public void AddCollectable(CollectableRotator collectable)
	{
		collectables.Add(collectable);
		onCollectableAdded?.Invoke(collectables.Count);
	}
}
