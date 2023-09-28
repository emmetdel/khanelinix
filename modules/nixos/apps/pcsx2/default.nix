{ config
, lib
, options
, pkgs
, ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.internal) mkBoolOpt;
  cfg = config.khanelinix.apps.pcsx2;
in
{
  options.khanelinix.apps.pcsx2 = {
    enable = mkBoolOpt false "Whether or not to enable PCSX2.";
  };
  # TODO: remove module

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ pcsx2 ]; };
}
