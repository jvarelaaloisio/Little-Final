using System;
using UnityEngine;

namespace Environment
{
    [ExecuteInEditMode]
    public class WaterShaderController : MonoBehaviour
    {
        //Properties
        public Transform clearPoint_1;
        public Transform clearPoint_2;
        
        //Shader Properties IDs
        private static readonly int ClearPoint_1_ID = Shader.PropertyToID("G_Water_ClearZone_1");
        private static readonly int ClearPoint_2_ID = Shader.PropertyToID("G_Water_ClearZone_2");

        private void Update()
        {
            if(clearPoint_1)
                Shader.SetGlobalVector(ClearPoint_1_ID,clearPoint_1.position);
            if(clearPoint_2)
                Shader.SetGlobalVector(ClearPoint_2_ID,clearPoint_2.position);
        }
    }
}
