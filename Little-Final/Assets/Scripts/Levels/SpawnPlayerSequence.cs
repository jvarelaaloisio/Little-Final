using System.Linq;
using Characters;
using Core.Data;
using Core.References;
using Cysharp.Threading.Tasks;
using UnityEngine;
using User;

namespace Levels
{
    [CreateAssetMenu(fileName = "LevelSequence_", menuName = "Levels/Management/Sequence")]
    public class SpawnPlayerSequence : ScriptableObject, ILevelSequence
    {
        [SerializeField] private GameObject playerPrefab;
        [SerializeField] private Vector3 position = Vector3.negativeInfinity;
        [SerializeField] private Quaternion rotation = Quaternion.identity;

        public bool IsValid => playerPrefab != null && position != Vector3.negativeInfinity;

        [ContextMenu("Play")]
        public async UniTask Play()
        {
            var operation = InstantiateAsync(playerPrefab, position, rotation);
            await UniTask.WaitUntil(() => operation.isDone);
            var go = operation.Result.FirstOrDefault();
            if (go)
            {
                if (!go.TryGetComponent(out IPhysicsCharacter<ReverseIndexStore> character))
                    character = go.AddComponent<PhysicsCharacter>();
                if (character is ISetup<ReverseIndexStore> setupableCharacter)
                    setupableCharacter.Setup(new ReverseIndexStore());

                if (!go.TryGetComponent(out PlayerController controller))
                    controller = go.AddComponent<PlayerController>();
                controller?.Setup(character);
            }
        }
    }
}