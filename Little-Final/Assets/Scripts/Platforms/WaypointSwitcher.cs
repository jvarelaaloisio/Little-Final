using UnityEngine;

namespace Platforms
{
    public class WaypointSwitcher : MonoBehaviour
    {
        [SerializeField]
        private TransformData[] waypoints;
        [SerializeField] private bool controlPosition;
        [SerializeField] private bool controlRotation;
        [SerializeField] private bool controlScale;
        
        private int _current;
        private int _next;
        
        
        private void Awake()
        {
            if (waypoints.Length < 2)
            {
                Debug.Log($"{gameObject.name}: not enough waypoints set");
                return;
            }

            _current = 0;
            _next = 1;
        }

        private void UpdatePosition(float interpolation)
        {
            
        }
    }
}