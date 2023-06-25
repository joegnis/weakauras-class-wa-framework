--Global definitions
JOEGNIS_CLASS_WA = JOEGNIS_CLASS_WA or {}
-- Infers spec name from group name so we should name the group exactly as this.
local SPEC = aura_env.id:gsub("General Options %- JWA %- ", "")
aura_env.SPEC = SPEC  -- not sharing this globally to avoid pollution

-- Separate out environments of each spec
JOEGNIS_CLASS_WA[SPEC] = JOEGNIS_CLASS_WA[SPEC] or {}
local JWA_SPEC = JOEGNIS_CLASS_WA[SPEC]
JWA_SPEC.config = {}
JWA_SPEC.config[SPEC] = aura_env.config

---Custom grow function
---@param new_positions any from WA custom grow function
---@param active_regions any from WA custom grow function
---@param group string
---@param icon_width number
---@param icon_height  number
---@param max_num_per_row  number
---@param row_spacing  number
---@param column_spacing  number
---@param grow_along_y boolean
---@param center_row boolean
---@param reverse_row_direction boolean
---@param reverse_col_direction boolean
function JWA_SPEC.CustomGrowCenter(new_positions, active_regions, group, icon_width, icon_height, max_num_per_row,
                                           row_spacing, column_spacing, grow_along_y, center_row,
                                           reverse_row_direction, reverse_col_direction)
    local num_regions = #active_regions
    if num_regions < 0 then return end

    JWA_SPEC.styleIconsInGroup(group, icon_width, icon_height)

    --[[
        Rows either grow along x or y axis.
    ]]
    local i_region = 1
    local regions_left = num_regions
    local position_col = 0
    local direction_row = reverse_row_direction and -1 or 1
    local direction_col = reverse_col_direction and -1 or 1
    -- Put icons row by row
    while regions_left > 0 do
        -- Number of icons (regions) in current row
        local num_icons = min(regions_left, max_num_per_row)
        local row_length = (num_icons - 1) * (icon_width + column_spacing)

        local position_row
        if center_row then
            position_row = -row_length / 2 * direction_row
        else
            position_row = 0
        end

        for _ = 1, num_icons do
            if grow_along_y then
                new_positions[i_region] = { position_col, position_row }
            else
                new_positions[i_region] = { position_row, position_col }
            end

            position_row = position_row + (icon_width + column_spacing) * direction_row
            i_region = i_region + 1
        end

        position_col = position_col - (icon_height + row_spacing) * direction_col
        regions_left = regions_left - num_icons
    end
end

---Sets style of icons in a WA group
---@param group string WA group name
---@param icon_width number
---@param icon_height number
function JWA_SPEC.styleIconsInGroup(group, icon_width, icon_height)
    local region_group = WeakAuras.GetRegion(group)
    if region_group and region_group.controlledChildren then
        for _, regions in pairs(region_group.controlledChildren) do
            local region = regions[""] and regions[""].regionData.region
            if region then
                region:SetRegionWidth(icon_width)
                region:SetRegionHeight(icon_height)
                region:SetZoom(0.3)
            end
        end
    end
end
-- For use in triggers
aura_env.styleIconsInGroup = JWA_SPEC.styleIconsInGroup

---@param group string dynamic group name
---@param new_positions any
---@param active_regions any
function JWA_SPEC.readConfigAndCustomGrow(group, new_positions, active_regions)
    -- Infers config group name:
    -- "Main - JWA - RestoDruid" -> "Main" -> "main_icon_settings"
    local config_group = group:gsub("%s+%- JWA %-.*", "")
    config_group = config_group:gsub("%s+", "_")
    config_group = strlower(config_group) .. "_icon_settings"
    local icon_width = JWA_SPEC.config[SPEC][config_group].width
    local icon_height = JWA_SPEC.config[SPEC][config_group].height
    local max_num_per_row = JWA_SPEC.config[SPEC][config_group].max_num_per_row
    local row_spacing = JWA_SPEC.config[SPEC][config_group].row_spacing
    local column_spacing = JWA_SPEC.config[SPEC][config_group].column_spacing
    local grow_along_y = JWA_SPEC.config[SPEC][config_group].grow_along_y
    local center_row = JWA_SPEC.config[SPEC][config_group].center_row
    local reverse_row_direction = JWA_SPEC.config[SPEC][config_group].reverse_row_direction
    local reverse_col_direction = JWA_SPEC.config[SPEC][config_group].reverse_col_direction

    JWA_SPEC.CustomGrowCenter(new_positions, active_regions,
        group, icon_width, icon_height, max_num_per_row,
        row_spacing, column_spacing, grow_along_y, center_row,
        reverse_row_direction, reverse_col_direction)
end

--Init
C_Timer.After(1, function()
    WeakAuras.ScanEvents("JOEGNIS_CLASS_WA_INIT")
end)
