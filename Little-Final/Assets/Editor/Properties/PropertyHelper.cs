using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class PropertyHelper
{
	List<Property> properties;

	public PropertyHelper(string path)
	{
		properties = ReadFile(path);
	}

	public Property GetProperty(string name)
	{
		List<Property> filtered = properties.FindAll(p => p.name == name);
		return (filtered.Count > 0)? filtered[0] : null;
	}

	List<Property> ReadFile(string path)
	{
		string[] data = File.ReadAllLines(path);
		List<Property> properties = new List<Property>();
		foreach (var prop in data)
		{
			properties.Add(JsonUtility.FromJson<Property>(prop));
		}
		return properties;
	}
}
