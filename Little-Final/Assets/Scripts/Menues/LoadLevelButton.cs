using Events.Channels;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Button))]
public class LoadLevelButton : MonoBehaviour
{
    public string sceneToLoad;
    public StringEventChannel sceneDataChannel;

    private Button Button
    {
        get
        {
            if (_button != null) return _button;
            _button = GetComponent<Button>();
            return _button;
        }
    }

    private  Button _button;

    private void OnEnable()
    {
        Button.onClick.AddListener(RaiseEvent);
    }

    private void OnDisable()
    {
        Button.onClick.RemoveListener(RaiseEvent);
    }

    private void RaiseEvent()
    {
        sceneDataChannel.RaiseEvent(sceneToLoad);
    }
}
