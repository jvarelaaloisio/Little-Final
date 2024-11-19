using Core.Providers;
using UnityEngine;
using UnityEngine.InputSystem;

namespace Input
{
    [CreateAssetMenu(menuName = "Data/Providers/PlayerInputProvider", fileName = "PlayerInputProvider", order = 0)]
    public class PlayerInputProvider : DataProvider<PlayerInput> { }
}