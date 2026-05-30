{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.colorshell;
in
{
  options.services.colorshell = {
    enable = lib.mkEnableOption "colorshell AGS desktop shell";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The colorshell package to use.";
    };

    configDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to colorshell configuration directory (themes, layout overrides).";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.colorshell = {
      Unit = {
        Description = "colorshell AGS desktop shell";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "on-failure";
        RestartSec = "1s";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
