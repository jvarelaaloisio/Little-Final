using System.Collections;
using Core.Extensions;
using Core.Interactions;
using Core.Missions;
using Core.Providers;
using Missions.Implementations;
using UnityEngine;
using UnityEngine.Playables;

namespace Missions
{
    public class MissionPoint : Sequence
    {
        [field: SerializeField] public MissionContainer Mission { get; set; }
        [SerializeField] private DataProvider<MissionsManager> missionsManagerProvider;
        [SerializeField] private SimpleDialogueRunner dialogueRunner;
        [SerializeField] private PlayableAsset talkSequence;
        [SerializeField] private PlayableAsset finishMissionSequence;
        [SerializeField] private PlayableAsset repeatMissionTaskSequence;
        [SerializeField] private PlayableAsset thanksSequence;
        [SerializeField] private PlayableAsset exitSequence;
        [SerializeField] private Dialogue giveMissionDialogue;
        [SerializeField] private Dialogue repeatMissionTaskDialogue;
        [SerializeField] private Dialogue finishMissionDialogue;
        [SerializeField] private Dialogue thanksDialogue;
        [SerializeField] private float sequenceSetupDuration = 1f;

        protected override IEnumerator SequenceInternal(IInteractor interactor)
        {
            if (!missionsManagerProvider.TryGetValue(out var missionsManager)
                || !Mission)
            {
                this.LogWarning($"{nameof(missionsManager)} not found or {nameof(Mission)} is null!");
                yield break;
            }

            yield return new WaitForSeconds(sequenceSetupDuration);
            if (missionsManager.TryGetStatus(Mission.Get, out var status))
            {
                if (status.IsFinished)
                    yield return Thank(missionsManager);
                else if (status.IsComplete)
                    yield return FinishMission(missionsManager);
                else
                    yield return RepeatMissionTask(missionsManager);
            }
            else
                yield return GiveMission(missionsManager);
            
            dialogueRunner.Deactivate();
            cinematicDirector.Play(exitSequence);
            yield return new WaitForSeconds((float)exitSequence.duration);
        }

        //TODO: Convert all these methods into separate classes with a bool method ShouldPlay and a priority-sorted list to go through
        private IEnumerator GiveMission(MissionsManager missionsManager)
        {
            cinematicDirector.Play(talkSequence);
            if (giveMissionDialogue)
                dialogueRunner.Run(giveMissionDialogue);
            else
            {
                this.LogError($"{giveMissionDialogue} is null!");
                yield break;
            }
            yield return new WaitUntil(dialogueRunner.IsFinished);
            missionsManager.AddMission(Mission.Add());
        }

        private IEnumerator FinishMission(MissionsManager missionsManager)
        {
            cinematicDirector.Play(finishMissionSequence);
            if (giveMissionDialogue)
                dialogueRunner.Run(finishMissionDialogue);
            else
            {
                this.LogError($"{finishMissionDialogue} is null!");
                yield break;
            }
            yield return new WaitUntil(dialogueRunner.IsFinished);
            dialogueRunner.Deactivate();
            missionsManager.FinishMission(Mission.Get);
        }
        
        private IEnumerator RepeatMissionTask(MissionsManager missionsManager)
        {
            cinematicDirector.Play(repeatMissionTaskSequence);
            if (giveMissionDialogue)
                dialogueRunner.Run(repeatMissionTaskDialogue);
            else
            {
                this.LogError($"{repeatMissionTaskDialogue} is null!");
                yield break;
            }
            yield return new WaitUntil(dialogueRunner.IsFinished);
        }
        
        private IEnumerator Thank(MissionsManager missionsManager)
        {
            cinematicDirector.Play(thanksSequence);
            if (giveMissionDialogue)
                dialogueRunner.Run(thanksDialogue);
            else
            {
                this.LogError($"{thanksDialogue} is null!");
                yield break;
            }
            yield return new WaitUntil(dialogueRunner.IsFinished);
        }
    }
}