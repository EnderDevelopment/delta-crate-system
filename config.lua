Config = {}

-- Crate settings
Config.CrateModels = {
    'prop_crate_01',
    'prop_crate_02'
}

Config.CrateSpawnChance = 0.1 -- 10% chance to spawn a crate

-- AI settings
Config.AIModels = {
    'a_m_m_bevhills_01',
    'a_m_m_bevhills_02'
}

Config.AISpawnChance = 0.2 -- 20% chance to spawn AI with a crate

-- Reward settings
Config.Rewards = {
    {name = 'money', amount = 1000},
    {name = 'weapon', weapon = 'WEAPON_PISTOL'}
}