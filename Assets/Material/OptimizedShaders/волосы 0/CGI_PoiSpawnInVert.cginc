#ifndef POI_SPAWN_IN_FRAG
    #define POI_SPAWN_FRAG
    #ifndef SPAWN_IN_VARIABLES
        #define SPAWN_IN_VARIABLES
        float3 _SpawnInGradientStart;
        float3 _SpawnInGradientFinish;
        fixed _SpawnInAlpha;
        fixed _SpawnInNoiseIntensity;
        float3 _SpawnInEmissionColor;
        float _SpawnInEmissionOffset;
        float _SpawnInVertOffset;
        float _SpawnInVertOffsetOffset;
        float _EnableScifiSpawnIn;
    #endif
    float calculateGradientValueVert(float3 start, float3 finish, float3 localPos)
    {
        return inverseLerp3(start, finish, localPos);
    }
    void applySpawnInVert(inout float4 worldPos, inout float4 localPos, float2 uv)
    {
        
        if ((0.0 /*_EnableScifiSpawnIn*/))
        {
            float noise = 0;
            float gradient = calculateGradientValueVert(float4(0,2,0,1), float4(0,-2,0,1), localPos.xyz);
            float inverseGradient = 1 - gradient;
            float alpha = gradient - (0.0 /*_SpawnInAlpha*/) - noise;
            worldPos.xyz += saturate(inverseGradient + (0.0 /*_SpawnInAlpha*/) + (0.1 /*_SpawnInVertOffsetOffset*/) -1) * float3(0, (10.0 /*_SpawnInVertOffset*/), 0);
            localPos.xyz = mul(unity_WorldToObject, worldPos).xyz;
        }
    }
#endif
