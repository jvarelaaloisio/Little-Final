using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClimbCollider : MonoBehaviour
{
    #region Variables

    #region Constant
    const int CLIMB_LAYER = 12, PICKABLE_LAYER = 16;
    #endregion

    #region Public
    public IPickable PickableItem
    {
        get
        {
            return _pickableItem;
        }
    }
    #endregion

    #region Private
    Player_Body _body;

    IPickable _pickableItem;
    #endregion

    #endregion

    #region Unity
    void Start()
    {
        _body = GetComponentInParent<Player_Body>();
    }
    #endregion

    #region Collisions
    private void OnTriggerEnter(Collider other)
    {
        switch (other.gameObject.layer)
        {
            case CLIMB_LAYER:
                {
                    _body.lastClimbable = other.transform;
                    _body.CollidingWithClimbable = true;
                    break;
                }
            case PICKABLE_LAYER:
                {
                    _pickableItem = other.GetComponent<IPickable>();
                    break;
                }
        }
    }
    private void OnTriggerExit(Collider other)
    {
        switch (other.gameObject.layer)
        {
            case CLIMB_LAYER:
                {
                    _body.CollidingWithClimbable = false;
                    break;
                }
            case PICKABLE_LAYER:
                {
                    _pickableItem = null;
                    break;
                }
        }
    }
    #endregion
}