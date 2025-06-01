using UnityEngine;

namespace Core.Extensions
{
	public static class StringExtensions
	{
		public static string Colored(this object message, UnityEngine.Color color)
			=> Colored(message, "#" + ColorUtility.ToHtmlStringRGB(color));
		public static string Colored(this object message, string color) => $"<color={color}>{message}</color>";
		public static string Bold(this object message) => $"<b>{message}</b>";
		public static string Italic(this object message) => $"<i>{message}</i>";
	}

	public static class C
	{
		public const string White = "white";
		public const string Black = "black";
		public const string Red = "red";
		public const string Green = "green";
		public const string Blue = "blue";
	}
}