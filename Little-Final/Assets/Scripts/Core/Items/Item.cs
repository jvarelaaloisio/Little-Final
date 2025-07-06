using System;
using Core.Helpers;

namespace Core.Items
{
    public abstract class Item
    {
        public IIdentifier ID { get; set; }
        public event Action<int, int> onQuantityChanged = delegate { };
        public abstract int Quantity { get; }
        public abstract void AddUnit(Item item);
        public abstract void RemoveUnit(Item item);
        protected void OnQuantityChanged(int oldValue, int newValue)
            => onQuantityChanged(oldValue, newValue);
    }
}