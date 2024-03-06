using UnityEngine;
using UnityEngine.Playables;

namespace Sequences
{
    [System.Serializable]
    public class DialoguePlayableAsset : PlayableAsset
    {
        // Factory method that generates a playable based on this asset
        public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
        {
            var behaviour = new DialogueBehaviour();
            return ScriptPlayable<DialogueBehaviour>.Create(graph, behaviour);
        }
    }
}
