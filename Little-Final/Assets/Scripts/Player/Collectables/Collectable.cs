using UnityEngine;

namespace Player.Collectables
{
    [SelectionBase]
    [RequireComponent(typeof(CollectableRotator))]
    [RequireComponent(typeof(Collider))]
    public class Collectable : MonoBehaviour
    {
        public ParticleSystem idleParticles;
        public float setupTime;
        public Vector3 scaleWhenPicked;
        private CollectableSetup _collectableSetup;
        public float distanceFromGround;
        public bool isRePositioningAtStart;
        private int _sceneIndex;

        private void Start()
        {
            _sceneIndex = gameObject.scene.buildIndex;
            if (!isRePositioningAtStart
                || !Physics.Raycast(
                    transform.position + Vector3.up / 3,
                    Vector3.down,
                    out RaycastHit hit,
                    10)
            )
                return;
            Debug.DrawLine(
                transform.position,
                hit.point,
                Color.red,
                1);
            transform.position = hit.point + Vector3.up * distanceFromGround;
        }

        private void OnTriggerEnter(Collider other)
        {
            idleParticles.Stop();
            CollectableBag bag = other.GetComponent<PlayerController>().collectableBag;
            bag.AddCollectable(GetComponent<CollectableRotator>());
            bag.ValidateNewReward();
            Transform pivot = other.GetComponent<PlayerController>().collectablePivot;
            GetComponent<Collider>().enabled = false;
            transform.SetParent(other.transform);
            Destroy(GetComponent<RotateAroundSelf>());
            _collectableSetup =
                new CollectableSetup(
                    GetComponent<CollectableRotator>(),
                    pivot,
                    scaleWhenPicked,
                    setupTime,
                    OnFinishedSetup,
                    _sceneIndex);
            _collectableSetup.StartSetup();
        }

        private void OnFinishedSetup()
        {
            Destroy(this);
        }

        [ContextMenu("Reposition")]
        private void Reposition()
        {
            if (Physics.Raycast(transform.position + Vector3.up / 3,
                                Vector3.down,
                                out RaycastHit hit,
                                10))
            {
                transform.position = hit.point + Vector3.up * distanceFromGround;
            }
        }

        private void OnDrawGizmos()
        {
            if (!isRePositioningAtStart
                || !Physics.Raycast(
                    transform.position + Vector3.up / 3,
                    Vector3.down,
                    out RaycastHit hit,
                    10
                )
            )
                return;
            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(hit.point + Vector3.up * distanceFromGround, .2f);
        }
    }
}