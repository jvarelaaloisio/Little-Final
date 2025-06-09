using System;
using System.Collections;
using System.Threading;
using Characters;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace User.States
{
    [CreateAssetMenu(menuName = "States/Character/Idle", fileName = "Idle", order = 0)]
    [Serializable]
    public class Idle : StateSo
    {
        public UniTask Enter(Hashtable data, CancellationToken token)
        {
            Character.Movement = MovementData.InvalidRequest;
            return UniTask.CompletedTask;
        }
    }
}