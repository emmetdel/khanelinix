{ config
, inputs
, lib
, pkgs
, system
, ...
}:
let
  inherit (lib) getExe' getExe mkIf mkEnableOption types mkOption;
  inherit (lib.internal) mkOpt;
  # inherit (inputs) hyprpaper hypr-socket-watch;

  cfg = config.khanelinix.desktop.addons.hyprpaper;
in
{
  options.khanelinix.desktop.addons.hyprpaper = {
    enable = mkEnableOption "Hyprpaper";
    monitors = mkOption {
      description = "Monitors and their wallpapers";
      type = with types; listOf (submodule {
        options = {
          name = mkOption {
            type = str;
          };
          wallpaper = mkOption {
            type = path;
          };
        };
      });
    };
    wallpapers = mkOpt (types.listOf types.path) [
    ] "Wallpapers to preload.";
  };

  config =
    mkIf cfg.enable
      {
        services.hyprpaper = {
          enable = true;
          # package = hyprpaper.packages.${system}.hyprpaper;
          package = pkgs.hyprpaper;
          preloads = cfg.wallpapers;
          wallpapers = map (monitor: "${monitor.name},${monitor.wallpaper}") cfg.monitors;
        };

        # FIX: broken with recent hyprpaper/hyprland updates... need to fix
        # systemd.user.services.hypr_socket_watch = {
        #   Install.WantedBy = [ "hyprland-session.target" ];
        #
        #   Unit = {
        #     Description = "Hypr Socket Watch Service";
        #     PartOf = [ "graphical-session.target" ];
        #   };
        #
        #   Service = {
        #     ExecStart = "${getExe pkgs.khanelinix.hypr_socket_watch}";
        #     Restart = "on-failure";
        #   };
        # };
      };
}
