using Core.Providers;
using UnityEngine;

namespace Characters
{
	[AddComponentMenu("Data/Populate Character Provider")]
	[RequireComponent(typeof(ICharacter))]
	public class PopulateCharacterProvider : PopulateComponentProvider<ICharacter> { }
}