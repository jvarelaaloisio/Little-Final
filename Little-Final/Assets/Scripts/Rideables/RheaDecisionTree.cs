using System.Collections.Generic;
using AI.DecisionTree;
using Core.Debugging;
using Core.Extensions;
using Core.Helpers;
using UnityEngine;
using UnityEngine.AI;

namespace Rideables
{
	public class RheaDecisionTree : MonoBehaviour
	{
		[Header("Setup")]
		[SerializeField]
		private RheaModel rheaModel;

		[SerializeField]
		private Awareness awareness;
		
		[SerializeField]
		private NavMeshAgent agent;

		[Header("Decision result keys")]
		[SerializeField]
		private Id eatFruitId;

		[SerializeField]
		private Id goToFruitId;

		[SerializeField]
		private Id walkAwayFromPlayerId;

		[SerializeField]
		private Id idleId;

		[SerializeField]
		private Id patrolId;

		[Header("Roulette Chances")]
		[SerializeField]
		private int idleChance;

		[SerializeField]
		private int patrolChance;

		[Header("Events")]
		[SerializeField]
		private IdUnityEvent onDecision;

		[Header("Debug")]
		[SerializeField]
		private Debugger debugger;

		[SerializeField]
		private bool logRepeatedResponsesOnDecisionTree;

		private DecisionTree<Id> _decisionTree;
		
		private string DebugTag => name + " (IA)";

		private void OnValidate()
		{
			// if (!awareness) awareness = GetComponent<Awareness>();
			if (!awareness
				&& !TryGetComponent(out awareness))
				awareness = transform.GetComponentInChildren<Awareness>();
			if (!agent) TryGetComponent(out agent);
		}

		private void Awake()
		{
			#region Actions

			var eatFruit = new TreeAction<Id>(eatFruitId);
			var goToFruit = new TreeAction<Id>(goToFruitId);
			var walkAwayFromPlayer = new TreeAction<Id>(walkAwayFromPlayerId);
			var idle = new TreeAction<Id>(idleId);
			var patrol = new TreeAction<Id>(patrolId);

			var actions = new[] {eatFruit, goToFruit, walkAwayFromPlayer, idle, patrol};

			#endregion

			#region Questions

			Dictionary<INode, int> rouletteDictionary = new Dictionary<INode, int>()
														{
															{idle, idleChance},
															{patrol, patrolChance},
														};
			var roulette = new TreeRoulette(rouletteDictionary);
			var isPlayerClose = new TreeQuestion(IsPlayerClose, walkAwayFromPlayer, roulette);
			var canGetToFruit = new TreeQuestion(CanGetToFruit, goToFruit, isPlayerClose);
			var canEatFruit = new TreeQuestion(CanEatFruit, eatFruit, canGetToFruit);
			var isAwareOfFruit = new TreeQuestion(IsAwareOfFruit, canEatFruit, isPlayerClose);

			IQuestion[] questions = {roulette, isPlayerClose, canGetToFruit, canEatFruit, isAwareOfFruit};

			#endregion

			_decisionTree = new DecisionTree<Id>(questions,
												actions,
												onDecision.Invoke,
												isAwareOfFruit, debugger)
							{
								Tag = DebugTag,
								LogRepeatedResponses = logRepeatedResponsesOnDecisionTree,
								LogTrace = true,
							};
		}

		[ContextMenu("Run Decision Tree")]
		public void RunDecisionTree()
		{
#if UNITY_EDITOR
			if (!Application.isPlaying)
			{
				Awake();
				_decisionTree.LogTrace = true;
			}
#endif
			_decisionTree.RunTree();
		}

		private bool IsPlayerClose()
		{
			Vector3 myPos = transform.position;
			Vector3 playerPos;
			return awareness.Player
					&& (playerPos = awareness.Player.position).y < myPos.y;
			// && (playerPos - myPos).IgnoreY().magnitude <= rheaModel.FleeDistance;
		}

		private bool CanGetToFruit()
		{
			NavMeshPath path = new NavMeshPath();
			agent.CalculatePath(awareness.Fruit.position, path);
			return path.status == NavMeshPathStatus.PathComplete;
		}

		private bool IsAwareOfFruit()
		{
			return awareness.Fruit;
		}

		private bool CanEatFruit()
		{
			return Vector3.Distance(transform.position, awareness.Fruit.position) <= rheaModel.EatDistance;
		}
	}
}