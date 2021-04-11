local HasAlreadyEnteredMarker = false
local LastZone                = nil
local actionDisplayed         = false
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsInShopMenu            = false
local Categories              = {}
local Vehicles                = {}
local LastVehicles            = {}
local nijeUradioTest = true

ESX                           = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(10000)

	ESX.TriggerServerCallback('esx_vehicleshop:getCategories', function(categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx_vehicleshop:sendCategories')
AddEventHandler('esx_vehicleshop:sendCategories', function (categories)
	Categories = categories
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function (vehicles)
	Vehicles = vehicles
end)

Ispisi2DText = function(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNUICallback('Test', function(data, cb) 
	SetNuiFocus(false, false)
	
	local model = data.id.model
	local playerPed = PlayerPedId()
	local playerpos = GetEntityCoords(playerPed)
	
	IsInShopMenu = false
	if nijeUradioTest then
		ESX.Game.SpawnVehicle(model, vector3(-1733.25, -2901.43, 13.94), 326, function(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			SetVehicleNumberPlateText(vehicle, "TEST")
			TriggerEvent("pNotify:SendNotification", {text = "Test traje 2 minuta!", type = "success", queue = "success", timeout = 2000, layout = "center"})
			Citizen.CreateThread(function () 
				local counter = 120
				ESX.ShowNotification('Sacekajte auto da se stvori!')
				while counter > 0 do 
					if counter == 60 then
						TriggerEvent("pNotify:SendNotification", {text = "Ostalo je jos minut voznje", type = "success", queue = "success", timeout = 2000, layout = "center"})
					end
					if counter == 10 then
						TriggerEvent("pNotify:SendNotification", {text = "Ostalo je jos 10 sekundi", type = "success", queue = "success", timeout = 2000, layout = "center"})
					end
					counter = counter -1
					Citizen.Wait(1000)
				end
				DeleteVehicle(vehicle)
				SetEntityCoords(playerPed, playerpos, false, false, false, false)

				ESX.ShowNotification('Zavrsili ste test')
			end)
			nijeUradioTest = false
		end)--]]
	else
		TriggerEvent("pNotify:SendNotification", {text = "Mozete testirati auto svakih 10 minuta", type = "success", queue = "success", timeout = 2000, layout = "center"})
	end
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(10000)
		if nijeUradioTest == false then
			Citizen.Wait(12000)
			nijeUradioTest = true
		end
	end
end)


RegisterNUICallback('BuyVehicle', function(data, cb)
    SetNuiFocus(false, false)

    local veh = data.id
    local playerPed = PlayerPedId()
	IsInShopMenu = false
    ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function(hasEnoughMoney)
		if hasEnoughMoney then
			ESX.Game.SpawnVehicle(veh.model, vector3(-27.33, -1082.17, 26.64), 69.2, function (vehicle)
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

				local newPlate     = GeneratePlate()
				local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
				vehicleProps.plate = newPlate
				SetVehicleNumberPlateText(vehicle, newPlate)

				TriggerServerEvent('uzmiauto:dark', vehicleProps)
				
				TriggerEvent("pNotify:SendNotification", {text = "Kupili ste vozilo!", type = "success", queue = "success", timeout = 2000, layout = "center"})
			end)

		else
			TriggerEvent("pNotify:SendNotification", {text = "Nemate dovoljno novca!", type = "success", queue = "success", timeout = 2000, layout = "center"})
		end

	end, veh.price)
end)

RegisterNetEvent('client:uzmiauto2')
AddEventHandler('client:uzmiauto2', function(model)
	print(model)
	ESX.Game.SpawnVehicle(model, vector3(-783.86, -223.76, 37.32), 196.32, function (vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		local newPlate     = GeneratePlate()
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		vehicleProps.plate = newPlate
		SetVehicleDirtLevel(vehicle, 0)
		SetVehicleNumberPlateText(vehicle, newPlate)
		TriggerEvent("pNotify:SendNotification", {text = "Uzeo si auto", type = "success", queue = "success", timeout = 2000, layout = "center"})
	end)
end)

RegisterNUICallback('CloseMenu', function()
    SetNuiFocus(false, false)
    IsInShopMenu = false
end)

function OpenShopMenu()
	local vehicle = {}
	if not IsInShopMenu then
		IsInShopMenu = true
		SetNuiFocus(true, true)
		SendNUIMessage({
            show = true,
            cars = Vehicles
        })
	end
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)

			DisableControlAction(0, 27, true)
			DisableControlAction(0, 173, true)
			DisableControlAction(0, 174, true)
			DisableControlAction(0, 176, true)
			DisableControlAction(0, 176, true)
			DisableControlAction(0, 177, true)

			drawLoadingText('Model se učitava, sačekajte!', 255, 255, 255, 255)
		end
	end
end

AddEventHandler('esx_vehicleshop:hasEnteredMarker', function (zone)
	if zone == 'Prodavnica' then
		CurrentAction     = 'shop_menu'
		PomocniText('Pritisnite ~INPUT_CONTEXT~ da otvorite autosalon')
		CurrentActionData = {}
		actionDisplayed = true
	end
end)

PomocniText = function(text)
	Citizen.CreateThread(function()
		SetTextComponentFormat("STRING")
		AddTextComponentString(text)
		DisplayHelpTextFromStringLabel(0, state, 0, -1)
	end)
end

AddEventHandler('esx_vehicleshop:hasExitedMarker', function (zone)
	if not IsInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)



Citizen.CreateThread(function ()
	local blip = AddBlipForCoord(Config.Zones.Prodavnica.Pos)

	SetBlipSprite (blip, 326)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Auto Salon')
	EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
        local letSleep = true
		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and #(coords - v.Pos) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
				letSleep = false
			end
			
			if #(coords - v.Pos) < v.Size.x then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_vehicleshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_vehicleshop:hasExitedMarker', LastZone)
		end

		if letSleep then
			Citizen.Wait(2000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentAction == nil then
			Citizen.Wait(500)
		else
			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu()
				end

				CurrentAction = nil
			end
		end
	end
end)

RegisterNetEvent('otvori:katalog')
AddEventHandler('otvori:katalog', function(source)
	OpenShopMenu()
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then

        Citizen.Wait(2000)

	    ESX.TriggerServerCallback('esx_vehicleshop:getCategories', function (categories)
	    	Categories = categories
	    end)

	    ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function (vehicles)
	    	Vehicles = vehicles
	    end)
		SetNuiFocus(false, false)

     end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInShopMenu then
			ESX.UI.Menu.CloseAll()

			local playerPed = PlayerPedId()

			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
		end
	end
end)