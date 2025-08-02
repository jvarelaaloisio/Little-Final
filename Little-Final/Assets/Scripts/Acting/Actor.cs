using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using Core.Acting;
using Core.Extensions;
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
        public object Data { get; set; }
    
        /// <summary>
        /// Type for the data that this actor uses.
        /// </summary>
        public abstract Type DataType { get; }

        public abstract bool TrySetData(object data);

        protected IIdentifier.Comparer IDComparer;
        
        protected readonly Dictionary<IIdentifier, HashSet<Func <IActor, CancellationToken, UniTask>>> PreBehavioursByAction;
        //TODO: There is no method to add or remove
        protected readonly HashSet<Func<IActor, CancellationToken, UniTask>> PreBehaviourWildcards = new();
        
        protected readonly Dictionary<IIdentifier, HashSet<Func <IActor, CancellationToken, UniTask>>> PostBehavioursByAction;
        //TODO: There is no method to add or remove
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
        public async UniTask Act(Func<IActor, CancellationToken, UniTask<bool>> behaviour,
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

                var success = await behaviour(this, token);

                if (success)
                {
                    await RunBehaviours(this, PostBehaviourWildcards, token);

                    if (actionId != default)
                        await RunBehavioursWithId(this, actionId, PostBehavioursByAction, token);
                }
            }
            finally
            {
                _semaphoreSlim.Release();
            }
        }

        /// <inheritdoc />
        public async UniTask Act<TActionData>(Func<TActionData, IIdentifier, CancellationToken, UniTask<bool>> behaviour,
                                              TActionData actionData,
                                              CancellationToken token,
                                              IIdentifier actionId = null)
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

                var success = await behaviour(actionData, actionId, token);

                if (success)
                {
                    await RunBehaviours(this, PostBehaviourWildcards, token);

                    if (actionId != default)
                        await RunBehavioursWithId(this, actionId, PostBehavioursByAction, token);
                }
            }
            finally
            {
                _semaphoreSlim.Release();
            }
        }

        ///<inheritdoc/>
        public async UniTask Act<TActionData>(Func<TActionData, CancellationToken, UniTask<bool>> behaviour,
                                              TActionData actionData,
                                              CancellationToken token,
                                              IIdentifier actionId = null)
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

                if (actionId != null)
                    await RunBehavioursWithId(this, actionId, PreBehavioursByAction, token);

                var success = await behaviour(actionData, token);

                if (success)
                {
                    await RunBehaviours(this, PostBehaviourWildcards, token);

                    if (actionId != null)
                        await RunBehavioursWithId(this, actionId, PostBehavioursByAction, token);
                }
            }
            finally
            {
                _semaphoreSlim.Release();
            }
        }

        public async UniTask Act<TActionData>(Func<TActionData, CancellationToken, UniTask> behaviour,
                                              TActionData actionData,
                                              CancellationToken token,
                                              IIdentifier actionId = null)
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

                if (actionId != null)
                    await RunBehavioursWithId(this, actionId, PreBehavioursByAction, token);

                await behaviour(actionData, token);

                await RunBehaviours(this, PostBehaviourWildcards, token);

                if (actionId != null)
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
        public new TData Data { get; set; }

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

        /// <inheritdoc />
        public override string ToString()
        {
            var openBracket = "{".Colored(Color.grey);
            var closeBracket = "}".Colored(Color.grey);
            var result = new StringBuilder();

            result.AppendLine(GetType().GetFormattedGenericName() + openBracket);
            result.AppendLine("\t" + nameof(PreBehavioursByAction) + openBracket);
            Append(PreBehavioursByAction);
            result.AppendLine("\t" + closeBracket);
            result.AppendLine("\t" + nameof(PostBehavioursByAction) + openBracket);
            Append(PostBehavioursByAction);
            result.AppendLine("\t" + closeBracket);
            result.AppendLine(closeBracket);

            return result.ToString();

            void Append(Dictionary<IIdentifier, HashSet<Func<IActor, CancellationToken, UniTask>>> dictionary)
            {
                foreach (var kvp in dictionary)
                {
                    result.AppendLine("\t\t" + kvp.Key.name + openBracket);
                    foreach (var func in kvp.Value)
                    {
                        result.AppendLine("\t\t\t" + func.Method.Name);
                    }
                    result.AppendLine("\t\t" + closeBracket);
                }
            }
        }
    }
}