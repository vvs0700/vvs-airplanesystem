ESX              = nil
local Categories = {}
local Vehicles   = {}
local Dark = {}
local br = 0

local Dark = {}
local br = 0

Dark.Vozila = {
--- avioni ---
	[1] = {name = 'Besra', model = 'Besra',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/3/35/Besra.png' },
	[2] = {name = 'Blimp', model = 'Blimp',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/1/19/Blimp.png' },
	[3] = {name = 'Blimp', model = 'Blimp2',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/7/77/Blimp2.png' },
	[4] = {name = 'CargoPlane', model = 'CargoPlane',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/9/9e/CargoPlane.png' },
	[5] = {name = 'Cuban800', model = 'Cuban800',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/6/63/Cuban800.png' },
	[6] = {name = 'Dodo', model = 'Dodo',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/f/fc/Dodo.png' },
	[7] = {name = 'Duster', model = 'Duster',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/a/a0/Duster.png' },
	[8] = {name = 'Hydra', model = 'Hydra',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/9/9d/Hydra.png' },
	[9] = {name = 'Jet', model = 'Jet',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/1/1e/Jet.png' },
	[10] = {name = 'Lazer', model = 'Lazer',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/6/6c/Lazer.png' },
	[11] = {name = 'Luxor', model = 'Luxor',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/f/f3/Luxor.png' },
	[12] = {name = 'Luxor2', model = 'Luxor2	',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/a/a8/Luxor2.png' },
	[13] = {name = 'Mammatus', model = 'Mammatus',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/a/a7/Mammatus.png' },
	[14] = {name = 'Miljet', model = 'Miljet',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/b/b8/Miljet.png' },
	[15] = {name = 'Nimbus', model = 'Nimbus',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/c/c8/Nimbus.png' },
	[16] = {name = 'Shamal', model = 'Shamal',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/b/be/Shamal.png' },
	[17] = {name = 'Stunt', model = 'Stunt',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/a/aa/Stunt.png' },
	[18] = {name = 'Titan', model = 'Titan',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/8/88/Titan.png' },
	[19] = {name = 'Velum', model = 'Velum',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/c/c3/Velum.png' },
	[20] = {name = 'Velum2', model = 'Velum2',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/e/e7/Velum2.png' },
	[21] = {name = 'Vestra', model = 'Vestra',price =  360000, category = 'audi', imglink = 'https://wiki.gtanet.work/images/8/8f/Vestra.png' },


}

Dark.Kategorije = {
	[1] = {name = "avioni", label="Avioni"},
}

function vozila()
	local vozila = Dark.Vozila
	local kategorije = Dark.Kategorije
	for i=1, #vozila, 1 do
		local vozilo = vozila[i]

		for j=1, #kategorije, 1 do
		   if kategorije[j].name == vozilo.category then
		    vozilo.categoryLabel = kategorije[j].label
		    br = br + 1
		    break
		   end
		end
		table.insert(vozila, vozilo)
	end
	TriggerClientEvent('esx_vehicleshop:sendCategories', -1, Dark.Kategorije)
	TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, vozila)
	print("^6 vvs >> ^2Ucitano je " .. br .. " vozila iz baze")
end
vozila()

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then end
end)

RegisterCommand('uzmiauto', function(source, args)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if args[1] ~= nil and xPlayer.job.name == 'autosalon' then
		xPlayer.triggerEvent('client:uzmiauto', args[1])
	end
end)

RegisterCommand('stvori', function(source, args)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if args[1] ~= nil and xPlayer.job.name == 'autosalon' then
		xPlayer.triggerEvent('client:uzmiauto2', args[1])
	end
end)


RegisterServerEvent('uzmiauto:dark')
AddEventHandler('uzmiauto:dark', function (vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps)
	}, function (rowsChanged)
		TriggerClientEvent("pNotify:SendNotification", _source, {text = "Vozilo sa tablicama " .. vehicleProps.plate .. " sada pripada vama.", type = "success", queue = "success", timeout = 2000, layout = "center"})
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function (source, cb)
	cb(Dark.Kategorije)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function (source, cb)
	cb(Dark.Vozila)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function (source, cb, price)
	local xPlayer     = ESX.GetPlayerFromId(source)
	local vehicleData = nil
	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterUsableItem('salonkatalog', function(source)
	TriggerClientEvent('otvori:katalog', source)
end)

RegisterServerEvent('katalog:dajitem')
AddEventHandler('katalog:dajitem', function()
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem('salonkatalog').count
	if item < 1 then
		xPlayer.addInventoryItem('salonkatalog', 1)
	else
    	TriggerClientEvent("pNotify:SendNotification", _source, {text = 'Vec imate katalog!', type = "success", queue = "success", timeout = 1500, layout = "center"})
	end
end)


RegisterCommand('dajkljuc', function(source, args)	
	myself = source
	other = args[1]
	if args[1] ~= nil then
	else
            TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Nepostojeci ID!")
			return
	end

	local plate1 = args[2]
	local plate2 = args[3]
	local plate3 = args[4]
	local plate4 = args[5]
	
  
	if plate1 ~= nil then plate01 = plate1 else plate01 = "" end
	if plate2 ~= nil then plate02 = plate2 else plate02 = "" end
	if plate3 ~= nil then plate03 = plate3 else plate03 = "" end
	if plate4 ~= nil then plate04 = plate4 else plate04 = "" end
  
  
	local plate = (plate01 .. " " .. plate02 .. " " .. plate03 .. " " .. plate04)

	
	mySteamID = GetPlayerIdentifiers(source)
	mySteam = mySteamID[1]
	myID = ESX.GetPlayerFromId(source).identifier
	myName = ESX.GetPlayerFromId(source).name

	targetSteamID = GetPlayerIdentifiers(args[1])
	targetSteamName = ESX.GetPlayerFromId(args[1]).name
	targetSteam = targetSteamID[1]
	
	MySQL.Async.fetchAll(
        'SELECT * FROM owned_vehicles WHERE plate = @plate',
        {
            ['@plate'] = plate
        },function(result)
        	if result[1] ~= nil then
                local playerName = ESX.GetPlayerFromIdentifier(result[1].owner).identifier
				local pName = ESX.GetPlayerFromIdentifier(result[1].owner).name
				CarOwner = playerName
				print("Car Transfer ", myID, CarOwner)
				if myID == CarOwner then
					print("Transfered")
					
					data = {}
						TriggerClientEvent('chatMessage', other, "^4Auto sa tablicama ^*^1" .. plate .. "^r^4je prebacen tebi od: ^*^2" .. myName)
			 
						MySQL.Sync.execute("UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate", {['@owner'] = targetSteam, ['@plate'] = plate})
						TriggerClientEvent('chatMessage', source, "^4Ti si  ^*^3prebacio^0^4 tvoje vozilo sa tablicom^*^1" .. plate .. "\" ^r^4:^*^2".. targetSteamName)
				else
					print("Did not transfer")
					TriggerClientEvent('chatMessage', source, "^*^1Ovo nije tvoje vozilo!")
				end
			else
				TriggerClientEvent('chatMessage', source, "^1^*GRESKA: ^r^0Tablice ovog vozila ne postoje ili nisu dobro napisane(VELIKIM SLOVIMA)!")
            end
		
        end)

end)
