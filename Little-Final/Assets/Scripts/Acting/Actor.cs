using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using UnityEngine;

namespace Acting
{
    public abstract class Actor
    {
        /// <summary>
        /// Value used as common action id to store tasks in <see cref="PreBehavioursByAction"/> and <see cref="PostBehavioursByAction"/>.
        /// Any behaviour stored in Wildcard will be run once anytime an action is done.
        /// </summary>
        public const string Wildcard = "";
        
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
        
        protected readonly Dictionary<string, HashSet<Func<Actor, CancellationToken, Task>>> PreBehavioursByAction = new();
        
        protected readonly Dictionary<string, HashSet<Func<Actor, CancellationToken, Task>>> PostBehavioursByAction = new();

        public bool TryAddPreBehaviour(Func<Actor, CancellationToken, Task> behaviour, string actionId = Wildcard)
            => TryAddBehaviour(PreBehavioursByAction, actionId, behaviour);

        public bool TryAddPostBehaviour(Func<Actor, CancellationToken, Task> behaviour, string actionId = Wildcard)
            => TryAddBehaviour(PostBehavioursByAction, actionId, behaviour);
        
        public void RemovePreBehaviour(Func<Actor, CancellationToken, Task> behaviour, string actionId = Wildcard)
            => RemoveBehaviour(PreBehavioursByAction, actionId, behaviour);

        public void RemovePostBehaviour(Func<Actor, CancellationToken, Task> behaviour, string actionId = Wildcard)
            => RemoveBehaviour(PostBehavioursByAction, actionId, behaviour);

        private static bool TryAddBehaviour(Dictionary<string, HashSet<Func<Actor, CancellationToken, Task>>> behavioursByAction, string actionId, Func<Actor, CancellationToken, Task> behaviour)
        {
            if (behavioursByAction.TryGetValue(actionId, out var behaviours))
                return behaviours.Add(behaviour);
            
            behaviours = new HashSet<Func<Actor, CancellationToken, Task>>();
            behavioursByAction.Add(actionId, behaviours);
            behaviours.Add(behaviour);
            return true;
        }
        
        private static void RemoveBehaviour(Dictionary<string, HashSet<Func<Actor, CancellationToken, Task>>> behavioursByAction, string actionId, Func<Actor, CancellationToken, Task> behaviour)
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
        public async Task Act(Func<Actor, CancellationToken, Task> behaviour,
                              CancellationToken token,
                              string actionId = Wildcard)
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
            
                if (actionId != Wildcard)
                    await RunBehavioursWithId(this, actionId, PreBehavioursByAction, token);

                await behaviour(this, token);

                await RunWildcards(this, PostBehavioursByAction, token);
            
                if (actionId != Wildcard)
                    await RunBehavioursWithId(this, actionId, PostBehavioursByAction, token);
            }
            finally
            {
                _semaphoreSlim.Release();
            }
            
            return;
            
            static async Task RunWildcards(Actor actor,
                                           Dictionary<string, HashSet<Func<Actor, CancellationToken, Task>>> behavioursByAction,
                                           CancellationToken cancellationToken)
            {
                if (behavioursByAction.TryGetValue(Wildcard, out var commonPreActions))
                {
                    foreach (var preAction in commonPreActions)
                        await preAction(actor, cancellationToken);
                }
            }
            
            static async Task RunBehavioursWithId(Actor actor,
                                           string actionId,
                                           Dictionary<string, HashSet<Func<Actor, CancellationToken, Task>>> behavioursByAction,
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
    
    public class Actor<TData> : Actor
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