using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;

namespace CRParticlePen3
{
    public class CREditorUtility : Editor
    {
        // 스크립트 파일 경로
        public static string GetScriptPath([System.Runtime.CompilerServices.CallerFilePath] string sourceFilePath = "")
        {
            string fullPath = System.IO.Path.GetDirectoryName(sourceFilePath);

            int rootIndex = fullPath.IndexOf(@"Assets\");
            if (rootIndex > -1)
            {
                return fullPath.Substring(rootIndex, fullPath.Length - rootIndex);
            }

            return null;
        }

        // 폴더 생성.
        public static void CreateFolders(string path)
        {
            if (AssetDatabase.IsValidFolder(path))
                return;

            string parent = System.IO.Path.GetDirectoryName(path);
            string child = System.IO.Path.GetFileName(path);
            CreateFolders(parent);
            AssetDatabase.CreateFolder(parent, child);
        }

        // 게임오브젝트 이름으로 찾기.
        public static GameObject FindGameobjectName(GameObject parent, string name)
        {
            if (!parent)
                return null;

            Transform[] objects = parent.GetComponentsInChildren<Transform>(true);
            for (int i = 0; i < objects.Length; i++)
            {
                if (objects[i].name.Equals(name))
                {
                    return objects[i].gameObject;
                }
            }

            return null;
        }

        // 게임 오브젝트 경로 찾기.
        public static string GetGameObjectPath(Transform transform)
        {
            string path = transform.name;
            transform = transform.parent;

            if (transform == null)
                return "";

            while (transform.parent != null)
            {
                path = transform.name + "/" + path;
                transform = transform.parent;
            }
            return path;
        }

        // 프리펩 해제.
        public static void UnpackPrefab(GameObject target)
        {
            if (PrefabUtility.IsAnyPrefabInstanceRoot(target))
            {
                PrefabUtility.UnpackPrefabInstance(target, PrefabUnpackMode.Completely, InteractionMode.UserAction);
            }
        }

        // 에셋 제작.
        public static Object CreateAsset(Object source, string path)
        {
            AssetDatabase.CreateAsset(source, path);
            Object asset = AssetDatabase.LoadAssetAtPath<Object>(path);

            return asset ? asset : null;
        }

        // 에셋 복사.
        public static Object CopyAsset(Object source, string path)
        {
            if (!source)
                return null;

            string assetPath = AssetDatabase.GetAssetPath(source);

            return CopyAsset(assetPath, path);
        }
        public static Object CopyAsset(string source, string path)
        {
            if (AssetDatabase.CopyAsset(source, path))
            {
                return AssetDatabase.LoadAssetAtPath<Object>(path);
            }

            return null;
        }

        // 백업 생성.
        public static string MakeBackup(Object target, string folderNanme)
        {
            string path = AssetDatabase.GetAssetPath(target);
            string directory = Path.GetDirectoryName(path);
            string name = Path.GetFileName(path);

            string backupPath = directory + "/" + folderNanme + "/" + name;

            CreateFolders(Path.GetDirectoryName(backupPath));
            CopyAsset(target, backupPath);

            return backupPath;
        }

        // GUI Line 그리기.
        public static void GuiLine(int i_height = 1, int padding = 5)
        {
            GUILayout.Space(padding);
            Rect rect = EditorGUILayout.GetControlRect(false, i_height);
            rect.height = i_height;
            EditorGUI.DrawRect(rect, new Color(0.5f, 0.5f, 0.5f, 1));
            GUILayout.Space(padding);
        }

        // 타이틀 이미지.
        public static void TitleTexture(Texture2D background, Texture2D content)
        {
            if (background || content)
            {
                Rect rect = EditorGUILayout.GetControlRect(false, GUILayout.Height(70));

                if (background)
                    GUI.DrawTexture(rect, background, ScaleMode.ScaleAndCrop);

                if (content)
                    GUI.DrawTexture(rect, content, ScaleMode.ScaleToFit);
            }
        }
    }
}