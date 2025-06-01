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
    public class Idle : CharacterState
    {
        public override UniTask Enter(Hashtable data, CancellationToken token)
        {
            Character.Movement = MovementData.InvalidRequest;
            return base.Enter(data, token);
        }
    }
}