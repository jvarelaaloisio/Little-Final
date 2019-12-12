using UnityEngine;
using System;


public class Flight:MonoBehaviour{
    public float _maxSpeed = 1000.0f;
    public float _minSpeed = 100.0f;
    public float _rotationSpeed = 200.0f;
    public float _acceleration = 1000.0f;
    public float _speed;
    bool _playerControl = true;
    public Quaternion AddRot = Quaternion.identity;
    public void Start(){
    	
    	//_speed = _maxSpeed *.5;
    	
    }
    
    public void FixedUpdate()
        {
    		
            
            int roll = 0;
            int pitch = 0;
            int yaw = 0;
            roll = (int)(Input.GetAxis("Horizontal") * (Time.deltaTime * _rotationSpeed));
            pitch = (int)(Input.GetAxis("Vertical") * -(Time.deltaTime * _rotationSpeed));
            yaw = (int)(Input.GetAxis("Horizontal2") * (Time.deltaTime * _rotationSpeed));
            _speed = Input.GetAxis("Vertical2") * -(Time.deltaTime * _acceleration);
    		_speed = Mathf.Clamp(_speed, _minSpeed, _maxSpeed);
            
    //        if(_speed < _minSpeed){
    //        	_speed = _minSpeed;
    //        }else if(_speed > _maxSpeed){
    //        	_speed = _maxSpeed;
    //        }
            if(_playerControl){
            AddRot.eulerAngles = new Vector3((float)(-pitch), (float)yaw, (float)(-roll));
            GetComponent<Rigidbody>().rotation *= AddRot;
            Vector3 AddPos = Vector3.forward;
            AddPos = GetComponent<Rigidbody>().rotation * AddPos;
            GetComponent<Rigidbody>().velocity = AddPos * (Time.deltaTime * _speed);
            }
            if(transform.position.y > 200){
            	_playerControl = false;
            	AddRot.eulerAngles = new Vector3((float)pitch, (float)(-yaw), (float)roll);
            GetComponent<Rigidbody>().rotation *= AddRot;
            }else if(transform.position.y < 185){
            	_playerControl = true;
            }
        }
}