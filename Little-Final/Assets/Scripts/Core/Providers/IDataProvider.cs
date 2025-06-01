namespace Core.Providers
{
	public interface IDataProvider<T>
	{
		T Value { get; set; }
	}
}