using System;
using UnityEngine;

namespace Environment.MaterialPropertyBlockHelper
{
    [Serializable]
    public class PropertyBlockInt : PropertyBlockData
    {
        [SerializeField] public int value;
    }

    [Serializable]
    public class PropertyBlockFloat : PropertyBlockData
    {
        [SerializeField] public float value;
    }

    [Serializable]
    public class PropertyBlockVector4 : PropertyBlockData
    {
        [SerializeField] public Vector4 value;
    }
    
    [Serializable]
    public class PropertyBlockColor : PropertyBlockData
    {
        [SerializeField] public Color value;
    }

    [Serializable]
    public class PropertyBlockTexture : PropertyBlockData
    {
        [SerializeField] public Texture value;
    }

    [Serializable]
    public abstract class PropertyBlockData
    {
        [SerializeField] public string name;
    }
}