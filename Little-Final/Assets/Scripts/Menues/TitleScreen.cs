using UnityEngine;

public class TitleScreen : MonoBehaviour
{
    public void PlayGame() => GameSceneManager.Instance.LoadGame();

    public void QuitGame() => Application.Quit();
}