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


        private IEnumerator Start()
        {
            Camera camera = null;
            yield return new WaitUntil(() => cameraProvider.TryGetValue(out camera));
            birdControl.currentCamera = camera;
            yield return new WaitForEndOfFrame();
            birdControl.SpawnAmount(quantity);
        }
    }
}