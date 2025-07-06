using System;
using System.Collections.Generic;
using Characters;
using Core.Data;
using Core.Helpers;
using Core.References;
using UnityEngine;

namespace Spawning {
    [Obsolete("Use Levels.SpawnPlayerSequence")]
    public class OldPlayerSpawner : MonoBehaviour {
        [SerializeField] private ReverseIndexStore data;
        
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
            character.Setup(data);
            //------
            character.DisableUntilSetup = true;
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

    public class PlayerSpawner : Spawner<PhysicsCharacter, ReverseIndexStore>
    {
        protected override void HandleSpawn(PhysicsCharacter newBorn)
        {
            newBorn.DisableUntilSetup = true;
            newBorn.Initialize();
        }
    }
}
