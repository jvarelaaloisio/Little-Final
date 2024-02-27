using System.Collections.Generic;
using UnityEngine;

namespace Environment.MaterialPropertyBlockHelper
{
    [CreateAssetMenu(fileName = "PropertyBlockData", menuName = "Data/PropertyBlockData", order = 0)]
    public class PropertyBlockData : ScriptableObject
    {
        public List<PropertyBlockTexture> texturesData;
        public List<PropertyBlockColor> colorsData;
        public List<PropertyBlockVector4> vectorsData;
        public List<PropertyBlockFloat> floatsData;
        public List<PropertyBlockInt> integersData; 
        
    }
}