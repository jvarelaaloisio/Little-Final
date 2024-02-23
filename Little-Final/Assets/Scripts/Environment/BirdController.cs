using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Serialization;

namespace Environment
{
    public class BirdController : MonoBehaviour
    {
        [SerializeField] private lb_BirdController birdControl;
        
        private void Start()
        {
            StartCoroutine(SpawnSomeBirds());
        }
        
        IEnumerator SpawnSomeBirds(){
            yield return new WaitForEndOfFrame();
            birdControl.SendMessage ("SpawnAmount",10);
        }
    }
}