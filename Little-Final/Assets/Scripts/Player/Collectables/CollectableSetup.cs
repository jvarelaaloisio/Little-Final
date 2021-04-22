using System;
using Core.Extensions;
using UnityEngine;
using VarelaAloisio.UpdateManagement.Runtime;

namespace Player.Collectables
{
	public class CollectableSetup
	{
		private readonly ActionOverTime _setupAction;
		private readonly CollectableRotator _collectable;
		private readonly Transform _collectableTransform;

		private readonly Vector3 _originPosition,
			_originScale,
			_objectiveScale;

		private readonly Quaternion _originRotation;

		private readonly Action _onFinishCallBack;

		public CollectableSetup(
			CollectableRotator collectable,
			Transform pivot,
			Vector3 objectiveScale,
			float setupTime,
			Action onFinishCallBack,
			int sceneIndex)
		{
			_collectable = collectable;
			_collectable.pivot = pivot;
			_onFinishCallBack = onFinishCallBack;
			_objectiveScale = objectiveScale;
			_collectableTransform = _collectable.transform;
			_originPosition = _collectableTransform.position;
			_originRotation = _collectableTransform.rotation;
			_originScale = _collectableTransform.localScale;
			_setupAction = new ActionOverTime(
				setupTime,
				Setup,
				FinishSetup,
				sceneIndex,
				true);
		}

		public void StartSetup()
			=> _setupAction.StartAction();

		private void Setup(float lerp) =>
			_collectableTransform.Lerp(
				_originPosition,
				_collectable.GetPosition(0),
				_originRotation,
				_collectable.pivot.rotation,
				_originScale,
				_objectiveScale,
				BezierHelper.GetSinBezier(lerp));

		private void FinishSetup()
		{
			_collectable.enabled = true;
			_onFinishCallBack();
		}
	}
}