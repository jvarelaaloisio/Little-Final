using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class HardCode : GenericFunctions, IUpdateable
{
    [SerializeField]
    float moveTime;
    UpdateManager _uManager;
    Timer _moveTimer;
    Vector3 origin, obj;
    void Start()
    {
        try
        {
            _uManager = GameObject.FindObjectOfType<UpdateManager>();
            _uManager.AddItem(this);
        }
        catch (NullReferenceException)
        {
            print(this.name + "update manager not found");
        }
        _moveTimer = SetupTimer(moveTime, "");
    }
    public void OnUpdate()
    {
        if (!_moveTimer.Counting) return;
        float index = _moveTimer.CurrentTime / moveTime;
        if (index > 1) print(index);
        transform.position = Vector3.Lerp(origin, obj, index);
    }

    protected override void TimerFinishedHandler(string ID)
    {

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer != 16) return;
        origin = transform.position;
        obj = origin;
        obj.y += 25;
        _moveTimer.Play();
    }

}
