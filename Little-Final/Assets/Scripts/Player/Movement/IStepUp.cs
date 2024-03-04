using System;
using System.Collections;
using UnityEngine;

namespace Player.Movement
{
    public interface IStepUp
    {
        bool Should(Vector3 direction, StepUpConfig configOverride = null);
        bool Can(out Vector3 stepPosition, Vector3 direction, StepUpConfig configOverride = null);
        void StepUp(StepUpConfig configOverride, Vector3 point, Action callback = null);
        IEnumerator StepUpCoroutine(StepUpConfig configOverride, Vector3 destination, Action callback = null);
    }
}