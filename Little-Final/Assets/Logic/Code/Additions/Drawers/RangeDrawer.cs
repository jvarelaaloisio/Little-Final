using System;
using UnityEngine;
using UnityEditor;
using Random = UnityEngine.Random;
[CustomPropertyDrawer(typeof(RangeAttribute))]
public class RangeDrawer : PropertyDrawer
{
	private readonly string error = $"{nameof(RangeAttribute)} only supports serialized properties of {nameof(SerializedPropertyType.Integer)} ({typeof(int)}) and {nameof(SerializedPropertyType.Float)} ({typeof(float)})).";

	private bool foldout;

	public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
	{
		if (foldout)
			position.height -= EditorGUIUtility.singleLineHeight;

		EditorGUI.BeginProperty(position, label, property);

		DrawProperty(position, property);

		EditorGUI.EndProperty();
	}

	protected virtual void DrawProperty(Rect position, SerializedProperty property)
	{
		void ShowSlider<T>(
			Func<SerializedProperty, T> getter, Action<SerializedProperty, T> setter,
			Action<Rect, SerializedProperty, T, T> field, Action<Rect, SerializedProperty, T, T, GUIContent> field2,
			Func<T, T, T> random, Func<T, T, T> stepper
		) => ShowField(position, property, attribute as RangeAttribute, getter, setter, field, field2, random, stepper);

		switch (property.propertyType)
		{
			case SerializedPropertyType.Float:
			ShowSlider(
				e => e.floatValue, (e, v) => e.floatValue = v, EditorGUI.Slider, EditorGUI.Slider,
				Random.Range, (v, s) => (float)Math.Round(v / s, MidpointRounding.AwayFromZero) * s
			);
			break;
			case SerializedPropertyType.Integer:
			ShowSlider(
				e => e.intValue, (e, v) => e.intValue = v, EditorGUI.IntSlider, EditorGUI.IntSlider,
				Random.Range, (v, s) => v / s * s
			);
			break;
			default:
			string tooltip = error + $" Property {property.name} is {property.propertyType}.";
			EditorGUI.HelpBox(position, tooltip, MessageType.Error);
			Debug.LogException(new ArgumentException(tooltip));
			break;
		}
	}

	protected void ShowField<T, U>(
		Rect position, SerializedProperty property, RangeAttribute rangeAttribute,
		Func<SerializedProperty, T> getter, Action<SerializedProperty, T> setter,
		Action<Rect, SerializedProperty, U, U> field, Action<Rect, SerializedProperty, U, U, GUIContent> field2,
		Func<U, U, T> random, Func<T, U, T> stepper
		)
	{
		T Get() => getter(property);
		void Set(T v) => setter(property, v);

		U Cast(float v) => (U)Convert.ChangeType(v, typeof(U));

		U min, max, step;
		try
		{
			min = Cast(rangeAttribute.min);
			max = Cast(rangeAttribute.max);
			step = Cast(rangeAttribute.step);
		}
		catch (InvalidCastException)
		{
			throw new ArgumentException($"Generic parameter {nameof(T)} {typeof(T)} must be casteable from {typeof(float)}");
		}

		T oldValue = Get();

		bool hasStep = !Equals(step, default(U));

		if (rangeAttribute.showRandomButton)
		{
			// Show slider without label. Using " " instead of "" forces the slider to set space for the label
			// We take advantage of that in order to align it with the foldout.
			field2(position, property, min, max, new GUIContent(" ", property.tooltip));
			if ((foldout = EditorGUI.Foldout(position, foldout, new GUIContent(property.displayName, property.tooltip), true)) &&
				GUI.Button(
					new Rect(position.x, position.y + EditorGUIUtility.singleLineHeight, position.width, position.height),
					new GUIContent("Randomize", $"Produce a random value from {min} to {max}{(hasStep ? $" in steps of {step}" : "")}.")
				))
				Set(random(min, max));
		}
		else
			// Show normal slider
			field(position, property, min, max);

		// Only round if necessary
		T value = Get();
		if (hasStep && !Equals(value, oldValue))
			Set(stepper(value, step));
	}

	public override float GetPropertyHeight(SerializedProperty property, GUIContent label) => EditorGUI.GetPropertyHeight(property) + (foldout ? EditorGUIUtility.singleLineHeight : 0);
}
