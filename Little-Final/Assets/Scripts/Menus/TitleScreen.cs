using Events;
using Menus;
using Menus.Events;
using UnityEngine;

public class TitleScreen : MonoBehaviour
{
    public LevelDataContainerViaBuildIndexes levelOne;
    
    public void PlayGame() => GameSceneManager.Instance.LoadLevel(levelOne);

    public void QuitGame() => Application.Quit();
}