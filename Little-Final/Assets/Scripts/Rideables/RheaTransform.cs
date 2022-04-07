using Core.Movement;
using Player;

namespace Rideables
{
	public class RheaTransform : Rhea
	{
		protected override void Awake()
		{
			base.Awake();
			onBroke.AddListener(() => Movement.Speed = base.speed);
		}

		protected override void InitializeMovement(out IMovement movement, float speed)
		{
			movement = new MovementThroughTransform(speed);
		}

		protected override void Break()
		{
			Movement.Speed = 0;
		}
	}
}