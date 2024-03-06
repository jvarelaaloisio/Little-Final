using System.Collections;
using Core.Extensions;
using UnityEngine;
using UnityEngine.Playables;

// A behaviour that is attached to a playable
namespace Sequences
{
    public class MoveBehaviour : PlayableBehaviour
    {
        public Vector3 Origin { get; set; } = Vector3.negativeInfinity;
        public Vector3 Destination { get; set; } = Vector3.negativeInfinity;
        public Transform transform { get; set; }

        // Called when the owning graph starts playing
        public override void OnGraphStart(Playable playable)
        {
        
        }

        // Called when the owning graph stops playing
        public override void OnGraphStop(Playable playable)
        {
        
        }

        // Called when the state of the playable is set to Play
        public override void OnBehaviourPlay(Playable playable, FrameData info)
        {
        }

        // Called when the state of the playable is set to Paused
        public override void OnBehaviourPause(Playable playable, FrameData info)
        {
        
        }

        // Called each frame while the state is set to Play
        public override void PrepareFrame(Playable playable, FrameData info)
        {
            var lerp = (float)(playable.GetTime() / playable.GetDuration());
            transform.position = Vector3.LerpUnclamped(Origin, Destination, lerp);
        }
        private IEnumerator MoveCoroutine(Vector3 destination, float duration)
        {
            var origin = transform.position;
            var start = Time.time;
            float now = 0;
            do
            {
                now = Time.time;
                var lerp = (now - start) / duration;
                transform.position = Vector3.LerpUnclamped(origin, destination, lerp);
                yield return null;
            } while (now < start + duration);
        }
    }
}
