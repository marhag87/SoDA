function SoDA:GetAuras()
    local auras = {}

    -- Sleeping bag buff
    SoDA:ForEachAura("player", "HELPFUL", nil, function(_, _, count, _, _, expirationTime, _, _, _, spellId, _)
        -- Well-Rested
        if spellId == 429959 then
            local duration = expirationTime - GetTime()
            auras.sleepingBagBuff = { ["count"] = count, ["duration"] = duration }
        end
    end)

    return auras
end
