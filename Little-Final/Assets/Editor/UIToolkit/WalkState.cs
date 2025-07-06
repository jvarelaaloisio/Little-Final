using System;
using System.Collections;
using System.Collections.Generic;
using FSM;
using UnityEngine;
using UnityEngine.UIElements;

[Serializable]
public class WalkState<T> : State<T>
{
    [SerializeInNode(typeof(TextField))] [SerializeField] private string name = "Walk state name";
    [SerializeInNode(typeof(FloatField))] [SerializeField] private float speed = 15f;
    
    public WalkState(string name) : base(name) { }
}
[Serializable]
public class JumpState<T> : State<T>
{
    [SerializeInNode(typeof(TextField))] [SerializeField] private string name = "jump state name";
    [SerializeInNode(typeof(Vector3Field))] [SerializeField] private Vector3 force = new(0, 1, 0);
    [SerializeInNode(typeof(Slider))] [SerializeField] private float speed = 15f;
    [SerializeInNode(typeof(FloatField))] [SerializeField] private float fallMultiplier = 15f;
    
    public JumpState(string name) : base(name) { }
}

public class SerializeInNodeAttribute : Attribute
{
    public SerializeInNodeAttribute(Type fieldType)
    {
        FieldType = fieldType;
    }

    public Type FieldType { get; }
}
