namespace Core.Extensions
{
	public static class BoolExtensions
	{
		public static int TrueIs0FalseIs1(this bool value) => value ? 0 : 1;
	}
}
