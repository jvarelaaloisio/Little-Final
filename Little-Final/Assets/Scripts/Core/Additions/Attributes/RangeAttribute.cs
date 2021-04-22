using System;
using UnityEngine;

[AttributeUsage(AttributeTargets.Field, AllowMultiple = false, Inherited = true)]
public class RangeAttribute : PropertyAttribute
{
	/// <summary>
	/// Minimal value that can be taken.
	/// </summary>
	public readonly float min;

	/// <summary>
	/// Maximum value that can be taken.
	/// </summary>
	public readonly float max;

	/// <summary>
	/// Steps of the taken value. The value must be a multiple of <see cref="step"/>.
	/// </summary>
	public readonly float step;

	/// <summary>
	/// Whenever a randomize button should be shown below the field in the inspector.
	/// </summary>
	public readonly bool showRandomButton;

	public RangeAttribute(float min, float max, float step = 0, bool showRandomButton = false)
	{
		this.min = min;
		this.max = max;
		this.step = step;
		this.showRandomButton = showRandomButton;
	}
}
