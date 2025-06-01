using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Characters;
using Cysharp.Threading.Tasks;
using FsmAsync;
using UnityEngine;

namespace User.States
{
    //TODO: Make ISetup<>
    [Serializable]
    public class CharacterState : ScriptableObject, ICharacterState
    {
        public ICharacter Character { get; set; }
        public IFloorTracker FloorTracker { get; set; }

        /// <inheritdoc />
        public string Name { get; set; }

        /// <inheritdoc />
        public ILogger Logger { get; set; }

        /// <inheritdoc />
        public List<Func<(IState state, CancellationToken token), UniTask>> OnEnter { get; } = new();

        /// <inheritdoc />
        public List<Func<(IState state, CancellationToken token), UniTask>> OnExit { get; } = new();

        /// <inheritdoc />
        public virtual async UniTask Enter(Hashtable transitionData, CancellationToken token)
        {
            foreach (var task in OnEnter)
                await task((this, token));
        }

        /// <inheritdoc />
        public virtual async UniTask Exit(Hashtable transitionData, CancellationToken token)
        {
            foreach (var task in OnExit)
                await task((this, token));
        }
    }
}