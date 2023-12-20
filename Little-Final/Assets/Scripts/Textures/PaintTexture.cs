using UnityEngine;
using UnityEngine.Rendering;

[System.Serializable]
public class PaintTexture
{
    public string id;
    public RenderTexture runTimeTexture;
    public RenderTexture paintedTexture;
    public RenderTexture fixedIslands;

    public CommandBuffer commandBuffer;

    private Material _mPaintInUV;
    private Material _mFixedEdges;
    private readonly Mesh _mesh;

    public PaintTexture(Color clearColor, int width, int height, string id,
                            Shader sPaintInUV, Mesh mesh, Shader fixIslandEdgesShader, RenderTexture markedIslands)
    {
        this.id = id;
        _mesh = mesh;

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

        _mPaintInUV = new Material(sPaintInUV);
        if (!_mPaintInUV.SetPass(0)) Debug.LogError("Invalid Shader Pass: ");
        _mPaintInUV.SetTexture("_MainTex", paintedTexture);

        _mFixedEdges = new Material(fixIslandEdgesShader);
        _mFixedEdges.SetTexture("_IslandMap", markedIslands);
        _mFixedEdges.SetTexture("_MainTex", paintedTexture);

        // ----------------------------------------------

        commandBuffer = new CommandBuffer();
        commandBuffer.name = "TexturePainting" + id;

        // Render to runtime texture
        commandBuffer.SetRenderTarget(runTimeTexture);
        commandBuffer.DrawMesh(_mesh, Matrix4x4.identity, _mPaintInUV);

        BaseBlit();
    }

    public void Blit(Texture baseTexture)
    {
        Graphics.Blit(baseTexture, runTimeTexture);
        Graphics.Blit(runTimeTexture, paintedTexture);
    }

    private void BaseBlit()
    {
        // Fix UV island rifts (errors)
        commandBuffer.Blit(runTimeTexture, fixedIslands, _mFixedEdges);
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
        _mPaintInUV.SetMatrix("mesh_Object2World", localToWorld);
    }

    public void Release()
    {
        RenderTexture.active = null;
        if(runTimeTexture)
            runTimeTexture.Release();
        if(paintedTexture)
            paintedTexture.Release();
        if(fixedIslands)
            fixedIslands.Release();
    }
}