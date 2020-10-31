using CharacterMovement;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(DamageHandler))]
[RequireComponent(typeof(Animator))]
public class Player_Brain : MonoBehaviour, IUpdateable_DEPRECATED
{
	#region Variables
	#region Private
	IPickable _itemPicked;
	UpdateManager_DEPRECATED updateManager;
	IBody body;
	Player_Animator animator;
	DamageHandler damageHandler;
	PlayerState state;
	#endregion
	#region Properties
	public IBody Body => body;
	public bool JumpBuffer { get; set; }
	public bool LongJumpBuffer { get; set; }
	#endregion
	#endregion

	void Start()
	{
		updateManager = GameObject.FindObjectOfType<UpdateManager_DEPRECATED>();
		updateManager?.AddItem(this);
		body = GetComponent<IBody>();
		animator = GetComponent<Player_Animator>();
		//damageHandler.LifeChangedEvent += LifeChangedHandler;
		//animator.AnimationEvents += AnimationEventHandler;
		state = new PS_Walk();
		state.OnStateEnter(this);
	}

	public void ChangeState<T>() where T : PlayerState, new()
	{
		state.OnStateExit();
		state = new T();
		//Debug.Log(typeof(T));
		state.OnStateEnter(this);
	}

	public void OnUpdate()
	{
		state.OnStateUpdate();
		if (Input.GetKeyDown(KeyCode.R))
			Debug.Log(state.ToString());
		if (Input.GetKeyDown(KeyCode.F))
		{
			Debug.DrawRay(transform.position, transform.forward, Color.blue, 1);
			Debug.DrawRay(transform.position, transform.up, Color.green, 1);
			Debug.DrawRay(transform.position, transform.right, Color.red, 1);
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
