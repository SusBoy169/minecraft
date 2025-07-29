using UnityEngine;

public class World : MonoBehaviour
{
    public GameObject chunkPrefab;
    public GameObject playerPrefab;

    void Start()
    {
        // Create a single chunk for now
        GameObject chunkGO = Instantiate(chunkPrefab, Vector3.zero, Quaternion.identity);
        Chunk chunk = chunkGO.GetComponent<Chunk>();
        chunk.Generate(0, 0);
        chunk.Draw();

        // Create the player
        Instantiate(playerPrefab, new Vector3(8, 30, 8), Quaternion.identity);
    }
}
