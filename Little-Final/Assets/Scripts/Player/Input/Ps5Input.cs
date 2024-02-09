using System;
using UnityEngine;

public class Ps5Input : IPlayerInput
{
    private const string JumpBtn = "JumpPS5";

    public Vector2 GetHorInput()
    {
        return new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical")).normalized;
    }

    public bool GetClimbInput()
    {
        return Input.GetButton("Climb") || Input.GetAxis("ClimbPS5") == 1;
    }

    public bool GetJumpInput()
    {
        return Input.GetButtonDown(JumpBtn);
    }
    [Obsolete]
    public bool GetLongJumpInput()
    {
        return Input.GetButtonDown(JumpBtn) && Input.GetButton("Crouch");
    }

    public bool GetPickInput()
    {
        return Input.GetButtonDown("Pick");
    }

    public bool GetThrowInput()
    {
        return Input.GetButton("Throw");
    }

    public bool GetInteractInput()
    {
        return Input.GetButtonDown("Interact");
    }

    public bool GetCameraResetInput()
    {
        return Input.GetButtonDown("ResetCamera");
    }

    public bool GetGlideInput()
    {
        return Input.GetButton(JumpBtn);
    }

    public bool GetRunInput()
    {
        return Input.GetButton("Run") || Input.GetAxis("RunPS5") == 1;
    }

    public bool GetSwirlInput()
    {
        return Input.GetButtonDown("Swirl");
    }
}