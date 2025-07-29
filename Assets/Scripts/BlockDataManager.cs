using System.Collections.Generic;
using UnityEngine;

public class BlockDataManager : MonoBehaviour
{
    public static BlockDataManager Instance;

    public Block[] blocks;

    private Dictionary<string, Block> blockDictionary = new Dictionary<string, Block>();

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else
        {
            Destroy(gameObject);
        }

        foreach (Block block in blocks)
        {
            blockDictionary[block.blockName] = block;
        }
    }

    public Block GetBlock(string blockName)
    {
        if (blockDictionary.ContainsKey(blockName))
        {
            return blockDictionary[blockName];
        }
        return null;
    }
}
