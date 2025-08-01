using System;

namespace Player.Stamina
{
	public interface IStamina
	{
		event Action OnRefilling;
		event Action OnRefilled;
		event Action<float> OnUpgrade;
		float Current { get; }
		bool IsRefilling { get; }
		float Max { get; }
		float RefillSpeed { get; }
		void Consume(float value);
		void StopRefilling();
		void ResumeRefilling();
		void RefillCompletely();
		void UpgradeMax(float value);
		event Action<float> OnChange;
	}
}