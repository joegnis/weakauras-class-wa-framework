-- Run on: changed
function(newPositions, activeRegions)
    if JOEGNIS_CLASS_WA then
        local config_group = JOEGNIS_CLASS_WA.CONFIG_GROUP_MAIN
        JOEGNIS_CLASS_WA.readConfigAndCustomGrow(config_group, aura_env.id, newPositions, activeRegions)
    end
end
