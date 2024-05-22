{ config, lib }:
let
  catppuccin = import ../../../../../theme/catppuccin/colors.nix;
in
{
  manager = {
    cwd = {
      fg = catppuccin.colors.text.hex;
    };
    hovered = {
      fg = catppuccin.colors.base.hex;
      bg = catppuccin.colors.blue.hex;
    };
    preview_hovered = {
      underline = true;
    };
    find_keyword = {
      fg = catppuccin.colors.yellow.hex;
      italic = true;
    };
    find_position = {
      fg = catppuccin.colors.pink.hex;
      bg = "reset";
      italic = true;
    };
    marker_selected = {
      fg = catppuccin.colors.green.hex;
      bg = catppuccin.colors.green.hex;
    };
    marker_copied = {
      fg = catppuccin.colors.yellow.hex;
      bg = catppuccin.colors.yellow.hex;
    };
    marker_cut = {
      fg = catppuccin.colors.red.hex;
      bg = catppuccin.colors.red.hex;
    };
    tab_active = {
      fg = catppuccin.colors.base.hex;
      bg = catppuccin.colors.blue.hex;
    };
    tab_inactive = {
      fg = catppuccin.colors.text.hex;
      bg = catppuccin.colors.surface1.hex;
    };
    tab_width = 1;
    border_symbol = "│";
    border_style = {
      fg = catppuccin.colors.blue.hex;
    };
    count_copied = {
      fg = catppuccin.colors.base.hex;
      bg = catppuccin.colors.yellow.hex;
    };
    count_cut = {
      fg = catppuccin.colors.base.hex;
      bg = catppuccin.colors.pink.hex;
    };
    count_selected = {
      fg = catppuccin.colors.base.hex;
      bg = catppuccin.colors.green.hex;
    };
    syntect_theme =
      let
        cfg = config.khanelinix.theme;
        inherit (lib.internal) capitalize;
      in
      "/bat/${capitalize cfg.selectedTheme.name} ${capitalize cfg.selectedTheme.variant}.tmTheme";
  };
}
