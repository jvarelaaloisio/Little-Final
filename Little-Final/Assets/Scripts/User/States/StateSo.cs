using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using Characters;
using Core.Acting;
using Core.Data;
using Core.Extensions;
using Core.Helpers;
using Core.References;
using Cysharp.Threading.Tasks;
using FsmAsync;
using UnityEngine;

namespace User.States
{
    //TODO: Make ISetup<>
    //THOUGHT: This doesn't need to be a SO when the FSM editor is done.
    [CreateAssetMenu(menuName = "States/Character/State", fileName = "StateSo", order = 0)]
    [Serializable]
    public class StateSo : ScriptableObject, ICharacterState<ReverseIndexStore>
    {
        /// <inheritdoc />
        [field:SerializeField] public string Name { get; set; }
        [field:SerializeField] public InterfaceRef<IActorStateBehaviour<ReverseIndexStore>>[] behaviours { get; set; }

        public ICharacter Character { get; set; }

        /// <inheritdoc />
        public ILogger Logger { get; set; }

        /// <inheritdoc />
        public List<Func<IState<ReverseIndexStore>, ReverseIndexStore, CancellationToken, UniTask>> OnEnter { get; } = new();

        /// <inheritdoc />
        public List<Func<IState<ReverseIndexStore>, ReverseIndexStore, CancellationToken, UniTask<bool>>> OnTryHandleInput { get; }

        /// <inheritdoc />
        public List<Func<IState<ReverseIndexStore>, ReverseIndexStore, CancellationToken, UniTask>> OnExit { get; } = new();

        private void Reset()
        {
            Name = name;
        }

        /// <inheritdoc />
        public async UniTask Enter(ReverseIndexStore data, CancellationToken token)
        {
            if (!data.TryGetFirst(out IActor<ReverseIndexStore> actor))
                return;
            foreach (var behaviour in behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                await behaviour.Ref.Enter(actor, token);
            }
        }

        /// <inheritdoc />
        public async UniTask<bool> TryHandleInput(ReverseIndexStore data, CancellationToken token)
        {
            if (!data.TryGetFirst(out IActor<ReverseIndexStore> actor))
                return false;
            foreach (var behaviour in behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                if (await behaviour.Ref.TryHandleInput(actor, token))
                    return true;
            }

            return false;
        }

        /// <inheritdoc />
        public async UniTask Exit(ReverseIndexStore data, CancellationToken token)
        {
            if (!data.TryGetFirst(out IActor<ReverseIndexStore> actor))
                return;
            foreach (var behaviour in behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                await behaviour.Ref.Exit(actor, token);
            }
        }
    }
}