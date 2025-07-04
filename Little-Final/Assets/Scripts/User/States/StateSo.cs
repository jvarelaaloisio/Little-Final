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
    public class StateSo : ScriptableObject, IState<IActor<ReverseIndexStore>>
    {
        /// <inheritdoc />
        
        public string Name
        {
            get => _state.Name;
            set => _state.Name = value;
        }

        [field:SerializeField] public InterfaceRef<IActorStateBehaviour<ReverseIndexStore>>[] Behaviours { get; set; }

        private IState<IActor<ReverseIndexStore>> _state;

        private void Awake()
            => _state ??= new State<IActor<ReverseIndexStore>> { Name = name };

        /// <inheritdoc />
        public List<Func<IState<IActor<ReverseIndexStore>>, IActor<ReverseIndexStore>, CancellationToken, UniTask>> OnEnter
            => _state.OnEnter;

        /// <inheritdoc />
        public List<Func<IState<IActor<ReverseIndexStore>>, IActor<ReverseIndexStore>, CancellationToken, UniTask<bool>>> OnTryHandleInput
            => _state.OnTryHandleInput;

        /// <inheritdoc />
        public List<Func<IState<IActor<ReverseIndexStore>>, IActor<ReverseIndexStore>, CancellationToken, UniTask>> OnExit
            => _state.OnExit;

        /// <inheritdoc />
        public virtual async UniTask Enter(IActor<ReverseIndexStore> target, CancellationToken token)
        {
            if (!target.Data.TryGetFirst(out IActor<ReverseIndexStore> actor))
                return;
            await _state.Enter(target, token);
            foreach (var behaviour in Behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                await behaviour.Ref.Enter(actor, token);
            }
        }

        /// <inheritdoc />
        public virtual async UniTask<bool> TryHandleDataChanged(IActor<ReverseIndexStore> target, CancellationToken token)
        {
            if (!target.Data.TryGetFirst(out IActor<ReverseIndexStore> actor))
                return false;
            await _state.TryHandleDataChanged(target, token);
            foreach (var behaviour in Behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                if (await behaviour.Ref.TryHandleInput(actor, token))
                    return true;
            }

            return false;
        }

        /// <inheritdoc />
        public virtual async UniTask Exit(IActor<ReverseIndexStore> target, CancellationToken token)
        {
            if (!target.Data.TryGetFirst(out IActor<ReverseIndexStore> actor))
                return;
            await _state.Exit(target, token);
            foreach (var behaviour in Behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                await behaviour.Ref.Exit(actor, token);
            }
        }
    }
}