using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Environment.MaterialPropertyBlockHelper
{
    [RequireComponent(typeof(Renderer))]
    public class MaterialPropertyBlockManager : MonoBehaviour
    {
        [SerializeField] private PropertyBlockData propertyBlockData;
        
        private Renderer _renderer;
        private MaterialPropertyBlock _propBlock;

        private void Start()
        {
            InitComponentAndSetProperties();
        }

        [ContextMenu("ForceSetMaterialProperties")]
        public void InitComponentAndSetProperties()
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
            if (propertyBlockData.texturesData.Any())
            {
                foreach (var textureProp in propertyBlockData.texturesData.Where(propertyBlockTexture => propertyBlockTexture != null))
                {
                    _propBlock.SetTexture(textureProp.name, textureProp.value);
                }
            }
            
            if (propertyBlockData.vectorsData.Any())
            {
                foreach (var vectorProp in propertyBlockData.vectorsData.Where(propertyBlockTexture => propertyBlockTexture != null))
                {
                    _propBlock.SetVector(vectorProp.name, vectorProp.value);
                }
            }
            
            if (propertyBlockData.colorsData.Any())
            {
                foreach (var colorProp in propertyBlockData.colorsData.Where(propertyBlockTexture => propertyBlockTexture != null))
                {
                    _propBlock.SetColor(colorProp.name, colorProp.value);
                }
            }
            
            if (propertyBlockData.floatsData.Any())
            {
                foreach (var floatProp in propertyBlockData.floatsData.Where(propertyBlockTexture => propertyBlockTexture != null))
                {
                    _propBlock.SetFloat(floatProp.name, floatProp.value);
                }
            }
            
            if (propertyBlockData.integersData.Any())
            {
                foreach (var intProp in propertyBlockData.integersData.Where(propertyBlockTexture => propertyBlockTexture != null))
                {
                    _propBlock.SetInt(intProp.name, intProp.value);
                }
            }
            
            _renderer.SetPropertyBlock(_propBlock);
        }
    }
}