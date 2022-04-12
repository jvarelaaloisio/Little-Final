using UnityEngine;

namespace Core.Interactions
{
	public interface IPickable : IInteractable
	{
		/// <summary>
		/// Throw the object
		/// </summary>
		/// <param name="force">amount of force</param>
		/// <param name="direction">direction wich the object is thrown</param>
		void Throw(float force, Vector3 direction);
	}
}