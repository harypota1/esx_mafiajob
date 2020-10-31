-- Discord: harypota#3867

Config = {}
Config.Organisations = {
	['org_corona'] = {
		Members = {
			-- rangi: 1,2,3,4,5
			['steam:110000123456789'] = 1, -- 1 = najmniejsza ranga w mafii (1-5)
			['steam:11000010e39af9a'] = 5, -- 5 = największa ranga w mafii (5-1)
		},
		Settings = {
			DailyMoney = 30000, -- Dzienne kasa
			Type = 'cartel', -- typy: gang/cartel/syndicate/mafia
			Label = 'Cartelinio', 
			Blip = {
				{Position = {x = -90.57, y = 994.43, z = 234.56 }, Sprite = 437, Color = 64, Label = 'Corona Nuova'}
			},
			Weapons = {
				{name = 'weapon_pistol', price = 40000, grade = 5},
			},
			Items = {
				{label = 'Magaznyek', name = 'clip', price = 5000, grade = 5}
			}
		},
		Zones = {
			BossMenu = {
				{x = -60.19, y = 982.01, z = 233.54}
			},	
			Armory = {
				{x = -85.29, y = 997.42, z = 229.44}
			},
			Clothing = {
				{x = -99.5, y = 999.18, z = 234.87}
			},
			Cupboard = {
				{x = -78.22, y = 1001.62, z = 229.44}
			}
		}
	}
}

Config.Scope = {
    ['weapon_snspistol_mk2'] = 'COMPONENT_AT_PI_RAIL_02',
    ['weapon_smg_mk2'] = 'COMPONENT_AT_SCOPE_SMALL_SMG_MK2',
    ['weapon_pumpshotgun_mk2'] = 'COMPONENT_AT_SIGHTS',
	['weapon_microsmg'] = 'COMPONENT_AT_SCOPE_MACRO',
	['weapon_smg'] = 'COMPONENT_AT_SCOPE_MACRO_02',
	['weapon_assaultsmg'] = 'COMPONENT_AT_SCOPE_MACRO',
	['weapon_combatpdw'] = 'COMPONENT_AT_SCOPE_SMALL',
	['weapon_assaultrifle'] = 'COMPONENT_AT_SCOPE_MACRO',
	['weapon_assaultrifle_mk2'] = 'COMPONENT_AT_SCOPE_MACRO_MK2',
	['weapon_carbinerifle'] = 'COMPONENT_AT_SCOPE_MEDIUM',
	['weapon_carbinerifle_mk2'] = 'COMPONENT_AT_SCOPE_MACRO_MK2',
	['weapon_advancedrifle'] = 'COMPONENT_AT_SCOPE_SMALL',
	['weapon_specialcarbine'] = 'COMPONENT_AT_SCOPE_MEDIUM',
	['weapon_specialcarbine_mk2'] = 'COMPONENT_AT_SCOPE_MACRO_MK2',
	['weapon_bullpuprifle'] = 'COMPONENT_AT_SCOPE_SMALL',
	['weapon_bullpuprifle_mk2'] = 'COMPONENT_AT_SCOPE_MACRO_02_MK2',
	['weapon_mg'] = 'COMPONENT_AT_SCOPE_SMALL_02',
	['weapon_combatmg'] = 'COMPONENT_AT_SCOPE_MEDIUM',
	['weapon_sniperrifle'] = 'COMPONENT_AT_SCOPE_LARGE',
	['weapon_heavysniper'] = 'COMPONENT_AT_SCOPE_LARGE',
	['weapon_heavysniper_mk2'] = 'COMPONENT_AT_SCOPE_LARGE_MK2' ,
	['weapon_marksmanrifle'] = 'COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM',
	['weapon_marksmanrifle_mk2'] = 'COMPONENT_AT_SCOPE_MEDIUM_MK2'
}

Config.Silencer = {
	['weapon_pistol'] = 'COMPONENT_AT_PI_SUPP_02',
	['weapon_pistol_mk2'] = 'COMPONENT_AT_PI_SUPP_02',
	['weapon_combatpistol'] = 'COMPONENT_AT_PI_SUPP',
	['weapon_appistol'] = 'COMPONENT_AT_PI_SUPP',
	['weapon_pistol50'] = 'COMPONENT_AT_AR_SUPP_02',
	['weapon_snspistol_mk2'] = 'COMPONENT_AT_PI_SUPP_02',
	['weapon_heavypistol'] = 'COMPONENT_AT_PI_SUPP',
	['weapon_vintagepistol'] = 'COMPONENT_AT_PI_SUPP',
	['weapon_ceramicpistol'] = 'COMPONENT_CERAMICPISTOL_SUPP',
	['weapon_microsmg'] = 'COMPONENT_AT_AR_SUPP_02' ,
	['weapon_smg'] = 'COMPONENT_AT_PI_SUPP',
	['weapon_smg_mk2'] = 'COMPONENT_AT_PI_SUPP',
	['weapon_assaultsmg'] = 'COMPONENT_AT_AR_SUPP_02',
	['weapon_assaultrifle_mk2'] = 'COMPONENT_AT_AR_SUPP_02',
	['weapon_machinepistol'] = 'COMPONENT_AT_PI_SUPP',
	['weapon_pumpshotgun'] = 'COMPONENT_AT_SR_SUPP',
	['weapon_pumpshotgun_mk2'] = 'COMPONENT_AT_SR_SUPP_03',
	['weapon_assaultshotgun'] = 'COMPONENT_AT_AR_SUPP',
	['weapon_bullpupshotgun'] = 'COMPONENT_AT_AR_SUPP_02',
	['weapon_heavyshotgun'] = 'COMPONENT_AT_AR_SUPP_02',
	['weapon_assaultrifle'] = 'COMPONENT_AT_AR_SUPP_02',
	['weapon_carbinerifle'] = 'COMPONENT_AT_AR_SUPP',
	['weapon_carbinerifle_mk2'] = 'COMPONENT_AT_AR_SUPP',
	['weapon_advancedrifle'] = 'COMPONENT_AT_AR_SUPP',
	['weapon_specialcarbine'] = 'COMPONENT_AT_AR_SUPP_02',
	['weapon_specialcarbine_mk2'] = 'COMPONENT_AT_AR_SUPP_02',
	['weapon_bullpuprifle'] = 'COMPONENT_AT_AR_SUPP',
	['weapon_bullpuprifle_mk2'] = 'COMPONENT_AT_AR_SUPP',
	['weapon_sniperrifle'] = 'COMPONENT_AT_AR_SUPP_02',
	['weapon_heavysniper_mk2'] = 'COMPONENT_AT_SR_SUPP_03',
	['weapon_marksmanrifle'] = 'COMPONENT_AT_AR_SUPP',
	['weapon_marksmanrifle_mk2'] = 'COMPONENT_AT_AR_SUPP'
}

Config.Flashlight = {
	['weapon_pistol'] = 'COMPONENT_AT_PI_FLSH',
	['weapon_pistol_mk2'] = 'COMPONENT_AT_PI_FLSH_02',
	['weapon_combatpistol'] = 'COMPONENT_AT_PI_FLSH',
	['weapon_appistol'] = 'COMPONENT_AT_PI_FLSH',
	['weapon_pistol50'] = 'COMPONENT_AT_PI_FLSH',
	['weapon_snspistol_mk2'] = 'COMPONENT_AT_PI_FLSH_03',
	['weapon_heavypistol'] = 'COMPONENT_AT_PI_FLSH',
	['weapon_microsmg'] = 'COMPONENT_AT_PI_FLSH',
	['weapon_smg'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_smg_mk2'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_assaultsmg'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_combatpdw'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_pumpshotgun'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_pumpshotgun_mk2'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_assaultshotgun'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_bullpupshotgun'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_heavyshotgun'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_assaultrifle'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_assaultrifle_mk2'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_carbinerifle'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_carbinerifle_mk2'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_advancedrifle'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_specialcarbine'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_specialcarbine_mk2'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_bullpuprifle'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_bullpuprifle_mk2'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_marksmanrifle_mk2'] = 'COMPONENT_AT_AR_FLSH',
	['weapon_marksmanrifle'] = 'COMPONENT_AT_AR_FLSH'
}

Config.Magazine = {
    ['weapon_pistol'] = 'COMPONENT_PISTOL_CLIP_02',
    ['weapon_combatpistol'] = 'COMPONENT_COMBATPISTOL_CLIP_02',
    ['weapon_pistol50'] = 'COMPONENT_PISTOL50_CLIP_02',
    ['weapon_snspistol_mk2'] = 'COMPONENT_SNSPISTOL_MK2_CLIP_02',
    ['weapon_smg_mk2'] = 'COMPONENT_SMG_MK2_CLIP_02',
    ['weapon_machinepistol'] = 'COMPONENT_MACHINEPISTOL_CLIP_03',
	['weapon_pistol_mk2'] = 'COMPONENT_PISTOL_MK2_CLIP_02',
	['weapon_appistol'] = 'COMPONENT_APPISTOL_CLIP_02',
	['weapon_snspistol'] = 'COMPONENT_SNSPISTOL_CLIP_02',
	['weapon_heavypistol'] = 'COMPONENT_HEAVYPISTOL_CLIP_02',
	['weapon_vintagepistol'] = 'COMPONENT_VINTAGEPISTOL_CLIP_02',
	['weapon_microsmg'] = 'COMPONENT_MICROSMG_CLIP_02',
	['weapon_smg'] = 'COMPONENT_SMG_CLIP_02',
	['weapon_assaultsmg'] = 'COMPONENT_ASSAULTSMG_CLIP_02',
	['weapon_combatpdw'] = 'COMPONENT_COMBATPDW_CLIP_02',
	['weapon_minismg'] = 'COMPONENT_MINISMG_CLIP_02',
	['weapon_assaultshotgun'] = 'COMPONENT_ASSAULTSHOTGUN_CLIP_02',
	['weapon_heavyshotgun'] = 'COMPONENT_HEAVYSHOTGUN_CLIP_02',
	['weapon_assaultrifle'] = 'COMPONENT_ASSAULTRIFLE_CLIP_02',
	['weapon_assaultrifle_mk2'] = 'COMPONENT_ASSAULTRIFLE_MK2_CLIP_02',
	['weapon_carbinerifle'] = 'COMPONENT_CARBINERIFLE_CLIP_02',
	['weapon_carbinerifle_mk2'] = 'COMPONENT_CARBINERIFLE_MK2_CLIP_02',
	['weapon_advancedrifle'] = 'COMPONENT_ADVANCEDRIFLE_CLIP_02',
	['weapon_specialcarbine'] = 'COMPONENT_SPECIALCARBINE_CLIP_02',
	['weapon_specialcarbine_mk2'] = 'COMPONENT_SPECIALCARBINE_MK2_CLIP_02',
	['weapon_bullpuprifle'] = 'COMPONENT_BULLPUPRIFLE_CLIP_02',
	['weapon_bullpuprifle_mk2'] = 'COMPONENT_BULLPUPRIFLE_MK2_CLIP_02',
	['weapon_compactrifle'] = 'COMPONENT_COMPACTRIFLE_CLIP_02',
	['weapon_mg'] = 'COMPONENT_MG_CLIP_02',
	['weapon_combatmg'] = 'COMPONENT_COMBATMG_CLIP_02',
	['weapon_combatmg_mk2'] = 'COMPONENT_COMBATMG_MK2_CLIP_02',
	['weapon_gusenberg'] = 'COMPONENT_GUSENBERG_CLIP_02',
	['weapon_marksmanrifle'] = 'COMPONENT_MARKSMANRIFLE_CLIP_02',
	['weapon_marksmanrifle_mk2'] = 'COMPONENT_MARKSMANRIFLE_MK2_CLIP_02',
	['weapon_heavysniper_mk2'] = 'COMPONENT_HEAVYSNIPER_MK2_CLIP_02',
}

Config.Type2 = {
    'weapon_snspistol_mk2',
    'weapon_smg_mk2',
    'weapon_pumpshotgun_mk2',
	'weapon_pistol_mk2',
	'weapon_assaultrifle_mk2',
	'weapon_carbinerifle_mk2',
	'weapon_specialcarbine_mk2',
	'weapon_bullpuprifle_mk2',
	'weapon_combatmg_mk2',
	'weapon_marksmanrifle_mk2'
}