{ config, lib, pkgs, ... }:

let 
  cfg = config.apps.todo-cli;
  
  todoCommand = pkgs.writeShellScriptBin "todo" ''
    #!/bin/bash
    
    TOKEN_FILE="$HOME/dotfiles/secrets/todoist.token"
          if [ ! -f "$TOKEN_FILE" ]; then
            echo "➤ Missing Token File"
            exit 0
          fi
          
    FALLBACK_TOKEN=$(cat "$TOKEN_FILE" | ${pkgs.coreutils}/bin/tr -d '[:space:]')
    todo() {
        local TOKEN="''${TODOIST_TOKEN:-$FALLBACK_TOKEN}"
        local URL="https://api.todoist.com/api/v1/sync"
    
        if [ -z "$TOKEN" ] || [[ "$TOKEN" == *"****"* ]]; then
            echo "Error: Token missing. Set FALLBACK_TOKEN in the script."
            return 1
        fi
    
        generate_uuid() {
            if command -v uuidgen &> /dev/null; then uuidgen; else cat /proc/sys/kernel/random/uuid; fi
        }
    
        refresh_conky() {
            systemctl --user restart conky-session > /dev/null 2>&1
        }
    
        if [ "$#" -gt 0 ] && [ "$1" != "-t" ]; then
            local content="$1"
            local due_string="$2"
            local uuid=$(generate_uuid)
            local temp_id=$(generate_uuid)
            local args_json
    
            if [ -n "$due_string" ]; then
                args_json=$(printf '{"content": "%s", "due": {"string": "%s"}}' "$content" "$due_string")
            else
                args_json=$(printf '{"content": "%s"}' "$content")
            fi
    
            local payload
            payload=$(printf '{"commands": [{"type": "item_add", "temp_id": "%s", "uuid": "%s", "args": %s}]}' \
                "$temp_id" "$uuid" "$args_json")
    
            echo "Creating task: $content..."
            local response
            response=$(${pkgs.curl}/bin/curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "$payload" "$URL")
    
            if echo "$response" | grep -q '"ok"'; then
                echo -e "\033[1;32m✔ Task added successfully!\033[0m"
                refresh_conky
            else
                echo -e "\033[1;31m✘ Error:\033[0m"
                echo "$response"
            fi
            return 0
        fi
    
        local payload='{"sync_token": "*", "resource_types": ["items"]}'
        local response
        response=$(${pkgs.curl}/bin/curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "$payload" "$URL")
    
        if ! echo "$response" | ${pkgs.jq}/bin/jq . >/dev/null 2>&1; then
            echo "API Error."
            return 1
        fi
    
        local raw_output
        raw_output=$(echo "$response" | ${pkgs.jq}/bin/jq -r '
            .items 
            | sort_by(.due.date // "2099-12-31") 
            | .[] 
            | select(.checked == false and .is_deleted == false) 
            | "\(.id)|\(if .parent_id then "   ↳ " else "" end)\(.content)|\(.due.date // "No Date")"
        ')
    
        if [ -z "$raw_output" ]; then
            if [ -t 1 ]; then echo "No tasks found."; fi
            return 0
        fi
    
        if [ -t 1 ]; then
            echo "----------------------------------------"
            echo "  TODO LIST (ALL)"
            echo "----------------------------------------"
        fi
    
        declare -a task_ids
        local count=1
    
        while IFS='|' read -r id content due; do
            task_ids[$count]=$id
            
            if [ -t 1 ]; then
                printf "\033[1;36m[%d]\033[0m %-30s \033[0;33m(%s)\033[0m\n" "$count" "$content" "$due"
            else
                echo "> $content"
            fi
            
            ((count++))
        done <<< "$raw_output"
    
        if [ -t 1 ]; then
            echo "----------------------------------------"
        fi
        
        if [[ -t 1 ]]; then
            echo -n "Select # to complete (or Enter to exit): "
            read -r selection
    
            if [ -z "$selection" ]; then return 0; fi
    
            if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -lt "$count" ] && [ "$selection" -gt 0 ]; then
                local target_id="''${task_ids[$selection]}"
                local uuid=$(generate_uuid)
                
                local close_payload
                close_payload=$(printf '{"commands": [{"type": "item_close", "uuid": "%s", "args": {"id": "%s"}}]}' "$uuid" "$target_id")
    
                echo "Completing task..."
                local close_response
                close_response=$(${pkgs.curl}/bin/curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" -d "$close_payload" "$URL")
    
                if echo "$close_response" | grep -q '"ok"'; then
                    echo -e "\033[1;32m✔ Done!\033[0m"
                    refresh_conky
                else
                    echo -e "\033[1;31m✘ Error:\033[0m"
                fi
            else
                echo "Invalid selection."
            fi
        fi
    }
    
    if [[ "''${BASH_SOURCE[0]}" == "''${0}" ]]; then
        todo "$@"
    fi
  '';

in {
  options.apps.todo-cli = {
    enable = lib.mkEnableOption "Todo list cli i made";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ 
      todoCommand 
      pkgs.util-linux 
    ];
  };
}