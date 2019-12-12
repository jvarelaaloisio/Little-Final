using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.SceneManagement;

[RequireComponent(typeof(Player_Body))]
[RequireComponent(typeof(Damage_Handler))]
public class Player_Brain : GenericFunctions, IUpdateable
{
    #region Variables

    #region Public
    public bool GodMode;
    #endregion

    #region Serialized
    Vector3 origin;
    [SerializeField]
    [Range(0, 5)]
    float cameraFollowTime = 0.5f;
    [SerializeField]
    float throwForce = 8;
    #endregion

    #region Private

    #region Other Objects
    GameManager _manager;
    UpdateManager _uManager;
    Player_Animator _animControl;
    Player_Body _body;
    Damage_Handler _damageHandler;
    IPickable _itemPicked;
    #endregion

    Timer _followCameraTimer;
    IPlayerInput input;
    Vector2 _movInput;

    #region Flags
    enum Flag
    {
        IS_GROUND,
        IS_JUMPING,
        IS_GLIDING,
        IS_CLIMBING,
        IS_CLIMBING_TO_TOP,
        IS_ON_TOP,
        IS_HIT,
        IS_DEAD
    }
    Dictionary<Flag, bool> _flags = new Dictionary<Flag, bool>();
    #endregion

    #region States
    [SerializeField]
    PlayerState _state;
    #endregion

    #endregion

    #endregion

    #region Unity
    void Start()
    {
        origin = transform.position;
        origin.y += 2;
        try
        {
            _uManager = GameObject.FindObjectOfType<UpdateManager>();
            _uManager.AddItem(this);
        }
        catch (NullReferenceException)
        {
            print(this.name + "update manager not found");
        }
        try
        {
            _manager = GameObject.FindObjectOfType<GameManager>();
        }
        catch (NullReferenceException)
        {
            print(this.name + "game manager not found");
        }
        InitializeVariables();
        SetupHandlers();
        SetupFlags();
    }
    public void OnUpdate()
    {
        _state = ControlStates(_state);
        _animControl.ChangeState(_state);
        switch (_state)
        {
            case PlayerState.WALKING:
                {
                    ReadWalkingStateInput();
                    ReadPickInput();
                    break;
                }
            case PlayerState.JUMPING:
                {
                    ReadJumpingStateInput();
                    ReadPickInput();
                    break;
                }
            case PlayerState.CLIMBING:
                {
                    ReadClimbingStateInput();
                    ReadClimbInput();
                    break;
                }
            case PlayerState.CLIMBING_TO_TOP:
                {

                    break;
                }
            case PlayerState.GOT_HIT:
                {
                    break;
                }
            case PlayerState.DEAD:
                {
                    //SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
                    transform.position = origin;
                    break;
                }
        }
    }
    #endregion

    #region Public
    public Vector3 GivePostion()
    {
        return _body.Position;
    }
    #endregion

    #region Private

    #region Setup
    /// <summary>
    /// Setups the flags
    /// </summary>
    void SetupFlags()
    {
        foreach (var flag in (Flag[])Enum.GetValues(typeof(Flag)))
        {
            _flags.Add(flag, false);
        }
    }

    /// <summary>
    /// Called in the start to prepeare this script
    /// </summary>
    void InitializeVariables()
    {
        _body = GetComponent<Player_Body>();
        _damageHandler = GetComponent<Damage_Handler>();
        try
        {
            _animControl = GetComponentInChildren<Player_Animator>();
        }
        catch (NullReferenceException)
        {
            print(this.name + "anim script not found");
        }
        input = gameObject.AddComponent<DesktopInput>();
        _followCameraTimer = SetupTimer(cameraFollowTime, "Follow Camera Timer");
    }
    /// <summary>
    /// Setups the event handlers for the body events
    /// </summary>
    void SetupHandlers()
    {
        _body.BodyEvents += BodyEventHandler;
        _damageHandler.LifeChangedEvent += LifeChangedHandler;
        _animControl.AnimationEvents += AnimationEventHandler;
    }
    #endregion

    #region Input

    /// <summary>
    /// Tells the body to change the velocity in the horizontal plane
    /// </summary>
    void ControlHorMovement()
    {
        _movInput = input.ReadHorInput();
        if (_movInput == Vector2.zero) return;
        _body.Walk(_movInput);
        UpdateForward();
    }

    /// <summary>
    /// reads input to tell the body if the player wants to climb
    /// </summary>
    void ReadClimbInput()
    {
        _body.InputClimb = input.ReadClimbInput();
    }

    void ReadPickInput()
    {
        if (input.ReadPickInput())
        {
            if (_itemPicked == null)
            {
                _itemPicked = GetComponentInChildren<ClimbCollider>().PickableItem;
                if (_itemPicked != null)
                {
                    _itemPicked.Pick(transform);
                }
            }
            else
            {
                _itemPicked.Release();
                _itemPicked = null;
            }
        }
        if (input.ReadThrowInput() && _itemPicked != null)
        {
            _itemPicked.Throw(throwForce, transform.forward);
            _itemPicked = null;
        }
    }

    /// <summary>
    /// Reads the input for the walking state
    /// </summary>
    void ReadWalkingStateInput()
    {
        ControlHorMovement();
        //REVISAR
        if (_movInput != Vector2.zero) FollowCameraRotation();

        //Jump
        if (input.ReadJumpInput()) _body.InputJump = true;
        ReadClimbInput();
    }

    /// <summary>
    /// Reads the input for the Jumping State
    /// </summary>
    void ReadJumpingStateInput()
    {
        ControlHorMovement();

        if (_movInput != Vector2.zero) FollowCameraRotation();
        bool jumpInput = input.ReadJumpInput();
        _body.InputGlide = jumpInput;
        if (!jumpInput && _body.Velocity.y > 0) _body.StopJump();

        ReadClimbInput();
    }

    void ReadClimbingStateInput()
    {
        _movInput = input.ReadHorInput();
        _body.Climb(_movInput);
    }

    #endregion

    #region EventHandlers
    /// <summary>
    /// Handles events from the body
    /// </summary>
    /// <param name="typeOfEvent"></param>
    void BodyEventHandler(BodyEvent typeOfEvent)
    {
        switch (typeOfEvent)
        {
            case BodyEvent.LAND:
                {
                    _flags[Flag.IS_GROUND] = true;
                    _flags[Flag.IS_JUMPING] = false;
                    break;
                }
            case BodyEvent.JUMP:
                {
                    _flags[Flag.IS_JUMPING] = true;
                    _flags[Flag.IS_GROUND] = false;
                    break;
                }
            case BodyEvent.CLIMB:
                {
                    _flags[Flag.IS_JUMPING] = false;
                    _flags[Flag.IS_CLIMBING] = true;
                    break;
                }
            case BodyEvent.TRIGGER:
                {
                    if (_state == PlayerState.CLIMBING)
                    {
                        _body.PushPlayer();
                        _flags[Flag.IS_CLIMBING_TO_TOP] = true;
                    }
                    break;
                }
        }
    }

    /// <summary>
    /// Handles events from the damage_handler
    /// </summary>
    /// <param name="newLife"></param>
    void LifeChangedHandler(float newLife)
    {
        if (newLife <= 0) Die();
        else
        {
            _flags[Flag.IS_HIT] = true;
        }
    }

    /// <summary>
    /// Handles events from the timers
    /// </summary>
    /// <param name="ID"></param>
    protected override void TimerFinishedHandler(string ID)
    {
    }

    /// <summary>
    /// Handles events from the animation script
    /// </summary>
    /// <param name="typeOfEvent"></param>
    void AnimationEventHandler(AnimationEvent typeOfEvent)
    {
        switch (typeOfEvent)
        {
            case AnimationEvent.HIT_FINISHED:
                {
                    _flags[Flag.IS_HIT] = false;
                    break;
                }
            case AnimationEvent.CLIMB_FINISHED:
                {
                    _flags[Flag.IS_ON_TOP] = true;
                    break;
                }
        }
    }
    #endregion

    /// <summary>
    /// Here goes everything to do when the player dies
    /// </summary>
    void Die()
    {
        if (GodMode || _flags[Flag.IS_DEAD]) return;
        _flags[Flag.IS_DEAD] = true;
        _manager.PlayerIsDead(false);
    }

    /// <summary>
    /// returns the new state for the player
    /// </summary>
    /// <param name="state"></param>
    /// <returns></returns>
    PlayerState ControlStates(PlayerState state)
    {
        if (_flags[Flag.IS_DEAD])
        {
            _flags[Flag.IS_DEAD] = false;
            return PlayerState.DEAD;
        }
        switch (state)
        {
            case PlayerState.WALKING:
                {
                    if (_flags[Flag.IS_HIT]) return PlayerState.GOT_HIT;
                    if (_flags[Flag.IS_JUMPING])
                    {
                        _flags[Flag.IS_JUMPING] = false;
                        return PlayerState.JUMPING;
                    }
                    if (_flags[Flag.IS_CLIMBING])
                    {
                        _flags[Flag.IS_CLIMBING] = false;
                        return PlayerState.CLIMBING;
                    }
                    break;
                }
            case PlayerState.JUMPING:
                {
                    if (_flags[Flag.IS_HIT]) return PlayerState.GOT_HIT;
                    if (_flags[Flag.IS_GROUND] || !_body.IsInTheAir)
                    {
                        _flags[Flag.IS_GROUND] = false;
                        return PlayerState.WALKING;
                    }
                    if (_flags[Flag.IS_CLIMBING])
                    {
                        _flags[Flag.IS_CLIMBING] = false;
                        return PlayerState.CLIMBING;
                    }
                    break;
                }
            case PlayerState.CLIMBING:
                {
                    if (_flags[Flag.IS_CLIMBING_TO_TOP])
                    {
                        _flags[Flag.IS_CLIMBING_TO_TOP] = false;
                        //return PlayerState.CLIMBING_TO_TOP;
                        return PlayerState.JUMPING;
                    }
                    if (_flags[Flag.IS_GROUND])
                    {
                        _flags[Flag.IS_GROUND] = false;
                        return PlayerState.WALKING;
                    }
                    if (_flags[Flag.IS_JUMPING])
                    {
                        _flags[Flag.IS_JUMPING] = false;
                        return PlayerState.JUMPING;
                    }
                    break;
                }
            case PlayerState.CLIMBING_TO_TOP:
                {
                    if (_flags[Flag.IS_GROUND])
                    {
                        _flags[Flag.IS_GROUND] = false;
                        return PlayerState.WALKING;
                    }
                    if (_flags[Flag.IS_ON_TOP])
                    {
                        _flags[Flag.IS_ON_TOP] = false;
                        return PlayerState.WALKING;
                    }
                    break;
                }
            case PlayerState.GOT_HIT:
                {
                    if (!_flags[Flag.IS_HIT]) return PlayerState.WALKING;
                    break;
                }
            case PlayerState.DEAD:
                {
                    return PlayerState.WALKING;
                }
        }
        return state;
    }

    /// <summary>
    /// Makes the body rotate to the camera direction
    /// </summary>
    void FollowCameraRotation()
    {
        if (_followCameraTimer.Counting) return;
        _followCameraTimer.Play();
        //_followCameraTimer.GottaCount = true;
    }

    void UpdateForward()
    {
        float pivot = SmoothFormula(_followCameraTimer.CurrentTime, cameraFollowTime);
        if (_followCameraTimer.Counting) transform.eulerAngles = new Vector3(0, Mathf.LerpAngle(transform.eulerAngles.y, _manager.GiveCamera().eulerAngles.y, pivot), 0);
    }
    #endregion

    #region Gizmos
    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(transform.position, transform.position + transform.forward);
    }

    #endregion

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == 17)
        {
            origin = transform.position + Vector3.up;
        }
    }
}