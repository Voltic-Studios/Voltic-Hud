local playerHUDActive = false
local showHUD = true
local isMinimapVisible = true
local fuelSystem = string.upper(CarHUD.FuelSystem)

CreateThread(function()
	while true do
		local player = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(player)
		if not IsPauseMenuActive() and IsPedInAnyVehicle(player) and not IsThisModelABicycle(vehicle) then
			sleep = 50

			vel = math.floor(GetEntitySpeed(vehicle) * 3.6)
			local fuel = math.floor(exports["LegacyFuel"]:GetFuel(vehicle))
			
			SendNUIMessage({
				action = "carhud",
				toggle = true,
				vel = vel,
				fuel = fuel,
				type = CarHUD.type,
				config = CarHUD.fuel,
			})
		else
			sleep = 1000
			SendNUIMessage({
				action = "carhud",
				toggle = false,
			})
		end
		Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(150)
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			DisplayRadar(true)
			isMinimapVisible = true
		else
			if isMinimapVisible then
				DisplayRadar(false)
				isMinimapVisible = false
			end
		end
	end
end)

CreateThread(function()
	Wait(5000) -- Wait a moment before executing startHUD() at the beginning
	startHUD()
end)

AddEventHandler("onResourceStart", function(resourceName)
	if GetCurrentResourceName() ~= resourceName then
		return
	end
	Wait(500)
	startHUD()
end)

function startHUD()
	if showHUD then
		SendNUIMessage({ action = "showPlayerHUD" })
		playerHUDActive = true
		TriggerEvent("QBCore:Notify", Config.NotifyON, "success")
	else
		SendNUIMessage({ action = "hidePlayerHUD" })
		playerHUDActive = false
		TriggerEvent("QBCore:Notify", Config.NotifyOFF, "error")

	end
end

CreateThread(function()
	while true do
		if not IsPauseMenuActive() then
			if not playerHUDActive and showHUD then
				SendNUIMessage({ action = "showPlayerHUD" })
				playerHUDActive = true
			elseif playerHUDActive and not showHUD then
				SendNUIMessage({ action = "hidePlayerHUD" })
				playerHUDActive = false
			end
			local stamina = 0
			if not IsEntityInWater(PlayerPedId()) then
				stamina = (100 - GetPlayerSprintStaminaRemaining(PlayerId()))
			else
				stamina = (GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10)
			end
			SendNUIMessage({
				action = "updatePlayerHUD",
				health = (GetEntityHealth(PlayerPedId()) - 100),
				armor = GetPedArmour(PlayerPedId()),
				thirst = getThirst(),
				hunger = getHunger(),
				stamina = stamina,
			})
		end
		Wait(300)
	end
end)

RegisterNetEvent("hud:client:UpdateNeeds", function(newHunger, newThirst)
	thirst = newThirst
	hunger = newHunger
end)

RegisterCommand(Config.hud, function()
	showHUD = not showHUD
	startHUD()
end)


function getThirst()
	TriggerEvent('esx_status:getStatus', 'thirst', function(status)
		thirst = status.getPercent()
	end)

	return thirst
end

function getHunger()
	TriggerEvent('esx_status:getStatus', 'hunger', function(status)
		hunger = status.getPercent()
	end)

	return hunger
end
