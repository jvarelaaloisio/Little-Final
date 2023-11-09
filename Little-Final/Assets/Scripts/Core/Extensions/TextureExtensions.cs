using UnityEngine;

public static class TextureExtensions
{
    public static void SaveToFile(this RenderTexture renderTexture, string filePath)
    {
        Texture2D tex = new Texture2D(renderTexture.width, renderTexture.height, TextureFormat.RGB24, false);
        RenderTexture.active = renderTexture;
        //Reads pixels from the current render target
        tex.ReadPixels(new Rect(0, 0, renderTexture.width, renderTexture.height), 0, 0);
        //Copies changes you've made in a CPU texture to the GPU
        tex.Apply();

        byte[] bytes = tex.EncodeToPNG();
        
        if(Application.isPlaying)
            Object.Destroy(tex);
        else
            Object.DestroyImmediate(tex);

        System.IO.File.WriteAllBytes(filePath, bytes);
    }
}