using UnityEngine;

public static class BezierHelper
{
	public static float GetArcSinBezier(float x)
	{
		return (Mathf.Asin(x * 2 - 1) + Mathf.PI / 2) / Mathf.PI;
	}
	public static float GetCircunferenceBezier(float x)
	{
		return 1 - Mathf.Sqrt(1 - Mathf.Pow(x, 2));
	}
	public static float GetSinBezier(float x)
	{
		return (Mathf.Sin((x - .5f) * Mathf.PI) + 1) / 2;
	}
}