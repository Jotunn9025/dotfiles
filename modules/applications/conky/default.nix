{ config, lib, pkgs, ... }:

let 
  cfg = config.apps.conky;
  
  themeColor = "b5b3ff";
  
  baseConfig = ''
    update_interval = 1,
    double_buffer = true,
    no_buffers = true,
    text_buffer_size = 2048,
    
    own_window = true,
    own_window_type = 'desktop',   
    own_window_transparent = false, 
    own_window_argb_visual = true,
    own_window_argb_value = 0,
    own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
    
    draw_borders = true,
    border_width = 2,
    border_inner_margin = 15,
    draw_graph_borders = true,
    draw_shades = false,
    use_xft = true,
    font = 'sans-serif:size=11',
    default_color = '${themeColor}',
    default_outline_color = '${themeColor}',
    color1 = '${themeColor}',
  '';
in {
  options.apps.conky = {
    enable = lib.mkEnableOption "Conky widgets";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      conky
      curl
      jq
      gnused
    ];

    home-manager.users.youhan = {
      # 1. battery.sh
      xdg.configFile."conky/battery.sh" = {
        executable = true;
        text = ''
          #!/bin/sh
          
          INFO=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 2>/dev/null)
          STATE=$(echo "$INFO" | grep "state:" | awk '{print $2}')
          
          if [ "$STATE" = "discharging" ]; then
            PERCENT=$(echo "$INFO" | grep "percentage:" | awk '{print $2}' | tr -d '%')
            TIME=$(echo "$INFO" | grep "time to empty:" | awk '{print $4, $5}')
            
            echo "\''${voffset 5}BATTERY \''${alignr}$PERCENT% ($TIME)"
            echo "\''${execbar echo $PERCENT}"
          fi
        '';
      };

      # 2. clock date
      xdg.configFile."conky/clock.conf".text = ''
        conky.config = {
          ${baseConfig}
          alignment = 'top_right',
          gap_x = 30,
          gap_y = 60,
        }
        conky.text = [[
        ''${alignc}''${font sans-serif:bold:size=48}''${time %H:%M}''${font}
        ''${voffset 5}''${alignc}''${font sans-serif:size=16}''${time %A, %d %B}''${font}
        ]]
      '';

      # 3. bototm right system resources
      xdg.configFile."conky/system.conf".text = ''
        conky.config = {
          ${baseConfig}
          alignment = 'bottom_right',
          gap_x = 30,
          gap_y = 60,
          minimum_width = 300,
        }
        conky.text = [[
        ''${font sans-serif:bold:size=12}SYSTEM ''${hr 2}''${font}
        ''${voffset 5}CPU ''${alignr}''${cpu cpu0}%
        ''${cpubar 6}
        ''${voffset 5}RAM ''${alignr}''${mem} / ''${memmax} (''${memperc}%)
        ''${membar 6}
        ''${voffset 5}DISK ''${alignr}''${fs_used /} / ''${fs_size /} (''${fs_used_perc /}%)
        ''${fs_bar 6 /}
        ''${execpi 5 ~/.config/conky/battery.sh}
        ]]
      '';

      # 4. bottom left todoist
      xdg.configFile."conky/tasks.conf".text = ''
        conky.config = {
          ${baseConfig}
          alignment = 'bottom_left',
          gap_x = 30,
          gap_y = 60,
          minimum_width = 350,
        }
        conky.text = [[
        ''${font sans-serif:bold:size=12}TASKS ''${hr 2}''${font}
        ''${voffset 5}''${execi 60 ${pkgs.bash}/bin/bash -c "todo"}
        ]]
      '';

      systemd.user.services.conky-session = {
        Unit = {
          Description = "Conky Widget Session";
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "forking";
          ExecStart = ''${pkgs.writeShellScript "start-conky" ''
            sleep 5
            ${pkgs.conky}/bin/conky -c ~/.config/conky/clock.conf -d
            ${pkgs.conky}/bin/conky -c ~/.config/conky/system.conf -d
            ${pkgs.conky}/bin/conky -c ~/.config/conky/tasks.conf -d
          ''}'';
          ExecStop = "${pkgs.coreutils}/bin/killall conky";
          Restart = "on-failure";
        };
      };
    };
  };
}