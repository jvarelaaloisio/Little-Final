using System;
using System.Collections.Generic;

namespace Core.Helpers
{
    public interface IIdentifier: IEquatable<IIdentifier>
    {
        string name { get; }
        /// <summary>
        /// The number identifier for this object
        /// </summary>
        int Code { get; }
        public sealed class Comparer : EqualityComparer<IIdentifier>
        {
            /// <inheritdoc />
            public override bool Equals(IIdentifier x, IIdentifier y)
                => x?.Equals(y) ?? y is null;

            /// <inheritdoc />
            public override int GetHashCode(IIdentifier obj)
                => obj?.Code ?? 0;
        }
    }
}