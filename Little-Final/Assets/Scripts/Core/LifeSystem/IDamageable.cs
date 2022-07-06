using System;

namespace Core.LifeSystem
{
	public interface IDamageable
	{
		int MaxLifePoints { get; }
		bool AllowOverFlow { get; }
		int LifePoints { get; }
		void TakeDamage(int damagePoints);
		event Action OnDeath;
	}
}