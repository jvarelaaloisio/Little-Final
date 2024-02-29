using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Core.Providers;
using UnityEngine;

namespace Core.Coroutines
{
    public class CoroutineRunner : MonoBehaviour
    {
        private HashSet<CoroutineContainer> coroutines = new();

        [SerializeField] private DataProvider<CoroutineRunner> dataProvider;
        
        private void OnEnable()
        {
            dataProvider.Value = this;
        }

        private void OnDisable()
        {
            if (dataProvider.Value == this)
                dataProvider.Value = null;
        }

        public Coroutine RunCoroutine(IEnumerator behaviour, string behaviourName, bool isSceneVolatile = true)
        {
            var coroutine = StartCoroutine(behaviour);
            coroutines.Add(new CoroutineContainer(coroutine, behaviourName, isSceneVolatile));
            return coroutine;
        }

        public void CancelCoroutine(string behaviourName)
        {
            StopCoroutine(behaviourName);
            coroutines.RemoveWhere(container => container.coroutine == null || container.behaviourName == behaviourName);
        }

        public void CancelAllVolatileCoroutines()
        {
            var tempCors = new CoroutineContainer[coroutines.Count];
            coroutines.CopyTo(tempCors);
            foreach (var coroutineContainer in tempCors.Where(container => container.isSceneVolatile))
            {
                StopCoroutine(coroutineContainer.behaviourName);
                coroutines.Remove(coroutineContainer);
            }
        }
        
        private readonly struct CoroutineContainer
        {
            public readonly Coroutine coroutine;
            public readonly string behaviourName;
            public readonly bool isSceneVolatile;

            public CoroutineContainer(Coroutine coroutine, string behaviourName, bool isSceneVolatile = true)
            {
                this.isSceneVolatile = isSceneVolatile;
                this.coroutine = coroutine;
                this.behaviourName = behaviourName;
            }
        }
    }
}
