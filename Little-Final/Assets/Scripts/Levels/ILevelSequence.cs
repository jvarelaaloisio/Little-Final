using System.Threading.Tasks;

namespace Levels
{
    public interface ILevelSequence
    {
        bool IsValid { get; }
        Task Play();
    }
}