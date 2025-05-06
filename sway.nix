{lib, pkgs, ...}: {
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.waylock}/bin/waylock"; }
    ];
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";
      output = {
        "Dell Inc. DELL U2715H GH85D64103KS" = {
          pos = "0 0";
        };
        "Dell Inc. DELL U2715H GH85D6410FGS" = {
          pos = "2560 0";
          transform = "270";
        };
      };

      workspaceOutputAssign = [
        { output = "Dell Inc. DELL U2715H GH85D64103KS"; workspace = "1"; }
        { output = "Dell Inc. DELL U2715H GH85D64103KS"; workspace = "2"; }
        { output = "Dell Inc. DELL U2715H GH85D64103KS"; workspace = "3"; }
        { output = "Dell Inc. DELL U2715H GH85D64103KS"; workspace = "4"; }
        { output = "Dell Inc. DELL U2715H GH85D64103KS"; workspace = "5"; }
        { output = "Dell Inc. DELL U2715H GH85D64103KS"; workspace = "6"; }
        { output = "Dell Inc. DELL U2715H GH85D6410FGS"; workspace = "9"; }
        { output = "Dell Inc. DELL U2715H GH85D6410FGS"; workspace = "10"; }
      ];

      bars = [
        {
          position = "top";
          statusCommand = "while date +'%Y-%m-%d %H:%M'; do sleep 1; done";
          colors = {
            statusline = "#ffffff";
            background = "#323232";
            inactiveWorkspace = {
              background = "#32323200";
              border = "#32323200";
              text = "#5c5c5c";
            };
          };
        }
      ];

      floating.criteria = [
        { app_id = "fzfmenu"; }
        { class = "Pavucontrol"; }
      ];

      window.titlebar = false;

      seat = {
        "*" = {
          hide_cursor = "3000";
        };
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+Shift+c" = "kill";
        "${modifier}+Shift+r" = "reload";
        "${modifier}+Shift+s" = "exec waylock";
        "${modifier}+p" = "exec fzflaunch";
        # this seems hacky
        "--locked XF86AudioMicMute" = "exec sp";  # HHKB eject key
        "--locked XF86AudioPlay" = "exec sp";
        "--locked XF86AudioMute"  = "exec wpctl set-mute \@DEFAULT_SINK@ toggle";
        "--locked XF86AudioLowerVolume" = "exec pactl set-sink-volume \@DEFAULT_SINK@ 5%-";
        "--locked XF86AudioRaiseVolume" = "exec pactl set-sink-volume \@DEFAULT_SINK@ 5%+";
      };

      input = {
        "1267:12753:VEN_04F3:00_04F3:31D1_Touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          middle_emulation = "enabled";
        };
        "type:keyboard" =  {
         xkb_layout  = "us";
         xkb_variant  = "altgr-intl";
         xkb_options = "ctrl:nocaps";
        };
      };
    };
  };
}
