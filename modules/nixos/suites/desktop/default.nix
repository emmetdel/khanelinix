{
  config,
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.desktop;
in
{
  options.${namespace}.suites.desktop = {
    enable = mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {
    khanelinix = {
      programs = {
        graphical = {
          apps = {
            _1password = enabled;
          };

          wms = {
            hyprland = enabled;
          };
        };
      };
    };
  };
}
