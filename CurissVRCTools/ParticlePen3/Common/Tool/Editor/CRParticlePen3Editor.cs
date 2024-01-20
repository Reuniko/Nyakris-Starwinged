using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Animations;
using UnityEditor;
using UnityEditor.Animations;
using VRC.SDK3.Avatars.Components;
using VRC.SDK3.Avatars.ScriptableObjects;
using UnityEditor.EditorTools;


namespace CRParticlePen3
{
    [CustomEditor(typeof(Pen3Script))]
    public partial class CRParticlePen3Editor : Editor
    {
        Pen3Script targetScript { get { return (Pen3Script)target; } }
        int toolbar = 0;

        public void OnEnable()
        {
            CREditorUtility.UnpackPrefab(targetScript.gameObject);
        }

        public override void OnInspectorGUI()
        {
            // 툴바.
            toolbar = GUILayout.Toolbar(toolbar, new string[2] { "Main", "Color" });

            GUILayout.Space(3);

            // 타이틀.
            CREditorUtility.TitleTexture(targetScript.reference.TitleBG, targetScript.reference.TitleContent);

            CREditorUtility.GuiLine();

            if (toolbar == 0)
            {
                // 아바타.
                EditorGUILayout.PropertyField(serializedObject.FindProperty("avatar"));

                // Ink 위치.
                EditorGUILayout.PropertyField(serializedObject.FindProperty("InkTarget"));

                CREditorUtility.GuiLine();

                // 펜 오브젝트.
                EditorGUILayout.PropertyField(serializedObject.FindProperty("penObject"));

                CREditorUtility.GuiLine();

                // 왼손, 오른손.
                EditorGUILayout.PropertyField(serializedObject.FindProperty("hand"));

                // 펜 사이즈.
                EditorGUILayout.PropertyField(serializedObject.FindProperty("penSize"));

                CREditorUtility.GuiLine();

                // Write Default.
                EditorGUILayout.PropertyField(serializedObject.FindProperty("writeDefault"));
            }
            else
            {

                // 팔레트 갯수.
                targetScript.paletteCount = EditorGUILayout.IntSlider("Palette Count", targetScript.paletteCount, 1, 8);

                // 컬러 메뉴.
                for (int i = 0; i < targetScript.paletteCount; i++)
                {

                    CREditorUtility.GuiLine();
                    Palette palette = targetScript.paletteList[i];

                    palette.colorCount = EditorGUILayout.IntSlider("Color Count", palette.colorCount, 1, 8);
                    for (int j = 0; j < palette.colorCount; j++)
                    {
                        palette.color[j] = EditorGUILayout.ColorField(new GUIContent("Color " + (j + 1)), palette.color[j], true, false, false);
                        palette.color[j].a = 1;
                    }
                }
            }

            CREditorUtility.GuiLine();

            serializedObject.ApplyModifiedProperties();


            

            // 적용 버튼.
            EditorGUI.BeginDisabledGroup(ErrorCheck());            
            if (GUILayout.Button("Apply"))
            {
                // 스크립트 위치 변경.
                if (targetScript.transform.GetComponentInParent<VRCAvatarDescriptor>() != null)
                    targetScript.transform.parent = null;

                // 폴더 생성.
                string dataPath = GetDataPath();
                CREditorUtility.CreateFolders(dataPath);
                CREditorUtility.CreateFolders(dataPath + "/Color");

                // 기존 데이터 제거.
                Remove();

                // Prefab 적용.
                ApplyPrefab();

                // FX 적용.
                ApplyFX();

                // 메뉴 적용.
                ApplayMenu();

                // 파라미터 적용.
                ApplyParameters();
            }
            EditorGUI.EndDisabledGroup();
        }

        // 에러 체크.
        bool ErrorCheck()
        {
            bool result = false;

            // 레퍼런스.
            if (!this.targetScript.reference)
            {
                EditorGUILayout.HelpBox("Reference Prefab not found", MessageType.Error);
                return true;
            }

            // 파일 루트.
            if (!this.targetScript.reference.root)
            {
                EditorGUILayout.HelpBox("Root not found", MessageType.Error);
                result = true;

                result = true;
            }

            // 아바타.
            if (!this.targetScript.avatar)
            {
                EditorGUILayout.HelpBox("Avatar not found", MessageType.Error);
                result = true;
            }

            // 잉크 타겟.
            if (!this.targetScript.InkTarget)
            {
                EditorGUILayout.HelpBox("Ink target not found", MessageType.Error);
                result = true;
            }

            // 메뉴 빈칸.
            if (this.targetScript.avatar && this.targetScript.avatar.expressionsMenu)
            {
                if (this.targetScript.avatar.expressionsMenu.controls.Count >= VRCExpressionsMenu.MAX_CONTROLS)
                {
                    EditorGUILayout.HelpBox("Menu is full", MessageType.Error);
                    result = true;
                }
            }

            // 파라미터 빈칸.
            if (targetScript.avatar && targetScript.avatar.expressionParameters && !CR_VRCMenuUtility.CheckParameterCount(this.targetScript.avatar.expressionParameters, targetScript.reference.param))
            {
                EditorGUILayout.HelpBox(
                    CR_VRCMenuUtility.CountRequireParam(this.targetScript.avatar.expressionParameters, targetScript.reference.param)
                    + " parameters are required", MessageType.Error);

                result = true;
            }

            return result;
        }

        // Gizmo.
        [DrawGizmo(GizmoType.Selected | GizmoType.Active)]
        static void DrawGizmo(Pen3Script script, GizmoType gizmoType)
        {

            Texture2D colorIcon = script.reference.colorDummy;
            Gizmos.DrawSphere(script.transform.position, script.penSize);
            
        }
    }
}
