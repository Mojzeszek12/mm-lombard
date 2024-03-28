ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent("mm-lombard:sprzedajitem")
AddEventHandler("mm-lombard:sprzedajitem", function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.LombardItems[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then print(('Ten item nie istnieje!'):format(xPlayer.identifier)) return end

	if xItem.count < amount then
        TriggerClientEvent('esx:showNotification', source, 'Nie masz wystarczającej ilości tego przedmiotu!')
		return
	end

	price = ESX.Math.Round(price * amount)

	if Config.Brudna then
		xPlayer.addAccountMoney('black_money', price)
	else
		xPlayer.addMoney(price)
	end

	xPlayer.removeInventoryItem(xItem.name, amount)
    TriggerClientEvent('esx:showNotification', source, 'Sprzedano '..amount..' '.. xItem.label..' za $'..ESX.Math.GroupDigits(price))
end)
