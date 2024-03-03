using System.Collections;
using System.Linq;
using Core.Extensions;
using Missions;
using Missions.Implementations;
using UnityEngine;
using UnityEngine.UI;

namespace UI
{
    public class ItemIconsView : MonoBehaviour
    {
        [SerializeField] private Image iconPrefab;
        [SerializeField] private RectTransform iconParent;
        [SerializeField] private ItemMission mission;
        [Header("Animation")]
        [SerializeField] private Vector3 animatedIconOrigin;
        [SerializeField] private AnimationCurve movementAnimationCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);
        [SerializeField] private AnimationCurve scaleAnimationCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);
        [SerializeField] private RectTransform canvas;
        
        [Header("Icon customization")]
        [SerializeField] private Color iconColorOff = Color.black;
        [SerializeField] private Color iconColorOn = Color.white;
        
        private int _currentQuantity = 0;

        private void OnEnable()
        {
            mission.onMissionAdded += HandleMissionAdded;
            mission.onItemQtyChanged += HandleIconsChange;
        }

        private void HandleMissionAdded(Mission mission, int quantity)
        {
            iconParent.gameObject.SetActive(true);
            if (iconPrefab == null)
            {
                this.LogError($"{nameof(iconPrefab)} is null!");
                return;
            }

            for (int i = 0; i < quantity; i++)
            {
                var icon = Instantiate(iconPrefab, iconParent);
                icon.color = iconColorOff;
            }
        }

        private void OnDisable()
        {
            mission.onMissionAdded -= HandleMissionAdded;
            mission.onItemQtyChanged -= HandleIconsChange;
        }

        private void HandleIconsChange(int qty)
        {
            var quantityToAdd = qty - _currentQuantity;
            if (quantityToAdd > 0)
            {
                StartCoroutine(AddIcons(_currentQuantity, quantityToAdd));
            }

            _currentQuantity = qty;
        }

        private IEnumerator AddIcons(int currentQuantity, int quantityToAdd)
        {
            var animatedIcon = Instantiate(iconPrefab, transform);
            var animatedIconRect = animatedIcon.rectTransform;
            animatedIcon.color = iconColorOn;
            for (int i = 0; i < quantityToAdd; i++)
            {
                animatedIconRect.anchoredPosition = animatedIconOrigin;
                animatedIconRect.localScale = Vector3.zero;
                if (iconParent.childCount <= currentQuantity + i)
                {
                    this.LogWarning($"{nameof(iconParent)} doesn't have enough children (index was {currentQuantity + i})");
                    yield break;
                }

                var originScale = animatedIconRect.localScale;
                var target = iconParent.GetChild(currentQuantity + i);
                //Scale
                var start = Time.time;
                float now = 0;
                if (scaleAnimationCurve.keys.Length < 1)
                {
                    this.LogError($"{nameof(scaleAnimationCurve)} has no keys!");
                    yield break;
                }
                var duration = scaleAnimationCurve.keys.Last().time - scaleAnimationCurve.keys.First().time;
                do
                {
                    now = Time.time;
                    var lerp = (now - start) / duration;
                    animatedIconRect.localScale = Vector2.LerpUnclamped(originScale,
                                                               target.localScale,
                                                               scaleAnimationCurve.Evaluate(lerp));
                    yield return null;
                } while (now < start + duration);
                
                //Position
                var originPosition = animatedIconRect.anchoredPosition;
                var canvasDestination = canvas.InverseTransformPoint(target.position);
                var destination = canvasDestination;
                start = Time.time;
                now = 0;
                if (movementAnimationCurve.keys.Length < 1)
                {
                    this.LogError($"{nameof(movementAnimationCurve)} has no keys!");
                    yield break;
                }
                this.Log($"Moving {nameof(animatedIcon)} from {originPosition} to {destination}");
                duration = movementAnimationCurve.keys.Last().time - movementAnimationCurve.keys.First().time;
                do
                {
                    now = Time.time;
                    var lerp = (now - start) / duration;
                    animatedIconRect.anchoredPosition = Vector3.LerpUnclamped(originPosition,
                                                                              destination,
                                                                              movementAnimationCurve.Evaluate(lerp));
                    yield return null;
                } while (now < start + duration);

                if (target.TryGetComponent(out Image image))
                    image.color = iconColorOn;
                else
                    this.LogError($"{target.name} doesn't have an Image component!");
            }
            Destroy(animatedIcon);
        }
    }
}
