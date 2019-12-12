using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UI_Debug : MonoBehaviour
{
	public GameObject player;
	public Text velocity;

	string _newText;
	
    void Update()
    {
		//_newText = "";
        _newText += player.GetComponent<Rigidbody>().velocity.y.ToString();
        //_newText += (player.GetComponent<Player_Body>().angle * 360).ToString();
        //velocity.text = _newText;
	}
}
