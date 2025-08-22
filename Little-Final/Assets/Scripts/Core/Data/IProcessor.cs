namespace Core.Data
{
	public interface IProcessor<T> where T : struct
	{
		T Process(T input);
	}
}