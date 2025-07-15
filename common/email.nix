{pkgs, ...}: {
  home.packages = with pkgs; [
    isync
    msmtp
    neomutt
    notmuch
  ];

  xdg.configFile = {
    "isync/mbsyncrc".source = ../mbsyncrc;
    "msmtp/config".source = ../msmtp_config;
    "notmuch/notmuchrc".source = ../notmuchrc;

    "mutt" = {
      source = ../mutt;
      recursive = true;
    };
  };
}
