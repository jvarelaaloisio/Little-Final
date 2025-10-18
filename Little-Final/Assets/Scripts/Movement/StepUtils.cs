using System;
using System.Collections;
using Core.Debugging;
using UnityEngine;

namespace Movement
{
	public static class StepUtils
	{
		public static bool HasWall(Vector3 direction,
		                           Vector3 origin,
		                           Vector3 directionScaled,
		                           float distance,
		                           int mask,
		                           Debugger debugger = null,
		                           string debugTag = "")
		{
			bool hasWall = Physics.Raycast(origin, direction, out var hit, distance, mask);
			if (hasWall)
				debugger?.DrawLine(debugTag, origin, hit.point, Color.red);
			else
				debugger?.DrawRay(debugTag, origin, directionScaled, Color.green);
			return hasWall;
		}

		public static IEnumerator Do(Transform transform,
		                             Vector3 destination,
		                             float duration,
		                             AnimationCurve curve,
		                             Action callback)
		{
			var origin = transform.position;
			var beginning = Time.time;
			float now = 0;
			do
			{
				now = Time.time;
				var lerp = (now - beginning) / duration;
				transform.position = Vector3.Lerp(origin, destination, curve.Evaluate(lerp));

				yield return null;
			} while (now < beginning + duration);

			transform.position = destination;
			callback?.Invoke();
		}
	}
}