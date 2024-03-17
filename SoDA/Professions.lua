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

    local s = self.db.global.settings
    local professions = character.professions or {}

    -- Header
    group:AddChild(SoDA:Header(" "))

    -- First Primary
    if s["First primary"] == nil or s["First primary"] then
        group:AddChild(SoDA:GetSkillGui(professions.firstPrimary, true))
    end

    -- Second Primary
    if s["Second primary"] == nil or s["Second primary"] then
        group:AddChild(SoDA:GetSkillGui(professions.secondPrimary, true))
    end

    -- Cooking
    if s.Cooking == nil or s.Cooking then
        group:AddChild(SoDA:GetSkillGui(professions.cooking, false))
    end

    -- First Aid
    if s["First Aid"] == nil or s["First Aid"] then
        group:AddChild(SoDA:GetSkillGui(professions.firstAid, false))
    end

    -- Fishing
    if s.Fishing == nil or s.Fishing then
        group:AddChild(SoDA:GetSkillGui(professions.fishing, false))
    end

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

    local s = self.db.global.settings

    -- Professions
    group:AddChild(SoDA:Header(self.L["Professions"]))

    -- First primary
    if s["First primary"] == nil or s["First primary"] then
        group:AddChild(SoDA:LegendLabel(self.L["First primary"]))
        group:AddChild(SoDA:LegendLabel(" "))
    end

    -- Second primary
    if s["Second primary"] == nil or s["Second primary"] then
        group:AddChild(SoDA:LegendLabel(self.L["Second primary"]))
        group:AddChild(SoDA:LegendLabel(" "))
    end

    -- Cooking
    if s.Cooking == nil or s.Cooking then
        group:AddChild(SoDA:LegendLabel(self.L["Cooking"]))
    end

    -- First Aid
    if s["First Aid"] == nil or s["First Aid"] then
        group:AddChild(SoDA:LegendLabel(self.L["First Aid"]))
    end

    -- Fishing
    if s.Fishing == nil or s.Fishing then
        group:AddChild(SoDA:LegendLabel(self.L["Fishing"]))
    end

    return group
end

function SoDA:ProfessionsEnabled()
    local s = self.db.global.settings
    local firstPrimary = s["First primary"]
    if firstPrimary == nil then firstPrimary = true end
    local secondPrimary = s["Second primary"]
    if secondPrimary == nil then secondPrimary = true end
    local cooking = s["Cooking"]
    if cooking == nil then cooking = true end
    local firstAid = s["First Aid"]
    if firstAid == nil then firstAid = true end
    local fishing = s["Fishing"]
    if fishing == nil then fishing = true end
    return firstPrimary or secondPrimary or cooking or firstAid or fishing
end
