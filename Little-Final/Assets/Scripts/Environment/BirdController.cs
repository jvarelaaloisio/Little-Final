using System;
using System.Collections;
using Core.Providers;
using UnityEngine;

namespace Environment
{
    public class BirdController : MonoBehaviour
    {
        [SerializeField] private int quantity = 10;
        [SerializeField] private lb_BirdController birdControl;
        [SerializeField] private DataProvider<Camera> cameraProvider;


        private void OnEnable()
        {
            StartCoroutine(Spawn());
        }

        private void OnDisable()
        {
            StopCoroutine(Spawn());
        }

        private IEnumerator Spawn()
        {
            Camera camera = null;
            yield return new WaitUntil(() => cameraProvider.TryGetValue(out camera));
            birdControl.enabled = true;
            birdControl.currentCamera = camera;
            while(!destroyCancellationToken.IsCancellationRequested)
            {
                yield return new WaitForSeconds(1);
                birdControl.SpawnAmount(quantity);
            }
        }
    }
}