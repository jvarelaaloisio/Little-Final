using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.SceneManagement;

public class HardCode2 : MonoBehaviour, IUpdateable
{
    Player_Rewards pRewards;
    UpdateManager _uManager;
    public GameObject Win;
    public int WinScene;
    bool earned;
    void Start()
    {
        pRewards = GameObject.FindObjectOfType<Player_Rewards>();
        if (!pRewards) return;
        try
        {
            _uManager = GameObject.FindObjectOfType<UpdateManager>();
            _uManager.AddItem(this);
        }
        catch (NullReferenceException)
        {
            print(this.name + "update manager not found");
        }
    }
    public void OnUpdate()
    {
        if (!earned)
        {
            if (pRewards.SpecialsEarned == 7)
            {
                earned = true;
                Win.SetActive(true);
            }
        }
        else if (pRewards.SpecialsEarned == 8)
        {
            SceneManager.LoadScene(WinScene);
        }
    }
}
