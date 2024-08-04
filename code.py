#!/bin/bash

# Solicita ao usuário para inserir a lista de códigos de tecla, separados por espaços
read -p "Digite os códigos de keyevent separados por espaços: " -a keyevent_list

# Verifica se há um dispositivo conectado
if adb get-state 1>/dev/null 2>&1; then
    echo "Enviando keyevents para o dispositivo..."
    # Itera sobre a lista e executa o comando adb para cada código
    for key in "${keyevent_list[@]}"; do
        echo "Enviando keyevent $key..."
        adb shell input keyevent "$key"
        sleep 1  # Adiciona um pequeno atraso entre os comandos, se necessário
    done
else
    echo "Nenhum dispositivo encontrado. Conecte um dispositivo e tente novamente."
fi
