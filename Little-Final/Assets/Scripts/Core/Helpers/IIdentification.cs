using System;

namespace Core.Helpers
{
    public interface IIdentification: IEquatable<IIdentification>
    {
        string name { get; }
        int hashCode { get; }
    }
}