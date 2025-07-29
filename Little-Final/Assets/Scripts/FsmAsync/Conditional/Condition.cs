using System;
using System.Collections.Generic;
using System.Threading;
using Core.Helpers;
using Cysharp.Threading.Tasks;

namespace FsmAsync.Conditional
{
	public readonly struct Condition<TTarget, TOutput> : ICondition<TTarget, TOutput>
	{
		public Func<TTarget, CancellationToken, UniTask<bool>> Predicate { get; }
		public TOutput Output { get; }
		public string Name { get; }

		public Condition(Func<TTarget, CancellationToken, UniTask<bool>> predicate,
						 TOutput output,
						 string name)
		{
			Predicate = predicate;
			Output = output;
			Name = name;
		}

		public Condition(Predicate<TTarget> predicate,
						 TOutput output,
						 string name)
		{
			Predicate = (target, _) => new UniTask<bool>(predicate(target));
			Output = output;
			Name = name;
		}

		public UniTask<bool> IsMet(TTarget data, CancellationToken token)
			=> Predicate(data, token);
		public UniTask<bool> IsMet(TTarget data, out TOutput output, CancellationToken token)
		{
			output = Output;
			return Predicate(data, token);
		}

		public TOutput GetOutput()
			=> Output;

		public bool Equals(ICondition<TTarget, TOutput> other)
			=> other != null && EqualityComparer<TOutput>.Default.Equals(Output, other.Output);

		public override bool Equals(object obj)
			=> obj is ICondition<TTarget, TOutput> other && Equals(other);

		public override int GetHashCode()
			=> HashCode.Combine(Predicate, Output);
	}
}