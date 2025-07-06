using System;
using Core.Extensions;
using UnityEditor.SearchService;
using UnityEngine;
using Object = UnityEngine.Object;

namespace VarelaAloisio.Editor
{
	[ObjectSelectorEngine]
	public class InterfaceSelectorEngine : IObjectSelectorEngine
	{
		/// <inheritdoc />
		public string name => "Interface selector engine";

		/// <inheritdoc />
		public void BeginSession(ISearchContext context)
		{
			Debug.Log("Begin Session called".Colored("green"));
		}

		/// <inheritdoc />
		public void EndSession(ISearchContext context)
		{
			Debug.Log("End Session called".Colored("red"));
		}

		/// <inheritdoc />
		public void BeginSearch(ISearchContext context, string query)
		{
			Debug.Log("Begin Search called".Colored("green"));
		}

		/// <inheritdoc />
		public void EndSearch(ISearchContext context)
		{
			Debug.Log("End Search called".Colored("red"));
		}

		/// <inheritdoc />
		public bool SelectObject(ISearchContext context, Action<Object, bool> onObjectSelectorClosed, Action<Object> onObjectSelectedUpdated)
		{
			Debug.Log("Select Object called".Colored("blue"));
			return true;
		}

		/// <inheritdoc />
		public void SetSearchFilter(ISearchContext context, string searchFilter)
		{
			Debug.Log("Set Search Filter called".Colored("#aa8800"));
		}
	}
}