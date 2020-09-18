--
-- export The Pantheon data
--
local zip = zip

if not loadStatFile then
	dofile("statdesc.lua")
end
loadStatFile("stat_descriptions.txt")

local out = io.open("../Data/3_0/Pantheons.lua", "w")
out:write('-- This file is automatically generated, do not edit!\n')
out:write('-- The Pantheon data (c) Grinding Gear Games\n\n')
out:write('return {\n')

for _, p in pairs(dat("PantheonPanelLayout"):GetRowList("IsDisabled", false)) do
    out:write('\t["', p.Id, '"] = {\n')
    out:write('\t\tisMajorGod = ', tostring(p.IsMajorGod), ',\n')
    out:write('\t\tsouls = {\n')

    local gods = {
        { name = p.GodName1, statKeys = p.Effect1StatsKey, values = p.Effect1Values },
        { name = p.GodName2, statKeys = p.Effect2StatsKey, values = p.Effect2Values },
        { name = p.GodName3, statKeys = p.Effect3StatsKey, values = p.Effect3Values },
        { name = p.GodName4, statKeys = p.Effect4StatsKey, values = p.Effect4Values },
    }
    for god_index, god in pairs(gods) do
        if next(god.statKeys) then
            out:write('\t\t\t[', god_index, '] = { ')
            out:write('name = "', god.name, '",\n')
            out:write('\t\t\t\tmods = {\n')
            for soul_index, souls in pairs(zip(god.statKeys, god.values)) do
                local key = souls[1]
                local value = souls[2]
                local stats = { }
                stats[key.Id] = { min = value, max = value }
                out:write('\t\t\t\t\t-- ', key.Id, '\n')
                out:write('\t\t\t\t\t[', soul_index, '] = { line = "', table.concat(describeStats(stats), ' '), '", ')
                out:write('value = { ', value, ' }, ')
                out:write('},\n')

            end
            out:write('\t\t\t\t},\n')
            out:write('\t\t\t},\n')
        end
    end

    out:write('\t\t},\n')
    out:write('\t},\n')
end

out:write('}')
out:close()

print("Pantheon data exported.")
