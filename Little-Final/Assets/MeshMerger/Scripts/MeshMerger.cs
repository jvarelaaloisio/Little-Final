using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using System.Linq;

public class MeshMerger : MonoBehaviour
{
    [SerializeField] private Transform[] _mergeObjects;
    [SerializeField] private Transform _meshPivot;

    [Header("Save properties")]
    [SerializeField] private string _objectName = "MergedObject";
#if(UNITY_EDITOR)
    [SerializeField] private bool _saveMesh;
    [SerializeField] private string _savePath = "Assets/SavedMeshes";

    private MeshSaver _meshSaver = new MeshSaver();
#endif

    public void Merge()
    {
        Transform[] _meshesTransforms = GetTargetTranforms(_mergeObjects).Distinct().ToArray();
        Mesh[] meshes = new Mesh[_meshesTransforms.Length];
        meshes = _meshesTransforms.Select(transform => transform.GetComponent<MeshFilter>().sharedMesh).ToArray();

        Vector3[] vertices = new Vector3[0];
        int[] triangles = new int[0];
        Vector2[] uv = new Vector2[0];
        Vector4[] tangents = new Vector4[0];
        Vector3[] normals = new Vector3[0];

        List<SubMeshInfo> subMeshesInfo = new List<SubMeshInfo>();

        for (int meshIndex = 0; meshIndex < meshes.Length; meshIndex++)
        {
            Mesh currentMesh = meshes[meshIndex];
            Transform currentTransform = _meshesTransforms[meshIndex];
            Material[] meshMaterials = _meshesTransforms[meshIndex].GetComponent<MeshRenderer>().sharedMaterials;
            Vector3 meshLocalPosition = currentTransform.position - _meshPivot.position;
            //Vector3 globalScale = Vector3.Scale(currentTransform.localScale, 
            //    currentTransform.parent == null ? Vector3.one : GetGlobalScale(currentTransform.parent));

            Vector3 globalScale = GetGlobalScale(currentTransform);

            int subMeshCount = currentMesh.subMeshCount;
            SubMeshDescriptor[] subMeshDescriptors = new SubMeshDescriptor[subMeshCount];
            for (int i = 0; i < subMeshCount; i++) subMeshDescriptors[i] = currentMesh.GetSubMesh(i);

            for (int i = 0; i < meshMaterials.Length; i++)
            {
                List<Vector3> addedVertices = currentMesh.vertices
                    .ToList()
                    .GetRange(subMeshDescriptors[i].firstVertex, subMeshDescriptors[i].vertexCount)
                    .Select(verticle => RotateAndScaleVerticle(verticle, currentTransform.rotation,
                    globalScale, Vector3.zero) + meshLocalPosition)
                    .ToList();

                List<Vector2> addedUV = currentMesh.uv
                    .ToList()
                    .GetRange(subMeshDescriptors[i].firstVertex, subMeshDescriptors[i].vertexCount);

                List<Vector4> addedTangents = currentMesh.tangents
                    .ToList()
                    .GetRange(subMeshDescriptors[i].firstVertex, subMeshDescriptors[i].vertexCount)
                    .Select(tangent =>
                    {
                        Vector4 result = RotateAndScaleVerticle(tangent, currentTransform.rotation, Vector3.one, Vector3.zero);
                        result.w = tangent.w;
                        return result;
                    })
                    .ToList();

                List<Vector3> addedNormals = currentMesh.normals
                    .ToList()
                    .GetRange(subMeshDescriptors[i].firstVertex, subMeshDescriptors[i].vertexCount)
                    .Select(normal => RotateAndScaleVerticle(normal, currentTransform.rotation, Vector3.one, Vector3.zero))
                    .ToList();

                List<int> addedTriangleIndexes = currentMesh.triangles
                    .ToList()
                    .GetRange(subMeshDescriptors[i].indexStart, subMeshDescriptors[i].indexCount)
                    .Select(index => index - subMeshDescriptors[i].firstVertex)
                    .ToList();

                int subMeshInfoIndex = subMeshesInfo
                    .FindIndex(subMeshInfo => subMeshInfo.VerticesMaterial == meshMaterials[i]);
                if (subMeshInfoIndex == -1)
                {
                    subMeshesInfo.Add(new SubMeshInfo
                    {
                        Vertices = addedVertices,
                        UV = addedUV,
                        Tangents = addedTangents,
                        Normals = addedNormals,
                        TriangleIndexes = addedTriangleIndexes,
                        VerticesMaterial = meshMaterials[i]
                    });
                }
                else
                {
                    subMeshesInfo[subMeshInfoIndex].TriangleIndexes
                        .AddRange(addedTriangleIndexes
                        .Select(index => index + subMeshesInfo[subMeshInfoIndex].Vertices.Count));
                    subMeshesInfo[subMeshInfoIndex].Vertices.AddRange(addedVertices);
                    subMeshesInfo[subMeshInfoIndex].UV.AddRange(addedUV);
                    subMeshesInfo[subMeshInfoIndex].Tangents.AddRange(addedTangents);
                    subMeshesInfo[subMeshInfoIndex].Normals.AddRange(addedNormals);
                }
            }
        }

        Material[] materials = new Material[subMeshesInfo.Count];

        SubMeshDescriptor[] finalSubMeshDescriptors = new SubMeshDescriptor[subMeshesInfo.Count];

        for (int i = 0; i < subMeshesInfo.Count; i++)
        {
            materials[i] = subMeshesInfo[i].VerticesMaterial;
            int startVerticleIndex = vertices.Length;
            int startTrianglesIndex = triangles.Length;

            triangles = triangles
                .Concat(subMeshesInfo[i].TriangleIndexes
                .Select(index => index + vertices.Length))
                .ToArray();
            vertices = vertices
                .Concat(subMeshesInfo[i].Vertices)
                .ToArray();
            uv = uv
                .Concat(subMeshesInfo[i].UV)
                .ToArray();
            tangents = tangents
                .Concat(subMeshesInfo[i].Tangents)
                .ToArray();
            normals = normals
                .Concat(subMeshesInfo[i].Normals)
                .ToArray();

            finalSubMeshDescriptors[i] = new SubMeshDescriptor
            {
                firstVertex = startVerticleIndex,
                indexStart = startTrianglesIndex,
                vertexCount = subMeshesInfo[i].Vertices.Count,
                indexCount = subMeshesInfo[i].TriangleIndexes.Count,
            };
        }

        Mesh resultMesh = CreateMesh(vertices, triangles, uv, tangents, normals, finalSubMeshDescriptors);
        GameObject house = CreateGameObject(resultMesh, materials);

#if(UNITY_EDITOR)
        if (_saveMesh) _meshSaver.SaveMesh(resultMesh, _savePath);
#endif
    }

    private Vector3 RotateAndScaleVerticle(Vector3 verticle, Quaternion rotation, Vector3 scale, Vector3 pivot)
    {
        verticle = Vector3.Scale(verticle, scale);
        Vector3 pos = rotation * (verticle - pivot) + pivot;
        return pos;
    }

    private Vector3 Abs(Vector3 vector)
    {
        return new Vector3(Mathf.Abs(vector.x), Mathf.Abs(vector.y), Mathf.Abs(vector.z));
    }

    //private Vector3 GetGlobalScale(Transform transform)
    //{
    //    Vector3 scale = transform.rotation * transform.localScale;

    //    if (transform.parent == null)
    //        return Abs(scale);
    //    else return Vector3.Scale(Abs(scale), GetGlobalScale(transform.parent));
    //}
    private Vector3 GetGlobalScale(Transform transform)
    {
        if (transform.parent == null)
            return transform.localScale;
        else return Vector3.Scale(transform.localScale, GetGlobalScale(transform.parent));
    }

    private Transform[] GetTargetTranforms(Transform[] transforms)
    {
        List<Transform> result = new List<Transform>();
        for (int i = 0; i < transforms.Length; i++)
        {
            if (transforms[i].TryGetComponent(out MeshFilter meshFilter)) result.Add(transforms[i]);

            Transform[] children = new Transform[transforms[i].childCount];
            for (int t = 0; t < transforms[i].childCount; t++) children[t] = transforms[i].GetChild(t);
            result.AddRange(GetTargetTranforms(children));
        }

        return result.ToArray();
    }

    private Mesh CreateMesh(Vector3[] vertices, int[] triangles, Vector2[] uv, Vector4[] tangents, Vector3[] normals, SubMeshDescriptor[] subMeshDescriptors)
    {
        Mesh resultMesh = new Mesh();

        resultMesh.vertices = vertices;
        resultMesh.triangles = triangles;
        resultMesh.uv = uv;
        resultMesh.tangents = tangents;
        resultMesh.normals = normals;
        resultMesh.name = $"{_objectName}Mesh";
        resultMesh.subMeshCount = subMeshDescriptors.Length;
        for (int i = 0; i < subMeshDescriptors.Length; i++) resultMesh.SetSubMesh(i, subMeshDescriptors[i]);

        resultMesh.RecalculateBounds();

        return resultMesh;
    }

    private GameObject CreateGameObject(Mesh mesh, Material[] materials)
    {
        GameObject house = new GameObject(_objectName);
        house.AddComponent<MeshFilter>().sharedMesh = mesh;
        house.AddComponent<MeshRenderer>().sharedMaterials = materials;

        return house;
    }

    private struct SubMeshInfo
    {
        public List<Vector3> Vertices;
        public List<Vector2> UV;
        public List<Vector4> Tangents;
        public List<Vector3> Normals;
        public List<int> TriangleIndexes;
        public Material VerticesMaterial;
    }
}