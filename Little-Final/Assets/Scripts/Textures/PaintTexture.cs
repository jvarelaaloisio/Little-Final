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
    public RenderTexture fixedIslands;

    public PaintTexture(Color clearColor, int width, int height, string id,
                            Shader sPaintInUV, Mesh mToDraw, Shader fixIslandEdgesShader, RenderTexture markedIslands)
    {
        this.id = id;

        runTimeTexture = new RenderTexture(width, height, 0)
        {
            anisoLevel = 0,
        };

        paintedTexture = new RenderTexture(runTimeTexture.descriptor)
        {
            anisoLevel = 0,
        };

        fixedIslands = new RenderTexture(runTimeTexture.descriptor);

        Graphics.SetRenderTarget(runTimeTexture);
        //Clear the current render target (runtimeTexture)
        GL.Clear(false, true, clearColor);
        
        Graphics.SetRenderTarget(paintedTexture);
        GL.Clear(false, true, clearColor);

        mPaintInUV = new Material(sPaintInUV);
        if (!mPaintInUV.SetPass(0)) Debug.LogError("Invalid Shader Pass: ");
        mPaintInUV.SetTexture("_MainTex", paintedTexture);

        mFixedEdges = new Material(fixIslandEdgesShader);
        mFixedEdges.SetTexture("_IslandMap", markedIslands);
        mFixedEdges.SetTexture("_MainTex", paintedTexture);

        // ----------------------------------------------

        commandBuffer = new CommandBuffer();
        commandBuffer.name = "TexturePainting" + id;


        // Render to runtime texture
        commandBuffer.SetRenderTarget(runTimeTexture);
        commandBuffer.DrawMesh(mToDraw, Matrix4x4.identity, mPaintInUV);

        // Fix UV island rifts (errors)
        commandBuffer.Blit(runTimeTexture, fixedIslands, mFixedEdges);
        // Put fixed texture in runtime
        commandBuffer.Blit(fixedIslands, runTimeTexture);
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

    public void Release()
    {
        RenderTexture.active = null;
        runTimeTexture.Release();
        paintedTexture.Release();
        fixedIslands.Release();
    }
}