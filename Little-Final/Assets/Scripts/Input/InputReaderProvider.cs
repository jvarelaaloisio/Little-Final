using Core.Gameplay;
using Core.Providers;
using UnityEngine;

namespace Input
{
    [CreateAssetMenu(menuName = "Data/Providers/InputReader", fileName = "InputReaderProvider", order = 0)]
    public class InputReaderProvider : DataProvider<IInputReader> { }
}