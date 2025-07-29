using UnityEngine;

public class Chunk : MonoBehaviour
{
    private MeshFilter meshFilter;
    private MeshRenderer meshRenderer;
    private MeshCollider meshCollider;

    public const int ChunkWidth = 16;
    public const int ChunkHeight = 256;
    public const int ChunkDepth = 16;

    private Block[,,] blocks = new Block[ChunkWidth, ChunkHeight, ChunkDepth];

    public void Generate(int chunkX, int chunkZ)
    {
        for (int x = 0; x < ChunkWidth; x++)
        {
            for (int z = 0; z < ChunkDepth; z++)
            {
                int worldX = chunkX * ChunkWidth + x;
                int worldZ = chunkZ * ChunkDepth + z;

                int height = (int)(Mathf.PerlinNoise(worldX * 0.015f, worldZ * 0.015f) * 10 + 20);

                for (int y = 0; y < ChunkHeight; y++)
                {
                    if (y == 0)
                    {
                        SetBlock(x, y, z, BlockDataManager.Instance.GetBlock("Bedrock"));
                    }
                    else if (y < height - 3)
                    {
                        SetBlock(x, y, z, BlockDataManager.Instance.GetBlock("Stone"));
                    }
                    else if (y < height)
                    {
                        SetBlock(x, y, z, BlockDataManager.Instance.GetBlock("Dirt"));
                    }
                    else if (y == height)
                    {
                        SetBlock(x, y, z, BlockDataManager.Instance.GetBlock("Grass"));
                    }
                    else
                    {
                        SetBlock(x, y, z, BlockDataManager.Instance.GetBlock("Air"));
                    }
                }
            }
        }
    }

    public void SetBlock(int x, int y, int z, Block block)
    {
        blocks[x, y, z] = block;
    }

    public Block GetBlock(int x, int y, int z)
    {
        if (x < 0 || x >= ChunkWidth || y < 0 || y >= ChunkHeight || z < 0 || z >= ChunkDepth)
        {
            return BlockDataManager.Instance.GetBlock("Air");
        }
        return blocks[x, y, z];
    }

    private void Awake()
    {
        meshFilter = gameObject.AddComponent<MeshFilter>();
        meshRenderer = gameObject.AddComponent<MeshRenderer>();
        meshCollider = gameObject.AddComponent<MeshCollider>();
    }

    public void Draw()
    {
        List<Vector3> vertices = new List<Vector3>();
        List<int> triangles = new List<int>();
        List<Vector2> uvs = new List<Vector2>();

        for (int y = 0; y < ChunkHeight; y++)
        {
            for (int x = 0; x < ChunkWidth; x++)
            {
                for (int z = 0; z < ChunkDepth; z++)
                {
                    Block block = GetBlock(x, y, z);
                    if (block != null && block.isSolid)
                    {
                        if (GetBlock(x, y + 1, z) == null || !GetBlock(x, y + 1, z).isSolid)
                            AddFace(vertices, triangles, uvs, new Vector3(x, y, z), Vector3.up, block.textureID);
                        if (GetBlock(x, y - 1, z) == null || !GetBlock(x, y - 1, z).isSolid)
                            AddFace(vertices, triangles, uvs, new Vector3(x, y, z), Vector3.down, block.textureID);
                        if (GetBlock(x + 1, y, z) == null || !GetBlock(x + 1, y, z).isSolid)
                            AddFace(vertices, triangles, uvs, new Vector3(x, y, z), Vector3.right, block.textureID);
                        if (GetBlock(x - 1, y, z) == null || !GetBlock(x - 1, y, z).isSolid)
                            AddFace(vertices, triangles, uvs, new Vector3(x, y, z), Vector3.left, block.textureID);
                        if (GetBlock(x, y, z + 1) == null || !GetBlock(x, y, z + 1).isSolid)
                            AddFace(vertices, triangles, uvs, new Vector3(x, y, z), Vector3.forward, block.textureID);
                        if (GetBlock(x, y, z - 1) == null || !GetBlock(x, y, z - 1).isSolid)
                            AddFace(vertices, triangles, uvs, new Vector3(x, y, z), Vector3.back, block.textureID);
                    }
                }
            }
        }

        Mesh mesh = new Mesh();
        mesh.vertices = vertices.ToArray();
        mesh.triangles = triangles.ToArray();
        mesh.uv = uvs.ToArray();
        mesh.RecalculateNormals();

        meshFilter.mesh = mesh;
        meshCollider.sharedMesh = mesh;
    }

    void AddFace(List<Vector3> vertices, List<int> triangles, List<Vector2> uvs, Vector3 pos, Vector3 dir, int textureID)
    {
        int vertexIndex = vertices.Count;

        Vector3[] faceVertices = new Vector3[4];
        Vector2[] faceUvs = new Vector2[4];

        float textureSize = 0.0625f;
        float u = (textureID % 16) * textureSize;
        float v = (textureID / 16) * textureSize;

        if (dir == Vector3.up)
        {
            faceVertices[0] = pos + new Vector3(0, 1, 0);
            faceVertices[1] = pos + new Vector3(0, 1, 1);
            faceVertices[2] = pos + new Vector3(1, 1, 1);
            faceVertices[3] = pos + new Vector3(1, 1, 0);
        }
        else if (dir == Vector3.down)
        {
            faceVertices[0] = pos + new Vector3(0, 0, 0);
            faceVertices[1] = pos + new Vector3(1, 0, 0);
            faceVertices[2] = pos + new Vector3(1, 0, 1);
            faceVertices[3] = pos + new Vector3(0, 0, 1);
        }
        else if (dir == Vector3.right)
        {
            faceVertices[0] = pos + new Vector3(1, 0, 0);
            faceVertices[1] = pos + new Vector3(1, 1, 0);
            faceVertices[2] = pos + new Vector3(1, 1, 1);
            faceVertices[3] = pos + new Vector3(1, 0, 1);
        }
        else if (dir == Vector3.left)
        {
            faceVertices[0] = pos + new Vector3(0, 0, 0);
            faceVertices[1] = pos + new Vector3(0, 0, 1);
            faceVertices[2] = pos + new Vector3(0, 1, 1);
            faceVertices[3] = pos + new Vector3(0, 1, 0);
        }
        else if (dir == Vector3.forward)
        {
            faceVertices[0] = pos + new Vector3(0, 0, 1);
            faceVertices[1] = pos + new Vector3(1, 0, 1);
            faceVertices[2] = pos + new Vector3(1, 1, 1);
            faceVertices[3] = pos + new Vector3(0, 1, 1);
        }
        else if (dir == Vector3.back)
        {
            faceVertices[0] = pos + new Vector3(0, 0, 0);
            faceVertices[1] = pos + new Vector3(0, 1, 0);
            faceVertices[2] = pos + new Vector3(1, 1, 0);
            faceVertices[3] = pos + new Vector3(1, 0, 0);
        }

        faceUvs[0] = new Vector2(u, v);
        faceUvs[1] = new Vector2(u, v + textureSize);
        faceUvs[2] = new Vector2(u + textureSize, v + textureSize);
        faceUvs[3] = new Vector2(u + textureSize, v);

        vertices.AddRange(faceVertices);
        triangles.Add(vertexIndex);
        triangles.Add(vertexIndex + 1);
        triangles.Add(vertexIndex + 2);
        triangles.Add(vertexIndex);
        triangles.Add(vertexIndex + 2);
        triangles.Add(vertexIndex + 3);
        uvs.AddRange(faceUvs);
    }
}
