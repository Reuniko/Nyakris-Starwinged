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
        // Prefab 생성.
        void ApplyPrefab()
        {
            // 프리펩 생성.
            GameObject penPrefab = GameObject.Instantiate(targetScript.reference.PenPrefab, Vector3.zero, Quaternion.Euler(Vector3.zero));
            penPrefab.transform.parent = targetScript.avatar.transform;
            penPrefab.name = targetScript.reference.PenPrefab.name;

            // 타겟 연결.
            Transform inkTracking = penPrefab.transform.Find("InkTracking");
            PositionConstraint positionConstraint = inkTracking.GetComponent<PositionConstraint>();
            RotationConstraint rotationConstraint = inkTracking.GetComponent<RotationConstraint>();
            Animator animator = targetScript.avatar.GetComponent<Animator>();

            Transform sourceTarget;

            // Left Hand.
            sourceTarget = animator.GetBoneTransform(HumanBodyBones.LeftHand);
            positionConstraint.AddSource(SetConstraintSource(sourceTarget, 0));
            rotationConstraint.AddSource(SetConstraintSource(sourceTarget, 0));

            // Right Hand.
            sourceTarget = animator.GetBoneTransform(HumanBodyBones.RightHand);
            positionConstraint.AddSource(SetConstraintSource(sourceTarget, 0));
            rotationConstraint.AddSource(SetConstraintSource(sourceTarget, 0));

            // Left Foot.
            sourceTarget = animator.GetBoneTransform(HumanBodyBones.LeftFoot);
            positionConstraint.AddSource(SetConstraintSource(sourceTarget, 0));
            rotationConstraint.AddSource(SetConstraintSource(sourceTarget, 0));

            // Right Foot.
            sourceTarget = animator.GetBoneTransform(HumanBodyBones.RightFoot);
            positionConstraint.AddSource(SetConstraintSource(sourceTarget, 0));
            rotationConstraint.AddSource(SetConstraintSource(sourceTarget, 0));

            // Head.
            sourceTarget = animator.GetBoneTransform(HumanBodyBones.Head);
            positionConstraint.AddSource(SetConstraintSource(sourceTarget, 0));
            rotationConstraint.AddSource(SetConstraintSource(sourceTarget, 0));

            // Chest.
            sourceTarget = animator.GetBoneTransform(HumanBodyBones.Chest);
            positionConstraint.AddSource(SetConstraintSource(sourceTarget, 0));
            rotationConstraint.AddSource(SetConstraintSource(sourceTarget, 0));

            // 펜 위치.
            Transform penTarget = new GameObject("PenTarget").transform;
            penTarget.transform.parent = targetScript.InkTarget;
            penTarget.transform.position = targetScript.transform.position;
            penTarget.transform.rotation = Quaternion.Euler(0, 0, 0);
            penTarget.transform.localScale = Vector3.one;

            Transform penPosition = penPrefab.transform.Find("PenPosition");
            penPosition.transform.position = penTarget.transform.position;
            penPosition.transform.rotation = penTarget.rotation;
            penPosition.transform.localScale = Vector3.one;

            ParentConstraint penPositionConstraint = penPosition.GetComponent<ParentConstraint>();
            penPositionConstraint.AddSource(SetConstraintSource(penTarget, 1));

            // 펜 사이즈.
            float penSize = targetScript.penSize * 2.0f;
            Transform inkDraw = penPrefab.transform.Find("PenPosition/Ink/InkDraw");
            inkDraw.localScale = new Vector3(penSize, penSize, penSize);

            Transform inkPoint = penPrefab.transform.Find("PenPosition/Ink/InkPoint");
            ParticleSystem inkPointParticle = inkPoint.GetComponent<ParticleSystem>();
            ParticleSystem.MainModule particleMain = inkPointParticle.main;
            particleMain.startSize = penSize;

            // 커스텀 오브젝트.
            Transform penObject = penPrefab.transform.Find("PenPosition/PenObject");
            if (targetScript.penObject)
            {
                targetScript.penObject.parent = penObject;
            }
            penObject.gameObject.SetActive(false);

        }

        // 애니메이션 컨트롤러 적용.
        void ApplyFX()
        {
            VRCAvatarDescriptor avatar = targetScript.avatar;
            string dataPath = GetDataPath();

            // FX 사용 설정.
            avatar.customizeAnimationLayers = true;
            avatar.baseAnimationLayers[2].isEnabled = true;
            avatar.baseAnimationLayers[2].isDefault = false;
            avatar.baseAnimationLayers[4].isEnabled = true;
            avatar.baseAnimationLayers[4].isDefault = false;

            // 아바타 FX.
            RuntimeAnimatorController avatarFX = avatar.baseAnimationLayers[4].animatorController;
            if (!avatarFX)
            {
                avatarFX = (RuntimeAnimatorController)CREditorUtility.CopyAsset(targetScript.reference.fxBase, dataPath + "/AvatarFX.controller");
                avatar.baseAnimationLayers[4].animatorController = avatarFX;
            }

            // 펜 FX.
            AnimatorController penFX;
            if (targetScript.hand == Pen3Script.Hand.Right)
                penFX = (AnimatorController)Instantiate(targetScript.reference.fxR);
            else
                penFX = (AnimatorController)Instantiate(targetScript.reference.fxL);

            // Write Default 설정.
            for (int i = 0; i < penFX.layers.Length; i++)
            {
                for (int j = 0; j < penFX.layers[i].stateMachine.states.Length; j++)
                {
                    penFX.layers[i].stateMachine.states[j].state.writeDefaultValues = targetScript.writeDefault;
                }
            }

            // 적용.
            CR_AnimatorControllerUtility.MergeController((AnimatorController)avatarFX, (AnimatorController)penFX, true);

            // 아바타 Gesture.
            if (!targetScript.penObject)
            {
                RuntimeAnimatorController avatarGesture = avatar.baseAnimationLayers[2].animatorController;
                if (!avatarGesture)
                {
                    avatarGesture = (RuntimeAnimatorController)CREditorUtility.CopyAsset(targetScript.reference.gestureBase, dataPath + "/AvatarGesture.controller");
                    avatar.baseAnimationLayers[2].animatorController = avatarGesture;
                }

                // 적용.
                if (targetScript.hand == Pen3Script.Hand.Right)
                    CR_AnimatorControllerUtility.MergeController((AnimatorController)avatarGesture, (AnimatorController)targetScript.reference.gestureR, true);
                else
                    CR_AnimatorControllerUtility.MergeController((AnimatorController)avatarGesture, (AnimatorController)targetScript.reference.gestureL, true);
            }

            // 컬러 애니메이션 적용.
            AnimatorControllerLayer layer = CR_AnimatorControllerUtility.FindLayer((AnimatorController)avatarFX, "PenColor");

            for (int i = 0; i < targetScript.paletteCount; i++)
            {
                Palette palette = targetScript.paletteList[i];
                AnimationClip clip = CreateColorAnimation(palette.color, dataPath + "/Color/Pen_Palette_" + i + ".anim");

                for (int j = 0; j < palette.colorCount; j++)
                {
                    AnimatorState state = layer.stateMachine.AddState("T_Color_" + i + " " + j, new Vector2(i*250, j*50));
                    state.writeDefaultValues = targetScript.writeDefault;
                    state.motion = clip;
                    state.speed = 0;

                    AnimatorStateTransition transition = layer.stateMachine.AddAnyStateTransition(state);
                    transition.hasExitTime = false;
                    transition.exitTime = 0;
                    transition.duration = 0;
                    transition.offset = 0.1f * j;
                    transition.canTransitionToSelf = false;

                    transition.AddCondition(AnimatorConditionMode.Equals, i * 10 + j, "PenColor");
                }

                AssetDatabase.SaveAssets();
            }
        }

        

        // 메뉴 적용.
        void ApplayMenu()
        {
            string dataPath = GetDataPath();
            targetScript.avatar.customExpressions = true;

            // 아바타 메뉴.
            VRCExpressionsMenu avatarMenu = targetScript.avatar.expressionsMenu;
            if (avatarMenu == null)
            {
                avatarMenu = (VRCExpressionsMenu)CREditorUtility.CopyAsset(targetScript.reference.menuBase, dataPath + "/AvatarMenu.asset");
                targetScript.avatar.expressionsMenu = avatarMenu;
            }

            // 아바타 메뉴에 펜 메뉴 추가.
            VRCExpressionsMenu.Control penControl = CR_VRCMenuUtility.MenuCopyControl(avatarMenu, targetScript.reference.menuPen, "Pen");            

            // 펜 메인메뉴 추가.
            VRCExpressionsMenu menuMain = (VRCExpressionsMenu)CREditorUtility.CopyAsset(targetScript.reference.menuMain, dataPath + "/PenMain.asset");
            penControl.subMenu = menuMain;

            EditorUtility.SetDirty(avatarMenu);

            // 컬러 메뉴 추가.
            VRCExpressionsMenu.Control menuColorControl = CR_VRCMenuUtility.MenuFindControl(menuMain, "Color");
            if (targetScript.paletteCount > 1)
                menuColorControl.subMenu = MakeColorMenu();
            else
                menuColorControl.subMenu = MakePaletteManu(0);
            
            EditorUtility.SetDirty(menuMain);
        }

        // 파라미터 적용
        void ApplyParameters()
        {
            string dataPath = GetDataPath();

            // 아바타 파라미터.
            VRCExpressionParameters avatarParam = targetScript.avatar.expressionParameters;
            if (avatarParam == null)
            {
                avatarParam = (VRCExpressionParameters)CREditorUtility.CopyAsset(targetScript.reference.paramBase, dataPath + "/AvatarParam.asset");
                targetScript.avatar.expressionParameters = avatarParam;
            }

            // 파라미터 적용.
            CR_VRCMenuUtility.AddAllParameter(avatarParam, targetScript.reference.param);
        }

        // 컬러 메뉴 제작.
        VRCExpressionsMenu MakeColorMenu()
        {
            // 메뉴 생성.
            VRCExpressionsMenu colorMenu = (VRCExpressionsMenu)CREditorUtility.CopyAsset(targetScript.reference.menuBase, GetDataPath() + "/ColorMenu.asset");

            // 팔레트 작성.
            for (int i = 0; i < targetScript.paletteCount; i++)
            {
                VRCExpressionsMenu paletteMenu = MakePaletteManu(i);

                // 팔레트 아이콘 제작.
                Texture2D gradientTexture = CreateGradientIcon(targetScript.paletteList[i].color, targetScript.paletteList[i].colorCount, GetDataPath(), "Gradient " + (i + 1));

                // 팔레트 메뉴 제작.
                VRCExpressionsMenu.Control control = new VRCExpressionsMenu.Control()
                {
                    //icon = texture,
                    name = "Palette " + (i + 1),
                    type = VRCExpressionsMenu.Control.ControlType.SubMenu,
                    subMenu = paletteMenu,
                    icon = gradientTexture
                };
                colorMenu.controls.Add(control);
            }

            EditorUtility.SetDirty(colorMenu);

            return colorMenu;
        }

        // 팔레트 메뉴 제작.
        VRCExpressionsMenu MakePaletteManu(int paletteNum)
        {
            string dataPath = GetDataPath();
            Texture2D colorIcon = AssetDatabase.LoadAssetAtPath<Texture2D>(RootPath() + "/Common/Icon/Icon_ColorDummy.png");
            Palette palette = targetScript.paletteList[paletteNum];

            // 메뉴 생성.
            VRCExpressionsMenu paletteMenu = (VRCExpressionsMenu)CREditorUtility.CopyAsset(targetScript.reference.menuBase, dataPath + "/Palette " + paletteNum + ".asset");
            for (int i = 0; i < palette.colorCount; i++)
            {
                Color color = targetScript.paletteList[paletteNum].color[i];

                // 컬러 아이콘 제작.
                string rgb = "R" + color.r * 255 + "G" + color.g * 255 + "B" + color.b * 255;
                string path = dataPath + "/Color/" + rgb + ".png";

                Texture2D texture = AssetDatabase.LoadAssetAtPath<Texture2D>(path);
                if (texture == null)
                {
                    texture = (Texture2D)CREditorUtility.CopyAsset(colorIcon, path);
                    SetTextureColor(texture, color);
                    System.IO.File.WriteAllBytes(path, texture.EncodeToPNG());
                    AssetDatabase.ImportAsset(path);
                }

                // 컬러 메뉴 제작.
                VRCExpressionsMenu.Control control = new VRCExpressionsMenu.Control()
                {
                    icon = texture,
                    type = VRCExpressionsMenu.Control.ControlType.Toggle,
                    parameter = new VRCExpressionsMenu.Control.Parameter() { name = "PenColor" },
                    value = (paletteNum * 10) + i
                };
                paletteMenu.controls.Add(control);
            }

            EditorUtility.SetDirty(paletteMenu);

            return paletteMenu;
        }

        // 제거.
        void Remove()
        {
            VRCAvatarDescriptor avatar = targetScript.avatar;


            // 오브젝트 제거.
            Transform prefab = targetScript.avatar.transform.Find("ParticlePen3");
            if (prefab)
            {
                GameObject.DestroyImmediate(prefab.gameObject);
            }

            // 타겟 제거.
            GameObject targetObject = CREditorUtility.FindGameobjectName(targetScript.avatar.gameObject, "PenTarget");
            if (targetObject)
            {
                GameObject.DestroyImmediate(targetObject);
            }

            // FX.
            RuntimeAnimatorController avatarFX = avatar.baseAnimationLayers[4].animatorController;
            if (avatarFX)
            {
                AnimatorControllerLayer[] layers;

                AnimatorController fx = (AnimatorController)targetScript.reference.fxRemove;
                layers = fx.layers;

                for (int i = 0; i < layers.Length; i++)
                {
                    CR_AnimatorControllerUtility.RemoveLayer((AnimatorController)avatarFX, layers[i].name);
                }
            }

            // Gesture.
            RuntimeAnimatorController avatarGesture = avatar.baseAnimationLayers[2].animatorController;
            if (avatarGesture)
            {
                AnimatorControllerLayer[] layers;

                AnimatorController gesture = (AnimatorController)targetScript.reference.fxRemove;
                layers = gesture.layers;

                for (int i = 0; i < layers.Length; i++)
                {
                    CR_AnimatorControllerUtility.RemoveLayer((AnimatorController)avatarGesture, layers[i].name);
                }
            }

            // 메뉴.
            VRCExpressionsMenu avatarMenu = targetScript.avatar.expressionsMenu;
            if (avatarMenu)
            {
                VRCExpressionsMenu.Control control = CR_VRCMenuUtility.MenuFindControl(avatarMenu, targetScript.reference.menuPen.controls[0].name);
                avatarMenu.controls.Remove(control);
                EditorUtility.SetDirty(avatarMenu);
            }

            // 파라미터.
            VRCExpressionParameters avatarParam = targetScript.avatar.expressionParameters;
            if (avatarParam)
            {
                for (int i = 0; i < targetScript.reference.param.parameters.Length; i++)
                {
                    CR_VRCMenuUtility.RemoveParameter(avatarParam, targetScript.reference.param.parameters[i].name);
                }
            }
        }

        // Root 경로.
        string RootPath()
        {
            return Path.GetDirectoryName(AssetDatabase.GetAssetPath(targetScript.reference.root));
        }

        // Data 경로.
        string GetDataPath()
        {
            string avatarName = targetScript.avatar.name;

            // 폴더 생성.
            string dataPath = RootPath();
            dataPath += "/Data";
            dataPath += "/" + avatarName;
            CREditorUtility.CreateFolders(dataPath);

            return dataPath;
        }

        // Constraint Source 생성.
        ConstraintSource SetConstraintSource(Transform sourceTarget, float weight)
        {
            ConstraintSource constraintSource = new ConstraintSource
            {
                sourceTransform = sourceTarget,
                weight = weight
            };

            return constraintSource;
        }
    }
}
