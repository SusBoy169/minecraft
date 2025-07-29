using UnityEngine;

[CreateAssetMenu(fileName = "New Block", menuName = "Voxel/Block")]
public class Block : ScriptableObject
{
    public string blockName;
    public bool isSolid;
    public int textureID;
}
