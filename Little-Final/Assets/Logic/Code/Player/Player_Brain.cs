using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(DamageHandler))]
[RequireComponent(typeof(Animator))]
public class Player_Brain : MonoBehaviour, IUpdateable
{
	#region Variables
	#region Private
	IPickable _itemPicked;
	UpdateManager updateManager;
	IBody body;
	Player_Animator animator;
	DamageHandler damageHandler;
	PlayerState_Ab state;
	#endregion
	#region Props
	public IBody Body { get => body; }
	#endregion
	#endregion

	void Start()
	{
		updateManager = GameObject.FindObjectOfType<UpdateManager>();
		updateManager?.AddItem(this);
		body = GetComponent<IBody>();
		animator = GetComponent<Player_Animator>();
		body.BodyEvents += BodyEventHandler;
		//damageHandler.LifeChangedEvent += LifeChangedHandler;
		//animator.AnimationEvents += AnimationEventHandler;
		state = new PS_Walk();
		state.OnStateEnter(this);
	}

	public void ChangeState<T>() where T : PlayerState_Ab, new()
	{
		//OnStateExit del estado anterior
		state.OnStateExit();
		//Creo nuevo estado y corro su OnStateEnter
		state = new T();
		//Debug.Log(typeof(T));
		state.OnStateEnter(this);
	}

	public void OnUpdate()
	{
		state.OnStateUpdate();
		if (Input.GetKeyDown(KeyCode.R))
			Debug.Log(state.ToString());
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

	#region EventHandlers
	void BodyEventHandler(BodyEvent eventType)
	{
		if (eventType.Equals(BodyEvent.LAND))
			ChangeState<PS_Walk>();
	}
	void LifeChangedHandler(float newLife)
	{

	}
	void AnimationEventHandler(AnimationEvent typeOfEvent)
	{

	}
	#endregion
}
