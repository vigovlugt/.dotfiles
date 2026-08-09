{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraLuaFiles.config = ./hyprland.lua;
  };
}
