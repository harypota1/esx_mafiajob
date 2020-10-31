ESX = nil
local Organisations = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

for jobs, data in pairs(Config.Organisations) do
		Organisations[jobs] = {}
end

ESX.RegisterServerCallback('esx_organisation:getCharackter' ,function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer and xPlayer.identifier then
		for k, v in ipairs(Organisations) do
			if v.hex == xPlayer.identifier then
				table.remove(Organisations, k)
			end
		end
		local tmp = {}
		for jobs, data in pairs(Config.Organisations) do
			if xPlayer and xPlayer.identifier and data.Members[xPlayer.identifier] then
				tmp = {
					hex = xPlayer.identifier, 
					name = jobs, 
					grade = data.Members[xPlayer.identifier], 
					label = Config.Organisations[jobs].Settings.Label,
					type = Config.Organisations[jobs].Settings.Type
				}
				table.insert(Organisations[jobs], tmp)
				break
			end
		end
		cb(tmp)
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('esx_organisation:getSocietyMoney', function(source, cb, society)
	if society then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..society, function(account)
			cb(account and account.money or 0)
		end)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_organisation:put',function(source, cb, target)
	TriggerClientEvent('esx_organisation:check', target)
end)

RegisterServerEvent('esx_organisation:buyWeapon')
AddEventHandler('esx_organisation:buyWeapon', function(weapon, price, society)
	local can = false
	local xPlayer = ESX.GetPlayerFromId(source)
	if not Organisations or not Organisations[society] then
		return
	end
	for k, v in pairs(Organisations[society]) do
		if tostring(v.hex):find(xPlayer.identifier) then
			can = true
			break
		end
	end
	if not can then
		return
	end
	if price and type(price) == 'number' then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..society, function(account)
			if price and account.money and  account.money >= price then
				if weapon:find('item_' ) then
					xPlayer.addInventoryItem(weapon:gsub('item_', ''), 1)
				else
					xPlayer.addWeapon(weapon, 250)
				end
				account.removeMoney(price)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Niewystarczająca kwota pieniędzy na koncie organizacji!')
			end
		end)
	else
		if weapon:find('item_' ) then
			xPlayer.addInventoryItem(weapon:gsub('item_', ''), 1)
		else
			xPlayer.addWeapon(weapon, 250)
		end
	end
end)

RegisterServerEvent('esx_organisation:withdrawMoney')
AddEventHandler('esx_organisation:withdrawMoney', function(society, amount, typemoney)
	local can = false
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, v in pairs(Organisations[society]) do
		if tostring(v.hex):find(xPlayer.identifier) then
			can = true
			break
		end
	end
	if not can then
		return
	end
	society = 'society_'..society
	amount = ESX.Math.Round(tonumber(amount))
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			if typemoney == 1 then
				xPlayer.addAccountMoney('black_money', amount)
				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Pobrałeś z konta firmy: ~r~'..ESX.Math.GroupDigits(amount)..'$~s~')
			elseif typemoney == 2 then
				xPlayer.addMoney(amount)
				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Pobrałeś z konta firmy: ~g~'..ESX.Math.GroupDigits(amount)..'$~s~')
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Nieprawidłowa kwota!')
		end
	end)
end)

RegisterServerEvent('esx_organisation:depositMoney')
AddEventHandler('esx_organisation:depositMoney', function(society, amount)
	local can = false
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, v in pairs(Organisations[society]) do
		if tostring(v.hex):find(xPlayer.identifier) then
			can = true
			break
		end
	end
	if not can then
		return
	end
	society = 'society_'..society
	amount = ESX.Math.Round(tonumber(amount))
	if amount > 0 and xPlayer.getMoney() >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)
		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Zdeponowałeś na konto firmy: ~g~'..ESX.Math.GroupDigits(amount)..'$~s~')
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Nieprawidłowa kwota!')
	end
end)

ESX.RegisterServerCallback('esx_organisation:getArmoryWeapons', function(source, cb, society)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..society, function(store)
		local weapons = {}
		for k, v in pairs((store.get('weapons') or {})) do
			if k and v and v.name and v.ammo and v.ammo > 0 then
				if not weapons[v.name] then
					weapons[v.name] = {ammo = v.ammo, count = 1}
				else
					if weapons[v.name].count then
					weapons[v.name].count = weapons[v.name].count + 1
					else
						weapons[v.name].count = 1
					end
				end
			end
		end
		cb(weapons or {})
	end)
end)

ESX.RegisterServerCallback('esx_organisation:addArmoryWeapon', function(source, cb, weaponName, count, society)
	local can = false
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, v in pairs(Organisations[society]) do
		if tostring(v.hex):find(xPlayer.identifier) then
			can = true
			break
		end
	end
	if not can then
		return
	end
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..society, function(store)
		local storeWeapons = store.get('weapons') or {}
		table.insert(storeWeapons, {name = weaponName, ammo = count})
		store.set('weapons', storeWeapons)
		xPlayer.removeWeapon(weaponName)
	end)
end)

ESX.RegisterServerCallback('esx_organisation:removeArmoryWeapon', function(source, cb, weaponName, society)
	local can = false
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, v in pairs(Organisations[society]) do
		if tostring(v.hex):find(xPlayer.identifier) then
			can = true
			break
		end
	end
	if not can then
		return
	end
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..society, function(store)
		local storeWeapons = store.get('weapons') or {}
		local ammo = nil
		for k, v in ipairs(storeWeapons) do
			if v.name == weaponName then
				ammo = v.ammo
				table.remove(storeWeapons, k)
				break
			end
		end
		store.set('weapons', storeWeapons)
		xPlayer.addWeapon(weaponName, ammo)
	end)
end)


RegisterServerEvent('esx_organisation:putStockItems')
AddEventHandler('esx_organisation:putStockItems', function(itemName, count, society)
	local can = false
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, v in pairs(Organisations[society]) do
		if tostring(v.hex):find(xPlayer.identifier) then
			can = true
			break
		end
	end
	if not can then
		return
	end
	local itemcounter = xPlayer.getInventoryItem(itemName).count
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..society, function(inventory)
		local item = inventory.getItem(itemName)
		if item.count >= 0 then
			if itemcounter >= count then
				xPlayer.removeInventoryItem(itemName, count)
				inventory.addItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Wpłaciłeś ~g~' .. count .. 'x~w~ ' .. item.label)
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Nieprawidłowa ilość!')
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Nieprawidłowa ilość!')
		end
	end)
end)

ESX.RegisterServerCallback('esx_organisation:getStockItems', function(source, cb, society)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..society, function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_organisation:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory
	cb({items = items})
end)

RegisterServerEvent('esx_organisation:getStockItem')
AddEventHandler('esx_organisation:getStockItem', function(itemName, count, society)
	local can = false
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, v in pairs(Organisations[society]) do
		if tostring(v.hex):find(xPlayer.identifier) then
			can = true
			break
		end
	end
	if not can then
		return
	end
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..society, function(inventory)
		local item = inventory.getItem(itemName)
		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Wypłaciłeś ~g~' .. count .. 'x~w~ ' .. item.label)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Nieprawidłowa ilość!')
		end
	end)
end)

function SendDailyCash(d, h, m)
	for jobs, data in pairs(Config.Organisations) do
		if data.Settings.DailyMoney and data.Settings.DailyMoney > 0 then
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..jobs, function(account)
				if account and account.money then
					account.addMoney(data.Settings.DailyMoney)
					if data.Members and Organisations[jobs] then
						for k, v in pairs(Organisations[jobs]) do
							if v.grade == 5 then
								local xPlayer = ESX
								PlayerFromIdentifier(v.hex)
								if xPlayer then
									TriggerClientEvent('esx:showNotification', xPlayer.source, 'Na konto został przelany dzienny dochód: ~g~'..ESX.Math.GroupDigits(data.Settings.DailyMoney)..'$~s~')
								end
							end
						end
					end
				end
			end)
		end
	end
end

TriggerEvent('cron:runAt', 18, 00	, SendDailyCash)