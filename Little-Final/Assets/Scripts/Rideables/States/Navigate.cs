using System;
using Core.Debugging;
using Core.Movement;
using UnityEngine;

namespace Rideables.States
{
	//TODO: Implement. Base rhea class should not be conscious of the nav mesh agent.
	public class Navigate<T> : CharacterState<T>
	{
		private readonly INavigator _navigator;

		public Vector3 Destination => _navigator.Destination;
		
		public float ArrivalDistance => _navigator.ArrivalDistance;
		
		public Navigate(string name,
						Transform transform,
						Action onCompletedObjective,
						Debugger debugger,
						INavigator navigator)
			: base(name, transform, onCompletedObjective, debugger)
		{
			_navigator = navigator;
		}

		public void NavigateTo(Vector3[] candidateDestinations)
		{
			foreach (Vector3 destination in candidateDestinations)
			{
				float distance = Vector3.Distance(destination, Destination);
				Debugger.DrawLine(Name, MyTransform.position, Destination, Color.red, .5f);
				if(distance < ArrivalDistance)
					return;
				if (_navigator.TrySetDestination(destination))
				{
					Debugger.Log(Name, $"dest: {destination}, Dest: {Destination}, distance: {distance}");
					Debugger.DrawLine(Name, MyTransform.position, destination, Color.white, 1f);
					return;
				}

				Debugger.DrawLine(Name, MyTransform.position, destination, Color.black, 1f);
			}

			Debugger.LogError(Name, $"{MyTransform.name}: Could not set a destination", MyTransform);
			CompletedObjective();
		}

		protected override void Update(float deltaTime)
		{
			base.Update(deltaTime);
			if (_navigator.HasArrived)
				CompletedObjective();
		}
	}
}