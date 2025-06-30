using System;
using UnityEngine;

namespace Core.Data
{
	/// <summary>
	/// Serializable wrapper for animation parameters to ease the use of hashes.
	/// </summary>
	[Serializable]
	public class AnimatorParameter
	{
		[field: SerializeField] public string Name { get; set; }

		private int? _hash;

		/// <summary>
		/// Cached hash value for this animation
		/// </summary>
		public int Hash => _hash ??= Animator.StringToHash(Name);

		public AnimatorParameter(string name)
			=> this.Name = name;
	}
}