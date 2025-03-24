using Acting;
using Core.Acting;
using Core.Attributes;
using Core.References;
using UnityEngine;

namespace Characters
{
    public abstract class Character<TData> : MonoBehaviour, ISetup<TData>, ICharacter<TData>
    {
        [Tooltip("If true, this component will be disabled until it's setup and initialized.")]
        [field: SerializeField] public bool OverrideLifeCycle { get; set; }

        /// <summary>
        /// Specifies if the <see cref="Setup"/> method has been called or not.
        /// <remarks>If the character is not set, <see cref="Actor"/> might be null.</remarks>
        /// </summary>
        public bool IsSet { get; protected set; }= false;

        public IActor<TData> Actor { get; private set; }
        [field: SerializeReadOnly] public MovementData Movement { get; set; } = MovementData.InvalidRequest;
        public abstract Vector3 Velocity { get; set; }

        protected virtual void Awake()
        {
            if (OverrideLifeCycle)
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

        /// <summary>
        /// Sets <see cref="IsSet"/> to false, base definition doesn't affect <see cref="Actor"/>.
        /// </summary>
        public virtual void Clear()
            => IsSet = false;

        public virtual void Initialize()
        {
            if (IsSet is false)
                Debug.LogWarning($"{name}: Setup hasn't been called before initialize");
            if (OverrideLifeCycle)
                enabled = true;
        }

        public abstract void Jump(float force);
    }
}
