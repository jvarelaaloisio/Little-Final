using System.Collections;
using Core.Extensions;
using UnityEngine;

namespace Extras
{
    public class MoveTo : MonoBehaviour
    {
        [SerializeField] private Vector3 destination;
        [SerializeField] private AnimationCurve curve;

        public void Go()
        {
            StartCoroutine(MoveCoroutine(destination));
        }

        private IEnumerator MoveCoroutine(Vector3 destination)
        {
            var origin = transform.position;
            var start = Time.time;
            float now = 0;
            do
            {
                now = Time.time;
                var lerp = (now - start);
                transform.position = Vector3.LerpUnclamped(origin, destination, curve.Evaluate(lerp));
                yield return null;
            } while (now < start + curve.Duration());
        }
    }
}
