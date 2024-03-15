function SoDA:GetProfessions()
    local primaryProfessions = {
        self.L["Alchemy"],
        self.L["Blacksmithing"],
        self.L["Enchanting"],
        self.L["Engineering"],
        self.L["Herbalism"],
        self.L["Leatherworking"],
        self.L["Mining"],
        self.L["Skinning"],
        self.L["Tailoring"],
    }
    local professions = {}

    local firstPrimaryFound = false;
    local numSkills = GetNumSkillLines();
    for i = 1, numSkills do
        local skillName, header, _, skillRank, _, _, skillMaxRank, _ = GetSkillLineInfo(i);
        if not header then
            local skill = {
                ["name"] = skillName,
                ["rank"] = skillRank,
                ["maxRank"] = skillMaxRank,
            }
            for _, primaryProf in pairs(primaryProfessions) do
                if skillName == primaryProf then
                    if firstPrimaryFound then
                        professions.secondPrimary = skill
                    else
                        professions.firstPrimary = skill
                        firstPrimaryFound = true
                    end
                end
            end
            if skillName == self.L["Cooking"] then
                professions.cooking = skill
            end
            if skillName == self.L["First Aid"] then
                professions.firstAid = skill
            end
            if skillName == self.L["Fishing"] then
                professions.fishing = skill
            end
        end
    end

    return professions
end

function SoDA:GetProfessionsGui(character)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    local professions = character.professions or {}

    -- Header
    group:AddChild(SoDA:Header(" "))

    -- First Primary
    group:AddChild(SoDA:GetSkillGui(professions.firstPrimary, true))

    -- Second Primary
    group:AddChild(SoDA:GetSkillGui(professions.secondPrimary, true))

    -- Cooking
    group:AddChild(SoDA:GetSkillGui(professions.cooking, false))

    -- First Aid
    group:AddChild(SoDA:GetSkillGui(professions.firstAid, false))

    -- Fishing
    group:AddChild(SoDA:GetSkillGui(professions.fishing, false))

    return group
end

function SoDA:GetSkillGui(skill, showName)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)
    local skillLabel = self.aceGui:Create("Label")
    skillLabel:SetWidth(self.defaultWidth)
    local skillNameLabel = self.aceGui:Create("Label")
    skillNameLabel:SetWidth(self.defaultWidth)
    skillNameLabel:SetText(" ")

    if skill == nil then
        skillLabel:SetText(" ")
    else
        skillNameLabel:SetText(skill.name)
        skillLabel:SetText(skill.rank .. "/" .. skill.maxRank)
        if skill.rank == skill.maxRank and skill.rank >= self.maxProfessionRank then
            skillLabel:SetColor(0, 1, 0)
        end
        -- Skill tooltip
        SoDA:Tooltip(skillLabel.frame, function()
            SoDA:SkillTooltip(skillLabel.frame, skill)
        end)
    end

    if showName then
        group:AddChild(skillNameLabel)
    end
    group:AddChild(skillLabel)
    return group
end

function SoDA:SkillTooltip(frame, skill)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine(skill.name)
    GameTooltip:AddLine(" ")
    local text = skill.rank .. "/" .. skill.maxRank
    if skill.rank == skill.maxRank and skill.rank >= self.maxProfessionRank then
        GameTooltip:AddLine("|cff00ff00" .. text .. FONT_COLOR_CODE_CLOSE)
    else
        GameTooltip:AddLine("|cffffffff" .. text .. FONT_COLOR_CODE_CLOSE)
    end
    GameTooltip:Show()
end

function SoDA:GetProfessionsLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    -- Professions
    group:AddChild(SoDA:Header("Professions"))

    -- First primary
    group:AddChild(SoDA:LegendLabel("First primary"))
    group:AddChild(SoDA:LegendLabel(" "))

    -- Second primary
    group:AddChild(SoDA:LegendLabel("Second primary"))
    group:AddChild(SoDA:LegendLabel(" "))

    -- Cooking
    group:AddChild(SoDA:LegendLabel(self.L["Cooking"]))

    -- First Aid
    group:AddChild(SoDA:LegendLabel(self.L["First Aid"]))


    -- Fishing
    group:AddChild(SoDA:LegendLabel(self.L["Fishing"]))

    return group
end
