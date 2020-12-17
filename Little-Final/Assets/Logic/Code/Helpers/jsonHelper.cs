using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public static class jsonHelper
{
	/// <summary>
	/// Saves a list of objects in the given path
	/// </summary>
	/// <typeparam name="T">type of the objects</typeparam>
	/// <param name="path">Path with or without file name</param>
	/// <param name="data">The objects to save</param>
	/// <param name="fileName">the name of the file if it's not included in the path</param>
	public static void Save<T>(string path, List<T> data, string fileName = null)
	{
		if (fileName != null) path += "/" + fileName;
		List<string> dataString = new List<string>();
		foreach (T d in data)
		{
			dataString.Add(JsonUtility.ToJson(d));
		}
		File.WriteAllLines(path, dataString);
	}
	/// <summary>
	/// Loads a list of objects from the given path
	/// </summary>
	/// <typeparam name="T">Type of the objects </typeparam>
	/// <param name="path">Path with or without file name</param>
	/// <param name="fileName">the name of the file if it's not included in the path</param>
	/// <returns></returns>
	public static List<T> Load<T>(string path, string fileName = null)
	{
		if (fileName != null) path += "/" + fileName;
		string[] dataString = File.ReadAllLines(path);
		List<T> data = new List<T>();
		foreach (var d in dataString)
		{
			data.Add(JsonUtility.FromJson<T>(d));
		}
		return data;
	}
}
