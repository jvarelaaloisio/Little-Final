using UnityEngine;

namespace Characters
{
	public interface IPhysicsCharacter : ICharacter
	{
		Rigidbody rigidbody { get; }

		/// <summary>
		/// Adds a force to the list of forces that will be applied in the next fixedUpdate.
		/// <remarks>This is meant for instant forces mainly. If what you're looking for is to add a constant force, <i>like pushing with a stream of wind</i>, <see cref="TryAddContinuousForce"/> is recommended instead.</remarks>
		/// </summary>
		/// <param name="force" />
		/// <param name="forceMode">Default: <see cref="ForceMode"/>.<see cref="ForceMode.Impulse"/></param>
		void AddForce(Vector3 force, ForceMode forceMode = ForceMode.Impulse);

		/// <summary>
		/// Adds a request to the continuous forces List
		/// </summary>
		/// <param name="force">The force to be applied every fixed update</param>
		/// <param name="mode"></param>
		bool TryAddContinuousForce(Vector3 force, ForceMode mode = ForceMode.Force);

		/// <summary>
		/// Removes a requests from the continuous forces List
		/// </summary>
		/// <param name="request"></param>
		void RemoveContinuousForce(Vector3 force, ForceMode mode = ForceMode.Force);
	}
}