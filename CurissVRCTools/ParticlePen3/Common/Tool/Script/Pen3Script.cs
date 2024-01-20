using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using VRC.SDK3.Avatars.Components;
using VRC.SDK3.Avatars.ScriptableObjects;

namespace CRParticlePen3
{
    public class Pen3Script : MonoBehaviour
    {
        public Pen3Reference reference;

        public VRCAvatarDescriptor avatar;
        public Transform InkTarget;
        public Transform penObject;

        public enum Hand { Right, Left }
        public Hand hand = Hand.Right;
        public float penSize;

        public bool writeDefault = true;

        [SerializeField] public int paletteCount = 1;
        [SerializeField] public Palette[] paletteList = new Palette[8];
    }

    [Serializable]
    public class Palette
    {
        public int colorCount = 8;
        public Color[] color = new Color[8];
    }
}
