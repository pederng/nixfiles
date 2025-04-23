_: {
  home.sessionVariables = {
    LD_LIBRARY_PATH = "";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
  };
  xdg = {
    userDirs = {
      enable = true;
      desktop = "$HOME";
      documents = "$HOME/docs";
      download = "$HOME/docs/dl";
      music = "$HOME/docs";
      pictures = "$HOME/docs";
      videos = "$HOME/docs";
      templates = "$HOME/docs";
      publicShare = "$HOME/docs";
    };
    mimeApps = {
      enable = true;
      associations.added = {"binary/octet-stream" = "gvim/desktop";};
      defaultApplications = {
        "application/pdf" = "zathura.desktop";
        "application/x-extension-html" = "org.qutebrowser.qutebrowser.desktop";
        "image/png" = "sxiv.desktop";
        "text/html" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
      };
    };
  };

}
