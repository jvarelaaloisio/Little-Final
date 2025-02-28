epublic class SpawnService
{
    public ISetup<T> Create (ISetup<T> prefab)
    {
        ISetup<T> instance;
        if(type is Monobehaviour or ScriptableObject)
        {
            instance = Object.Instantiate(prefab);
        }
    }
}