using System;
using UnityEngine;
using UnityEngine.InputSystem;
using Core.Providers;

namespace Input
{
    [AddComponentMenu("Data/Populate Player Input Provider")]
    [RequireComponent(typeof(PlayerInput))]
    public class PopulatePlayerInputProvider : PopulateComponentProvider<PlayerInput> { }
}
