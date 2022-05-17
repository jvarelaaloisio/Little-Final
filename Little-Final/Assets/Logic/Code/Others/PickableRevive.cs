using Core;
using Events.UnityEvents;
using Interactables;
using UnityEngine;
using UnityEngine.Events;

namespace Logic.Code.Others
{
	[RequireComponent(typeof(PickableItem))]
	[RequireComponent(typeof(Rigidbody))]
	public class PickableRevive : MonoBehaviour, IDamageHandler
	{
		[SerializeField]
		private int lifePoints;

		[Header("Setup")]
		[SerializeField]
		private PickableItem pickableItem;

		[SerializeField]
		private Rigidbody rigidbody;

		[Header("Events")]
		[SerializeField]
		private IntUnityEvent onLifeChanged;

		[SerializeField]
		private UnityEvent onDeath;

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
			DamageHandler = new DamageHandler(lifePoints, 0, LifeChanged, gameObject.scene.buildIndex);
		}

		private void LifeChanged(float lifePoints)
		{
			onLifeChanged.Invoke((int) DamageHandler.lifePoints);
			Debug.Log(DamageHandler.lifePoints);
			if (DamageHandler.lifePoints > 0)
				return;
			onDeath.Invoke();
			_origin.ApplyDataTo(transform);
			rigidbody.velocity = Vector3.zero;
		}
	}
}