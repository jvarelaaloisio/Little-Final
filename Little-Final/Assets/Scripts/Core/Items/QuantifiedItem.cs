using UnityEngine;

namespace Core.Items
{
    public class QuantifiedItem : Item
    {
        private int _quantity;

        /// <summary>
        /// Should this item allow quantity to go below zero (0)
        /// </summary>
        public bool AllowDebt { get; set; } = false;

        public QuantifiedItem(int quantity = 0)
        {
            _quantity = quantity;
        }

        public override int Quantity => _quantity;

        //NEW
        public override void AddUnit(Item item)
        {
            var oldQty = _quantity;
            _quantity += item.Quantity;
            OnQuantityChanged(oldQty, _quantity);
        }

        public override void RemoveUnit(Item item)
        {
            var oldQty = _quantity;
            _quantity -= item.Quantity;
            if (!AllowDebt)
            {
                _quantity = Mathf.Max(0, _quantity);
            }
            OnQuantityChanged(oldQty, _quantity);
        }
    }
}