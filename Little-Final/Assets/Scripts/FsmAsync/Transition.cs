using System;
using System.Collections.Generic;
using System.Threading;
using Core.FSM;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace FsmAsync
{
    [Serializable]
    public struct Transition<TTarget, TId> : ITransition<TTarget, TId>
    {
        private readonly ILogger _logger;
        private readonly string _loggerTag;

        public Transition(IState<TTarget> from,
                          IState<TTarget> to,
                          TId id,
                          ILogger logger = null,
                          string loggerTag = "")
        {
            From = from;
            OnTransition = new List<Func<(IState<TTarget> from, IState<TTarget> to), UniTask>>();
            To = to;
            Id = id;
            _logger = logger;
            _loggerTag = loggerTag;
        }

        public TId Id { get; }
        public IState<TTarget> From { get; }
        public IState<TTarget> To { get; }
        public List<Func<(IState<TTarget> from, IState<TTarget> to), UniTask>> OnTransition { get; }

        public async UniTask Do(TTarget data, bool shouldLogTransition, CancellationToken token)
        {
            if (From is null)
                _logger?.LogError(_loggerTag, $"{nameof(From)} is null");
            else
                await From.Exit(data, token);

            foreach (var task in OnTransition)
                await task((From, To));

            if (To is null)
                _logger?.LogError(_loggerTag, $"{nameof(To)} is null");
            else
            {
                await To.Enter(data, token);
                if (shouldLogTransition)
                    _logger?.Log(_loggerTag, $"transitioned: {Colored(From?.Name, "yellow")} -> {Colored(To.Name, "green")}");
            }
        }

        public UniTask Do(TTarget data, CancellationToken token)
            => Do(data, _logger != null, token);

        private static string Colored(object message, string color) => $"<color={color}>{message}</color>";
    }
}