﻿using System;
using System.Collections.Generic;
using System.Linq;
using Hai.ComboGesture.Scripts.Components;
using Hai.ComboGesture.Scripts.Editor.Internal.Reused;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;


namespace Hai.ComboGesture.Scripts.Editor.Internal
{
    internal class LayerForExpressionsView
    {
        private readonly FeatureToggles _featuresToggles;
        private readonly AnimatorGenerator _animatorGenerator;
        private readonly AvatarMask _expressionsAvatarMask;
        private readonly AnimationClip _emptyClip;
        private readonly string _activityStageName;
        private readonly ConflictPrevention _conflictPrevention;
        private readonly AssetContainer _assetContainer;
        private readonly ConflictFxLayerMode _compilerConflictFxLayerMode;
        private readonly AnimationClip _compilerIgnoreParamList;
        private readonly AnimationClip _compilerFallbackParamList;
        private readonly List<CurveKey> _blinkBlendshapes;
        private readonly AnimatorController _animatorController;
        private readonly List<GestureComboStageMapper> _comboLayers;
        private readonly bool _useGestureWeightCorrection;
        private readonly bool _useSmoothing;
        private readonly List<ManifestBinding> _manifestBindings;
        private readonly string _animInfix;

        public LayerForExpressionsView(FeatureToggles featuresToggles,
            AnimatorGenerator animatorGenerator,
            AvatarMask expressionsAvatarMask,
            AnimationClip emptyClip,
            string activityStageName,
            ConflictPrevention conflictPrevention,
            AssetContainer assetContainer,
            ConflictFxLayerMode compilerConflictFxLayerMode,
            AnimationClip compilerIgnoreParamList,
            AnimationClip compilerFallbackParamList,
            List<CurveKey> blinkBlendshapes,
            AnimatorController animatorController,
            List<GestureComboStageMapper> comboLayers,
            bool useGestureWeightCorrection,
            bool useSmoothing,
            List<ManifestBinding> manifestBindings,
            string animInfix)
        {
            _featuresToggles = featuresToggles;
            _animatorGenerator = animatorGenerator;
            _expressionsAvatarMask = expressionsAvatarMask;
            _emptyClip = emptyClip;
            _activityStageName = activityStageName;
            _conflictPrevention = conflictPrevention;
            _assetContainer = assetContainer;
            _compilerConflictFxLayerMode = compilerConflictFxLayerMode;
            _compilerIgnoreParamList = compilerIgnoreParamList;
            _compilerFallbackParamList = compilerFallbackParamList;
            _blinkBlendshapes = blinkBlendshapes;
            _animatorController = animatorController;
            _comboLayers = comboLayers;
            _useGestureWeightCorrection = useGestureWeightCorrection;
            _useSmoothing = useSmoothing;
            _manifestBindings = manifestBindings;
            _animInfix = animInfix;
        }

        public void Create()
        {
            EditorUtility.DisplayProgressBar("GestureCombo", "Clearing expressions layer", 0f);
            var machine = ReinitializeLayer();

            var defaultState = machine.AddState("Default", SharedLayerUtils.GridPosition(-1, -1));
            defaultState.motion = _emptyClip;
            defaultState.writeDefaultValues = _conflictPrevention.ShouldWriteDefaults;

            if (_activityStageName != null)
            {
                CreateTransitionWhenActivityIsOutOfBounds(machine, defaultState);
            }

            var activityManifests = _manifestBindings;
            EditorUtility.DisplayProgressBar("GestureCombo", "Generating animations", 0f);
            _assetContainer.RemoveAssetsStartingWith("zAutogeneratedExp" + _animInfix + "_", typeof(AnimationClip));
            _assetContainer.RemoveAssetsStartingWith("zAutogeneratedPup" + _animInfix + "_", typeof(BlendTree));
            activityManifests = new AnimationNeutralizer(
                activityManifests,
                _compilerConflictFxLayerMode,
                _compilerIgnoreParamList,
                _compilerFallbackParamList,
                _blinkBlendshapes,
                _assetContainer,
                _conflictPrevention.ShouldGenerateExhaustiveAnimations,
                _emptyClip,
                Feature(FeatureToggles.DoNotFixSingleKeyframes)
            ).NeutralizeManifestAnimations();

            // The blend tree auto weight corrector assumes that all of the Manifests' blend trees have been autogenerated.
            // This remains true as long as the Animation Neutralizer is executed before this.
            activityManifests = new CgeBlendTreeAutoWeightCorrector(activityManifests, _useGestureWeightCorrection, _useSmoothing, _assetContainer)
                .MutateAndCorrectExistingBlendTrees();

            foreach (var parameter in AllParametersUsedByBlendTrees(activityManifests))
            {
                SharedLayerUtils.CreateParamIfNotExists(_animatorController, parameter, AnimatorControllerParameterType.Float);
            }

            var combinator = new IntermediateCombinator(activityManifests);

            new GestureCExpressionCombiner(
                _animatorController,
                machine,
                combinator.IntermediateToTransition,
                _activityStageName,
                _conflictPrevention.ShouldWriteDefaults,
                _useGestureWeightCorrection,
                _useSmoothing
            ).Populate();
        }

        private static List<string> AllParametersUsedByBlendTrees(List<ManifestBinding> activityManifests)
        {
            return activityManifests
                .SelectMany(binding => binding.Manifest.AllBlendTreesFoundRecursively())
                .SelectMany(tree =>
                {
                    switch (tree.blendType)
                    {
                        case BlendTreeType.Simple1D:
                            return new List<string> {tree.blendParameter};
                        case BlendTreeType.SimpleDirectional2D:
                            return new List<string> {tree.blendParameter, tree.blendParameterY};
                        case BlendTreeType.FreeformDirectional2D:
                            return new List<string> {tree.blendParameter, tree.blendParameterY};
                        case BlendTreeType.FreeformCartesian2D:
                            return new List<string> {tree.blendParameter, tree.blendParameterY};
                        case BlendTreeType.Direct:
                            return tree.children.Select(motion => motion.directBlendParameter).ToList();
                        default:
                            throw new ArgumentOutOfRangeException();
                    }
                })
                .Distinct()
                .ToList();
        }

        private void CreateTransitionWhenActivityIsOutOfBounds(AnimatorStateMachine machine, AnimatorState defaultState)
        {
            var transition = machine.AddAnyStateTransition(defaultState);
            SharedLayerUtils.SetupDefaultTransition(transition);

            foreach (var layer in _comboLayers)
            {
                transition.AddCondition(AnimatorConditionMode.NotEqual, layer.stageValue, _activityStageName);
            }
        }

        private AnimatorStateMachine ReinitializeLayer()
        {
            return _animatorGenerator.CreateOrRemakeLayerAtSameIndex("Hai_GestureExp", 1f, _expressionsAvatarMask).ExposeMachine();
        }

        private bool Feature(FeatureToggles feature)
        {
            return (_featuresToggles & feature) == feature;
        }
    }
}
