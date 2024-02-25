using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Environment.MaterialPropertyBlockHelper
{
    [RequireComponent(typeof(Renderer))]
    public class MaterialPropertyBlockManager : MonoBehaviour
    {
        [SerializeField] private List<PropertyBlockTexture> texturesData;
        [SerializeField] private List<PropertyBlockColor> colorsData;
        [SerializeField] private List<PropertyBlockVector4> vectorsData;
        [SerializeField] private List<PropertyBlockFloat> floatsData;
        [SerializeField] private List<PropertyBlockInt> integersData;
        
        private Renderer _renderer;
        private MaterialPropertyBlock _propBlock;

        private void Start()
        {
            InitComponentAndSetProperties();
        }

        [ContextMenu("ForceSetMaterialProperties")]
        private void InitComponentAndSetProperties()
        {
            InitComponent();
            SetMaterialProperties();
        }
        
        private void InitComponent()
        {
            _renderer = GetComponent<Renderer>();
            
            if (_renderer == null)
            {
                Debug.LogError("Renderer component not found!");
                enabled = false;
                return;
            }

            _propBlock = new MaterialPropertyBlock();
            _renderer.GetPropertyBlock(_propBlock);
        }
        
        private void SetMaterialProperties()
        {
            if (texturesData.Any())
            {
                foreach (var textureProp in texturesData.Where(propertyBlockTexture => propertyBlockTexture != null))
                {
                    _propBlock.SetTexture(textureProp.name, textureProp.value);
                }
            }
            
            if (vectorsData.Any())
            {
                foreach (var vectorProp in vectorsData.Where(propertyBlockTexture => propertyBlockTexture != null))
                {
                    _propBlock.SetVector(vectorProp.name, vectorProp.value);
                }
            }
            
            if (colorsData.Any())
            {
                foreach (var colorProp in colorsData.Where(propertyBlockTexture => propertyBlockTexture != null))
                {
                    _propBlock.SetColor(colorProp.name, colorProp.value);
                }
            }
            
            if (floatsData.Any())
            {
                foreach (var floatProp in floatsData.Where(propertyBlockTexture => propertyBlockTexture != null))
                {
                    _propBlock.SetFloat(floatProp.name, floatProp.value);
                }
            }
            
            if (integersData.Any())
            {
                foreach (var intProp in integersData.Where(propertyBlockTexture => propertyBlockTexture != null))
                {
                    _propBlock.SetInt(intProp.name, intProp.value);
                }
            }
            
            _renderer.SetPropertyBlock(_propBlock);
        }
    }
}