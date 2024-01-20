using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using VRC.SDK3.Avatars.Components;
using UnityEditor;
using VRC.SDK3.Avatars.ScriptableObjects;

namespace CRParticlePen3
{
    public class CR_VRCMenuUtility
    {
        // 메뉴의 컨트롤러를 이름으로 찾습니다.
        public static VRCExpressionsMenu.Control MenuFindControl(VRCExpressionsMenu source, string name)
        {
            if (!source)
                return null;

            foreach (VRCExpressionsMenu.Control item in source.controls)
            {
                if (item.name.Equals(name))
                    return item;
            }

            return null;
        }

        // 모든 서브메뉴를 새 파일로 넣습니다.
        public static void MenuAllSubMenuNewAsset(VRCExpressionsMenu target, string path)
        {
            for (int i = 0; i < target.controls.Count; i++)
            {
                MenuSubMenuNewAsset(target.controls[i], path);
            }

            EditorUtility.SetDirty(target);
        }

        // 서브메뉴를 새 파일로 넣습니다.
        public static VRCExpressionsMenu MenuSubMenuNewAsset(VRCExpressionsMenu.Control control, string path)
        {
            if (control.subMenu == null)
                return null;

            string assetPath = AssetDatabase.GetAssetPath(control.subMenu);

            bool result = AssetDatabase.CopyAsset(assetPath, path + "/" + control.subMenu.name + ".asset");
            if (!result)
                return null;

            VRCExpressionsMenu menu = AssetDatabase.LoadAssetAtPath<VRCExpressionsMenu>(path + "/" + control.subMenu.name + ".asset");
            control.subMenu = menu;

            return menu;
        }

        // 메뉴의 컨트롤러를 복사하여 추가 합니다.
        public static VRCExpressionsMenu.Control MenuCopyControl(VRCExpressionsMenu target, VRCExpressionsMenu source, string name)
        {
            VRCExpressionsMenu.Control control = MenuFindControl(source, name);

            return MenuCopyControl(target, control);
        }
        public static VRCExpressionsMenu.Control MenuCopyControl(VRCExpressionsMenu target, VRCExpressionsMenu.Control control)
        {
            VRCExpressionsMenu.Control newControl = new VRCExpressionsMenu.Control()
            {
                icon = control.icon,
                labels = control.labels,
                name = control.name,
                parameter = control.parameter,
                style = control.style,
                subMenu = control.subMenu,
                subParameters = control.subParameters,
                type = control.type,
                value = control.value
            };

            target.controls.Add(newControl);
            EditorUtility.SetDirty(target);

            return newControl;
        }

        // 메뉴 컨트롤러의 내용을 복사 합니다.
        public static VRCExpressionsMenu.Control MenuReplaceControl(VRCExpressionsMenu target, string name, VRCExpressionsMenu.Control control)
        {
            if (!target || control == null)
                return null;

            VRCExpressionsMenu.Control targetControl = MenuFindControl(target, name);
            targetControl.icon = control.icon;
            targetControl.labels = control.labels;
            targetControl.name = control.name;
            targetControl.parameter = control.parameter;
            targetControl.style = control.style;
            targetControl.subMenu = control.subMenu;
            targetControl.subParameters = control.subParameters;
            targetControl.type = control.type;
            targetControl.value = control.value;

            return targetControl;
        }

        // 모든 컨트롤러를 복사 합니다.
        public static void CopyAllMenuControl(VRCExpressionsMenu target, VRCExpressionsMenu source)
        {
            foreach (VRCExpressionsMenu.Control item in source.controls)
            {
                VRCExpressionsMenu.Control remove = MenuFindControl(target, item.name);
                if (remove != null)
                    target.controls.Remove(remove);

                target.controls.Add(item);
            }
            EditorUtility.SetDirty(target);
        }

        // 파라미터를 추가 합니다.
        public static void AddParameter(VRCExpressionParameters parameters, string name, VRCExpressionParameters.ValueType valueType, float deaultValue, bool saved)
        {
            VRCExpressionParameters.Parameter targetParam = parameters.FindParameter(name);
            if (targetParam == null)
            {
                int length = parameters.parameters.Length;

                Array.Resize(ref parameters.parameters, length + 1);
                parameters.parameters[length] = new VRCExpressionParameters.Parameter();
                targetParam = parameters.parameters[length];
            }

            targetParam.name = name;
            targetParam.valueType = valueType;
            targetParam.defaultValue = deaultValue;
            targetParam.saved = saved;

            EditorUtility.SetDirty(parameters);
        }

        // 모든 파라미터를 복사 합니다.
        public static void AddAllParameter(VRCExpressionParameters target, VRCExpressionParameters source)
        {
            foreach (VRCExpressionParameters.Parameter item in source.parameters)
            {
                AddParameter(target, item.name, item.valueType, item.defaultValue, item.saved);
            }
        }

        // 파라미터를 제거 합니다.
        public static void RemoveParameter(VRCExpressionParameters target, string name)
        {
            VRCExpressionParameters.Parameter parameter;

            if (!target)
                return;

            parameter = target.FindParameter(name);
            if (parameter == null)
                return;

            List<VRCExpressionParameters.Parameter> list = new List<VRCExpressionParameters.Parameter>(target.parameters);
            list.Remove(parameter);
            target.parameters = list.ToArray();

            EditorUtility.SetDirty(target);
        }

        // 빈 파라미터의 겟수를 반환 합니다.
        public static int EmptyParamCount(VRCExpressionParameters parameter)
        {
            int count = 0;
            foreach (VRCExpressionParameters.Parameter item in parameter.parameters)
            {
                if (item.name.Equals("")) count++;
            }

            return count;
        }

        // 필요한 파라미터 수 체크.
        public static int CountRequireParam(VRCExpressionParameters target, VRCExpressionParameters source)
        {
            int count = 0;

            if (!target || !source)
                return 0;

            for (int i = 0; i < source.parameters.Length; i++)
            {
                string paramName = source.GetParameter(i).name;

                if (target.FindParameter(paramName) == null)
                {
                    count += 1;
                }
            }

            return count;
        }

        // 파라미터 공간 확인.
        public static bool CheckParameterCount(VRCExpressionParameters target, VRCExpressionParameters source)
        {
            if (target)
            {
                int remainingParams = VRCExpressionParameters.MAX_PARAMETER_COST - target.CalcTotalCost();
                int requireParams = CountRequireParam(target, source);

                if (remainingParams < requireParams)
                {
                    return false;
                }
            }

            return true;
        }
    }
}