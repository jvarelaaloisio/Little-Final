using Characters;
using Cysharp.Threading.Tasks;

namespace User.States
{
    public class Idle : UserState
    {
        public override UniTask Awake()
        {
            Character.Movement = MovementData.InvalidRequest;
            return base.Awake();
        }
    }
}