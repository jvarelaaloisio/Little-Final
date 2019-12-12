using UnityEngine.UI;

public class Player_Rewards : EnumeratorManager
{
	#region Public
	public float[] specialCooldowns;
	public Text coinsText,
		moonsText,
		specialsText;
	public int SpecialsEarned
	{
		get
		{
			return specialCount;
		}
	}
	#endregion

	#region Getters
	public int Moons
	{
		get
		{
			return _moons;
		}
	}
	#endregion

	#region Private
	int _coins;
	int _moons;

	int specialCount;
	#endregion

	#region Public
	public void GetReward(int kindOfReward)
	{
		switch (kindOfReward)
		{
			default:
			{
				print("The kind " + kindOfReward + "has not been defined, it will be passed as a coin");
				_coins += 1;
				break;
			}
			case (int)Reward.coin:
			{
				_coins += 1;
				break;
			}
			case (int)Reward.moon:
			{
				_moons += 1;
				break;
			}
			case (int)Reward.win:
			{
				specialCount += 1;
				break;
			}
        }
        if (coinsText != null)
        {
            coinsText.text = (_coins * 100).ToString();
        }
        if (moonsText != null)
        {
            moonsText.text = _moons.ToString();
        }
        if (specialsText != null)
        {
            specialsText.text = specialCount.ToString();
        }
    }
	#endregion
}