using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Core.Helpers;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace FsmAsync
{
    [Serializable]
    public struct Transition<T> : ITransition<T>
    {
        private readonly ILogger _logger;
        private readonly string _loggerTag;

        public Transition(IState<T> from,
                          IState<T> to,
                          ILogger logger = null,
                          string loggerTag = "")
        {
            From = from;
            OnTransition = new List<Func<(IState<T> from, IState<T> to), UniTask>>();
            To = to;
            _logger = logger;
            _loggerTag = loggerTag;
        }

        public IState<T> From { get; }
        public IState<T> To { get; }
        public List<Func<(IState<T> from, IState<T> to), UniTask>> OnTransition { get; }

        public async UniTask Do(T data, CancellationToken token)
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
                _logger?.Log(_loggerTag, $"transitioned: {Colored(From?.Name, "yellow")} -> {Colored(To.Name, "green")}");
            }
        }
        private static string Colored(object message, string color) => $"<color={color}>{message}</color>";
    }
}