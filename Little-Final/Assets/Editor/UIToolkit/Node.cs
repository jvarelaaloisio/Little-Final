using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor.Experimental.GraphView;
using UnityEngine;
using UnityEngine.UIElements;
using Cursor = UnityEngine.Cursor;

namespace Editor.UIToolkit
{
    public class Node : PointerManipulator
    {
        [Serializable]
        public class Data
        {
            [field: SerializeField] public Texture2D GrabCursor { get; set; }
            [field: SerializeField] public string Title { get; set; } = "Title";
            [field: SerializeField] public object targetObject { get; set; }
        }

        private readonly Data _data;

        public Node(VisualElement target, VisualElement root, Data data)
        {
            this.target = target;
            this.Root = root;
            _data = data;
        }

        private Vector2 TargetStartPosition { get; set; }

        private Vector3 PointerStartPosition { get; set; }

        private bool Enabled { get; set; }

        private VisualElement Root { get; }

        public async void SetupGUI()
        {
            if (target == null)
                return;
            if (target.TryFindChild("title", out TextElement title))
                title.text = _data.Title;
            if (target.TryFindChild("properties", out ListView properties)
                && properties.TryFindChild("unity-content-container", out VisualElement content))
            {
                //properties.hierarchy.Add(new BlackboardField(););
                // var labelType = TryGetFieldOfType<string>().FirstOrDefault();
                // if (labelType != null)
                // {
                //     var constructorInfo = labelType.GetConstructor(Type.EmptyTypes);
                //     var textField = (VisualElement)constructorInfo.Invoke(Array.Empty<object>());
                //     properties.hierarchy.Add(textField);
                // }

                foreach (var field in _data.targetObject
                                           .GetType()
                                           .GetFields(BindingFlags.Default
                                                      | BindingFlags.Instance
                                                      | BindingFlags.Public
                                                      | BindingFlags.NonPublic))
                {
                    var attribute = field.GetCustomAttribute<SerializeInNodeAttribute>();
                    if (attribute is { FieldType: not null }
                        && typeof(VisualElement).IsAssignableFrom(attribute.FieldType))
                    {
                        var baseField = Activator.CreateInstance(attribute.FieldType);
                        //Let's assume the field type inherits from baseField
                        var labelProperty = attribute.FieldType.GetProperty("label");
                        if (labelProperty != null)
                        {
                            labelProperty.SetValue(baseField, field.Name);
                        }
                        var valueProperty = attribute.FieldType.GetProperty("value");
                        if (valueProperty != null)
                        {
                            valueProperty.SetValue(baseField, field.GetValue(_data.targetObject));
                        }
                        var visualElement = baseField as VisualElement;
                        visualElement.name = _data.targetObject.GetType().Name + "." + field.Name;
                        content?.Add(visualElement);
                    }
                }
                // properties.hierarchy.Add(new TextField());
            }
        }

        public static IEnumerable<Type> TryGetFieldOfType<T>()
        {
            // Get the assembly where BaseField<> is defined
            var assembly = typeof(BaseField<>).Assembly;

            // Get all types in the assembly
            var allTypes = assembly.GetTypes();

            // Filter types that inherit from BaseField<>
            var labelFieldTypes = allTypes.Where(t =>
                !t.IsAbstract
                && t.BaseType is { IsGenericType: true });
            var inheritors = labelFieldTypes.Where(t => t.InheritsFrom(typeof(BaseField<>)));

            var castedTypes = inheritors.Where(t => t.BaseType.GetGenericArguments().FirstOrDefault() == typeof(T));
            return castedTypes;
        }

        protected override void RegisterCallbacksOnTarget()
        {
            target.RegisterCallback<PointerDownEvent>(PointerDownHandler);
            target.RegisterCallback<PointerMoveEvent>(PointerMoveHandler);
            target.RegisterCallback<PointerUpEvent>(PointerUpHandler);
            target.RegisterCallback<PointerCaptureOutEvent>(PointerCaptureOutHandler);
        }

        protected override void UnregisterCallbacksFromTarget()
        {
            target.UnregisterCallback<PointerDownEvent>(PointerDownHandler);
            target.UnregisterCallback<PointerMoveEvent>(PointerMoveHandler);
            target.UnregisterCallback<PointerUpEvent>(PointerUpHandler);
            target.UnregisterCallback<PointerCaptureOutEvent>(PointerCaptureOutHandler);
        }

        // This method stores the starting position of target and the pointer,
        // makes target capture the pointer, and denotes that a drag is now in progress.
        private void PointerDownHandler(PointerDownEvent evt)
        {
            TargetStartPosition = target.transform.position;
            PointerStartPosition = evt.position;
            target.CapturePointer(evt.pointerId);
            Cursor.SetCursor(_data.GrabCursor, Vector2.zero, CursorMode.Auto);
            Enabled = true;
        }

        // This method checks whether a drag is in progress and whether target has captured the pointer.
        // If both are true, calculates a new position for target within the bounds of the window.
        private void PointerMoveHandler(PointerMoveEvent evt)
        {
            if (Enabled && target.HasPointerCapture(evt.pointerId))
            {
                Vector3 pointerDelta = evt.position - PointerStartPosition;
                target.transform.position =
                    new Vector2(
                        Mathf.Clamp(TargetStartPosition.x + pointerDelta.x, 0, target.panel.visualTree.worldBound.width),
                        Mathf.Clamp(TargetStartPosition.y + pointerDelta.y, 0, target.panel.visualTree.worldBound.height));
            }
        }

        // This method checks whether a drag is in progress and whether target has captured the pointer.
        // If both are true, makes target release the pointer.
        private void PointerUpHandler(PointerUpEvent evt)
        {
            if (Enabled && target.HasPointerCapture(evt.pointerId))
            {
                target.ReleasePointer(evt.pointerId);
            }
        }

        // This method checks whether a drag is in progress. If true, queries the root
        // of the visual tree to find all slots, decides which slot is the closest one
        // that overlaps target, and sets the position of target so that it rests on top
        // of that slot. Sets the position of target back to its original position
        // if there is no overlapping slot.
        private void PointerCaptureOutHandler(PointerCaptureOutEvent evt)
        {
            if (Enabled)
            {
                VisualElement slotsContainer = target.parent;
                UQueryBuilder<VisualElement> allSlots = slotsContainer.Query<VisualElement>(className: "slot");
                UQueryBuilder<VisualElement> overlappingSlots = allSlots.Where(OverlapsTarget);
                VisualElement closestOverlappingSlot = FindClosestSlot(overlappingSlots);
                Vector3 closestPos = Vector3.zero;
                if (closestOverlappingSlot != null)
                {
                    closestPos = RootSpaceOfSlot(closestOverlappingSlot);
                    closestPos = new Vector2(closestPos.x - 5, closestPos.y - 5);
                }

                if (closestOverlappingSlot != null)
                    target.transform.position = closestPos;
                Enabled = false;
            }
        }

        private bool OverlapsTarget(VisualElement slot)
            => target.worldBound.Overlaps(slot.worldBound);

        private VisualElement FindClosestSlot(UQueryBuilder<VisualElement> slots)
        {
            List<VisualElement> slotsList = slots.ToList();
            float bestDistanceSq = float.MaxValue;
            VisualElement closest = null;
            foreach (VisualElement slot in slotsList)
            {
                Vector3 displacement = RootSpaceOfSlot(slot) - target.transform.position;
                float distanceSq = displacement.sqrMagnitude;
                if (distanceSq < bestDistanceSq)
                {
                    bestDistanceSq = distanceSq;
                    closest = slot;
                }
            }

            return closest;
        }

        private Vector3 RootSpaceOfSlot(VisualElement slot)
        {
            Vector2 slotWorldSpace = slot.parent.LocalToWorld(slot.layout.position);
            return Root.WorldToLocal(slotWorldSpace);
        }
    }
}