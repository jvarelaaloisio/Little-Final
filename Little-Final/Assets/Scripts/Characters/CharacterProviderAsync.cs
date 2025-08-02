using DataProviders.Async;
using UnityEngine;

namespace Characters
{
	[CreateAssetMenu(menuName = "Data/Providers/Async/Character", fileName = "CharacterProviderAsync", order = 0)]
	public class CharacterProviderAsync : DataProviderAsync<ICharacter> { }
}