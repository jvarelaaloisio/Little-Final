using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace FsmAsync
{
    [Serializable]
    public struct Transition
    {
        private readonly ILogger _logger;
        private readonly string _loggerTag;

        public Transition(State from,
                          State to,
                          ILogger logger = null,
                          string loggerTag = "")
        {
            From = from;
            OnTransition = new List<Func<(State from, State to), UniTask>>();
            To = to;
            _logger = logger;
            _loggerTag = loggerTag;
        }

        public State From { get; }
        public State To { get; }
        public List<Func<(State from, State to), UniTask>> OnTransition { get; }

        public async UniTask Do(CancellationToken token, Hashtable data = null)
        {
            data ??= new Hashtable();
            if (From is null)
                _logger?.LogError(_loggerTag, $"{nameof(From)} is null");
            else
                await From.Sleep(data, token);

            foreach (var task in OnTransition)
                await task((From, To));

            if (To is null)
                _logger?.LogError(_loggerTag, $"{nameof(To)} is null");
            else
            {
                await To.Awake(data, token);
                _logger?.Log(_loggerTag, $"transitioned: {Colored(From?.Name, "yellow")} -> {Colored(To.Name, "green")}");
            }
        }
        private static string Colored(object message, string color) => $"<color={color}>{message}</color>";
    }
}