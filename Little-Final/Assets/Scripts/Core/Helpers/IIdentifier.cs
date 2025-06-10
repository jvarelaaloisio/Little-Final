using System;
using System.Collections.Generic;

namespace Core.Helpers
{
    public interface IIdentifier: IEquatable<IIdentifier>
    {
        string name { get; }
        int Id { get; }
        public sealed class Comparer : EqualityComparer<IIdentifier>
        {
            /// <inheritdoc />
            public override bool Equals(IIdentifier x, IIdentifier y)
                => x?.Equals(y) ?? y is null;

            /// <inheritdoc />
            public override int GetHashCode(IIdentifier obj)
                => obj?.Id ?? 0;
        }
    }
}