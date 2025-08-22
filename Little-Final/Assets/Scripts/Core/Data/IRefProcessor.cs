namespace Core.Data
{
	public interface IRefProcessor<T> where T : class
	{
		void Process(ref T input);
	}
}