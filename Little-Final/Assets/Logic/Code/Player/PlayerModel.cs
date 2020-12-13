using System.Collections.Generic;
using UnityEngine;
using UpdateManagement;
[RequireComponent(typeof(DamageHandler))]
[RequireComponent(typeof(PlayerView))]
[SelectionBase]
public class PlayerModel : MonoBehaviour, IUpdateable
{
	#region Variables
	#region Public
	public PlayerView view;
	public List<Ability> AbilitiesOnLand,
					AbilitiesInAir,
					AbilitiesOnWall;
	#endregion
	#region Private
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
	#endregion
	#endregion

	void Start()
	{
		UpdateManager.Instance.Subscribe(this);
		body = GetComponent<IBody>();
		//damageHandler.LifeChangedEvent += LifeChangedHandler;
		stamina = new Stamina(PP_Stats.Instance.MaxStamina, PP_Stats.Instance.StaminaRefillDelay, PP_Stats.Instance.StaminaRefillSpeed, view.UpdateStamina);
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
		if (Input.GetKeyDown(KeyCode.R))
			stamina.ConsumeStamina(10);
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
	void BodyEventHandler(BodyEvent eventType)
	{
		if (eventType.Equals(BodyEvent.LAND))
			ChangeState<PS_Walk>();
	}
	void LifeChangedHandler(float newLife)
	{

	}
	#endregion
	private void OnGUI()
	{
		Rect rect = new Rect(10, 25, 100, 100);
		GUILayout.BeginArea(rect);
		GUI.skin.label.fontSize = 15;
		GUILayout.Label(state.GetType().ToString());
		if (stamina.IsRefillingActive)
			GUI.skin.label.normal.textColor = Color.green;
		else
			GUI.skin.label.normal.textColor = Color.red;
		
		GUILayout.Label("Stamina: " + stamina.FillState);
		GUILayout.EndArea();
	}
}
