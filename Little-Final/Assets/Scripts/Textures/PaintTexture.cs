using UnityEngine;
using UnityEngine.Rendering;

[System.Serializable]
public class PaintTexture
{
    public string id;
    public RenderTexture runTimeTexture;
    public RenderTexture paintedTexture;

    public CommandBuffer commandBuffer;

    private Material mPaintInUV;
    private Material mFixedEdges;
    private RenderTexture fixedIlsands;

    public PaintTexture(Color clearColor, int width, int height, string id,
                            Shader sPaintInUV, Mesh mToDraw, Shader fixIslandEdgesShader, RenderTexture markedIslands)
    {
        this.id = id;

        runTimeTexture = new RenderTexture(width, height, 0)
        {
            anisoLevel = 0,
            useMipMap = false,
            filterMode = FilterMode.Bilinear
        };

        paintedTexture = new RenderTexture(width, height, 0)
        {
            anisoLevel = 0,
            useMipMap = false,
            filterMode = FilterMode.Bilinear
        };


        fixedIlsands = new RenderTexture(paintedTexture.descriptor);

        var temp = RenderTexture.active;
        RenderTexture.active = runTimeTexture;
        Graphics.SetRenderTarget(runTimeTexture);
        //Clear the current render target (runtimeTexture)
        GL.Clear(false, true, clearColor);
        RenderTexture.active = paintedTexture;
        Graphics.SetRenderTarget(paintedTexture);
        GL.Clear(false, true, clearColor);
        RenderTexture.active = temp;


        mPaintInUV = new Material(sPaintInUV);
        if (!mPaintInUV.SetPass(0)) Debug.LogError("Invalid Shader Pass: ");
        mPaintInUV.SetTexture("_MainTex", paintedTexture);

        mFixedEdges = new Material(fixIslandEdgesShader);
        mFixedEdges.SetTexture("_IslandMap", markedIslands);
        mFixedEdges.SetTexture("_MainTex", paintedTexture);

        // ----------------------------------------------

        commandBuffer = new CommandBuffer();
        commandBuffer.name = "TexturePainting" + id;


        // Render to runtime text
        commandBuffer.SetRenderTarget(runTimeTexture);
        commandBuffer.DrawMesh(mToDraw, Matrix4x4.identity, mPaintInUV);

        // Fix UV island rifts (errors)
        commandBuffer.Blit(runTimeTexture, fixedIlsands, mFixedEdges);
        // Put fixed texture in runtime
        commandBuffer.Blit(fixedIlsands, runTimeTexture);
        // Put runtime in painted
        commandBuffer.Blit(runTimeTexture, paintedTexture);
    }

    public void SetActiveTexture(Camera mainC)
    {
        mainC.AddCommandBuffer(CameraEvent.AfterDepthTexture, commandBuffer);
    }

    public void SetInactiveTexture(Camera mainC)
    {
        mainC.RemoveCommandBuffer(CameraEvent.AfterDepthTexture, commandBuffer);
    }

    public void UpdateShaderParameters(Matrix4x4 localToWorld)
    {
        // Must be updated every time the mesh moves, and also at start
        mPaintInUV.SetMatrix("mesh_Object2World", localToWorld);
    }
}