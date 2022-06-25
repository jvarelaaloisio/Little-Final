using System;

namespace Core.Stamina
{
	public interface IStaminaContainer
	{
		Action<float> onStaminaChange { get; set; }
		Player.Stamina.Stamina Stamina { get; }
	}
}