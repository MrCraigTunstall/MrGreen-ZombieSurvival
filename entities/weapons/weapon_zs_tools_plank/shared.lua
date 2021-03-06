if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "weapon_zs_base_dummy"

SWEP.HoldType = "slam"

if ( CLIENT ) then
	SWEP.PrintName = "Board Pack"
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	
	killicon.AddFont( "weapon_zs_tools_plank", "HL2MPTypeDeath", "9", Color(255, 255, 255, 255 ) )
	
	--SWEP.NoHUD = true
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	SWEP.IgnoreBonemerge = true
	
	SWEP.IgnoreThumbs = true
	SWEP.UseHands = true
	
end

SWEP.BoardModels = {
	Model("models/props_debris/wood_board04a.mdl"),
	Model("models/props_debris/wood_board06a.mdl"),
	Model("models/props_debris/wood_board02a.mdl"),
	Model("models/props_debris/wood_board01a.mdl"),
	Model("models/props_debris/wood_board07a.mdl")
}

SWEP.Author = "NECROSSIN"

SWEP.ViewModel = "models/weapons/v_c4.mdl"
--SWEP.ViewModel  = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = Model("models/props_debris/wood_board06a.mdl")


SWEP.Type = "Tool"
SWEP.Weight = 2
SWEP.Slot = 5

-- SWEP.Info = ""
SWEP.HumanClass = "support"
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 5
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1
SWEP.ShowViewModel = false
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 0.15


function SWEP:InitializeClientsideModels()
	

	self.ViewModelBoneMods = {
		["v_weapon.Left_Ring01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -5.975, 0) },
		["v_weapon.Left_Index01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 27, 0) },
		["v_weapon.Right_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-13.825, 2.549, -5.014) },
		["v_weapon.Left_Middle01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 16.261, 0) },
		["v_weapon.Left_Thumb01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(12.512, -10, -29.639) },
		["v_weapon.Left_Pinky01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -6.244, 0) },
		["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.136, 0), angle = Angle(5.625, 23.011, 15.069) },
		["v_weapon.Right_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(15.824, 11.439, 14.48) },
		["v_weapon.Left_Thumb02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 5.23, 0) },
		["v_weapon.Left_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(23.357, 19.294, -17.288) },
		["v_weapon.Left_Middle02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 22.256, 0) },
		["v_weapon.Left_Thumb03"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 52.168, 0) },
		["v_weapon.c4"] = { scale = Vector(0.002, 0.002, 0.002), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	--	["v_weapon.Left_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(-7.238, 12.175, -3.358), angle = Angle(58.224, -14.443, 76.694) }
			["v_weapon.button0"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button1"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button2"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button3"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button4"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button5"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button6"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button7"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button8"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["v_weapon.button9"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	}
	self.VElements = {
		["plank"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "v_weapon.c4", rel = "", pos = Vector(-3.619, 0.218, 0.619), angle = Angle(6.836, 48.5, -10.445), size = Vector(0.31, 0.31, 0.31), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self.WElements = {
		["plank"] = { type = "Model", model = "models/props_debris/wood_board06a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.288, 4.263, 0), angle = Angle(52.837, -1.726, 0), size = Vector(0.5, 0.437, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

function SWEP:OnInitialize()
	if SERVER then
		self.Weapon.FirstSpawn = true
	end	
end

function SWEP:OnDeploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
end

function SWEP:PrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end
	
	local aimvec = self.Owner:GetAimVector()
	local shootpos = self.Owner:GetShootPos()
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 32, filter = self.Owner})

	if self and self:IsValid() and self.Weapon:Clip1() < 1 then
		return
	end
	

	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(60, 65))	
	self:SetNextPrimaryFire(CurTime() + 1)
	
	if SERVER then		
		local ent = ents.Create("prop_physics_multiplayer")
		if IsValid(ent) then
			local ang = aimvec:Angle()
			ang:RotateAroundAxis(ang:Forward(), 90)
			ent:SetPos(tr.HitPos)
			ent:SetAngles(ang)
			ent:SetModel(table.Random(self.BoardModels))
			ent:Spawn()
			local hp = 350
			ent:SetHealth(hp)
			ent.PropHealth = hp
			ent.PropMaxHealth = hp
			
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMass(math.min(phys:GetMass(), 50))
				phys:SetVelocityInstantaneous(self.Owner:GetVelocity())
			end
			ent:SetPhysicsAttacker(self.Owner)
			self:TakePrimaryAmmo(1)
		end
		
		if self:Clip1() == 0 then
			DropWeapon(self.Owner)
			self:Remove()
		end		
		
	end
	

	

end

function SWEP:Reload() 
	return false
end  
 
function SWEP:SecondaryAttack()
return false
end 
