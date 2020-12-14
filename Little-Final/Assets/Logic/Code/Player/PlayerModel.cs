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
	public CollectableBag collectableBag;
	public PlayerView view;
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
	#endregion
	#region Properties
	public IBody Body => body;
	public bool JumpBuffer { get; set; }
	public bool LongJumpBuffer { get; set; }
	public Stamina Stamina => stamina;
	public DamageHandler DamageHandler => damageHandler;
	#endregion
	#endregion

	void Start()
	{
		collectableBag = new CollectableBag(PP_Stats.Instance.CollectablesForReward, UpgradeStamina);
		UpdateManager.Instance.Subscribe(this);
		body = GetComponent<IBody>();
		damageHandler.onLifeChanged += OnlifeChanged;
		stamina = new Stamina(PP_Stats.Instance.InitialStamina, PP_Stats.Instance.StaminaRefillDelay, PP_Stats.Instance.StaminaRefillSpeed, view.UpdateStamina);
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
		state.OnStateUpdate();
		if (Physics.Raycast(transform.position, Vector3.down, out RaycastHit hit, 100, LayerMask.GetMask("Default", "Floor", "NonClimbable")))
		{
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

	public void ResetJumpBuffers()
	{
		JumpBuffer = false;
		LongJumpBuffer = false;
	}
	#region EventHandlers
	private void UpgradeStamina()
	{
		stamina.UpgradeMaxStamina(stamina.MaxStamina + PP_Stats.Instance.StaminaUpgrade);
	}
	void OnlifeChanged(float lifePoints)
	{
		if (lifePoints < 0)
		{
			view.ShowDeathFeedback();
			ChangeState<PS_Idle>();
		}
	}
	#endregion
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
}
