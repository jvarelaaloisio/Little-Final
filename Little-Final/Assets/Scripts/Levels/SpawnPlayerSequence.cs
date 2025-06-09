using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Characters;
using Core.Helpers;
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
        [SerializeField] private Dictionary<Type, IDictionary<IIdentification, object>> data = new();

        public bool IsValid => playerPrefab != null && position != Vector3.negativeInfinity;

        [ContextMenu("Play")]
        public async Task Play()
        {
            var operation = InstantiateAsync(playerPrefab, position, rotation);
            while (!operation.isDone)
                await Task.Delay(1000 / 30);
            var go = operation.Result.FirstOrDefault();
            if (go)
            {
                if (!go.TryGetComponent(out PhysicsCharacter character))
                    character = go.AddComponent<PhysicsCharacter>();
                character?.Setup(data);

                if (!go.TryGetComponent(out PlayerController controller))
                    controller = go.AddComponent<PlayerController>();
                controller?.Setup(character);
            }
        }
    }
}