using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Characters;
using Core.References;
using Cysharp.Threading.Tasks;
using FsmAsync;
using UnityEngine;

namespace User.States
{
    //TODO: Make ISetup<>
    //THOUGHT: This doesn't need to be a SO when the FSM editor is done.
    [Serializable]
    public class CharacterState : ScriptableObject, ICharacterState
    {
        /// <inheritdoc />
        [field:SerializeField] public string Name { get; set; }
        [field:SerializeField] public InterfaceRef<ISideEffect>[] SideEffects { get; set; }

        public ICharacter Character { get; set; }

        /// <inheritdoc />
        public ILogger Logger { get; set; }

        /// <inheritdoc />
        public List<Func<(IState state, CancellationToken token), UniTask>> OnEnter { get; } = new();

        /// <inheritdoc />
        public List<Func<(IState state, CancellationToken token), UniTask>> OnExit { get; } = new();

        private void Reset()
        {
            Name = name;
        }

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

    public interface ISideEffect
    {
    }
}