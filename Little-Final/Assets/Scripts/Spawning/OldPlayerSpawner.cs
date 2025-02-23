using Acting;
using Characters;
using Core.References;
using UnityEngine;

namespace Spawning {
    public class OldPlayerSpawner : MonoBehaviour {
        [SerializeField] private InterfaceRef<PhysicsCharacter.IData> data;
        
        public PhysicsCharacter characterPrefab;
        [SerializeField] private bool spawnInStart;

        private void Start()
        {
            if (spawnInStart)
                Spawn();
        }

        private void Spawn()
        {
            //TODO: Replace Instantiate with Service.Get<ISpawnService>().Instantiate(characterPrefab).TryAutoSetup()
            //That instantiate method should expect an ISetup and return an structure with a TryAutoSetup method that fetches the references from a database  
            //------
            var character = Instantiate(characterPrefab);
            character.Setup(data.Ref);
            //------
            character.OverrideLifeCycle = true;
            character.Initialize();
        }
    }

    public abstract class Spawner<TSetup, TData> : MonoBehaviour where TSetup : MonoBehaviour, ISetup<TData>
    {
        [SerializeField] private InterfaceRef<TData> data;
        
        public TSetup prefab;
        [SerializeField] private bool spawnInStart;

        private void Start()
        {
            if (spawnInStart)
                Spawn();
        }

        public void Spawn()
        {
            //TODO: Replace Instantiate with Service.Get<ISpawnService>().Instantiate(characterPrefab).TryAutoSetup()
            //That instantiate method should expect an ISetup and return an structure with a TryAutoSetup method that fetches the references from a database  
            //------
            var newBorn = Instantiate(prefab);
            newBorn.Setup(data.Ref);
            //------
            HandleSpawn(newBorn);
        }

        protected abstract void HandleSpawn(TSetup newBorn);
    }

    public class PlayerSpawner : Spawner<PhysicsCharacter, PhysicsCharacter.IData>
    {
        protected override void HandleSpawn(PhysicsCharacter newBorn)
        {
            newBorn.OverrideLifeCycle = true;
            newBorn.Initialize();
        }
    }
}
