---@diagnostic disable: lowercase-global, undefined-global
cache = true
std = luajit
self = false
max_line_length = 180
globals = { "vim", "describe", "it", "use" }

files[".config/nvim/lua/hacksore/test/typescript.lua"] = {
  std = "luajit+busted",
}
