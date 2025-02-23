namespace Acting {
    public interface ISetup {
        public void Setup();
    }

    public interface ISetup<in T> {
        public void Setup(T data);
    }
}