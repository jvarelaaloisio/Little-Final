using System;
using System.Collections.Generic;
public class CollectableBag
{
	List<CollectableRotator> collectables;
	public int quantityForReward;
	private Action giveReward;
	public int Quantity => collectables.Count;

	public CollectableBag(int quantityForReward, Action giveReward)
	{
		this.quantityForReward = quantityForReward;
		this.giveReward = giveReward;
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
	}
}
