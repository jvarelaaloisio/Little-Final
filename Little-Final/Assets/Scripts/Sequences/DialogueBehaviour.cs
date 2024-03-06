using UnityEngine.Playables;

// A behaviour that is attached to a playable
namespace Sequences
{
    public class DialogueBehaviour : PlayableBehaviour
    {
        private double _playingSpeed;

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
            var director = playable.GetGraph().GetResolver() as PlayableDirector;
            if (director != null)
            {
                _playingSpeed = director.playableGraph.GetRootPlayable(0).GetSpeed();
                director.playableGraph.GetRootPlayable(0).SetSpeed(0);
            }
        }

        // Called when the state of the playable is set to Paused
        public override void OnBehaviourPause(Playable playable, FrameData info)
        {
        
        }

        // Called each frame while the state is set to Play
        public override void PrepareFrame(Playable playable, FrameData info)
        {
        
        }
    }
}
