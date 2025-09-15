using System.Threading;
using Core.Acting;
using Cysharp.Threading.Tasks;

namespace User.States
{
	public interface IActorStateBehaviour<T>
	{
		UniTask Enter(IActor<T> actor, CancellationToken token);
		UniTask Exit(IActor<T> actor, CancellationToken token);
		/// <summary/> Called in update for now. TODO: Come up with a better name
		/// <param name="actor"></param>
		/// <param name="token"></param>
		/// <returns>true if the input has been used,
		/// false if the input doesn't apply to this behaviour or if the behaviour doesn't stop others from processing the input.</returns>
		UniTask<bool> TryConsumeTick(IActor<T> actor, CancellationToken token);
	}
}