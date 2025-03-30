using System;
using Characters;
using Core.Gameplay;
using FsmAsync;
using UnityEngine;

namespace User.States
{
    [Serializable]
    public class UserState : State
    {
        public ICharacter Character { get; set; }
        public IInputReader InputReader { get; set; }
        public ILogger Logger { get; set; }
    }
}