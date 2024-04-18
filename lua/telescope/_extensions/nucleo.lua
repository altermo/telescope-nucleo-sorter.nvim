local lib = require 'nucleo.lib'
local sorters = require 'telescope.sorters'

local matcher = lib.create_matcher()

local function create_sorter()
    return sorters.Sorter:new {
        start = function(_, prompt)
            matcher:set_pattern(vim.trim(prompt))
        end,
        discard = true,
        scoring_function = function(_, _, line)
            local score = matcher:match(line)
            if score == 0 then return -1 end
            return 1 / score
        end,
        highlighter = function(_, _, display)
            local _, hlcols = matcher:match(display)
            return hlcols
        end,
    }
end
return require 'telescope'.register_extension {
    setup = function(_, conf)
        conf.file_sorter = create_sorter
        conf.generic_sorter = create_sorter
    end,
}
