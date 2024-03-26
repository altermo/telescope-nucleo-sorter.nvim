local lib = require 'nucleo.lib'
local sorters = require 'telescope.sorters'

local function create_sorter()
    return sorters.Sorter:new {
        discard = true,
        scoring_function = function(_, prompt, line)
            local score = lib.match(vim.trim(prompt), line).score
            if score == 0 then return -1 end
            return 1 / score
        end,
        highlighter = function(_, prompt, display)
            local hls = lib.match(prompt, display:sub(3), 3).hls
            return hls
        end,
    }
end
vim.schedule(function()
    require('telescope').load_extension('nucleo')
end)
return require 'telescope'.register_extension {
    setup = function(_, conf)
        conf.file_sorter = create_sorter
        conf.generic_sorter = create_sorter
    end,
}
