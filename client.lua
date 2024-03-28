ESX = exports['es_extended']:getSharedObject()


-- można podpisać pod targeta
-- niżej możecie sobie to przerobić


exports.qtarget:AddBoxZone("lombard", vector3(Config.LombardLocation.x, Config.LombardLocation.y, Config.LombardLocation.z), Config.LombardLocation.bigx, Config.LombardLocation.bigy, {
        name="lombard_point",
        heading=Config.LombardLocation.h,
        debugPoly=false,
        minZ=Config.Config.LombardLocation.minz,
        maxZ=Config.Config.LombardLocation.maxz,
        }, {
            options = {
                {
                    icon = "fas fa-sign-in-alt",
                    label = Config.LombardLabel,
                    action = function(entity)
                        OtworzLombard()
                    end,
                },
                {
                    event = "mm-lombard",
                    icon = "fas fa-sign-out-alt",
                    label = Config.LombardLabel,
                },
            },
            distance = 2.5
})



RegisterNetEvent('mm-lombard')
AddEventHandler('mm-lombard', function()
    OtworzLombard()
end)


function OtworzLombard()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.PawnshopItems[v.name]

		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, "$" .. ESX.Math.GroupDigits(price)),
				name = v.name,
				price = price,

				-- lepiej zostawić
				type = 'slider',
				value = 1,
				min = 1,
				max = v.count
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lombard', {
		title    = "Lombard",
		align    = Config.MenuAlign,
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('mm-lombard:sprzedajitem', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end

-- na blipa, można zmienić jak się chce ale raczej w configu

function CreateBlipCircle(coords, text, color, sprite, scale)
	blip = AddBlipForCoord(coords)

	SetBlipSprite (blip, sprite)
	SetBlipScale  (blip, scale)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
	CreateBlipCircle(vector3(Config.LombardLocation.x, Config.LombardLocation.y, Config.LombardLocation.z), Config.LombardBlipText, Config.LombardBlipColor, Config.LombardBlipSprite, Config.LombardScale)
end)


-- Raczej nie ruszać, chyba że wiecie co robicie

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)
