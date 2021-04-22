namespace Player.States
{
	public class LongJump : Jump
	{
		public override void OnStateUpdate()
		{
			MoveHorizontally(Body, PP_Jump.LongJumpSpeed, PP_Jump.TurnSpeedLongJump);

			CheckForJumpBuffer();
			CheckClimb();
			Controller.RunAbilityList(Controller.AbilitiesInAir);
			CheckGlide();
		}
	}
}