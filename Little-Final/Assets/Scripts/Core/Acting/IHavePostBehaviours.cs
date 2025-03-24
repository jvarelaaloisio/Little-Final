using System;
using System.Threading;
using System.Threading.Tasks;

namespace Core.Acting
{
	public interface IHavePostBehaviours
	{
		bool TryAddPostBehaviour(Func<IActor, CancellationToken, Task> behaviour, string actionId = IActor.Wildcard);
		void RemovePostBehaviour(Func<IActor, CancellationToken, Task> behaviour, string actionId = IActor.Wildcard);
	}
}