using System.Collections.Generic;
using AI.DecisionTree;
using Core.Attributes;
using Core.Debugging;
using Core.Helpers;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.Serialization;

namespace Rideables
{
	public class RheaDecisionTree : MonoBehaviour
	{
		private const string DEBUG_TAG = "IA";

		[Header("Setup")]
		[SerializeField]
		[ExposeScriptableObject]
		private RheaModel rheaModel;

		[SerializeField]
		private Awareness awareness;

		[SerializeField]
		private NavMeshAgent agent;

		[FormerlySerializedAs("eatFruitId")]
		[Header("Decision result keys")]
		[SerializeField]
		private IdContainer eatFruitIdContainer;

		[FormerlySerializedAs("goToFruitId")] [SerializeField]
		private IdContainer goToFruitIdContainer;

		[FormerlySerializedAs("walkAwayFromPlayerId")] [SerializeField]
		private IdContainer walkAwayFromPlayerIdContainer;

		[FormerlySerializedAs("idleId")] [SerializeField]
		private IdContainer idleIdContainer;

		[FormerlySerializedAs("patrolId")] [SerializeField]
		private IdContainer patrolIdContainer;

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

		private DecisionTree<IdContainer> _decisionTree;

		private float _lastRecoverStart;

		private void OnValidate()
		{
			if (!awareness
				&& !TryGetComponent(out awareness))
				awareness = transform.GetComponentInChildren<Awareness>();
			if (!agent) TryGetComponent(out agent);
		}

		private void Awake()
		{
			#region Actions

			var eatFruit = new TreeAction<IdContainer>(eatFruitIdContainer);
			var goToFruit = new TreeAction<IdContainer>(goToFruitIdContainer);
			var walkAwayFromPlayer = new TreeAction<IdContainer>(walkAwayFromPlayerIdContainer);
			var idle = new TreeAction<IdContainer>(idleIdContainer);
			var patrol = new TreeAction<IdContainer>(patrolIdContainer);

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
			var isRecovering = new TreeQuestion(IsRecovering, idle, isAwareOfFruit);

			IQuestion[] questions = {roulette, isPlayerClose, canGetToFruit, canEatFruit, isAwareOfFruit, isRecovering};

			#endregion

			_decisionTree = new DecisionTree<IdContainer>(questions,
												actions,
												OnDecision,
												isRecovering,
												debugger)
							{
								Tag = DEBUG_TAG,
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

		public void StartRecovering()
		{
			_lastRecoverStart = Time.time;
		}

		private void OnDecision(IdContainer idContainer)
		{
			onDecision.Invoke(idContainer);
		}

		private bool IsPlayerClose()
		{
			Vector3 myPos = transform.position;
			return awareness.Player
					&& awareness.Player.position.y < myPos.y + rheaModel.HeightDifferenceToAllowPlayerMount;
		}

		private bool CanGetToFruit()
		{
			NavMeshPath path = new NavMeshPath();
			agent.CalculatePath(awareness.Fruit.position, path);
			return path.status == NavMeshPathStatus.PathComplete;
		}


		private bool IsRecovering()
		{
			var isRecovering = Time.time - _lastRecoverStart < rheaModel.RecoverTime;
			return isRecovering;
		}

		private bool IsAwareOfFruit()
		{
			return awareness.Fruit;
		}

		private bool CanEatFruit()
		{
			return Vector3.Distance(transform.position, awareness.Fruit.position) <= rheaModel.EatDistance;
		}

		private void OnDrawGizmosSelected()
		{
			if (!rheaModel)
				return;
			Gizmos.color = new Color(1, .0f, .0f, 1f);
			Gizmos.DrawRay(transform.position, Vector3.up * rheaModel.HeightDifferenceToAllowPlayerMount);
		}
		
	}
}