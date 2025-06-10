using Cysharp.Threading.Tasks;

namespace Levels
{
    public interface ILevelSequence
    {
        bool IsValid { get; }
        UniTask Play();
    }
}