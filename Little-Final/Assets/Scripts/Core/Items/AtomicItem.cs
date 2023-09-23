using System.Collections.Generic;

namespace Core.Items
{
    public class AtomicItem : Item
    {
        private readonly List<Item> _items = new();
        public override int Quantity => _items.Count;
        public override void AddUnit(Item item)
        {
            _items.Add(item);
        }

        public override void RemoveUnit(Item item)
        {
            _items.Remove(item);
        }
    }
}