local resource_autoplace = require("resource-autoplace")

local name = "fossil"

local autoplace_control = {
    category = "resource",
    localised_name = { name },
    name = name,
    order = "b-d",
    richness = true,
    type = "autoplace-control"
}

local ore = {
    type = "resource",
    icon_size = 64,
    icon_mipmaps = 3,
    name = name,
    icon = "__dea-dia-system__/graphics/icon/fossil-1.png",
    flags = { "placeable-neutral" },
    order = "a-b-a",
    map_color = { r = 0.59, g = 0.48, b = 0.40 },
    minable =
    {
        hardness = .5,
        mining_particle = "medium-rock-stone-particle-small",
        mining_time = 2,
        result = name,
    },
    collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    autoplace = resource_autoplace.resource_autoplace_settings
        {
            name = name,
            order = "s",
            base_density = 4,
            base_spots_per_km = 1,
            has_starting_area_placement = true,
            regular_rq_factor_multiplier = 1.10,
            starting_rq_factor_multiplier = 2,
            candidate_spot_count = 20
        },
    stage_counts = { 5000, 700, 250 },
    stages =
    {
        sheet =
        {
            filename = "__dea-dia-system__/graphics/resource/fossil.png",
            priority = "extra-high",
            size = 128,
            frame_count = 3,
            variation_count = 3,
            scale = 0.5
        }

    },
}
data:extend {
    ore, autoplace_control
}