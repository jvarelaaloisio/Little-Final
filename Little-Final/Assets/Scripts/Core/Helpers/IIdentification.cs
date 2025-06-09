using System;
using System.Collections.Generic;

namespace Core.Helpers
{
    public interface IIdentification: IEquatable<IIdentification>
    {
        string name { get; }
        int HashCode { get; }
        public sealed class Comparer : EqualityComparer<IIdentification>
        {
            /// <inheritdoc />
            public override bool Equals(IIdentification x, IIdentification y)
                => x?.Equals(y) ?? y is null;

            /// <inheritdoc />
            public override int GetHashCode(IIdentification obj)
                => obj?.HashCode ?? 0;
        }
    }
}