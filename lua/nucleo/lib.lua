local ffi=require'ffi'
if not _G.nucleo_ffi_cdef then
    ffi.cdef[[
    int match(void*,char*,int,char*,int);
    ]]
    _G.nucleo_ffi_cdef=true
end
---@return string
local function get_path()
    local bin=vim.api.nvim_get_runtime_file('target/release/libnucleo_nvim.so',false)[1]
    if bin then return bin end
    vim.notify_once('nucleo.nvim: only debug build found')
    return (assert(
        vim.api.nvim_get_runtime_file('target/debug/libnucleo_nvim.so',false)[1],
        'lib not found'
    ))
end
local rlib=ffi.load(get_path())
local M={}
---@param patt string
---@param item string
---@param off number?
---@return {score:number,hls:number[]}
function M.match(patt,item,off)
    if patt=='' then return {score=1,hls={}} end
    off=off or 0
    local out=ffi.new('unsigned int[?]',#patt)
    local score=rlib.match(out,ffi.cast('char*',patt),#patt,ffi.cast('char*',item),#item)
    local hls={}
    for i=0,#patt-1 do
        table.insert(hls,1,out[i]+off)
    end
    return {score=score,hls=hls}
end
return M
