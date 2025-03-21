using UnityEngine;

public class Injected : MonoBehaviour
{
    [SerializeField] private InjectedField<Camera> camera;
    
    [System.Serializable]
    public class InjectedField<T>
    {
        [field:SerializeField] public string Id { get; set; }
        [field:SerializeField] public T Value { get; private set; }
    }
}