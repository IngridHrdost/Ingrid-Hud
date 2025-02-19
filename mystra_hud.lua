-- Ingrid HUD Lua Script

if CLIENT then

    local hudColor = Color(255, 255, 255, 200)
    local screenWidth, screenHeight = ScrW(), ScrH()
    local ingridMaterial = Material("materials/hud/hudbase.png")

    local healthMaterial = Material("materials/hud/can.png")
    local armorMaterial = Material("materials/hud/armor.png")
    local hungerMaterial = Material("materials/hud/yemek.png")
    local thirstMaterial = Material("materials/hud/su.png")

    local factionIcons = {
        ["Evsiz"] = Material("materials/hud/luminahud.png"),
        ["Karanlık"] = Material("materials/hud/karanlik.png"),
        ["Profesör"] = Material("materials/hud/profesor.png"),
        ["Slytherin"] = Material("materials/hud/slytherin.png"),
        ["Ravenclaw"] = Material("materials/hud/ravenclaw.png"),
        ["Gryffindor"] = Material("materials/gryffindor.png"),
        ["Hufflepuff"] = Material("materials//hufflepuff.png"),
        ["Seherbaz"] = Material("materials/seherbaz.png"),
        ["Bakanlık"] = Material("materials/bakanlik.png"),
        ["Bellatrix Lestrange"] = Material("materials/hud/bellatrix.png"),
        ["Barty Crouch JR."] = Material("materials/hud/barty.png")
    }



    local hiddenHUD = {
        ["CHudHealth"] = true,
        ["CHudBattery"] = true,
        ["CHudAmmo"] = true,
        ["CHudSecondaryAmmo"] = true
    }

    hook.Add("HUDShouldDraw", "Ingrid_HideDefaultHUD", function(name)
        if hiddenHUD[name] then return false end
    end)

    local function DrawBarWithScissor(material, x, y, width, height, percentage, vertical)
        render.SetScissorRect(
            x,
            y + (vertical and (1 - percentage) * height or 0),
            x + (not vertical and percentage * width or width),
            y + height,
            true
        )
        surface.SetMaterial(material)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(x, y, width, height)
        render.SetScissorRect(0, 0, 0, 0, false)
    end

    local function DrawFactionIcon(player, x, y, size)
        local factionID = player:GetCharacter() and player:GetCharacter():GetFaction() or nil
        if not factionID then return end

        local factionName = ix.faction.indices[factionID] and ix.faction.indices[factionID].name or nil
        if not factionName or not factionIcons[factionName] then return end

        local material = factionIcons[factionName]
        surface.SetMaterial(material)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(x, y, size, size)
    end
    
    local function DrawIngridHUD()
        local player = LocalPlayer()
        if not IsValid(player) or not player:Alive() then return end

        local iconX = 100
        local iconY = screenHeight - 300
        local iconSize = 64
     
        local health = math.Clamp(player:Health() / player:GetMaxHealth(), 0, 1)
        DrawBarWithScissor(healthMaterial, 50, screenHeight - 350, 512, 497, health, false)

        DrawFactionIcon(player, iconX, iconY, iconSize)

        local armor = math.Clamp(player:Armor() / 100, 0, 1)
        DrawBarWithScissor(armorMaterial, 50, screenHeight - 350, 512, 497, armor, false)

        local hunger = math.Clamp(player:GetNWInt("Hunger", 100) / 100, 0, 1)
        DrawBarWithScissor(hungerMaterial, 50, screenHeight - 350, 512, 497, hunger, true)

        local thirst = math.Clamp(player:GetNWInt("Thirst", 100) / 100, 0, 1)
        DrawBarWithScissor(thirstMaterial, 50, screenHeight - 350, 512, 497, thirst, true)

        surface.SetMaterial(ingridMaterial)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(50, screenHeight - 300 - 50, 512,497)

        draw.SimpleText(player:Health(), "Trebuchet24", 470, screenHeight - 85, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(player:Armor(), "Trebuchet24", 340, screenHeight - 85, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    end

    hook.Add("HUDPaint", "Ingrid_CustomHUD", DrawIngridHUD)
end
