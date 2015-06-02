-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function SendMapList ( pl,commandName,args )
	if MapCycle == nil then return end

	local x = 1
	for k, v in pairs( MapCycle ) do	
		umsg.Start( "RcMapList", pl )
			umsg.Short( x )
			umsg.String( v.Map )
		umsg.End()
		x = x + 1
	end
	
end
concommand.Add("get_maplist",SendMapList) 

function SendScoreData(pl,commandName,args)
	if not args[1] then return end
	
	local from = GetPlayerByUserID( tonumber( args[1] ) )
	if from and from:IsValid() then
		stats.SendRecordsData( from, pl )
	end
	
end
concommand.Add("get_playerstats",SendScoreData) 

function SendServerDataToPL(pl,commandName,args)
	SendServerData( pl )
end
concommand.Add("get_serverstats",SendServerDataToPL) 

function PrintMapCycle( pl,commandName,args )

	for k, v in pairs( MapCycle ) do
		pl:PrintMessage( HUD_PRINTCONSOLE,k..": "..v.Map.."\n" )
	end
	pl:PrintMessage( HUD_PRINTTALK,"The mapcycle has been printed in console" )
	
end
concommand.Add("zs_print_mapcycle",PrintMapCycle) 

function OpenBugPanel(pl, cmd, args)
	if not IsValid (pl) then return end
	if pl:Team() == TEAM_SPECTATOR then return end
	
	umsg.Start ("DoBugReportPanel", pl)
	umsg.End()
end
concommand.Add ("open_bugpanel", OpenBugPanel)

function SetAutoRedeem(pl,commandName,args)
	if not args[1] then
		return
	end
	pl.AutoRedeem = util.tobool(args[1])
end
concommand.Add("zs_setautoredeem",SetAutoRedeem) 

function DropWeapon(pl, commandName, args)
	if pl:GetActiveWeapon() == NULL then
		return false
	end
	
	local Weapon = pl:GetActiveWeapon()
	local wepname = Weapon:GetClass()
	
	local PlayerWeapons = pl:GetWeapons()
	local Count = 0
	for k,v in pairs ( GAMEMODE.HumanWeapons ) do
		if not v.Restricted then
			if v.Type ~= "admin" then
				if pl:HasWeapon(k) then
					Count = Count + 1
				end
			end
		end
	end
	
	-- you can't drop all of them!

	--
	--if Count == 1 then
	--	GAMEMODE:SetPlayerSpeed(pl, 210)
	--end
	
	if string.sub( wepname,1,5 ) == "admin" or wepname == "weapon_physcannon" or wepname == "weapon_physgun" then
		pl:Message("You can't drop this weapon")
		return false
	end
	
	-- Save ammo information from weapon
	if GetWeaponCategory(Weapon:GetClass()) ~= "Melee" then
		Weapon.Primary.RemainingAmmo = Weapon:Clip1()
		Weapon.Primary.Magazine = pl:GetAmmoCount(Weapon:GetPrimaryAmmoTypeString())
	end
	
	--
--	if GetWeaponCategory(Weapon:GetClass()) == "Tool1" or GetWeaponCategory(Weapon:GetClass()) == "Tool2" then
	if GetWeaponCategory(Weapon:GetClass()) == "Tool1" then
		Weapon.Ammunition = Weapon:Clip1()
		if wepname == "weapon_zs_medkit" then
			Weapon.RemainingAmmunition = pl:GetAmmoCount(Weapon:GetPrimaryAmmoTypeString())
		end
	end
	
	-- Drop the weapon and check to see if you can before.
	if not pl:CanDropWeapon(Weapon) then
		pl:ChatPrint("You can't drop your weapon inside objects.")
		return false
	end

	--Actual dropping
	pl:DropWeapon(Weapon)
	
	--Notify 
	--pl:ChatPrint( "You've dropped a "..tostring ( GAMEMODE.HumanWeapons[wepname].Name ) )
end
concommand.Add( "zs_dropweapon",DropWeapon ) 

local locpath = "zslocations/".. game.GetMap() ..".txt"
local locammount = 0
function SaveLocation(pl,commandName,args)
	if pl:IsAdmin() == false then return end
	local content = "-- File generated by the Mr. Green ZS location saver\n-- mrgreengaming.com"
	if file.Exists(locpath) then
		content = file.Read(locpath)
	end
	local playerpos = pl:GetPos()
	content = content .."\n\n-- Added by ".. pl:GetName()
	content = content .."\ntable.Add(DropPointsX,\"".. tostring(playerpos.x) .."\") -- PosX"
	content = content .."\ntable.Add(DropPointsY,\"".. tostring(playerpos.y) .."\") -- PosY"
	content = content .."\ntable.Add(DropPointsZ,\"".. tostring(playerpos.z) .."\") -- PosZ"
    file.Write(locpath, content)
	local ent = ents.Create("prop_dynamic")
	if ent:IsValid() then
		ent:SetModel(Model("models/weapons/w_crowbar.mdl"))
		ent:SetPos(playerpos)
		ent:Spawn()
	end
	locammount = locammount+1
	pl:ChatPrint("Location saved on server (no. ".. locammount ..").")
end
concommand.Add("zs_savelocation",SaveLocation)

function AmmountLocations(pl,commandName,args)
	if pl:IsAdmin() == false then return end
	pl:ChatPrint("Ammount of locations created this round: ".. locammount)
end
concommand.Add("zs_locammount",AmmountLocations)

function PrintZSStats(ply,commandName,args)
	ply:PrintMessage(HUD_PRINTCONSOLE,"--- Zombie Survival user stats ---")
	for k, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD or pl:Team() == TEAM_HUMAN then
			ply:PrintMessage(HUD_PRINTCONSOLE,"UserID: "..pl:UserID()..";  Name: "..pl:Name()..";  SteamID: "..pl:SteamID())
			ply:PrintMessage(HUD_PRINTCONSOLE,"VoiceSet: "..pl.VoiceSet..";  Model: "..pl:GetModel())
			ply:PrintMessage(HUD_PRINTCONSOLE,"Zombies killed: "..pl.ZombiesKilled..";  Humans killed: "..pl.BrainsEaten)
			ply:PrintMessage(HUD_PRINTCONSOLE,"Redeems: "..pl.Redeems..";  Hornyness: "..pl.Hornyness)
			ply:PrintMessage(HUD_PRINTCONSOLE,"------")
		end
	end
end
concommand.Add("status_zs",PrintZSStats)

-- Hats
function SetPlayerHat(pl,commandName,args)
	local h = args[1]
	local temp = {}
	
	if h then
		for k,hat in pairs(string.Explode("$",h)) do
			local itemID = util.GetItemID( hat )
			
			if hats[hat] and pl:Team() == TEAM_HUMAN 
			and pl:GetItemsDataTable()[itemID] and (not shopData[itemID].AdminOnly or pl:IsAdmin()) then
				table.insert(temp,hat)
			end
		
		end
	end
	
	if #temp > 0 then 
		local back = string.Implode("$",temp)
		GAMEMODE:DropHat(pl)
		pl.SelectedHat = back
		GAMEMODE:SpawnHat(pl,back)
	end
end
concommand.Add("mrgreen_hat_set",SetPlayerHat) 

function SetPlayerSuit(pl,commandName,args)
	local hat = args[1]
	local itemID = util.GetItemID(hat)

	if suits[hat] and (not IsValid(pl.Suit) or pl.Suit:GetHatType() ~= hat) and pl:Team() == TEAM_HUMAN 
		and pl:GetItemsDataTable()[itemID] and (not shopData[itemID].AdminOnly or pl:IsAdmin()) then
		GAMEMODE:DropSuit(pl)
		pl.SelectedSuit = hat
		pl:ConCommand("_zs_defaultsuit "..tostring(hat))
		GAMEMODE:SpawnSuit(pl,hat)
	end
end
concommand.Add("mrgreen_suit_set",SetPlayerSuit) 

function DropPlayerHat(pl,commandName,args)
	GAMEMODE:DropHat(pl)
	GAMEMODE:DropSuit(pl)
	pl.SelectedHat = "none"
end
concommand.Add("mrgreen_hat_drop",DropPlayerHat) 

function DropPlayerSuit(pl,commandName,args)
	GAMEMODE:DropSuit(pl)
	pl.SelectedSuit = "none"
	pl:ConCommand("_zs_defaultsuit "..pl.SelectedSuit)
end
concommand.Add("mrgreen_suit_drop",DropPlayerSuit) 

function UnlockEventHat(pl)
	if pl:HasBought("wbeanie") then
		return
	end
	
	pl.DataTable.ShopItems[64] = true
	pl:SaveShopItem( 64 )
	stats.SendShopData( pl, pl )
	
	pl:ChatPrint("Congratulations! You have unlocked Winter Beanie hat in the shop.")
end

function BuyItem(pl,commandName,args)
	if not pl:IsValid() then return end
	
	local item = tonumber( args[1] )

	if not shopData[item] then return end
	if shopData[item].Hidden then return end

	local gc = pl:GreenCoins()
	
	-- voornamelijk protectie tegen mensen die direct via console items pogen aan te schaffen
	if gc < shopData[item].Cost then
		pl:ChatPrint("You're too poor you lazy bastard.")
		return
	end
	if shopData[item].AdminOnly and not pl:IsAdmin() then
		pl:ChatPrint("Server-side validation bitch!")
		return
	end
	if pl:GetItemsDataTable()[item] then
		pl:ChatPrint("You already have this item!")
		stats.SendShopData( pl, pl )
		return
	end
	if (shopData[item].Requires and pl.TotalUpgrades < shopData[item].Requires) or (shopData[item].NeedUpgrade and pl.TotalUpgrades >= shopData[item].Requires and not pl:HasBought(shopData[item].NeedUpgrade)) then
		if not pl:HasBought(shopData[item].NeedUpgrade) then
			pl:ChatPrint ("You need "..shopData[shopData[item].NeedUpgrade].Name.." to buy this item!")
		else
			pl:ChatPrint ("You need "..shopData[item].Requires.." more upgrades to buy this item!")
		end			
		return
	end

	--  buy the thing
	pl:TakeGreenCoins( shopData[item].Cost )
	pl.DataTable.ShopItems[item] = true
	
	--  Register in the DB
	pl:SaveShopItem( item )
	
	--  increment pl.TotalUpgrades
	if shopData[item].Cost > 2500 then
		pl.TotalUpgrades = pl.TotalUpgrades + 1
		GAMEMODE:SendUpgradeNumber ( pl )
	end

	stats.SendShopData( pl, pl )
		
	if item == 27 then
		umsg.Start("removeOptions", pl)
		umsg.End()
	end
end
concommand.Add("mrgreen_buyitem",BuyItem) 

function SellItem(pl,commandName,args)
	if not pl:IsValid() then return end
	local item = args[1]
	if not shopData[item] then return end
	
	pl:ChatPrint("Selling items disabled")
	-- voornamelijk protectie tegen mensen die direct via console items pogen aan te schaffen
	--mainly protection against people who directly via console items attempt to purchase
	--Duby: Its gone as its not needed and its just sat here..
	
	
end
concommand.Add("mrgreen_sellitem",SellItem) 

-- Set title
function SetPlayerTitle(pl,commandName,args)
	local title = args[1]
	
	if not ValidTitle(pl, title) then
		pl:ChatPrint("Invalid title!")
		return
	end
	
	if pl.LastTChange and pl.LastTChange > CurTime()-5 then
		pl:ChatPrint("Please wait 5 seconds before setting a new title")
		return
	end
	
	pl.LastTChange = CurTime()
	
	pl.Title = title
	GAMEMODE:SendTitle({pl},player.GetAll())
end
concommand.Add("mrgreen_settitle",SetPlayerTitle) 

-- Kick player
function KickPlayer(pl,commandName,args)
	if args[1] == nil then return end
	if not (pl:IsAdmin()) then return end
	if not (args[2]) then args[2] = "The admin did not give a kick reason." end
	--args[2] = string.Replace(args[2]," ","_")

	local playerSteamId = GetPlayerByUserID(tonumber(args[1])):SteamID()
	for k=1, 3 do -- spam the command
		RunConsoleCommand("kickid", tonumber(args[1]))
	end
	
end
concommand.Add("kick_player",KickPlayer) 

function SlayPlayer(pl,commandName,args)

	if not (pl:IsAdmin()) then return end
	if not (args[1]) then return end
	GetPlayerByUserID(tonumber(args[1])):Kill()
end
concommand.Add("slay_player",SlayPlayer)

function RedeemPlayer(pl,commandName,args)
	if not (pl:IsSuperAdmin()) or not (args[1]) then
		return
	end

	GetPlayerByUserID(tonumber(args[1])):Redeem( pl )
end
concommand.Add("redeem_player",RedeemPlayer)

--Supply Crates count
function CountSupplyCrates(pl,commandName,args)
	if not (pl:IsAdmin()) then return end

	local CrateEntsCount = #ents.FindByClass("game_supplycrate")
	pl:ChatPrint("There are ".. tostring(CrateEntsCount) .." Supply Crates active")
end
concommand.Add("admin_countcrates",CountSupplyCrates)

-- Bring player
function BringPlayer(pl,commandName,args)

	if not (pl:IsAdmin()) then return end
	local target = GetPlayerByUserID(tonumber(args[1]))
	local des = pl
	
	if target == -1 or target == -2 then
		pl:PrintMessage(HUD_PRINTTALK, "Multiple or no players specified!")
		return
	end
	
	if not (des:Alive()) then
		pl:PrintMessage(HUD_PRINTTALK, "You're dead dumbass!")
		return
	end
	
	if not (target:Alive()) then
		pl:PrintMessage(HUD_PRINTTALK, "Specified player is not alive!")
		return
	end
	
	if (target == des) then
		pl:PrintMessage(HUD_PRINTTALK, "You can't bring yourself!")
		return			
	end
	
	local newpos = playerSend( target, des, target:GetMoveType() == MOVETYPE_NOCLIP )
	if not newpos then
		pl:PrintMessage( HUD_PRINTTALK, "Can't find a place to put them!")
		return
	end

	local newang = (des:GetPos() - newpos):Angle()

	target:SetPos( newpos )
	target:SetEyeAngles( newang )
	target:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!
	
	target:PrintMessage( HUD_PRINTTALK, "You were brought to (ADMIN) "..pl:Name())
	des:PrintMessage( HUD_PRINTTALK, "Player "..target:Name().." teleported to you")
	
end
concommand.Add("bring_player",BringPlayer) 

-- Goto player
function GotoPlayer(pl,commandName,args)

	if not (pl:IsAdmin()) then return end
	local target = pl
	local des = GetPlayerByUserID(tonumber(args[1]))
	
	if des == -1 or des == -2 then
		pl:PrintMessage(HUD_PRINTTALK, "Multiple or no players specified!")
		return
	end
	
	if not (des:Alive()) then
		pl:PrintMessage(HUD_PRINTTALK, "Specified player is not alive!")
		return
	end
	
	if not (target:Alive()) then
		pl:PrintMessage(HUD_PRINTTALK, "You're dead dumbass!")
		return
	end
	
	if (target == des) then
		pl:PrintMessage(HUD_PRINTTALK, "You can't goto yourself!")
		return			
	end
	
	local newpos = playerSend( target, des, target:GetMoveType() == MOVETYPE_NOCLIP )
	if not newpos then
		pl:PrintMessage( HUD_PRINTTALK, "Can't find a place to put you! Use noclip to force a goto.")
		return
	end

	local newang = (des:GetPos() - newpos):Angle()

	target:SetPos( newpos )
	target:SetEyeAngles( newang )
	target:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!
	
	target:PrintMessage( HUD_PRINTTALK, "Teleported to player "..target:Name())
	
end
concommand.Add("goto_player",GotoPlayer) 

-- Change map
function ChangeMap(pl,commandName,args)

	if not (pl:IsAdmin()) then return end
	for k=1, 3 do
		game.ConsoleCommand("changelevel "..args[1].."\n")
	end
	
end
concommand.Add("change_map",ChangeMap) 

--Remove
function AdminRemove(pl,cmd,args)
	if not (pl:IsAdmin()) then return end
	
	local tr = pl:GetEyeTrace()
	
	if tr.Hit and tr.Entity and IsValid(tr.Entity) and not tr.Entity:IsPlayer() and not tr.Entity.AmmoCrate then
		tr.Entity:Remove()
		for k, v in pairs( player.GetAll() ) do
			v:CustomChatPrint( {nil, Color(255,0,0),"[ADMIN] ", Color(245,245,255),"Admin ",Color(255,0,0),tostring ( pl:Name() ),Color(235,235,255)," removed entity ",Color(255,255,255),tostring(tr.Entity:GetClass()).." !"})
		end
	end
	
end
concommand.Add("mrgreen_admin_remove",AdminRemove)

function ShowLevelStats (pl, cmd, args)
	if not (pl:IsValid() and pl:Alive()) then
		return
	end
	
	pl:PrintMessage(HUD_PRINTTALK,"Your rank is "..pl:GetRank() .." with "..pl:GetXP().."/"..pl:NextRankXP() .." XP.")
end
concommand.Add("zs_showlevel",ShowLevelStats)

function EnableDamageOutput (pl, cmd, args)
	if not (pl:IsValid()) then
		return
	end
	
	if pl.DamageOutput then
		pl.DamageOutput = false
		pl:PrintMessage(HUD_PRINTTALK,"Disabled damage output.")		
	else
		pl.DamageOutput = true	
		pl:PrintMessage(HUD_PRINTTALK,"Enabled damage output.")		
	end

end
concommand.Add("zs_damageoutput",EnableDamageOutput)

function Pufu(pl, commandName,args )
	if ENDROUND then
		return
	end

	pl:ChatPrint("Dice temporarily disabled at round start")


end


function RollTheDice ( pl,commandName,args )
	if ENDROUND then
		return
	end

	if not (pl:IsValid() and pl:Alive() and not ENDROUND) then
		return
	end
	
	if CurTime() < (WARMUPTIME+10) then
		pl:ChatPrint("Dice temporarily disabled at round start")
		return
	end
	
	if pl.LastRTD >= CurTime() then
		pl:PrintMessage(HUD_PRINTTALK, "You have to wait "..math.floor((pl.LastRTD-CurTime())).." more seconds before you can roll the dice!")
		return
	end
	
	
	
	local choise,message,name
	
--[[	--Let's roll
	choise = math.random(1,5)
	--Second roll when having ladyluck-item
	if pl:HasBought("ladyluck") and choise <= 2 then
		choise = math.random(1,5)
	end
	
	if pl:HasBought("ladyluck") and choise <= 1 then
		choise = math.random(1,5)
		
	end]]--
	
	choise = math.random(1,6)
	
	if pl:HasBought("ladyluck") and choise <= 2 then
		choise = math.random(3,6) -- second chance with bad outcome
	end
	
	message = pl:GetName()

	if choise == 1 then	
		if pl:Team() == TEAM_UNDEAD then	
			pl:AddScore(1)
			message = "WIN: ".. message .." rolled the dice and has found a piece of brain!"
		end
		if pl:Team() == TEAM_HUMAN then	
			pl:SetVelocity(Vector(math.random(0,1000),math.random(0,1000),math.random(0,1000)))
			message = "LOSE: ".. message .." rolled the dice and has been flung!"
		end		
	elseif choise == 2 then
		if pl:Team() == TEAM_HUMAN then
			message = "LOSE: ".. message .." rolled the dice and got raped in the ass."
			pl:SetHealth(1)
		elseif pl:Team() == TEAM_UNDEAD then
			local calchealth = math.Clamp ( 200 - pl:Health(),60,200 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth(pl:Health() + randhealth)
			message = "WIN: ".. message .." rolled the dice and gained ".. randhealth .."KG of flesh!!"
		end
	elseif choise == 3 then
		if pl:Team() == TEAM_HUMAN then
				if pl:HasBought("ladyluck") then
			pl:GiveAmmo( 120, "pistol" )	
			pl:GiveAmmo( 80, "ar2" )
			pl:GiveAmmo( 120, "SMG1" )	
			pl:GiveAmmo( 80, "buckshot" )		
			pl:GiveAmmo( 8, "XBowBolt" )
			pl:GiveAmmo( 50, "357" )
			message = "WIN: ".. message .." rolled the dice and received extra ammo from lady luck!"		
		else
			pl:GiveAmmo( 90, "pistol" )	
			pl:GiveAmmo( 60, "ar2" )
			pl:GiveAmmo( 90, "SMG1" )	
			pl:GiveAmmo( 60, "buckshot" )		
			pl:GiveAmmo( 5, "XBowBolt" )
			pl:GiveAmmo( 30, "357" )
			message = "WIN: ".. message .." rolled the dice and received some ammo!"	
		end	
		elseif pl:Team() == TEAM_UNDEAD then
			local calchealth = math.Clamp ( 100 - pl:Health(),60,100 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth(math.max(pl:Health() - randhealth, 1))
			message = "LOSE: ".. message .." rolled the dice and lost ".. randhealth .."KG of flesh!!"
		end
	elseif choise == 4 and pl:Health() < pl:GetMaximumHealth() then
		if pl:Team() == TEAM_HUMAN then
			local calchealth = math.Clamp ( 100 - pl:Health(),10,50 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth( math.min( pl:Health() + randhealth, pl:GetMaximumHealth() ) )
			message = "WIN: ".. message .." rolled the dice and gained ".. randhealth .." health!"
		elseif pl:Team() == TEAM_UNDEAD then
			local calchealth = math.Clamp ( 200 - pl:Health(),60,200 )
			local randhealth = math.random( 25, math.Round ( calchealth ) )
			pl:SetHealth( pl:Health() + randhealth)
			message = "WIN: ".. message .." rolled the dice and gained ".. randhealth .."KG of flesh!!"
		end
	elseif choise == 5 then
		if pl:Team() == TEAM_HUMAN then
			pl:Ignite( math.random(1,4), 0)
			message = "LOSE: "..message.." was put on fire by the dice."
		elseif pl:Team() == TEAM_UNDEAD then
			pl.BrainsEaten = pl.BrainsEaten - 1
			message = "LOSE: ".. message .." rolled the dice and has lost a piece of brain!"
		end
	elseif choise == 6 then
		if pl:Team() == TEAM_HUMAN then
			message = message .. ".. rolled the dice and got bugger all!"
		elseif pl:Team() == TEAM_UNDEAD then
			message = message .." rolled the dice and got bugger all!"
		end	
	end
		
	pl.LastRTD = CurTime() + RTD_TIME

	PrintMessageAll(HUD_PRINTTALK, message)
end
concommand.Add("zs_rollthedice",RollTheDice) 

function ShowShop(pl,commandName,args)
	pl:SendLua("DrawGreenShop()")
end
concommand.Add("open_shop",ShowShop)

--[=[------------------------------------------
			Some extra functions
------------------------------------------]=]

function GetPlayerByUserID( id )
	for k, v in pairs(player.GetAll()) do
		if v:UserID() == id then
			return v
		end
	end
end

-- ulx player teleportation code
function playerSend( from, to, force )

	if not to:IsInWorld() and not force then return false end -- No way we can do this one

	local yawForward = to:EyeAngles().yaw
	local directions = { -- Directions to try
		math.NormalizeAngle( yawForward - 180 ), -- Behind first
		math.NormalizeAngle( yawForward + 90 ), -- Right
		math.NormalizeAngle( yawForward - 90 ), -- Left
		yawForward
	}

	local t = {}
	t.start = to:GetPos() + Vector( 0, 0, 32 ) -- Move them up a bit so they can travel across the ground
	t.filter = { to, from }

	local i = 1
	t.endpos = to:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47 -- (33 is player width, this is sqrt( 33^2 * 2 ))
	local tr = util.TraceEntity( t, from )
    while tr.Hit do -- While it's hitting something, check other angles
    	i = i + 1
    	if i > #directions then  -- No place found
			if force then
				return to:GetPos() + Angle( 0, directions[ 1 ], 0 ):Forward() * 47
			else
				return false
			end
		end

		t.endpos = to:GetPos() + Angle( 0, directions[ i ], 0 ):Forward() * 47

		tr = util.TraceEntity( t, from )
    end

	return tr.HitPos
	
end
--Where chat commands were. Duby: I removed them as having a big ass file is a horrible way of coding things..

function ApplyLoadout(pl, com, args)
	if not args or #args <= 0 or not IsValid(pl) then
		return
	end
	
	if not pl.Loadout then
		pl.Loadout = {}
	end
	
	for _, item in pairs(args) do
		if pl:HasUnlocked(item) then
			if string.sub(item, 1, 1) == "_" then
				pl:SetPerk(item)
			elseif string.sub(item, 1, 6) == "weapon" then
				table.insert(pl.Loadout,item)
			end
		end
	end
end
concommand.Add("_applyloadout",ApplyLoadout)


local function RestartCommand( pl, cmd, args )
    RunConsoleCommand("changelevel", tostring(game.GetMap()))
end
concommand.Add( "zs_restartmap", RestartCommand )