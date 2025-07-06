namespace Core.References {
    public interface ISetup {
        public void Setup();
    }

    public interface ISetup<in T> {
        public void Setup(T data);
    }
}