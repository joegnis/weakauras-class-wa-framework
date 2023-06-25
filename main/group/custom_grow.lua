-- Run on: changed
function grow(newPositions, activeRegions)
    --when copying to the game, copy from the next line
    --function(newPositions, activeRegions)
    local SPEC = aura_env.id:gsub(".*%- JWA %- ", "")
    local JOEGNIS_CLASS_WA = JOEGNIS_CLASS_WA and JOEGNIS_CLASS_WA[SPEC] or {}

    if JOEGNIS_CLASS_WA and JOEGNIS_CLASS_WA.readConfigAndCustomGrow then
        JOEGNIS_CLASS_WA.readConfigAndCustomGrow(aura_env.id, newPositions, activeRegions)
    end
end
