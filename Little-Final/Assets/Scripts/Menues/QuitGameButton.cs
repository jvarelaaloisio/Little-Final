using Events.Channels;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Button))]
public class QuitGameButton : MonoBehaviour
{
    public VoidChannelSo quitGameChannel;

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
        quitGameChannel.RaiseEvent();
    }
}