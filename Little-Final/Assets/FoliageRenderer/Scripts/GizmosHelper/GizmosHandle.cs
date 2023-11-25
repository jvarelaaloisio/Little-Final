using UnityEditor;
using UnityEngine;

namespace FoliageRenderer.Scripts.GizmosHelper
{
    public abstract class GizmosHandle
    {
        public static void DrawCircle(Vector3 position, float radius)
        {
            float theta = 0;
            var x = radius * Mathf.Cos(theta);
            var z = radius * Mathf.Sin(theta);
            var pos = position + new Vector3(x, 0, z);

            for(theta = 0.1f; theta < Mathf.PI * 2; theta += 0.1f)
            {
                x = radius * Mathf.Cos(theta);
                z = radius * Mathf.Sin(theta);
                var newPos = position + new Vector3(x, 0, z);
                Gizmos.DrawLine(pos, newPos);
                pos = newPos;
            }
        }
        
        public static void DrawCircle(Vector3 position, float radius, string label, Color labelColor)
        {
            float theta = 0;
            var x = radius * Mathf.Cos(theta);
            var z = radius * Mathf.Sin(theta);
            var pos = position + new Vector3(x, 0, z);

            for(theta = 0.1f; theta < Mathf.PI * 2; theta += 0.1f)
            {
                x = radius * Mathf.Cos(theta);
                z = radius * Mathf.Sin(theta);
                var newPos = position + new Vector3(x, 0, z);
                Gizmos.DrawLine(pos, newPos);
                pos = newPos;
            }
            
            DrawText(pos, label, labelColor);
        }

        public static void DrawText(Vector3 position, string label, Color color)
        {
            Handles.Label(position + Vector3.up * 0.4f, label, new GUIStyle
            {
                normal =
                {
                    textColor = color
                },
                fontStyle = FontStyle.Bold
            });
        }
    }
}