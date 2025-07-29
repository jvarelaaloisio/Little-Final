using System;
using System.Collections.Generic;
using System.Threading;
using Core.Acting;
using Core.Data;
using Core.Extensions;
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
            get => name;
            set => _state.Value.Name = value;
        }

        [field:SerializeField] public InterfaceRef<IActorStateBehaviour<ReverseIndexStore>>[] Behaviours { get; set; }

        [SerializeField] private bool enableLog;

        private AutoMap<IState<IActor<ReverseIndexStore>>> _state = new(() => new State<IActor<ReverseIndexStore>>());

        /// <inheritdoc />
        public List<Func<IState<IActor<ReverseIndexStore>>, IActor<ReverseIndexStore>, CancellationToken, UniTask>> OnEnter
            => _state.Value.OnEnter;

        /// <inheritdoc />
        public List<Func<IState<IActor<ReverseIndexStore>>, IActor<ReverseIndexStore>, CancellationToken, UniTask<bool>>> OnTryHandleInput
            => _state.Value.OnTryHandleInput;

        /// <inheritdoc />
        public List<Func<IState<IActor<ReverseIndexStore>>, IActor<ReverseIndexStore>, CancellationToken, UniTask>> OnExit
            => _state.Value.OnExit;

        /// <inheritdoc />
        public virtual async UniTask Enter(IActor<ReverseIndexStore> target, CancellationToken token)
        {
            if (string.IsNullOrEmpty(_state.Value.Name))
                Name = name;
            if (!target.Data.TryGetFirst(out IActor<ReverseIndexStore> actor))
                return;
            await _state.Value.Enter(target, token);
            foreach (var behaviour in Behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                if (enableLog)
                    this.Log($"Running {GetColoredName(behaviour)}.Enter");
                await behaviour.Ref.Enter(actor, token);
            }
        }

        /// <inheritdoc />
        public virtual async UniTask<bool> TryHandleDataChanged(IActor<ReverseIndexStore> target, CancellationToken token)
        {
            if (!target.Data.TryGetFirst(out IActor<ReverseIndexStore> actor))
                return false;
            await _state.Value.TryHandleDataChanged(target, token);
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
            await _state.Value.Exit(target, token);
            foreach (var behaviour in Behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                if (enableLog)
                    this.Log($"Running {GetColoredName(behaviour)}.Exit");
                await behaviour.Ref.Exit(actor, token);
            }
        }

        private static string GetColoredName(InterfaceRef<IActorStateBehaviour<ReverseIndexStore>> behaviour)
            => behaviour.Ref.GetType().Name.Colored("#22aa22");
    }
}