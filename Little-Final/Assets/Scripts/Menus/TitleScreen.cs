using Menus;
using Menus.Events;
using UnityEngine;

public class TitleScreen : MonoBehaviour
{
    public LevelDataContainerViaBuildIndexes levelOne;
    
    public void PlayGame() => GameSceneManager.Instance.LoadLevel(levelOne);

    public void QuitGame()
    {
#if UNITY_EDITOR
        if (Application.isPlaying)
        {
            UnityEditor.EditorApplication.isPlaying = false;
            return;
        }
#endif
        Application.Quit();
    }
}