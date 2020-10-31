ESX = nil
local PlayerData = {}
local isDead = false
local Blips = {}
local HasAlreadyEnteredMarker = false
local LastStation = nil
local LastPart = nil
local LastPartNum = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local onHead = nil
local isDead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	Citizen.Wait(5000)
	GetSharedOrganisation()
end)

GetSharedOrganisation = function()
	while ESX == nil do
		Citizen.Wait(0)
	end
	for k,v in pairs(Blips) do
		RemoveBlip(v)
	end
	PlayerData = ESX.GetPlayerData()
	PlayerData.organisation = {}
	ESX.TriggerServerCallback('esx_organisation:getCharackter', function(char)
		PlayerData.organisation = char
		if PlayerData.organisation and PlayerData.organisation.name then
			local work = Config.Organisations[PlayerData.organisation.name]
			work = work.Settings.Blip or false
			if work then
				for k, v in pairs(work) do
					local b = AddBlipForCoord(v.Position.x, v.Position.y, v.Position.z)
					SetBlipSprite(b, v.Sprite)
					SetBlipDisplay(b, 4)
					SetBlipScale(b, 1.4)
					SetBlipColour(b, v.Color)
					SetBlipAsShortRange(b, true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(v.Label)
					EndTextCommandSetBlipName(b)
					table.insert(Blips,b)
				end
			end
		end
	end)
end

function OpenOrganisationActionsMenu()
	local elements = {
		{label = 'Przeszukaj', value = 'body_search'},
		{label = 'Zakuj', value = 'handcuff'},
		{label = 'Przenieś', value = 'drag'},
		{label = 'Wyciągnij z Pojazdu', value = 'out_the_vehicle'},
		{label = 'Włóż do Pojazdu', 	value = 'put_in_vehicle'},
	}
	if PlayerData.organisation then
		table.insert(elements, {label = 'Worek', value = 'worek'})
		if Config.Organisations[PlayerData.organisation.name].Settings.Type == 'mafia' or Config.Organisations[PlayerData.organisation.name].Settings.Type == 'syndicate' then
			if PlayerData.organisation.grade >= 4 then
				table.insert(elements, {label = 'Wybierz wariant broni', value = 'skin'})
			end
			table.insert(elements,{label = 'Tłumik do broni',	value = 'silenter'})
		end
		if Config.Organisations[PlayerData.organisation.name].Settings.Type == 'syndicate' then
			if PlayerData.organisation.grade == 5 then
				table.insert(elements,{label = 'Magazynek do broni',	value = 'magazine'})
				table.insert(elements,{label = 'Celownik do broni',	value = 'scope'})
			end
			if PlayerData.organisation.grade >= 4 then
				table.insert(elements, {label = 'Latarka do broni',	value = 'flashlight'})
			end
		end
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'organisation_handcuffs',
		{
			title    = 'Organizacja'..(PlayerData.organisation and ': '..PlayerData.organisation.label or ''),
			align    = 'center',
			elements =  elements
	}, function(data, menu)
		if data.current.value == 'flashlight' then
			TriggerEvent("golden_components:addFlashlight")
		elseif data.current.value == 'skin' then
			TriggerEvent('golden_components:changeSkin')
		elseif data.current.value == 'silenter' then
			TriggerEvent("golden_components:addSilencer")
		elseif data.current.value == 'scope' then
			TriggerEvent("golden_components:addScope")
		elseif data.current.value == 'magazine' then
			TriggerEvent("golden_components:addMagazine")
		else
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				if data.current.value == 'body_search' then
					exports['esx_policejob']:OpenBodySearchMenu(closestPlayer)
				elseif data.current.value == 'handcuff' then
					-- Tutaj podajesz event do zakuwania
				elseif data.current.value == 'drag' then
					-- Tutaj podajesz event do przenoszenia
				elseif data.current.value == 'put_in_vehicle' then
					-- Tutaj podajesz event do wkladanie do pojazdu
				elseif data.current.value == 'out_the_vehicle' then
					-- Tutaj podajesz event do wyciagania z pojazdu
				elseif data.current.value == 'worek' then
					TriggerEvent('esx_organisation:worek',GetPlayerServerId(closestPlayer))
				end
			else
				ESX.ShowNotification('~r~Brak graczy w pobliżu!')
			end
		end
	end, function(data, menu)
		menu.close()
    end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if onHead then
			if IsPlayerDead(PlayerId()) then
				Citizen.Wait(50)
				DeleteEntity(onHead)
				onHead = nil
			else
				DrawRect(0, 0, 10.0, 10.0, 0, 0, 0, 255)
			end
		end
		if PlayerData.organisation and PlayerData.organisation.name then
			local coords = GetEntityCoords(PlayerPedId())
			for _, zone in pairs(Config.Organisations[PlayerData.organisation.name].Zones) do
				for k, v in pairs(zone) do
					if #(coords - vector3(v.x, v.y, v.z)) < 50 then
						DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 232, 142, 155, 100, false, true, 2, false, false, false, false)
					end
				end
			end
			if CurrentAction then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				if IsControlJustReleased(0, 38) then
					if CurrentAction == 'boss_menu' then
						OpenBossMenu()
					elseif CurrentAction == 'armory' then
						OpenArmoryMenu()					
					elseif CurrentAction == 'clothing' then
						--
					elseif CurrentAction == 'items_storage' then
						OpenStockMenu()
					end
					CurrentAction = nil
				end
			end
			if IsControlJustReleased(0, 167) and not isDead then
				OpenOrganisationActionsMenu()
			end
		end
	end
end)

function OpenStockMenu()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'schowek', {
        title    = 'Szafka',
        align    = 'center',
		elements = {
			{label = 'Pobierz przedmiot', value = 'get_stock'},
			{label = 'Zdeponuj przedmiot', value = 'put_stock'},
			{label = 'Pobierz broń', value = 'get_weapon'},
			{label = 'Zdeponuj broń', value = 'put_weapon'}
		},
	}, function(data, menu)
        if data.current.value == 'get_stock' then
			OpenGetStocksMenu()
       elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
        elseif data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()   
		elseif data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
        end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_organisation:getArmoryWeapons', function(weapons)
		local elements = {}
		for k, v in pairs(weapons) do
			table.insert(elements, {label = 'x' .. v.count .. ' ' .. ESX.GetWeaponLabel(k) .. ' [' .. v.ammo .. ']', value = k})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = 'Pobierz broń',
			align    = 'center',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.TriggerServerCallback('esx_organisation:removeArmoryWeapon', function()
			end, data.current.value, PlayerData.organisation.name)
		end, function(data, menu)
			menu.close()
		end)
	end, PlayerData.organisation.name)
end

function OpenPutWeaponMenu()
	local elements = {}
	local playerPed = PlayerPedId()
	local weaponList = ESX.GetWeaponList()
	for _, wep in pairs(weaponList) do
		local weaponHash = GetHashKey(wep.name)
		if HasPedGotWeapon(playerPed, weaponHash,  false) and wep.name ~= 'WEAPON_UNARMED' then
			local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
			table.insert(elements, {label = wep.label .. ' [' .. ammo .. ']', value = wep.name, ammo = ammo})
		end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		title = 'Zdeponuj broń',
		align = 'center',
		elements = elements
    }, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback('esx_organisation:addArmoryWeapon', function() 
		end, data.current.value, data.current.ammo or 0, PlayerData.organisation.name)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_organisation:getStockItems', function(items)
		local elements = {}
		for i, item in pairs(items) do
			if item.count > 0 then
				table.insert(elements, {label = 'x' .. item.count .. ' ' .. item.label, value = item.name})
			end
		end
		if not elements[1] then
			table.insert(elements, {label = 'Brak przedmiotów w szafce!'})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Pobierz przedmiot',
			align    = 'center',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				local itemName = data.current.value
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = 'Podaj ilość'
				}, function(data2, menu2)
					local count = tonumber(data2.value)
					if count == nil then
						ESX.ShowNotification('Nieprawidłowa ilość')
					else
						TriggerServerEvent('esx_organisation:getStockItem', itemName, count, PlayerData.organisation.name)
						menu2.close()
						menu.close()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, PlayerData.organisation.name)
end

 function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_organisation:getPlayerInventory', function(inventory)
		local elements = {}
		for i, item in pairs(inventory.items) do
			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, value = item.name})
			end
		end
		if not elements[1] then
			table.insert(elements, {label = 'Brak przedmiotów w plecaku!'})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Zdeponuj przedmiot',
			align    = 'center',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				local itemName = data.current.value
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
					title = 'Podaj Ilość'
				}, function(data2, menu2)
					local count = tonumber(data2.value)
					if count == nil then
						ESX.ShowNotification('~r~Nieprawidłowa ilość!')
					else
						TriggerServerEvent('esx_organisation:putStockItems', itemName, count, PlayerData.organisation.name)
						menu2.close()
						menu.close()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenArmoryMenu()
	local elements = {}
	if #Config.Organisations[PlayerData.organisation.name].Settings.Items > 0 then
		table.insert(elements, {label = 'Zakup przedmiot', value = 'buy_items'})
	end
	if #Config.Organisations[PlayerData.organisation.name].Settings.Weapons > 0 then
		table.insert(elements, {label = 'Zakup broń', value = 'buy_weapons'})
	end
	if not elements[1] then
		table.insert(elements, {label = 'Brak broni w zbrojowni!'})
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_' .. PlayerData.organisation.name, {
		title    = 'Zbrojownia: '..PlayerData.organisation.label,
		align    = 'center',
		elements = elements	
	}, function(data, menu)
		if not data.current.value then
			return
		end
		if data.current.value == 'buy_weapons' then
			OpenBuyWeaponsMenu()
		end
		if data.current.value == 'buy_items' then
			OpenBuyItemsMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBuyWeaponsMenu()
	ESX.TriggerServerCallback('esx_organisation:getSocietyMoney', function(money)
		local elements = {}
		table.insert(elements, {label = '[Stan Konta] $'..(money or 0)})
		for k, v in pairs(Config.Organisations[PlayerData.organisation.name].Settings.Weapons) do
			if v.grade and v.grade <= PlayerData.organisation.grade or not v.grade then
				table.insert(elements, {label = ESX.GetWeaponLabel(v.name)..' - <span style="background: linear-gradient(120deg,#3498db,#8e44ad); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">'..v.price..'$</span>', value = v.name, price = v.price})
			end
		end
		if not elements[1] then
			table.insert(elements, {label = 'Brak broni w zrbojowni!'})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_weapons_' .. PlayerData.organisation.name,
		{
			title    = 'Zakup broń',
			align    = 'center',
			elements = elements	
		}, function(data, menu)
			menu.close()
			if not data.current.value then
				return
			end
			TriggerServerEvent('esx_organisation:buyWeapon', data.current.value, data.current.price, PlayerData.organisation.name)
		end, function(data, menu)
			menu.close()
		end)
	end, PlayerData.organisation.name)
end

function OpenBuyItemsMenu()
	ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
		local elements = {}
		table.insert(elements, {label = '[Stan Konta] $'..(money or 0)})
		for k, v in pairs(Config.Organisations[PlayerData.organisation.name].Settings.Items) do
			if v.grade and v.grade <= PlayerData.organisation.grade or not v.grade then
				table.insert(elements, {label = v.label..' - <span style="background: linear-gradient(120deg,#3498db,#8e44ad); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">'..v.price..'$</span>', value = v.name, price = v.price})
			end
		end
		if not elements[1] then
			table.insert(elements, {label = 'Brak przedmiotów w zrbojowni!'})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_items_' .. PlayerData.organisation.name,
		{
			title    = 'Zakup przedmiot',
			align    = 'center',
			elements = elements	
		}, function(data, menu)
			menu.close()
			if not data.current.value then
				return
			end
			TriggerServerEvent('esx_organisation:buyWeapon', 'item_'..data.current.value, data.current.price, PlayerData.organisation.name)
		end, function(data, menu)
			menu.close()
		end)
	end, PlayerData.organisation.name)
end

function OpenBossMenu()
	local elements = {}
	ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
		table.insert(elements, {label = '[Stan Konta] $'..(money or 0)})
		if Config.Organisations[PlayerData.organisation.name].Settings.DailyMoney then
			table.insert(elements, {label = '[Dzienny dochód] $'..Config.Organisations[PlayerData.organisation.name].Settings.DailyMoney})
		end
		if PlayerData.organisation.grade >= 4 then
			table.insert(elements, {label = 'Pobierz kwotę z konta firmy', value = 'withdraw_society_money'})
			table.insert(elements, {label = 'Pobierz kwotę z konta firmy jako brudne', value = 'withdraw_society_black'})
		end
		table.insert(elements, {label = 'Zdeponuj kwotę na konto firmy', value = 'deposit_money'})
		table.insert(elements, {label = 'Wypierz pieniądze', value = 'wash'})
		ESX.UI.Menu.CloseAll()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. PlayerData.organisation.name,
		{
			title    = 'Zarządzaj organizacją: '..PlayerData.organisation.label,
			align    = 'center',
			elements = elements
			
		}, function(data2, menu2)
			if not data2.current.value then
				return
			end
			if data2.current.value == 'withdraw_society_money' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. PlayerData.organisation.name, {
					title = 'Kwota Wypłaty'
				}, function(data, menu)
					local amount = tonumber(data.value)
					if amount == nil then
						ESX.ShowNotification('~r~Nieprawidłowa kwota!')
					else
						menu.close()
						TriggerServerEvent('esx_organisation:withdrawMoney', PlayerData.organisation.name, amount, 2)
						OpenBossMenu()
					end
				end, function(data, menu)
					menu.close()
				end)
			elseif data2.current.value == 'withdraw_society_black' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_black_amount_' .. PlayerData.organisation.name, {
					title = 'Kwota Wypłaty'
				}, function(data, menu)
					local amount = tonumber(data.value)
					if amount == nil then
						ESX.ShowNotification('~r~Nieprawidłowa kwota!')
					else
						menu.close()
						TriggerServerEvent('esx_organisation:withdrawMoney', PlayerData.organisation.name, amount, 1)
						OpenBossMenu()
					end
				end, function(data, menu)
					menu.close()
				end)
			elseif data2.current.value == 'deposit_money' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. PlayerData.organisation.name,
				{
					title = 'Kwota Depozytu'
				}, function(data, menu)
					local amount = tonumber(data.value)
					if amount == nil then
						ESX.ShowNotification('~r~Nieprawidłowa kwota!')
					else
						menu.close()
						TriggerServerEvent('esx_organisation:depositMoney', PlayerData.organisation.name, amount)
						OpenBossMenu()
					end
				end, function(data, menu)
					menu.close()
				end)
			elseif data2.current.value == 'wash' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'black_money_wash', {
						title = 'Wpisz kwotę'
				}, function(datao, menuo)
					local count = tonumber(datao.value)
					if count == nil then
						ESX.ShowNotification('~r~Nieprawidłowa kwota!')
						menuo.close()
					else
						menuo.close()
						TriggerServerEvent('esx_policjajob:washMoney',count, true)
					end
				end, function(datao, menuo)
					menuo.close()
				end)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, PlayerData.organisation.name)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		if PlayerData.organisation and PlayerData.organisation.name then
			local coords = GetEntityCoords(PlayerPedId())
			local 


Marker = false
			local currentStation = nil
			local currentPart = nil
			local currentPartNum = nil
			for station, zone in pairs(Config.Organisations[PlayerData.organisation.name].Zones) do
				for k, v in pairs(zone) do
					if #(coords - vector3(v.x, v.y, v.z)) < 1.5 then
						isInMarker = true
						currentStation = k
						currentPart = station
						currentPartNum = v
					end
				end
			end
			local hasExited = false
			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
				if (LastStation  and LastPart  and LastPartNum ) and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) then
					TriggerEvent('esx_organisation:hasExitedMarker')
					hasExited = true
				end
				HasAlreadyEnteredMarker = true
				LastStation = currentStation
				LastPart = currentPart
				LastPartNum = currentPartNum
				TriggerEvent('esx_organisation:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end
			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_organisation:hasExitedMarker')
			end
		else
			Citizen.Wait(1500)
		end
	end
end)

AddEventHandler('esx_organisation:hasEnteredMarker', function(station, part, partNum)
	if part == 'BossMenu' then
		CurrentAction     = 'boss_menu'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby zarządzać organizacją'
		CurrentActionData = {}
	end
	if part == 'Armory' then
		CurrentAction     = 'armory'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby przeglądać zbrojownie'
		CurrentActionData = {}
	end
	if part == 'Clothing' then
		CurrentAction     = 'clothing'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby zmienić ubranie'
		CurrentActionData = {}
	end	
	if part == 'Cupboard' then
		CurrentAction     = 'items_storage'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby otworzyć magazyn'
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_organisation:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esx_organisation:check')
AddEventHandler('esx_organisation:check',function()
	if not onHead then
		local ped = PlayerPedId()
		onHead = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
		AttachEntityToEntity(onHead, ped, GetPedBoneIndex(ped, 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
		ESX.ShowNotification('~r~Ktoś założył ci worek na głowę!')
	else
		DeleteEntity(onHead)
		onHead = nil
		ESX.ShowNotification('~g~Ktoś zdjął ci worek z głowy')
	end
end)

RegisterNetEvent('esx_organisation:worek')
AddEventHandler('esx_organisation:worek', function(target)
	if not IsPlayerDead(target) and not onHead then
		ESX.TriggerServerCallback('esx_organisation:put',function(cb) end, target)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	GetSharedOrganisation()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	GetSharedOrganisation()
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('golden_components:changeSkin', function(data)
	local Ped = PlayerPedId()
	local weapon = GetSelectedPedWeapon(Ped)
	local type2 = false
	for _, w in ipairs(Config.Type2) do
		if GetHashKey(w) == weapon then
			type2 = true
			break
		end
	end
	elements = data or {}
	if #elements == 0 then
		table.insert(elements, {label = 'Domyślny', value = 0})
		if type2 then
			for i=1, 30, 1 do
				table.insert(elements, {label = 'Wariant '..i, value = i})
			end
		else
			table.insert(elements, {label = 'Zielony', value = 1})
			table.insert(elements, {label = 'Złoty', value = 2})
			table.insert(elements, {label = 'Różowy', value = 3})
			table.insert(elements, {label = 'Wojskowy', value = 4})
			table.insert(elements, {label = 'Niebieski', value = 5})
			table.insert(elements, {label = 'Pomarańczowy', value = 6})
			table.insert(elements, {label = 'Rękodzieło', value = 7})
		end
	elseif type2 then
		elements = {
			{label = 'Domyślny', value = 0}
		}
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'set_paint', {
		title	= 'Malowanie broni',
		align	= 'center',
		elements = elements
	},function(data, menu)
		SetPedWeaponTintIndex(Ped, GetSelectedPedWeapon(Ped), data.current.value)
	end,function(data, menu)  
		menu.close()
	end)
end)

RegisterNetEvent('golden_components:addScope')
AddEventHandler('golden_components:addScope', function()
	local Ped = PlayerPedId()
	local WeapHash = GetSelectedPedWeapon(Ped)
	for k,v in pairs(Config.Scope) do
		if GetHashKey(k) == WeapHash then
			if HasPedGotWeaponComponent(Ped, WeapHash, GetHashKey(v)) then
				RemoveWeaponComponentFromPed(Ped, WeapHash, GetHashKey(v))
				ESX.ShowNotification('[~r~-~w~]: Celownik')
				PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_UNEQUIP", "HUD_AMMO_SHOP_SOUNDSET", 1)
			else
				GiveWeaponComponentToPed(Ped, GetHashKey(k), GetHashKey(v))
				ESX.ShowNotification('[~g~+~w~]: Celownik')
				PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_EQUIP", "HUD_AMMO_SHOP_SOUNDSET", 1)
			end
			return
		end
	end
	ESX.ShowNotification('~r~Brak odpowniedniego komponentu do tego rodzaju broni!')
end)


RegisterNetEvent('golden_components:addSilencer')
AddEventHandler('golden_components:addSilencer', function()
	local Ped = PlayerPedId()
	local WeapHash = GetSelectedPedWeapon(Ped)
	for k,v in pairs(Config.Silencer) do
		if GetHashKey(k) == WeapHash then
			if HasPedGotWeaponComponent(Ped, WeapHash, GetHashKey(v)) then
				RemoveWeaponComponentFromPed(Ped, WeapHash, GetHashKey(v))
				ESX.ShowNotification('[~r~-~w~]: Tłumik')
				PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_UNEQUIP", "HUD_AMMO_SHOP_SOUNDSET", 1)
			else
				GiveWeaponComponentToPed(Ped, GetHashKey(k), GetHashKey(v))
				ESX.ShowNotification('[~g~+~w~]: Tłumik')
				PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_EQUIP", "HUD_AMMO_SHOP_SOUNDSET", 1)
			end
		end
	end
end)

RegisterNetEvent('golden_components:addFlashlight')
AddEventHandler('golden_components:addFlashlight', function()
	local Ped = PlayerPedId()
	local WeapHash = GetSelectedPedWeapon(Ped)
	for k,v in pairs(Config.Flashlight) do
		if GetHashKey(k) == WeapHash then
			if HasPedGotWeaponComponent(Ped, WeapHash, GetHashKey(v)) then
				RemoveWeaponComponentFromPed(Ped, WeapHash, GetHashKey(v))
				ESX.ShowNotification('[~r~-~w~]: Latarka')
				PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_UNEQUIP", "HUD_AMMO_SHOP_SOUNDSET", 1)
			else
				GiveWeaponComponentToPed(Ped, GetHashKey(k), GetHashKey(v))
				ESX.ShowNotification('[~g~+~w~]: Latarka')
				PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_EQUIP", "HUD_AMMO_SHOP_SOUNDSET", 1)
			end
		end
	end
end)

RegisterNetEvent('golden_components:addMagazine')
AddEventHandler('golden_components:addMagazine', function()
	local Ped = PlayerPedId()
	local WeapHash = GetSelectedPedWeapon(Ped)
	for k,v in pairs(Config.Magazine) do
		if GetHashKey(k) == WeapHash then
			if HasPedGotWeaponComponent(Ped, WeapHash, GetHashKey(v)) then
				RemoveWeaponComponentFromPed(Ped, WeapHash, GetHashKey(v))
				ESX.ShowNotification('[~r~-~w~]: Powiększony Magazynek')
				PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_UNEQUIP", "HUD_AMMO_SHOP_SOUNDSET", 1)
			else
				GiveWeaponComponentToPed(Ped, GetHashKey(k), GetHashKey(v))
				ESX.ShowNotification('[~g~+~w~]: Powiększony Magazynek')
				PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_EQUIP", "HUD_AMMO_SHOP_SOUNDSET", 1)
			end
		end
	end
end)