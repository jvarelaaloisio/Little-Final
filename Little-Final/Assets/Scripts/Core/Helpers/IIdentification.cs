namespace Core.Helpers
{
    public interface IIdentification
    {
        string name { get; }
        int hashCode { get; }
    }
}