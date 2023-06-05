using System;

namespace Core.Items
{
    public abstract class Item
    {
        public Action<int, int> onQuantityChanged = delegate { };
        public abstract int Quantity { get; }
    }
}