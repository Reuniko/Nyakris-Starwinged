using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using VRC.SDK3.Avatars.Components;
using VRC.SDK3.Avatars.ScriptableObjects;


namespace CRParticlePen3
{
    public class Pen3Reference : MonoBehaviour
    {
        public Object root;

        public GameObject PenPrefab;

        public RuntimeAnimatorController fxBase;
        public RuntimeAnimatorController gestureBase;

        public RuntimeAnimatorController gestureR;
        public RuntimeAnimatorController gestureL;
        public RuntimeAnimatorController fxR;
        public RuntimeAnimatorController fxL;
        public RuntimeAnimatorController fxRemove;

        public VRCExpressionsMenu menuBase;
        public VRCExpressionsMenu menuPen;
        public VRCExpressionsMenu menuMain;

        public VRCExpressionParameters param;
        public VRCExpressionParameters paramBase;

        public Texture2D colorDummy;
        public Texture2D gradientDummy;

        public Texture2D TitleBG;
        public Texture2D TitleContent;
    }
}
