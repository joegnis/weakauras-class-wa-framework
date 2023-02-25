--Global definitions
JOEGNIS_CLASS_WA = JOEGNIS_CLASS_WA or {}
--Reads class name from group name so we should name the group exactly as this.
--This also means we only support one group per class. This may be changed later.
local class = aura_env.id:gsub("General Options %- JWA %- ", "")
JOEGNIS_CLASS_WA.CLASS = class

JOEGNIS_CLASS_WA.config = aura_env.config
JOEGNIS_CLASS_WA.CONFIG_GROUP_MAIN = "main_icon_settings"
JOEGNIS_CLASS_WA.CONFIG_GROUP_SECOND = "second_icon_settings"
JOEGNIS_CLASS_WA.CONFIG_GROUP_TERTIARY1 = "tertiary1_icon_settings"
JOEGNIS_CLASS_WA.CONFIG_GROUP_TERTIARY2 = "tertiary2_icon_settings"
JOEGNIS_CLASS_WA.CONFIG_GROUP_QUATERNARY1 = "quaternary1_icon_settings"
JOEGNIS_CLASS_WA.CONFIG_GROUP_QUATERNARY2 = "quaternary2_icon_settings"

---Custom grow function
---@param new_positions any from WA custom grow function
---@param active_regions any from WA custom grow function
---@param group string
---@param icon_width number
---@param icon_height  number
---@param max_num_per_row  number
---@param horizontal_spacing  number
---@param vertical_spacing  number
---@param reverse_sort boolean
function JOEGNIS_CLASS_WA.CustomGrowCenter(new_positions, active_regions, group, icon_width, icon_height, max_num_per_row,
                                           horizontal_spacing, vertical_spacing, reverse_sort)
    local num_regions = #active_regions
    if num_regions < 0 then return end

    JOEGNIS_CLASS_WA.styleIconsInGroup(group, icon_width, icon_height)

    local i_region = 1
    local regions_left = num_regions
    local position_y = 0
    local direction_x = reverse_sort and -1 or 1
    -- Put icons line by line
    while regions_left > 0 do
        local num_reg_row = min(regions_left, max_num_per_row)
        local row_length = (num_reg_row - 1) * (icon_width + horizontal_spacing)
        local position_x = -row_length * direction_x / 2
        for _ = 1, num_reg_row do
            new_positions[i_region] = { position_x, position_y }

            position_x = position_x + (icon_width + horizontal_spacing) * direction_x
            i_region = i_region + 1
        end

        position_y = position_y - (icon_height + vertical_spacing)
        regions_left = regions_left - num_reg_row
    end
end

---Sets style of icons in a WA group
---@param group string WA group name
---@param icon_width number
---@param icon_height number
function JOEGNIS_CLASS_WA.styleIconsInGroup(group, icon_width, icon_height)
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

---@param config_group string config group name
---@param group string dynamic group name
---@param new_positions any
---@param active_regions any
function JOEGNIS_CLASS_WA.readConfigAndCustomGrow(config_group, group, new_positions, active_regions)
    local icon_width = JOEGNIS_CLASS_WA.config[config_group].width
    local icon_height = JOEGNIS_CLASS_WA.config[config_group].height
    local max_num_per_row = JOEGNIS_CLASS_WA.config[config_group].max_num_per_row
    local horizontal_spacing = JOEGNIS_CLASS_WA.config[config_group].horizontal_spacing
    local vertical_spacing = JOEGNIS_CLASS_WA.config[config_group].vertical_spacing
    local reverse_sort = JOEGNIS_CLASS_WA.config[config_group].reverse_sort

    JOEGNIS_CLASS_WA.CustomGrowCenter(new_positions, active_regions,
        group, icon_width, icon_height, max_num_per_row,
        horizontal_spacing, vertical_spacing, reverse_sort)
end

--Init
C_Timer.After(1, function()
    WeakAuras.ScanEvents("JOEGNIS_CLASS_WA_INIT")
end)
