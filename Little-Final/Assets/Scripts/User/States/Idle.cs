using System;
using System.Collections;
using System.Threading;
using Characters;
using Cysharp.Threading.Tasks;

namespace User.States
{
    [Serializable]
    public class Idle : UserState
    {
        public override UniTask Awake(Hashtable data, CancellationToken token)
        {
            Character.Movement = MovementData.InvalidRequest;
            return base.Awake(data, token);
        }
    }
}