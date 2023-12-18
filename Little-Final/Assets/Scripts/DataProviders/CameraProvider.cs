using Core.Providers;
using UnityEngine;

namespace DataProviders
{
    [CreateAssetMenu(menuName = "Data/Providers/Camera", fileName = "CameraProvider", order = 0)]
    public class CameraProvider : DataProvider<Camera>
    {
        public override Camera Value { get; set; }
    }
}