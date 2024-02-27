using System;
using UnityEngine;

namespace Environment.MaterialPropertyBlockHelper
{
    [Serializable]
    public class PropertyBlockInt : PropertyBlockBase
    {
        [SerializeField] public int value;
    }

    [Serializable]
    public class PropertyBlockFloat : PropertyBlockBase
    {
        [SerializeField] public float value;
    }

    [Serializable]
    public class PropertyBlockVector4 : PropertyBlockBase
    {
        [SerializeField] public Vector4 value;
    }
    
    [Serializable]
    public class PropertyBlockColor : PropertyBlockBase
    {
        [SerializeField] public Color value;
    }

    [Serializable]
    public class PropertyBlockTexture : PropertyBlockBase
    {
        [SerializeField] public Texture value;
    }

    [Serializable]
    public abstract class PropertyBlockBase
    {
        [SerializeField] public string name;
    }
}