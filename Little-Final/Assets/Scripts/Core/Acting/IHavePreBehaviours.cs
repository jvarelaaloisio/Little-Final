using System;
using System.Threading;
using System.Threading.Tasks;

namespace Core.Acting
{
	public interface IHavePreBehaviours
	{
		bool TryAddPreBehaviour(Func<IActor, CancellationToken, Task> behaviour, string actionId = IActor.Wildcard);
		void RemovePreBehaviour(Func<IActor, CancellationToken, Task> behaviour, string actionId = IActor.Wildcard);
	}
}