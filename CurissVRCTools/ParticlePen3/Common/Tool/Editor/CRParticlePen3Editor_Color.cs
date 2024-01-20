using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Animations;
using UnityEditor;
using UnityEditor.Animations;
using VRC.SDK3.Avatars.Components;
using VRC.SDK3.Avatars.ScriptableObjects;

namespace CRParticlePen3
{
    public partial class CRParticlePen3Editor : Editor
    {
        // 컬러 애니메이션 제작.
        private AnimationClip CreateColorAnimation(Color[] colors, string assetPath)
        {
            AnimationClip clip = new AnimationClip();
            AssetDatabase.CreateAsset(clip, assetPath);

            AnimationCurve curveR = new AnimationCurve();
            AnimationCurve curveG = new AnimationCurve();
            AnimationCurve curveB = new AnimationCurve();
            for (int i = 0; i < colors.Length; i++)
            {
                curveR.AddKey(new Keyframe(i, colors[i].r, float.PositiveInfinity, float.PositiveInfinity));
                curveG.AddKey(new Keyframe(i, colors[i].g, float.PositiveInfinity, float.PositiveInfinity));
                curveB.AddKey(new Keyframe(i, colors[i].b, float.PositiveInfinity, float.PositiveInfinity));
            }
            curveR.AddKey(new Keyframe(10, 1, float.PositiveInfinity, float.PositiveInfinity));
            curveG.AddKey(new Keyframe(10, 1, float.PositiveInfinity, float.PositiveInfinity));
            curveB.AddKey(new Keyframe(10, 1, float.PositiveInfinity, float.PositiveInfinity));

            EditorCurveBinding binding;
            string path;

            path = "ParticlePen3/PenPosition/Ink/InkDraw";
            binding = EditorCurveBinding.FloatCurve(path, typeof(ParticleSystem), "InitialModule.startColor.maxColor.r");
            AnimationUtility.SetEditorCurve(clip, binding, curveR);
            binding = EditorCurveBinding.FloatCurve(path, typeof(ParticleSystem), "InitialModule.startColor.maxColor.g");
            AnimationUtility.SetEditorCurve(clip, binding, curveG);
            binding = EditorCurveBinding.FloatCurve(path, typeof(ParticleSystem), "InitialModule.startColor.maxColor.b");
            AnimationUtility.SetEditorCurve(clip, binding, curveB);

            path = "ParticlePen3/PenPosition/Ink/InkPoint";
            binding = EditorCurveBinding.FloatCurve(path, typeof(ParticleSystemRenderer), "material._Color.r");
            AnimationUtility.SetEditorCurve(clip, binding, curveR);
            binding = EditorCurveBinding.FloatCurve(path, typeof(ParticleSystemRenderer), "material._Color.g");
            AnimationUtility.SetEditorCurve(clip, binding, curveG);
            binding = EditorCurveBinding.FloatCurve(path, typeof(ParticleSystemRenderer), "material._Color.b");
            AnimationUtility.SetEditorCurve(clip, binding, curveB);

            return clip;
        }

        // 컬러 텍스쳐 색상 변경.
        void SetTextureColor(Texture2D texture, Color color)
        {
            if (!texture) return;

            for (int x = 0; x < texture.width; x++)
            {
                for (int y = 0; y < texture.height; y++)
                {
                    texture.SetPixel(x, y, texture.GetPixel(x, y) * color);
                }
            }
            texture.Apply();
        }

        // 그라디언트 생성.
        Gradient CreateGradient(Color[] colors, int count)
        {
            // 그라디언트 작성.
            Gradient gradient = new Gradient();
            gradient.mode = GradientMode.Fixed;
            GradientColorKey[] colorKeys = new GradientColorKey[count];
            GradientAlphaKey[] alphaKeys = new GradientAlphaKey[2];

            for (int i = 0; i < count; i++)
            {
                colorKeys[i].color = colors[i];
                colorKeys[i].time = (1.0f / (count)) * (i+1);
            }

            alphaKeys[0].time = 0; alphaKeys[0].alpha = 1;
            alphaKeys[1].time = 1; alphaKeys[1].alpha = 1;

            gradient.SetKeys(colorKeys, alphaKeys);

            return gradient;
        }

        // 그래디언트 아이콘 생성.
        Texture2D CreateGradientIcon(Color[] color, int colorCount, string path, string name)
        {
            Texture2D colorDummy = targetScript.reference.colorDummy;
            Texture2D gradientDummy = targetScript.reference.gradientDummy;

            Texture2D tex = (Texture2D)CREditorUtility.CopyAsset(gradientDummy, path + "/Color/" + name + ".png");

            for (int y = 0; y < gradientDummy.width; y++)
            {
                for (int x = 0; x < gradientDummy.height; x++)
                {   
                    // 각도 계산.
                    float angle = (Mathf.Atan2(x - (tex.width/2), y - (tex.height / 2)) * 180.0f / Mathf.PI);
                    if (angle < 0)
                        angle = (angle + 360);

                    int num = Mathf.FloorToInt(angle / (360.0f / colorCount));

                    Color finalCol = color[num];
                    finalCol.a = tex.GetPixel(x, y).a;
                    tex.SetPixel(x, y, finalCol);
                }
            }
            tex.Apply();

            System.IO.File.WriteAllBytes(path + "/Color/" + name + ".png", tex.EncodeToPNG());
            AssetDatabase.ImportAsset(path + "/Color/" + name + ".png");

            return tex;
        }
    }
}