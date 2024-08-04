#!/bin/bash

# Função para converter caracteres em comandos keyevent
convert_char_to_keyevent() {
    local char="$1"
    case "$char" in
        [a-z]) echo "keyevent $(( $(printf '%d' "'$char") - 97 + 29 ))" ;; # a-z
        [A-Z]) echo "keyevent $(( $(printf '%d' "'$char") - 65 + 29 ))" ;; # A-Z
        [0-9]) echo "keyevent $(( $(printf '%d' "'$char") - 48 + 7 ))" ;; # 0-9
        ' ') echo "keyevent 62" ;; # Espaço
        *) echo "keyevent for special character $char not defined" ;; # Caracteres especiais não definidos
    esac
}

# Solicita ao usuário para inserir o caminho do arquivo com as senhas
read -p "Digite o caminho do arquivo com as senhas: " file_path

# Verifica se o arquivo existe
if [ ! -f "$file_path" ]; then
    echo "Arquivo não encontrado: $file_path"
    exit 1
fi

# Verifica se há um dispositivo conectado
if adb get-state 1>/dev/null 2>&1; then
    echo "Enviando senhas para o dispositivo..."
    
    # Lê o arquivo linha por linha
    while IFS= read -r password || [ -n "$password" ]; do
        # Remove espaços em branco no início e no final da senha
        password=$(echo "$password" | xargs)
        
        # Se a senha não estiver vazia
        if [ -n "$password" ]; then
            echo "Processando senha: $password"
            
            # Itera sobre cada caractere da senha
            for (( i=0; i<${#password}; i++ )); do
                # Extrai o caractere atual
                char="${password:$i:1}"
                
                # Converte o caractere para o comando keyevent correspondente
                keyevent_cmd=$(convert_char_to_keyevent "$char")
                if [[ "$keyevent_cmd" =~ ^keyevent ]]; then
                    echo "adb shell input $keyevent_cmd"
                    adb shell input $keyevent_cmd
                else
                    echo "$keyevent_cmd"
                fi
                
                # Adiciona um pequeno atraso entre os caracteres
                sleep 0.1
            done
            
            # Adiciona o comando "Enter" após a senha
            echo "adb shell input keyevent 66 # Enter"
            adb shell input keyevent 66
            
            echo "Senha '$password' enviada com sucesso."
            
            # Adiciona um pequeno atraso antes de passar para a próxima senha
            sleep 1
        fi
    done < "$file_path"
    
    echo "Todas as senhas foram enviadas."
else
    echo "Nenhum dispositivo encontrado. Conecte um dispositivo e tente novamente."
fi
