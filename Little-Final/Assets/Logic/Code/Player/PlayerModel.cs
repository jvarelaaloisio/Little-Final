using System.Collections.Generic;
using UnityEngine;
using UpdateManagement;
[RequireComponent(typeof(DamageHandler))]
[RequireComponent(typeof(PlayerView))]
[SelectionBase]
public class PlayerModel : MonoBehaviour, IUpdateable, IDamageable
{
	#region Variables
	#region Public
	public Transform collectablePivot;
	public PlayerView view;
	public CollectableBag collectableBag;
	public List<Ability> AbilitiesOnLand,
					AbilitiesInAir,
					AbilitiesOnWall;
	#endregion
	#region Private
	public float shadowMinDot;
	IPickable _itemPicked;
	IBody body;
	DamageHandler damageHandler;
	public Stamina stamina;
	PlayerState state;
	private Vector3 lastSafePosition;
	private Quaternion lastSafeRotation;
	private bool isDead;
	#endregion
	#region Properties
	public IBody Body => body;
	public bool JumpBuffer { get; set; }
	public bool LongJumpBuffer { get; set; }
	public Stamina Stamina => stamina;
	public PlayerState State => state;
	public DamageHandler DamageHandler => damageHandler;
	#endregion
	#endregion

	void Start()
	{
		collectableBag = new CollectableBag(PP_Stats.Instance.CollectablesForReward, UpgradeStamina, view.UpdatePonchoEffect);
		UpdateManager.Subscribe(this);
		body = GetComponent<IBody>();
		damageHandler.onLifeChanged += OnlifeChanged;
		stamina = new Stamina(maxStamina: PP_Stats.Instance.InitialStamina, refillDelay: PP_Stats.Instance.StaminaRefillDelay, refillSpeed: PP_Stats.Instance.StaminaRefillSpeed, onStaminaChange: view.UpdateStamina);
		state = new PS_Walk();
		state.OnStateEnter(this);
	}

	public void ChangeState<T>() where T : PlayerState, new()
	{
		state.OnStateExit();
		state = new T();
		state.OnStateEnter(this);
	}

	public void RunAbilityList(List<Ability> abilities)
	{
		foreach (Ability ability in abilities)
		{
			if (ability.ValidateTrigger(this))
			{
				ability.Use(this);
				stamina.ConsumeStamina(ability.Stamina);
			}
		}
	}

	public void OnUpdate()
	{
		if (Input.GetButtonDown("RefillStamina"))
		{
			stamina.UpgradeMaxStamina(400);
			stamina.RefillCompletely();
		}
		state.OnStateUpdate();
		if (Physics.Raycast(transform.position, Vector3.down, out RaycastHit hit, 100, LayerMask.GetMask("Default", "Floor", "NonClimbable", "OnlyForShadows"),QueryTriggerInteraction.Collide))
		{
			Debug.DrawLine(transform.position, hit.point, Color.white);
			float _shadowSize = Mathf.Clamp(hit.distance, 0, 1);
			if (Mathf.Abs(Vector3.Dot(Vector3.down, hit.normal)) < shadowMinDot)
				_shadowSize = 0;
			view.ShowPlayerShadow(hit.point, Quaternion.FromToRotation(Vector3.up, hit.normal), _shadowSize);
		}
	}

	public void PickItem()
	{/*
		if (_itemPicked == null)
		{
			_itemPicked = GetComponentInChildren<Player_FrontCollider>().PickableItem;
			_itemPicked?.Pick(transform);
		}
		else
		{
			_itemPicked.Release();
			_itemPicked = null;
		}*/
	}

	public void SaveSafeState(Vector3 position, Quaternion rotation)
	{
		if (isDead)
			return;
		lastSafePosition = position;
		lastSafeRotation = rotation;
	}

	public void Revive()
	{
		isDead = false;
		stamina.RefillCompletely();
		ChangeState<PS_Walk>();
		damageHandler.ResetLifePoints();
		transform.position = lastSafePosition;
		transform.rotation = lastSafeRotation;
	}

	public void ResetJumpBuffers()
	{
		JumpBuffer = false;
		LongJumpBuffer = false;
	}
	#region EventHandlers
	private void UpgradeStamina()
	{
		stamina.UpgradeMaxStamina(stamina.MaxStamina + PP_Stats.Instance.StaminaUpgrade);
		stamina.RefillCompletely();
	}
	void OnlifeChanged(float lifePoints)
	{
		if (!isDead && lifePoints < 0)
		{
			isDead = true;
			view.ShowDeathFeedback();
			ChangeState<PS_Idle>();
			new CountDownTimer(PP_Stats.Instance.DeadTime, Revive).StartTimer();
		}
	}
	#endregion
	private void OnGUI()
	{
#if UNITY_EDITOR
		Rect rect = new Rect(10, 25, 100, 550);
		GUILayout.BeginArea(rect);
		GUI.skin.label.fontSize = 15;
		GUI.skin.label.normal.textColor = Color.white;
		GUILayout.Label("State: " + state.GetType().ToString());
		if (stamina.IsRefillingActive)
			GUI.skin.label.normal.textColor = Color.green;
		else
			GUI.skin.label.normal.textColor = Color.red;

		GUILayout.Label("Stamina: " + stamina.FillState);
		GUILayout.EndArea();
#endif
	}

	private void OnDrawGizmos()
	{
		Gizmos.color = Color.blue;
		Gizmos.DrawLine(transform.position, lastSafePosition);
	}
}
