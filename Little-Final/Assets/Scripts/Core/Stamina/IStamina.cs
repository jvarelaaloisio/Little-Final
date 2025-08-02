using System;

namespace Core.Stamina
{
	public interface IStamina
	{
		event Action OnRefilling;
		event Action OnRefilled;
		event Action<float> OnUpgrade;
		event ValueChangeEvent OnChange;
		float Current { get; }
		bool CanRefill { get; }
		float Max { get; }
		float RefillSpeed { get; }
		void Consume(float value);
		void StopRefilling();
		void ResumeRefilling();
		void RefillCompletely();
		void UpgradeMax(float value);
	}
}