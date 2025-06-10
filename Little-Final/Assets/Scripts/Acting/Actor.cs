using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Core.Acting;
using Core.Helpers;
using Cysharp.Threading.Tasks;
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

        protected IIdentifier.Comparer IDComparer;
        
        protected readonly Dictionary<IIdentifier, HashSet<Func <IActor, CancellationToken, UniTask>>> PreBehavioursByAction;
        protected readonly HashSet<Func<IActor, CancellationToken, UniTask>> PreBehaviourWildcards = new();
        
        protected readonly Dictionary<IIdentifier, HashSet<Func <IActor, CancellationToken, UniTask>>> PostBehavioursByAction;
        protected readonly HashSet<Func<IActor, CancellationToken, UniTask>> PostBehaviourWildcards = new();

        public Actor()
        {
            IDComparer = new IIdentifier.Comparer();
            PostBehavioursByAction = new Dictionary<IIdentifier, HashSet<Func<IActor, CancellationToken, UniTask>>>(IDComparer);
            PreBehavioursByAction = new Dictionary<IIdentifier, HashSet<Func<IActor, CancellationToken, UniTask>>>(IDComparer);
        }

        public bool TryAddPreBehaviour(Func <IActor, CancellationToken, UniTask> behaviour, IIdentifier actionId = default)
            => TryAddBehaviour(PreBehavioursByAction, actionId, behaviour);

        public bool TryAddPostBehaviour(Func <IActor, CancellationToken, UniTask> behaviour, IIdentifier actionId = default)
            => TryAddBehaviour(PostBehavioursByAction, actionId, behaviour);
        
        public void RemovePreBehaviour(Func <IActor, CancellationToken, UniTask> behaviour, IIdentifier actionId = default)
            => RemoveBehaviour(PreBehavioursByAction, actionId, behaviour);

        public void RemovePostBehaviour(Func <IActor, CancellationToken, UniTask> behaviour, IIdentifier actionId = default)
            => RemoveBehaviour(PostBehavioursByAction, actionId, behaviour);

        private static bool TryAddBehaviour(Dictionary<IIdentifier, HashSet<Func <IActor, CancellationToken, UniTask>>> behavioursByAction,
                                            IIdentifier actionId,
                                            Func <IActor, CancellationToken, UniTask> behaviour)
        {
            if (behavioursByAction.TryGetValue(actionId, out var behaviours))
                return behaviours.Add(behaviour);
            
            behaviours = new HashSet<Func <IActor, CancellationToken, UniTask>>();
            behavioursByAction.Add(actionId, behaviours);
            behaviours.Add(behaviour);
            return true;
        }
        
        private static void RemoveBehaviour(Dictionary<IIdentifier, HashSet<Func <IActor, CancellationToken, UniTask>>> behavioursByAction,
                                            IIdentifier actionId,
                                            Func <IActor, CancellationToken, UniTask> behaviour)
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
        public async UniTask Act(Func<IActor, CancellationToken, UniTask> behaviour,
                              CancellationToken token,
                              IIdentifier actionId = default)
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
                await RunBehaviours(this, PreBehaviourWildcards, token);
            
                if (actionId != default)
                    await RunBehavioursWithId(this, actionId, PreBehavioursByAction, token);

                await behaviour(this, token);

                await RunBehaviours(this, PostBehaviourWildcards, token);
            
                if (actionId != default)
                    await RunBehavioursWithId(this, actionId, PostBehavioursByAction, token);
            }
            finally
            {
                _semaphoreSlim.Release();
            }
        }

        /// <inheritdoc />
        public async UniTask Act<TActionData>(Func<IActor, TActionData, CancellationToken, UniTask> behaviour,
                                              TActionData actionData,
                                              CancellationToken token,
                                              IIdentifier actionId = default)
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
                await RunBehaviours(this, PreBehaviourWildcards, token);
            
                if (actionId != default)
                    await RunBehavioursWithId(this, actionId, PreBehavioursByAction, token);

                await behaviour(this, actionData, token);

                await RunBehaviours(this, PostBehaviourWildcards, token);
            
                if (actionId != default)
                    await RunBehavioursWithId(this, actionId, PostBehavioursByAction, token);
            }
            finally
            {
                _semaphoreSlim.Release();
            }
        }

        private static async UniTask RunBehavioursWithId(IActor actor,
                                                         IIdentifier actionId,
                                                         Dictionary<IIdentifier, HashSet<Func<IActor, CancellationToken, UniTask>>> behavioursByAction,
                                                         CancellationToken cancellationToken)
        {
            if (behavioursByAction.TryGetValue(actionId, out var behaviours))
                await RunBehaviours(actor, behaviours, cancellationToken);
        }

        private static async UniTask RunBehaviours(IActor actor,
                                                   HashSet<Func<IActor, CancellationToken, UniTask>> behaviours,
                                                   CancellationToken cancellationToken)
        {
            foreach (var preAction in behaviours)
                await preAction(actor, cancellationToken);
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