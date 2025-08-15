namespace Core.References {
    public interface ISetup {
        public void Setup();
    }

    public interface ISetup<in T> {
        public void Setup(T data);
    }
    public interface ISetup<in T1, in T2> {
        public void Setup(T1 data1, T2 data2);
    }
}