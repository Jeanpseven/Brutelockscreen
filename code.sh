#!/bin/bash

# Solicita ao usuário para inserir a senha alfanumérica
read -p "Digite a senha alfanumérica: " password

# Verifica se há um dispositivo conectado
if adb get-state 1>/dev/null 2>&1; then
    echo "Enviando caracteres da senha para o dispositivo..."
    
    # Itera sobre cada caractere da senha
    for (( i=0; i<${#password}; i++ )); do
        # Extrai o caractere atual
        char="${password:$i:1}"
        
        # Envia o comando para digitar o caractere
        adb shell input text "$char"
        echo "Enviado: $char"
        
        # Envia o comando keyevent para "Enter"
        adb shell input keyevent 66
        echo "Enviado keyevent 66 (Enter)"
        
        sleep 1  # Adiciona um pequeno atraso entre os comandos, se necessário
    done
else
    echo "Nenhum dispositivo encontrado. Conecte um dispositivo e tente novamente."
fi
