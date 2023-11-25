using UnityEngine;

public static class TextureExtensions
{
    public static void SaveToFile(this RenderTexture renderTexture, string filePath)
    {
        RenderTexture previous = RenderTexture.active;
        Texture2D tex = new Texture2D(renderTexture.width, renderTexture.height, TextureFormat.RGB24, false);
        RenderTexture.active = renderTexture;
        tex.ReadPixels(new Rect(0, 0, renderTexture.width, renderTexture.height), 0, 0);
        tex.Apply();

        byte[] bytes = tex.EncodeToPNG();
        
        if(Application.isPlaying)
            Object.Destroy(tex);
        else
            Object.DestroyImmediate(tex);
        RenderTexture.active = previous;
        System.IO.File.WriteAllBytes(filePath, bytes);
    }
}