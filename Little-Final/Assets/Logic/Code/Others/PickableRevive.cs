using Interactables;
using Platforms;
using UnityEngine;

[RequireComponent(typeof(PickableItem))]
[RequireComponent(typeof(Rigidbody))]
public class PickableRevive : MonoBehaviour, IDamageable
{
    [SerializeField]
    private int lifePoints;

    [Header("Setup")]
    [SerializeField]
    private PickableItem pickableItem;
    
    [SerializeField]
    private Rigidbody rigidbody;

    private TransformData _origin;

    public DamageHandler DamageHandler { get; private set; }

    private void OnValidate()
    {
        if (!pickableItem)
            pickableItem = GetComponent<PickableItem>();
        if (!rigidbody)
            rigidbody = GetComponent<Rigidbody>();
    }

    private void Awake()
    {
        _origin = new TransformData(transform);
        DamageHandler = new DamageHandler(lifePoints, 0, GoToOrigin, gameObject.scene.buildIndex);
    }

    private void GoToOrigin(float lifePoints)
    {
        if (lifePoints > 0)
            return;
        pickableItem.Leave();
        _origin.ApplyDataTo(transform);
        rigidbody.velocity = Vector3.zero;
    }
}
