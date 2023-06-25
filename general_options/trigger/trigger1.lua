--[[
Type: Custom,
Event Type: Event,
Event(s): OPTIONS,JOEGNIS_CLASS_WA_INIT
]]
function trigger(event)
    --when copying to the game, copy from the next line
    --function(event)
    if event == "OPTIONS" or event == "JOEGNIS_CLASS_WA_INIT" then
        local SPEC = aura_env.SPEC
        local CONFIG = aura_env.config

        -- Infers group name from config key name
        for group_key, _ in pairs(aura_env.config) do
            local group = group_key:gsub("_icon_settings", "")
            group = group:gsub("_", " ")
            group = group:gsub("(%l)(%w*)", function(a, b) return string.upper(a) .. b end)
            group = group .. " - JWA - " .. SPEC

            aura_env.styleIconsInGroup(
                group,
                CONFIG[group_key].width,
                CONFIG[group_key].height
            )
        end
    end
end
