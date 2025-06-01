using System;
using System.Collections.Generic;

namespace Core.Helpers
{
    public interface IIdentification: IEquatable<IIdentification>
    {
        string name { get; }
        int hashCode { get; }
        public class Comparer : EqualityComparer<IIdentification>
        {
            /// <inheritdoc />
            public override bool Equals(IIdentification x, IIdentification y)
                => x?.Equals(y) ?? false;

            /// <inheritdoc />
            public override int GetHashCode(IIdentification obj)
                => obj?.hashCode ?? -1;
        }
    }
}