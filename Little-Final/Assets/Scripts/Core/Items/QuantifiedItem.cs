namespace Core.Items
{
    public class QuantifiedItem : Item
    {
        private int _quantity;

        public QuantifiedItem(int quantity = 0)
        {
            _quantity = quantity;
        }
        public override int Quantity => _quantity;

        public virtual void AddUnits(int units)
        {
            var oldQty = _quantity;
            _quantity += units;
            onQuantityChanged(oldQty, _quantity);
        }

        public virtual void RemoveUnits(int units)
        {
            var oldQty = _quantity;
            _quantity -= units;
            onQuantityChanged(oldQty, _quantity);
        }
    }
}