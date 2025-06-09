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
    public struct Transition : ITransition
    {
        private readonly ILogger _logger;
        private readonly string _loggerTag;

        public Transition(IState from,
                          IState to,
                          ILogger logger = null,
                          string loggerTag = "")
        {
            From = from;
            OnTransition = new List<Func<(IState from, IState to), UniTask>>();
            To = to;
            _logger = logger;
            _loggerTag = loggerTag;
        }

        public IState From { get; }
        public IState To { get; }
        public List<Func<(IState from, IState to), UniTask>> OnTransition { get; }

        public async UniTask Do(IDictionary<Type, IDictionary<IIdentification, object>> data, CancellationToken token)
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