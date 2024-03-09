function SoDA:GetBooks()
    local availableBooks = {
        ["DRUID"]   = {
            { ["spell"] = "417123" }, -- Enhanced Restoration
            { ["spell"] = "437138" }, -- Revive
            { ["spell"] = "436956" }, -- Deeper Wilds
        },
        ["HUNTER"]  = {
            { ["spell"] = "415423" }, -- Aspect of the Viper
        },
        ["MAGE"]    = {
            { ["spell"] = "436949" }, -- Expanded Intellect
        },
        ["PALADIN"] = {
            { ["spell"] = "435984" }, -- Enhanced Blessings
        },
        ["PRIEST"]  = {
            { ["spell"] = "401977" }, -- Shadowfiend
            { ["spell"] = "436951" }, -- Increased Fortitude
        },
        ["ROGUE"]   = {
            { ["spell"] = "438040" }, -- Redirect
        },
        ["SHAMAN"]  = {
            { ["spell"] = "437009" }, -- Totemic Projection
        },
        ["WARLOCK"] = {
            { ["spell"] = "437169" }, -- Portal of Summoning
            { ["spell"] = "437032" }, -- Soul Harvesting
        },
        ["WARRIOR"] = {
            { ["spell"] = "403215" }, -- Commanding Shout
        },
    }
    local books = {}
    books.numBooksAvailable = 0
    books.numBooksKnown = 0
    books.bookMap = {}
    for class, classBooks in pairs(availableBooks) do
        if class == self.db.global.characters[self.loggedInCharacter].basic.class then
            for _, v in ipairs(classBooks) do
                books.numBooksAvailable = books.numBooksAvailable + 1
                local name, _ = GetSpellInfo(v.spell)
                local isKnown = IsSpellKnown(v.spell)
                if isKnown then
                    books.numBooksKnown = books.numBooksKnown + 1
                end
                table.insert(books.bookMap, { ["spell"] = v.spell, ["known"] = isKnown })
            end
        end
    end

    return books
end

function SoDA:GetBooksGui(character)
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)
    local books = character.books or {}
    local numBooksKnown = books.numBooksKnown or "?"
    local numBooksAvailable = books.numBooksAvailable or "?"

    -- Header
    group:AddChild(SoDA:Header(" "))

    -- Books known
    local booksKnown = self.aceGui:Create("Label")
    booksKnown:SetWidth(self.defaultWidth)
    if numBooksKnown == numBooksAvailable and numBooksKnown ~= "?" then
        booksKnown:SetColor(0, 1, 0)
    end
    booksKnown:SetText(numBooksKnown .. "/" .. numBooksAvailable)
    -- Books tooltip
    booksKnown.frame:SetScript("OnEnter", function(_)
        SoDA:BooksTooltip(booksKnown.frame, books)
    end)
    booksKnown.frame:SetScript("OnLeave", function(_)
        GameTooltip:Hide()
    end)
    booksKnown.frame:SetScript("OnHide", function()
        booksKnown.frame:SetScript("OnEnter", nil)
        booksKnown.frame:SetScript("OnLeave", nil)
    end)
    group:AddChild(booksKnown)

    return group
end

function SoDA:GetBooksLegend()
    local group = self.aceGui:Create("SimpleGroup")
    group:SetWidth(self.defaultWidth)

    -- Books
    group:AddChild(SoDA:Header("Books"))

    -- Phase 2
    group:AddChild(SoDA:LegendLabel("Phase 2"))

    return group
end

function SoDA:BooksTooltip(frame, books)
    GameTooltip:SetOwner(frame, "ANCHOR_CURSOR")
    GameTooltip:AddLine("Books")
    local bookMap = books.bookMap or {}
    GameTooltip:AddLine(" ")
    for _, book in ipairs(bookMap) do
        local name, _ = GetSpellInfo(book.spell)
        if book.known then
            GameTooltip:AddDoubleLine(name, self.checkMark)
        else
            GameTooltip:AddDoubleLine(name, " ")
        end
    end
    GameTooltip:Show()
end
