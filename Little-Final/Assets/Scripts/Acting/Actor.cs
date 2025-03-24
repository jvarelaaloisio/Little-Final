using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Core.Acting;
using UnityEngine;

namespace Acting
{
    public abstract class Actor : IActor, IHavePreBehaviours<IActor>, IHavePostBehaviours<IActor>
    {
        
        private readonly SemaphoreSlim _semaphoreSlim = new(1, 1);
        /// <summary>
        /// Data used by the actor.
        /// </summary>
        public object Data { get; protected set; }
    
        /// <summary>
        /// Type for the data that this actor uses.
        /// </summary>
        public abstract Type DataType { get; }

        public abstract bool TrySetData(object data);
        
        protected readonly Dictionary<string, HashSet<Func <IActor, CancellationToken, Task>>> PreBehavioursByAction = new();
        
        protected readonly Dictionary<string, HashSet<Func <IActor, CancellationToken, Task>>> PostBehavioursByAction = new();

        public bool TryAddPreBehaviour(Func <IActor, CancellationToken, Task> behaviour, string actionId = IActor.Wildcard)
            => TryAddBehaviour(PreBehavioursByAction, actionId, behaviour);

        public bool TryAddPostBehaviour(Func <IActor, CancellationToken, Task> behaviour, string actionId = IActor.Wildcard)
            => TryAddBehaviour(PostBehavioursByAction, actionId, behaviour);
        
        public void RemovePreBehaviour(Func <IActor, CancellationToken, Task> behaviour, string actionId = IActor.Wildcard)
            => RemoveBehaviour(PreBehavioursByAction, actionId, behaviour);

        public void RemovePostBehaviour(Func <IActor, CancellationToken, Task> behaviour, string actionId = IActor.Wildcard)
            => RemoveBehaviour(PostBehavioursByAction, actionId, behaviour);

        private static bool TryAddBehaviour(Dictionary<string, HashSet<Func <IActor, CancellationToken, Task>>> behavioursByAction, string actionId, Func <IActor, CancellationToken, Task> behaviour)
        {
            if (behavioursByAction.TryGetValue(actionId, out var behaviours))
                return behaviours.Add(behaviour);
            
            behaviours = new HashSet<Func <IActor, CancellationToken, Task>>();
            behavioursByAction.Add(actionId, behaviours);
            behaviours.Add(behaviour);
            return true;
        }
        
        private static void RemoveBehaviour(Dictionary<string, HashSet<Func <IActor, CancellationToken, Task>>> behavioursByAction, string actionId, Func <IActor, CancellationToken, Task> behaviour)
        {
            if (behavioursByAction.TryGetValue(actionId, out var behaviours))
                behaviours.Remove(behaviour);
        }

        /// <summary>
        /// Runs pre-behaviours -> Runs given behaviour -> Runs post-behaviours
        /// </summary>
        /// <param name="behaviour">The action task.</param>
        /// <param name="token"></param>
        /// <param name="actionId">Used to determine which pre- and post-behaviours should run. Default is <see cref="Wildcard"/>.</param>
        public async Task Act(Func<IActor, CancellationToken, Task> behaviour,
                              CancellationToken token,
                              string actionId = IActor.Wildcard)
        {
            try
            {
                await _semaphoreSlim.WaitAsync(-1, token);
            }
            catch (Exception e)
            {
                Debug.LogException(e);
                return;
            }

            try
            {
                await RunWildcards(this, PreBehavioursByAction, token);
            
                if (actionId != IActor.Wildcard)
                    await RunBehavioursWithId(this, actionId, PreBehavioursByAction, token);

                await behaviour(this, token);

                await RunWildcards(this, PostBehavioursByAction, token);
            
                if (actionId != IActor.Wildcard)
                    await RunBehavioursWithId(this, actionId, PostBehavioursByAction, token);
            }
            finally
            {
                _semaphoreSlim.Release();
            }
            
            return;
            
            static async Task RunWildcards(IActor actor,
                                           Dictionary<string, HashSet<Func <IActor, CancellationToken, Task>>> behavioursByAction,
                                           CancellationToken cancellationToken)
            {
                if (behavioursByAction.TryGetValue(IActor.Wildcard, out var commonPreActions))
                {
                    foreach (var preAction in commonPreActions)
                        await preAction(actor, cancellationToken);
                }
            }
            
            static async Task RunBehavioursWithId(IActor actor,
                                           string actionId,
                                           Dictionary<string, HashSet<Func <IActor, CancellationToken, Task>>> behavioursByAction,
                                           CancellationToken cancellationToken)
            {
                if (behavioursByAction.TryGetValue(actionId, out var behaviours))
                {
                    foreach (var preAction in behaviours)
                        await preAction(actor, cancellationToken);
                }
            }
        }
    }
    
    public class Actor<TData> : Actor, IActor<TData>
    {
        /// <summary>
        /// Data used by the actor.
        /// </summary>
        public new TData Data { get; protected set; }

        /// <inheritdoc />
        public override Type DataType => typeof(TData);

        /// <inheritdoc />
        public override bool TrySetData(object data)
        {
            if (data is not TData castedData)
                return false;
            SetData(castedData);
            return true;

        }

        public virtual void SetData(TData data) => Data = data;
    }
}