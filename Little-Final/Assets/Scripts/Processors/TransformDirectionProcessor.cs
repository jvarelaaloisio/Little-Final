using Core.Data;
using UnityEngine;

namespace Processors
{
	[CreateAssetMenu(menuName = "Data/Processors/Transform Direction", fileName = "TransformDirectionProcessor", order = 0)]
	public class TransformDirectionProcessor : ScriptableObject, IProcessor<Vector3>
	{
		/// <inheritdoc />
		public Vector3 Process(Vector3 input, Transform transform)
			=> transform.TransformDirection(input);
	}
}