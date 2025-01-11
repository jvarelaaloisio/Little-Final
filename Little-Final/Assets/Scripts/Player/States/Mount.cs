using Core.Gameplay;
using Core.Interactions;
using Player.Properties;
using UnityEngine;

namespace Player.States
{
    public class Mount : State
    {
        private Vector3 _origin;
        private Transform _mount;
        private IRideable _rideable;
        private float _startTime;

        public override void OnStateEnter(PlayerController controller, IInputReader inputReader, int sceneIndex)
        {
            base.OnStateEnter(controller, inputReader, sceneIndex);
            _rideable = Controller.Rideable;
            if (_rideable == null)
            {
                Debug.Log("no rideable found");
                controller.ChangeState<Walk_OLD>();
                return;
            }
            _mount = _rideable.GetMount();
            _origin = MyTransform.position;
            _startTime = Time.time;
            Controller.GetComponent<Rigidbody>().isKinematic = true;
            Controller.OnMount.Invoke();
        }

        public override void OnStateUpdate()
        {
            var lerp = (Time.time - _startTime) / PP_Ride.MountTransitionDuration;
            var transitionEnded = lerp > 1;
            if (transitionEnded)
            {
                Controller.ChangeState<Ride>();
                MyTransform.SetParent(_mount);
                MyTransform.SetPositionAndRotation(_mount.position, _mount.rotation);
                Controller.Rideable.Interact(Controller);
                return;
            }

            MyTransform.position = Vector3.Lerp(_origin, _mount.position, lerp);
        }

        public override void OnStateExit()
        {
            Controller.GetComponent<Rigidbody>().isKinematic = false;
        }
    }
}