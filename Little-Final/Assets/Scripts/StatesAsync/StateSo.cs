using System;
using System.Collections.Generic;
using System.Threading;
using Core.Acting;
using Core.Data;
using Core.Extensions;
using Core.FSM;
using Core.References;
using Cysharp.Threading.Tasks;
using FsmAsync;
using UnityEngine;
using UnityEngine.Events;

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

        [SerializeField] private UnityEvent onEnter = new();
        [SerializeField] private UnityEvent onExit = new();
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
            onEnter.Invoke();
            await _state.Value.Enter(target, token);
            foreach (var behaviour in Behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                if (enableLog)
                    this.Log($"Running {GetColoredName(behaviour)}.Enter");
                await behaviour.Ref.Enter(target, token);
            }
        }

        /// <inheritdoc />
        public virtual async UniTask<bool> Tick(IActor<ReverseIndexStore> target, CancellationToken token)
        {
            await _state.Value.Tick(target, token);
            foreach (var behaviour in Behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                if (await behaviour.Ref.TryConsumeTick(target, token))
                    return true;
            }

            return false;
        }

        /// <inheritdoc />
        public virtual async UniTask Exit(IActor<ReverseIndexStore> target, CancellationToken token)
        {
            onExit.Invoke();
            await _state.Value.Exit(target, token);
            foreach (var behaviour in Behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                if (enableLog)
                    this.Log($"Running {GetColoredName(behaviour)}.Exit");
                await behaviour.Ref.Exit(target, token);
            }
        }

        private static string GetColoredName(InterfaceRef<IActorStateBehaviour<ReverseIndexStore>> behaviour)
            => behaviour.Ref.GetType().Name.Colored("#22aa22");
    }
}