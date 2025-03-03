-- the gas collector is a pumpjack and a roboport combined.
local visualization               = {
    layers = {
        {

            stripes = {
                {
                    filename = "__dea-dia-system__/graphics/entity/gas-collector/gas-collector-hr-animation-1.png",
                    width_in_frames = 8,
                    height_in_frames = 8
                }
            },
            priority = "high",
            width = 4720 / 8,
            height = 5120 / 8,
            frame_count = 8 * 8,
            animation_speed = 1,
            scale = 0.5,
            run_mode = "forward",
            flags = { "no-scale" }
        },
        {
            stripes = {
                {
                    filename = "__dea-dia-system__/graphics/entity/gas-collector/gas-collector-hr-emission-1.png",
                    width_in_frames = 8,
                    height_in_frames = 8
                }
            },
            priority = "high",
            width = 4720 / 8,
            height = 5120 / 8,
            frame_count = 8 * 8,
            animation_speed = 1,
            scale = 0.5,
            run_mode = "forward",
            draw_as_glow = true,
            flags = { "no-scale" }
        }
    }
}

local gas_collector               = table.deepcopy(data.raw["mining-drill"]["pumpjack"])

gas_collector.name                = "gas-collector"
gas_collector.resource_categories = {
    "gas-giant"
}


gas_collector.subgroup         = "gas-giant"

gas_collector.graphics_set     = nil
gas_collector.energy_source    = { type = "void" }

gas_collector.collision_box    = { { -3.4, -3.4 }, { 3.4, 3.4 } }
gas_collector.selection_box    = { { -3.5, -3.5 }, { 3.5, 3.5 } }

gas_collector.output_fluid_box =
{
    pipe_picture = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures,
    pipe_picture_frozen = require("__space-age__.prototypes.entity.electromagnetic-plant-pictures").pipe_pictures_frozen,
    pipe_covers = pipecoverspictures(),
    volume = 2000,
    pipe_connections = {
        {
            direction = defines.direction.south, flow_direction = "output", position = { 2.95, 2.95 }
        },
        {
            direction = defines.direction.north, flow_direction = "output", position = { -2.95, -2.95 }
        },
        {
            direction = defines.direction.west, flow_direction = "output", position = { -2.95, 2.95 }
        },
        {
            direction = defines.direction.east, flow_direction = "output", position = { 2.95, -2.95 }
        }
    },
    secondary_draw_orders = { north = -1 },
}


gas_collector.icon                                   = "__dea-dia-system__/graphics/icon/gas-collector.png"
gas_collector.collision_mask                         = {
    layers = {
    }
}
local gas_collector_roboport                         = table.deepcopy(data.raw["roboport"]["roboport"])
gas_collector_roboport.name                          = "gas-collector-roboport"
gas_collector_roboport.logistics_connection_distance = 120
gas_collector_roboport.selection_priority            = 51
gas_collector_roboport.is_military_target            = true

gas_collector_roboport.base_animation                = visualization
gas_collector_roboport.stateless_visualisation       = {
    animation = {
        filename = "__dea-dia-system__/graphics/entity/gas-collector/gas-collector-hr-shadow.png",
        priority = "high",
        width = 600,
        height = 400,
        frame_count = 1,
        line_length = 1,
        animation_speed = 1,
        scale = 0.5,
        draw_as_shadow = true,
    }
}
-- the roboport is the thing you can mine, because this allows the construction bots to remove everything from it before it can be removed.
gas_collector_roboport.minable                       = {
    mining_time = 100,
    result = "gas-collector"
}
gas_collector.minable                                = nil

local size                                           = 5
gas_collector_roboport.collision_box                 = {
    {
        x = -size,
        y = -size
    },
    {
        x = size,
        y = size
    }
}

gas_collector_roboport.placeable_by                  = { item = "gas-collector", count = 1 }
gas_collector_roboport.door_animation_down           = nil
gas_collector_roboport.door_animation_up             = nil
gas_collector_roboport.base_patch                    = nil
gas_collector_roboport.energy_source                 = { type = "void" }

gas_collector_roboport.collision_box                 = { { -2.4, -2.4 }, { 2.4, 2.4 } }
gas_collector_roboport.selection_box                 = { { -2.5, -2.5 }, { 2.5, 2.5 } }

local number_of_charging_ports                       = 20

gas_collector_roboport.charging_station_count        = number_of_charging_ports

local radius                                         = 10
local angle_increment                                = 2 * math.pi / number_of_charging_ports
local points                                         = {}

for i = 0, number_of_charging_ports - 1 do
    local angle = i * angle_increment
    local x = 0 + radius * math.cos(angle)
    local y = 0 + radius * math.sin(angle)
    table.insert(points, { x = x, y = y })
end
gas_collector_roboport.spawn_and_station_height = 60
gas_collector_roboport.charging_offsets = points


data.extend {
    gas_collector,
    gas_collector_roboport,
    {
        default_import_location = "planet-dea-dia",
        type = "item",
        name = "gas-collector",
        icon = "__dea-dia-system__/graphics/icon/gas-collector.png",
        icon_size = 64,
        place_result = "gas-collector",
        subgroup = gas_collector.subgroup,
        order = "d[gas-collector]",
        stack_size = 50,
        scale = 0.5,
    }, {
    type               = "recipe",
    name               = "gas-collector",
    icon               = "__dea-dia-system__/graphics/icon/gas-collector.png",
    category           = "metallurgy-or-assembling",
    surface_conditions = {
        {
            property = "gravity",
            max = 0
        }
    },
    energy_required    = 1,
    ingredients        = {
        { type = "item",  name = "roboport",                  amount = 1 },
        { type = "item",  name = "heat-exchanger",            amount = 1 },
        { type = "item",  name = "magnesium-plate",           amount = 1000 },
        { type = "item",  name = "copper-plate",              amount = 50 },
        { type = "item",  name = "rubber",                    amount = 50 },
        { type = "item",  name = "processing-unit",           amount = 100 },
        { type = "fluid", name = "lubricant",                 amount = 300 },
        { type = "item",  name = "space-platform-foundation", amount = 300 },
        { type = "item",  name = "steam-turbine",             amount = 4 },
        { type = "item",  name = "thruster",                  amount = 4 }
    },
    results            =
    {
        { type = "item", name = "gas-collector", amount = 1 },
    }
}
}

gas_collector.flags = {
    "not-blueprintable",
    "not-deconstructable",
    "not-rotatable",
    "not-flammable",
    "no-copy-paste",
    "player-creation",
    "not-upgradable",
    "not-in-kill-statistics"
}
gas_collector.corpse = nil
gas_collector_roboport.corpse = nil

gas_collector_roboport.flags = {
    "not-blueprintable",
    "not-rotatable",
    "not-flammable",
    "no-copy-paste",
    "player-creation",
    "not-upgradable",
    "not-in-kill-statistics"
}
