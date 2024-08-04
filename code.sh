#!/bin/bash

# Solicita ao usuário para inserir a lista de senhas separadas por espaço
read -p "Digite a lista de senhas separadas por espaço: " -a password_list

# Verifica se há um dispositivo conectado
if adb get-state 1>/dev/null 2>&1; then
    echo "Enviando senhas para o dispositivo..."
    
    # Itera sobre cada senha na lista
    for password in "${password_list[@]}"; do
        echo "Processando senha: $password"
        
        # Itera sobre cada caractere da senha
        for (( i=0; i<${#password}; i++ )); do
            # Extrai o caractere atual
            char="${password:$i:1}"
            
            # Envia o comando para digitar o caractere
            adb shell input text "$char"
            echo "Enviado: $char"
            
            # Adiciona um pequeno atraso entre os caracteres, se necessário
            sleep 0.1
        done
        
        # Envia o comando keyevent para "Enter"
        adb shell input keyevent 66
        echo "Enviado keyevent 66 (Enter)"
        
        # Adiciona um pequeno atraso antes de passar para a próxima senha
        sleep 1
    done
else
    echo "Nenhum dispositivo encontrado. Conecte um dispositivo e tente novamente."
fi
