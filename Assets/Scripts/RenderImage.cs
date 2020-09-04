using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RenderImage : MonoBehaviour
{
    public Material screenMat;

    // Start is called before the first frame update
    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        if(screenMat != null) {
            Graphics.Blit(src, dest, screenMat);
        }
    }
}
