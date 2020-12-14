using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Ability : ScriptableObject
{
	[SerializeField]
	[Range(0, 500, step: 1)]
	protected int stamina;
	public abstract int Stamina { get; }
	public abstract bool ValidateTrigger(PlayerModel model);
	public abstract void Use(PlayerModel model);
}
