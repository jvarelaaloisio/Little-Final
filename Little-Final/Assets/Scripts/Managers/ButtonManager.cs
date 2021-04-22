using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ButtonManager : MonoBehaviour
{
    public int I_MainMenuIndex = 1,
        I_Level1Index = 2,
        I_CreditsIndex = 6;

    /// <summary>
    /// Loads Level 1
    /// </summary>
    public void Restart()
    {
        SceneManager.LoadScene(I_Level1Index);
    }

    /// <summary>
    /// Loads Main Menu
    /// </summary>
    public void GoToMainMenu()
    {
        SceneManager.LoadScene(I_MainMenuIndex);
    }

    /// <summary>
    /// Closes the Game
    /// </summary>
    public void ExitGame()
    {
        Application.Quit();
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif
    }

    /// <summary>
    /// Loads Credits Scene
    /// </summary>
    public void GoToCredits()
    {
        SceneManager.LoadScene(I_CreditsIndex);
    }

    //Gizmos
    private void OnDrawGizmos()
    {
        Gizmos.color = Color.blue;
        Gizmos.DrawSphere(transform.position, .5f);
    }
}
