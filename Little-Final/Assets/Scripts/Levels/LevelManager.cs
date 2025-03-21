using Core.References;
using UnityEngine;

namespace Levels
{
    [CreateAssetMenu(fileName = "LevelManager_", menuName = "Levels/Management/Manager")]
    public class LevelManager : ScriptableObject
    {
        [SerializeField] private InterfaceRef<ILevelSequence>[] sequences;

        [ContextMenu("Manage")]
        public async void Manage()
        {
            foreach (var sequence in sequences)
            {
                await sequence.Ref.Play();
            }
        }
    }
}
