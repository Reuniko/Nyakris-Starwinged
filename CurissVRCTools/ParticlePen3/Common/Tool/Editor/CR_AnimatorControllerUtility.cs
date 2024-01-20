using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.Animations;

namespace CRParticlePen3
{
    public class CR_AnimatorControllerUtility
    {
        // 파라미터를 찾습니다.
        public static AnimatorControllerParameter FindParameter(AnimatorController source, string name)
        {
            for (int i = 0; i < source.parameters.Length; i++)
            {
                if (source.parameters[i].name.Equals(name))
                    return source.parameters[i];
            }

            return null;
        }

        // 파라미터 번호를 찾습니다.
        public static int FindParameterIndex(AnimatorController source, string name)
        {
            for (int i = 0; i < source.parameters.Length; i++)
            {
                if (source.parameters[i].name.Equals(name))
                    return i;
            }

            return -1;
        }

        // Layer를 이름으로 찾습니다.
        public static AnimatorControllerLayer FindLayer(AnimatorController source, string name)
        {
            foreach (AnimatorControllerLayer item in source.layers)
            {
                if (item.name.Equals(name))
                {
                    return item;
                }
            }

            return null;
        }

        // Layer의 번호를 찾습니다.
        public static int FindLayerIndex(AnimatorController source, string name)
        {
            for (int i = 0; i < source.layers.Length; i++)
            {
                if (source.layers[i].name.Equals(name))
                {
                    return i;
                }
            }

            return -1;
        }

        // AnimatorState를 이름으로 찾습니다.
        public static AnimatorState FindState(AnimatorStateMachine target, AnimatorState source)
        {
            if (!source || !target) return null;

            return FindState(target, source.name);
        }
        public static AnimatorState FindState(AnimatorStateMachine target, string source)
        {
            if (!target) return null;

            for (int i = 0; i < target.states.Length; i++)
            {
                if (target.states[i].state.name.Equals(source))
                {
                    return target.states[i].state;
                }
            }

            for (int i = 0; i < target.stateMachines.Length; i++)
            {
                AnimatorState state = FindState(target.stateMachines[i].stateMachine, source);
                if (state)
                    return state;
            }

            return null;
        }
        public static AnimatorState FindState(AnimatorController controller, string layerName, string stateName)
        {
            AnimatorControllerLayer layer = FindLayer(controller, layerName);
            AnimatorState state = FindState(layer.stateMachine, stateName);
            if (state)
                return state;

            return null;
        }

        // AnimatorStateMachine을 이름으로 찾습니다.
        public static AnimatorStateMachine FindStateStateMachine(AnimatorStateMachine target, AnimatorStateMachine source)
        {
            if (!source || !target) return null;

            for (int i = 0; i < target.stateMachines.Length; i++)
            {
                if (target.stateMachines[i].stateMachine.name.Equals(source.name))
                {
                    return target.stateMachines[i].stateMachine;
                }
            }

            return null;
        }

        // Transition을 찾습니다.
        public static AnimatorStateTransition FindTrsition(AnimatorState target, string name)
        {
            foreach (AnimatorStateTransition item in target.transitions)
            {
                if (item.name.Equals(name))
                    return item;
            }

            return null;
        }
        public static AnimatorStateTransition FindTrsition(AnimatorStateMachine target, string name)
        {
            foreach (ChildAnimatorState item in target.states)
            {
                AnimatorStateTransition transition = CR_AnimatorControllerUtility.FindTrsition(item.state, name);
                if (transition)
                    return transition;
            }

            return null;
        }
        public static AnimatorStateTransition FindTrsition(AnimatorStateTransition[] target, string name)
        {
            foreach (AnimatorStateTransition item in target)
            {
                if (item.name.Equals(name))
                    return item;
            }

            return null;
        }



        // Layer와 내용을 함께 복사 합니다.
        public static AnimatorControllerLayer CopyLayerWithData(AnimatorController target, AnimatorControllerLayer source, bool overwirte)
        {
            // 복사할 레이어의 stateMachine.
            AnimatorStateMachine stateMachine = source.stateMachine;

            // 중복 레이어 삭제.
            if (overwirte)
            {
                int index = FindLayerIndex(target, source.name);
                if (index != -1) target.RemoveLayer(index);
            }

            // StateMachine 복사.
            AnimatorStateMachine newStateMachine = CopyStateMachine(target, source.stateMachine);

            // Layer 복사.
            string name = target.MakeUniqueLayerName(source.name);
            AnimatorControllerLayer newLayer = CopyNewLayer(source, newStateMachine, true, name);
            target.AddLayer(newLayer);

            return newLayer;
        }
        public static AnimatorControllerLayer CopyLayerWithData(AnimatorController target, AnimatorController source, string name, bool overwirte)
        {
            AnimatorControllerLayer layer = CR_AnimatorControllerUtility.FindLayer(source, name);

            return CR_AnimatorControllerUtility.CopyLayerWithData(target, layer, overwirte);
        }

        // 애니메이터를 합칩니다.
        public static void MergeController(AnimatorController target, AnimatorController source, bool overwirte)
        {
            // Parameter 복사.
            CopyParameters(target, source);

            // Layer 복사.
            for (int i = 0; i < source.layers.Length; i++)
            {
                // 레이어 복사.
                CopyLayerWithData(target, source.layers[i], overwirte);
            }
        }


        // StateMachine 복사.
        public static AnimatorStateMachine CopyStateMachine(AnimatorController target, AnimatorStateMachine stateMachine)
        {
            // StateMachine 생성.
            AnimatorStateMachine newStateMachine = new AnimatorStateMachine();
            newStateMachine.name = stateMachine.name;

            newStateMachine.hideFlags = stateMachine.hideFlags;
            AssetDatabase.AddObjectToAsset(newStateMachine, target);

            // State 복사.
            foreach (ChildAnimatorState childState in stateMachine.states)
            {
                AnimatorState state = childState.state;

                AnimatorState newState = CopyNewState(state);
                newState.behaviours = CopyBehaviours(target, state.behaviours);

                newStateMachine.AddState(newState, childState.position);
                AssetDatabase.AddObjectToAsset(newState, target);
            }

            // SubStateMachine 복사.
            foreach (ChildAnimatorStateMachine childStateMachine in stateMachine.stateMachines)
            {
                AnimatorStateMachine subStateMachine = CopyStateMachine(target, childStateMachine.stateMachine);
                newStateMachine.AddStateMachine(subStateMachine, childStateMachine.position);
            }

            // AniState 복사.
            newStateMachine.anyStateTransitions = CopyNewTransitions(target, newStateMachine, stateMachine.anyStateTransitions);
            newStateMachine.anyStatePosition = stateMachine.anyStatePosition;

            // Entry 복사.
            newStateMachine.entryPosition = stateMachine.entryPosition;
            newStateMachine.defaultState = FindState(newStateMachine, stateMachine.defaultState);

            // Exit 복사.
            newStateMachine.exitPosition = stateMachine.exitPosition;

            // Transition 복사.
            for (int j = 0; j < stateMachine.states.Length; j++)
            {
                newStateMachine.states[j].state.transitions = CopyNewTransitions(target, newStateMachine, stateMachine.states[j].state.transitions);
            }

            return newStateMachine;
        }


        // Transition 목록을 복사 합니다.
        public static AnimatorStateTransition[] CopyNewTransitions(AnimatorController controller, AnimatorStateMachine stateMachine, AnimatorStateTransition[] source)
        {
            List<AnimatorStateTransition> transitionList = new List<AnimatorStateTransition>();
            foreach (AnimatorStateTransition transition in source)
            {
                AnimatorStateTransition newTransition = CopyNewTransition(stateMachine, transition);
                foreach (AnimatorCondition condition in transition.conditions)
                {
                    newTransition.AddCondition(condition.mode, condition.threshold, condition.parameter);
                }

                AssetDatabase.AddObjectToAsset(newTransition, controller);
                transitionList.Add(newTransition);
            }

            return transitionList.ToArray();
        }

        // Behaviours 목록을 복사 합니다.
        public static StateMachineBehaviour[] CopyBehaviours(AnimatorController controller, StateMachineBehaviour[] source)
        {
            List<StateMachineBehaviour> list = new List<StateMachineBehaviour>();
            foreach (StateMachineBehaviour item in source)
            {
                StateMachineBehaviour newBehaviour = CopyBehaviour(item);
                AssetDatabase.AddObjectToAsset(newBehaviour, controller);
                list.Add(newBehaviour);
            }

            return list.ToArray();
        }

        // 레이어를 지웁니다.
        public static void RemoveLayer(AnimatorController target, string name)
        {
            int index = FindLayerIndex(target, name);
            if (index != -1) target.RemoveLayer(index);
        }

        // Layer를 복사하여 반환 합니다. (Sync는 제외.)
        public static AnimatorControllerLayer CopyNewLayer(AnimatorControllerLayer source, AnimatorStateMachine stateMachine, bool isFirst)
        {
            return CopyNewLayer(source, stateMachine, isFirst, source.name);
        }
        public static AnimatorControllerLayer CopyNewLayer(AnimatorControllerLayer source, AnimatorStateMachine stateMachine, bool isFirst, string name)
        {
            AnimatorControllerLayer layer = new AnimatorControllerLayer()
            {
                avatarMask = source.avatarMask,
                blendingMode = source.blendingMode,
                defaultWeight = isFirst ? 1 : source.defaultWeight,
                iKPass = source.iKPass,
                name = name,
                stateMachine = stateMachine
            };

            return layer;
        }

        // AnimatorState를 복사하여 반환 합니다. (transition은 null값이 들어갑니다.)
        public static AnimatorState CopyNewState(AnimatorState source)
        {
            AnimatorState newState = new AnimatorState()
            {
                cycleOffset = source.cycleOffset,
                cycleOffsetParameter = source.cycleOffsetParameter,
                cycleOffsetParameterActive = source.cycleOffsetParameterActive,
                hideFlags = source.hideFlags,
                iKOnFeet = source.iKOnFeet,
                mirror = source.mirror,
                mirrorParameter = source.mirrorParameter,
                mirrorParameterActive = source.mirrorParameterActive,
                motion = source.motion,
                name = source.name,
                speed = source.speed,
                speedParameter = source.speedParameter,
                speedParameterActive = source.speedParameterActive,
                tag = source.tag,
                timeParameter = source.timeParameter,
                timeParameterActive = source.timeParameterActive,
                writeDefaultValues = source.writeDefaultValues,
            };
            return newState;
        }

        // Transition을 복사하여 반환 합니다. (연결대상은 State의 Name으로 찾습니다.)
        public static AnimatorStateTransition CopyNewTransition(AnimatorStateMachine target, AnimatorStateTransition transitions)
        {
            AnimatorState state = FindState(target, transitions.destinationState);
            AnimatorStateMachine stateMachine = FindStateStateMachine(target, transitions.destinationStateMachine);

            AnimatorStateTransition newTransitions = new AnimatorStateTransition
            {
                canTransitionToSelf = transitions.canTransitionToSelf,
                destinationState = state,
                destinationStateMachine = stateMachine,
                duration = transitions.duration,
                exitTime = transitions.exitTime,
                hasExitTime = transitions.hasExitTime,
                hasFixedDuration = transitions.hasFixedDuration,
                hideFlags = transitions.hideFlags,
                interruptionSource = transitions.interruptionSource,
                isExit = transitions.isExit,
                mute = transitions.mute,
                name = transitions.name,
                offset = transitions.offset,
                orderedInterruption = transitions.orderedInterruption,
                solo = transitions.solo
            };

            return newTransitions;
        }

        // Condition을 복사하여 반환 합니다.
        public static AnimatorCondition CopyNewCondition(AnimatorCondition source)
        {
            AnimatorCondition condition = new AnimatorCondition()
            {
                mode = source.mode,
                parameter = source.parameter,
                threshold = source.threshold
            };

            return condition;
        }

        // StateBehaviour를 복사하여 반환 합니다.
        public static StateMachineBehaviour CopyBehaviour(StateMachineBehaviour source)
        {
            System.Type type = source.GetType();
            StateMachineBehaviour newBehaviour = (StateMachineBehaviour)StateMachineBehaviour.CreateInstance(type);

            SerializedObject serializedSource = new SerializedObject(source);
            SerializedObject serializedNew = new SerializedObject(newBehaviour);

            SerializedProperty prop = serializedSource.GetIterator();
            while (prop.Next(true))
            {
                serializedNew.CopyFromSerializedProperty(prop);
            }
            serializedNew.ApplyModifiedProperties();

            return newBehaviour;
        }

        // 모든 Parameter를 복사합니다.
        public static void CopyParameters(AnimatorController target, AnimatorController source)
        {
            for (int i = 0; i < source.parameters.Length; i++)
            {
                int index = FindParameterIndex(target, source.parameters[i].name);
                if (index != -1)
                    continue;

                AnimatorControllerParameter parameter = new AnimatorControllerParameter()
                {
                    name = source.parameters[i].name,
                    type = source.parameters[i].type,
                    defaultBool = source.parameters[i].defaultBool,
                    defaultFloat = source.parameters[i].defaultFloat,
                    defaultInt = source.parameters[i].defaultInt
                };

                target.AddParameter(parameter);
            }
        }

        // Parameter를 복사합니다.
        public static void CopyParameter(AnimatorController target, AnimatorControllerParameter source)
        {
            int index = FindParameterIndex(target, source.name);
            if (index != -1)
                target.RemoveParameter(index);

            AnimatorControllerParameter parameter = new AnimatorControllerParameter()
            {
                name = source.name,
                type = source.type,
                defaultBool = source.defaultBool,
                defaultFloat = source.defaultFloat,
                defaultInt = source.defaultInt
            };

            target.AddParameter(parameter);
        }
        public static void CopyParameter(AnimatorController target, AnimatorController source, string name)
        {
            CopyParameter(target, FindParameter(source, name));
        }

        // Parameter를 지웁니다.
        public static void RemoveParameter(AnimatorController target, string name)
        {
            int parameter = FindParameterIndex(target, name);
            if (parameter == -1)
                return;

            target.RemoveParameter(parameter);
        }
    }
}