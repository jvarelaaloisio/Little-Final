using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using Characters;
using Core.Acting;
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
    public class StateSo : ScriptableObject, ICharacterState
    {
        /// <inheritdoc />
        [field:SerializeField] public string Name { get; set; }
        [field:SerializeField] public InterfaceRef<IActorStateBehaviour<IDictionary<Type, IDictionary<IIdentification, object>>>>[] behaviours { get; set; }

        public ICharacter Character { get; set; }

        /// <inheritdoc />
        public ILogger Logger { get; set; }

        /// <inheritdoc />
        public List<Func<IState, IDictionary<Type, IDictionary<IIdentification, object>>, CancellationToken, UniTask>> OnEnter { get; } = new();

        /// <inheritdoc />
        public List<Func<IState, IDictionary<Type, IDictionary<IIdentification, object>>, CancellationToken, UniTask<bool>>> OnTryHandleInput { get; }

        /// <inheritdoc />
        public List<Func<IState, IDictionary<Type, IDictionary<IIdentification, object>>, CancellationToken, UniTask>> OnExit { get; } = new();

        private void Reset()
        {
            Name = name;
        }

        /// <inheritdoc />
        public async UniTask Enter(IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token)
        {
            if (!data.TryGetFirst(out IActor actor))
                return;
            if (actor is not IActor<IDictionary<Type, IDictionary<IIdentification, object>>> typedActor)
                return;
            foreach (var behaviour in behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                await behaviour.Ref.Enter(typedActor, token);
            }
        }

        /// <inheritdoc />
        public async UniTask<bool> TryHandleInput(IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token)
        {
            if (!data.TryGetFirst(out IActor actor))
                return false;
            if (actor is not IActor<IDictionary<Type, IDictionary<IIdentification, object>>> typedActor)
                return false;
            foreach (var behaviour in behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                if (await behaviour.Ref.TryHandleInput(typedActor, token))
                    return true;
            }

            return false;
        }

        /// <inheritdoc />
        public async UniTask Exit(IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token)
        {
            if (!data.TryGetFirst(out IActor actor))
                return;
            if (actor is not IActor<IDictionary<Type, IDictionary<IIdentification, object>>> typedActor)
                return;
            foreach (var behaviour in behaviours)
            {
                if (!behaviour.HasValue)
                    continue;
                await behaviour.Ref.Exit(typedActor, token);
            }
        }
    }
}