using UnityEngine;

namespace Core.Extensions
{
    public static class LayerMaskExtensions
    {
        public static bool ContainsLayer(this LayerMask layerMask, int layer)
            => layerMask == (layerMask | (1 << layer));

        public static bool ContainsLayer(this LayerMask layerMask, string layer)
            => layerMask == (layerMask | (1 << LayerMask.NameToLayer(layer)));
    }
}
