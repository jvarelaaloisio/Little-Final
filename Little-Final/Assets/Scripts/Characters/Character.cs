using Acting;
using UnityEngine;

namespace Characters
{
    public abstract class Character<TData> : MonoBehaviour
    {
        /// <summary>
        /// Specifies if the <see cref="Setup"/> method has been run or not.
        /// <remarks>If the character is not set, <see cref="Actor"/> might be null.</remarks>
        /// </summary>
        protected bool IsSet = false;
        public Actor<TData> Actor { get; private set; }
        [field: SerializeField] public bool overrideLifeCycle { get; set; }

        protected virtual void Awake()
        {
            if (overrideLifeCycle)
                enabled = false;
        }

        /// <summary>
        /// Method used to give this class's <see cref="Actor"/> it's data.
        /// <remarks>Call this method before Initialize to have </remarks>
        /// </summary>
        /// <param name="data">Data to give to <see cref="Actor"/></param>
        public virtual void Setup(TData data)
        {
            Actor = new Actor<TData>();
            IsSet = true;
        }

        public virtual void Initialize()
        {
            if (IsSet is false)
                Debug.LogWarning($"{name}: Setup hasn't been called before initialize");
        }
    }
}
