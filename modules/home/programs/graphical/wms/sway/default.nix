{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.programs.graphical.wms.sway;

in
{
  options.${namespace}.programs.graphical.wms.sway = {
    enable = mkEnableOption "sway.";
    enableDebug = mkEnableOption "Enable debug mode.";
    appendConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration lines to add to bottom of `~/.config/hypr/sway.conf`.
      '';
    };
    prependConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration lines to add to top of `~/.config/hypr/sway.conf`.
      '';
    };
    extraSessionCommands = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra shell commands to run at start of session.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Configuration to pass through to the main sway module.
      '';
    };
  };

  # imports = lib.snowfall.fs.get-non-default-nix-files ./.;

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ xwaylandvideobridge ];

      sessionVariables = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_USE_XINPUT2 = "1";
        SDL_VIDEODRIVER = "wayland";
        WLR_DRM_NO_ATOMIC = "1";
        XDG_CURRENT_DESKTOP = "sway";
        XDG_SESSION_DESKTOP = "sway";
        XDG_SESSION_TYPE = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        __GL_GSYNC_ALLOWED = "0";
        __GL_VRR_ALLOWED = "0";
      };
    };

    khanelinix = {
      programs = {
        graphical = {
          launchers = {
            anyrun = enabled;
          };

          screenlockers = {
            swaylock = enabled;
          };
        };
      };

      services = {
        swayidle = enabled;
      };

      suites = {
        wlroots = enabled;
      };

      theme = {
        gtk = enabled;
        qt = enabled;
      };
    };

    services.cliphist.systemdTarget = lib.mkDefault "sway-session.target";

    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.sway;

      config = {
        bars = [
          { command = mkIf config.khanelinix.programs.graphical.bars.waybar.enable (lib.getExe pkgs.waybar); }
        ];
      } // cfg.settings;
      extraConfig = cfg.appendConfig;
      extraConfigEarly = cfg.prependConfig;

      extraSessionCommands = # bash
        ''
          ${lib.getExe pkgs.libnotify} --icon ~/.face -u normal \"Hello $(whoami)\"
        '';

      systemd = {
        enable = true;
        xdgAutostart = true;

        variables = [ "--all" ];
      };

      xwayland = true;
    };
  };
}
