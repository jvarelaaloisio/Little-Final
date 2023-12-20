using System;
using System.Collections;
using UnityEngine;

namespace Player
{
    //TODO: come up with a better solution
    public class StartPlayer : MonoBehaviour
    {
        [SerializeField] private Rigidbody playerRigidBody;
        [SerializeField] private float delay = .25f;

        private void Reset()
        {
            playerRigidBody = GetComponent<Rigidbody>();
        }

        private IEnumerator Start()
        {
            yield return new WaitForSeconds(delay);
            if (playerRigidBody)
            {
                playerRigidBody.isKinematic = false;
            }
        }
    }
}
