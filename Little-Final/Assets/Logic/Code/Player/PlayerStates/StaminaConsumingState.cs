using VarelaAloisio.UpdateManagement.Runtime;

public abstract class StaminaConsumingState : PlayerState
{
	protected ActionWithFrequency ConsumingStamina;

	protected CountDownTimer WaitToConsumeStamina;
	protected float StaminaPerSecond = 0;
	protected float StaminaConsumptionDelay = 0;

	public override void OnStateEnter(PlayerController controller, int sceneIndex)
	{
		base.OnStateEnter(controller, sceneIndex);
		
		ConsumingStamina =
			new ActionWithFrequency(
				ConsumeStamina,
				StaminaPerSecond,
				sceneIndex);
		if(StaminaConsumptionDelay == 0)
			return;
		WaitToConsumeStamina =
			new CountDownTimer(
				StaminaConsumptionDelay,
				ConsumingStamina.StartAction,
				sceneIndex);
	}

	public abstract override void OnStateUpdate();
	
	protected void ConsumeStamina()
	{
		Controller.stamina.ConsumeStamina(1);
	}
}