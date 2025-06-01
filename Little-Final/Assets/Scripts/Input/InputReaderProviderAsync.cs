using Core.Gameplay;
using Core.Providers;
using DataProviders.Async;
using UnityEngine;

namespace Input
{
	[CreateAssetMenu(menuName = "Data/Providers/Async/InputReader", fileName = "InputReaderProviderAsync", order = 0)]
	public class InputReaderProviderAsync : DataProviderAsync<IInputReader> { }
}