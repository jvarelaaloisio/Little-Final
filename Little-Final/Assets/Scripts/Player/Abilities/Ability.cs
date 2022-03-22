using UnityEngine;

namespace Player.Abilities
{
	public abstract class Ability : ScriptableObject
	{
		[SerializeField]
		[Range(0, 500)]
		protected int stamina;

		public virtual int Stamina => stamina;
		public abstract bool ValidateTrigger(PlayerController controller);
		public abstract void Use(PlayerController controller);
	}
}