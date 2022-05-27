using UnityEngine;

namespace Core.Interactions
{
	public interface IUser
	{
		Transform Transform { get; }
		void LoseInteraction();
	}
}