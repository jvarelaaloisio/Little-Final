using UnityEngine;

public class TitleScreen : MonoBehaviour
{
    public LevelDataContainer levelOne;
    
    public void PlayGame() => GameSceneManager.Instance.LoadLevel(levelOne.name);

    public void QuitGame() => Application.Quit();
}