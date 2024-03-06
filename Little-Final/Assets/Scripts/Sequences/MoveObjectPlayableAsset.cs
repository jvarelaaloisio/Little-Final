using UnityEngine;
using UnityEngine.Playables;

namespace Sequences
{
    [System.Serializable]
    public class MoveObjectPlayableAsset : PlayableAsset
    {
        public ExposedReference<Transform> transform;
        [SerializeField] private Vector3 origin;
        [SerializeField] private Vector3 destination;
        // Factory method that generates a playable based on this asset
        public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
        {
            var behaviour = new MoveBehaviour
                            {
                                transform = transform.Resolve(graph.GetResolver()),
                                Origin = origin,
                                Destination = destination
                            };
            return ScriptPlayable<MoveBehaviour>.Create(graph, behaviour);
        }
    }
}
