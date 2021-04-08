using System;
using System.Collections.Generic;
using Logic.Code.Player;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

[RequireComponent(typeof(DamageHandler))]
public class PlayerController : MonoBehaviour, IUpdateable, IDamageable
{
	#region Variables

	#region Public

	public PlayerView view;
	public Transform collectablePivot;
	public CollectableBag collectableBag;

	public List<Ability> AbilitiesOnLand,
		AbilitiesInAir,
		AbilitiesOnWall;

	public Action<float> OnPickCollectable = delegate { };
	public Action<float> OnStaminaChanges = delegate { };
	public Action<float> OnChangeSpeed = delegate { };
	public Action<string> OnSpecificAction = delegate { };
	public Action OnJump = delegate { };
	public Action OnLand = delegate { };
	public Action OnClimb = delegate { };
	public Action OnDeath = delegate { };
	public Action<bool> OnGlideChanges = delegate { };
	#endregion

	#region Private

	IPickable _itemPicked;
	IBody body;
	DamageHandler damageHandler;
	public Stamina stamina;
	PlayerState state;
	private Vector3 lastSafePosition;
	private Quaternion lastSafeRotation;
	private bool isDead;
	private int _sceneIndex;

	#endregion

	#region Properties

	public IBody Body => body;
	public bool JumpBuffer { get; set; }
	public bool LongJumpBuffer { get; set; }
	public Stamina Stamina => stamina;
	public PlayerState State => state;
	public DamageHandler DamageHandler => damageHandler;

	public int SceneIndex => _sceneIndex;

	#endregion

	#endregion

	private void Start()
	{
		collectableBag = new CollectableBag(
			PP_Stats.CollectablesForReward,
			UpgradeStamina,
			OnPickCollectable);
		UpdateManager.Subscribe(this);
		body = GetComponent<IBody>();
		damageHandler.onLifeChanged += OnLifeChanged;
		stamina = new Stamina(
			PP_Stats.InitialStamina,
			PP_Stats.StaminaRefillDelay,
			PP_Stats.StaminaRefillSpeed,
			SceneIndex,
			OnStaminaChanges);
		state = new PS_Walk();
		_sceneIndex = gameObject.scene.buildIndex;
		state.OnStateEnter(this, SceneIndex);
	}

	public void ChangeState<T>() where T : PlayerState, new()
	{
		state.OnStateExit();
		state = new T();
		state.OnStateEnter(this, SceneIndex);
	}

	public void RunAbilityList(in IEnumerable<Ability> abilities)
	{
		foreach (var ability in abilities)
		{
			if (!ability.ValidateTrigger(this))
				continue;
			ability.Use(this);
			stamina.ConsumeStamina(ability.Stamina);
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
		stamina.UpgradeMaxStamina(stamina.MaxStamina + PP_Stats.StaminaUpgrade);
		stamina.RefillCompletely();
	}

	private void OnLifeChanged(float lifePoints)
	{
		if (!isDead && lifePoints < 0)
		{
			isDead = true;
			OnDeath();
			ChangeState<PS_Void>();
			new CountDownTimer(PP_Stats.DeadTime, Revive, SceneIndex).StartTimer();
		}
	}

	#endregion

#if UNITY_EDITOR
	private void OnGUI()
	{
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
	}
#endif

	private void OnDrawGizmos()
	{
		Gizmos.color = Color.blue;
		Gizmos.DrawLine(transform.position, lastSafePosition);
	}
}