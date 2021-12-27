ESX = nil
local lastJob = nil
local isAmmoboxShown = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
  end
  Citizen.Wait(3000)
  if PlayerData == nil or PlayerData.job == nil then
	  	PlayerData = ESX.GetPlayerData()
	end
	SendNUIMessage({
		action = 'initGUI',
		data = { whiteMode = Config.enableWhiteBackgroundMode, enableAmmo = Config.enableAmmoBox, colorInvert = Config.disableIconColorInvert }
	})
end)

local dugamapa = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  SetRadarBigmapEnabled(false, false)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function showAlert(message, time, color)
	SendNUIMessage({
		action = 'showAlert',
		message = message,
		time = time,
		color = color
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
			ESX.TriggerServerCallback('poggu_hud:retrieveData', function(data)
			SendNUIMessage({
				action = 'setMoney',
				cash = data.cash,
				bank = data.bank,
				black_money = data.black_money,
				society = data.society
			})
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if(PlayerData ~= nil) then
			local jobName = PlayerData.job.label..' - '..PlayerData.job.grade_label
			if(lastJob ~= jobName) then
				lastJob = jobName
				SendNUIMessage({
					action = 'setJob',
					data = jobName
				})
			end
		end
	end
end)

Citizen.CreateThread(function()
 while true do
		Citizen.Wait(300)
		if Config.enableAmmoBox then
			local playerPed = PlayerPedId()
			local weapon, hash = GetCurrentPedWeapon(playerPed, 1)
			if(weapon) then
				isAmmoboxShown = true
				local _,ammoInClip = GetAmmoInClip(playerPed, hash)
				SendNUIMessage({
						action = 'setAmmo',
						data = ammoInClip..'/'.. GetAmmoInPedWeapon(playerPed, hash) - ammoInClip
				})
			else
				if isAmmoboxShown then
					isAmmoboxShown = false
					SendNUIMessage({
						action = 'hideAmmobox'
					})
				end
			end
		end
	end
end)

local isMenuPaused = false

function menuPaused()
	SendNUIMessage({
		action = 'disableHud',
		data = isMenuPaused
	})
end

local UserSakrio = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if not UserSakrio then

			if IsPauseMenuActive() then
				if not isMenuPaused then
					isMenuPaused = true
					menuPaused()
				end
			elseif isMenuPaused then
				isMenuPaused = false
				menuPaused()
			end

		else
			Wait(1000)
		end
	end
end)

RegisterCommand("hud", function(source, data)
	UserSakrio = not UserSakrio
	isMenuPaused = not isMenuPaused
	menuPaused()
end)

local isMenuPaused2 = false

function menuPaused2()
	if isMenuPaused2 then
		DisplayRadar(true)
	else
		DisplayRadar(false)
	end
	SendNUIMessage({
		action = 'cinema',
		data = isMenuPaused2
	})
end

local UserSakrio2 = true
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if not UserSakrio2 then

			if IsPauseMenuActive() then
				if not isMenuPaused2 then
					isMenuPaused2 = true
					menuPaused2()
				end
			elseif isMenuPaused2 then
				isMenuPaused2 = false
				menuPaused2()
			end

		else
			Wait(1000)
		end
	end
end)

RegisterCommand("cinema", function(source, data)
	UserSakrio2 = not UserSakrio2
	isMenuPaused2 = not isMenuPaused2
	menuPaused2()
end)

exports("cinema", function(state)

	if state and (state == true or state == false) then 
		UserSakrio2 = state
		isMenuPaused2 = state
	else
		UserSakrio2 = not UserSakrio2
		isMenuPaused2 = not isMenuPaused2
	end

	menuPaused2()
end)

exports("info", function()

	if state and (state == true or state == false) then 
		UserSakrio = state
		isMenuPaused = state
	else
		UserSakrio = not UserSakrio
		isMenuPaused = not isMenuPaused
	end

	menuPaused()
end)

local SakrivaSve = false

RegisterCommand("hud", function(source, args)
	local vrsta = args[1]

	if not vrsta then
		SakrivaSve = not SakrivaSve
		exports.panama_hudv3:info(SakrivaSve)
		exports.carandplayerhud:sakrij(SakrivaSve)
		exports.tokovoip_script:hide(SakrivaSve)
	else

		if vrsta == "cinema" then
			exports.panama_hudv3:cinema()
		elseif vrsta == "info" then
			exports.panama_hudv3:info()
		elseif vrsta == "statusi" then
			exports.carandplayerhud:sakrij()
		elseif vrsta == "voice" then
			exports.tokovoip_script:hide()
		elseif vrsta == "chat" then
			exports.chat:sakrij()
		end

	end

end)

function ImalPhone()

	local Inventory = ESX.GetPlayerData().inventory

	for i=1, #Inventory, 1 do
		if Inventory[i].name == "white_phone" then
			if Inventory[i].count > 0 then
				return true
			end
		end
	end	

	return false

end

local UkljuceneNotifikacije = true
RegisterCommand("notifikacije", function()
	UkljuceneNotifikacije = not UkljuceneNotifikacije
end, false)


RegisterNetEvent("panama_hud:tweet", function(tweet)
	if UkljuceneNotifikacije then
		if ImalPhone() then
			SendNUIMessage({
				akcija = "tweet",
				tweet = tweet
			})
		end
	end
end)

RegisterNetEvent("panama_hud:oglas", function(tweet)
	if UkljuceneNotifikacije then
		if ImalPhone() then
			SendNUIMessage({
				akcija = "oglas",
				oglas = tweet
			})
		end
	end
end)