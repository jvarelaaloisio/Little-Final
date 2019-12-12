using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Damage_Handler))]
public class Pickable_Revive : MonoBehaviour
{
    Damage_Handler _dhandler;
    Vector3 origin;
    void Start()
    {
        origin = transform.position;
        _dhandler = GetComponent<Damage_Handler>();
        _dhandler.LifeChangedEvent += GoToOrigin;
    }

    void GoToOrigin(float lifePoints)
    {
        if(lifePoints <= 0)
        {
            GetComponent<Pickable_Item>().Release();
            transform.position = origin;
            GetComponent<Rigidbody>().velocity = Vector3.zero;
        }
    }
}
