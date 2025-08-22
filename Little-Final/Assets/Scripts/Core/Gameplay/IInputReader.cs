using System;
using UnityEngine;

namespace Core.Gameplay
{
    public interface IInputReader
    {
        event Action<Vector2> OnMoveInput;
        event Action<Vector2> OnCameraInput;
        event Action<bool> OnRunInput;
        event Action OnCenterCameraPressed;
        event Action OnJumpPressed;
        event Action OnJumpReleased;
        event Action OnGlidePressed;
        event Action OnGlideReleased;
        event Action OnClimbPressed;
        event Action OnClimbReleased;
        event Action OnInteractPressed;
        event Action OnInteractReleased;
        event Action OnAbilityPressed;
        event Action OnAbilityReleased;
        event Action OnPause;
    }
}
