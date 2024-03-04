using System.Collections.Generic;
using UnityEngine;

namespace UI
{
    [CreateAssetMenu(menuName = "Models/Dialogue", fileName = "Dialogue", order = 0)]
    public class Dialogue : ScriptableObject
    {
        [field: TextArea]
        [field: SerializeField]
        public List<string> Phrases { get; set; } = new();
    }
}