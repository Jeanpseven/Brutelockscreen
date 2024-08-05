#!/bin/bash

# Solicita ao usuário para inserir o caminho do arquivo com as senhas
read -p "Digite o caminho do arquivo com as senhas: " file_path

# Verifica se o arquivo existe
if [! -f "$file_path" ]; then
    echo "Arquivo não encontrado: $file_path"
    exit 1
fi

# Obtém o tamanho da lista de senhas
tamanho_lista=$(wc -l < "$file_path")
echo "Tamanho da lista: $tamanho_lista"

# Lê as senhas da lista
senhas=()
while IFS= read -r line; do
    senhas+=("$line")
done < "$file_path"

# Processa as senhas
for (( i=0; i<tamanho_lista; i++ )); do
    senha="${senhas[$i]}"
    echo "Tentativa $((i+1)) de $tamanho_lista: $senha"
    
    # Envia a senha para o dispositivo
    for (( j=0; j<${#senha}; j++ )); do
        char="${senha:$j:1}"
        echo "adb shell input text '$char'"
        adb shell input text "$char"
        sleep 0.01 # reduziu o intervalo de sleep para 10ms
    done
    
    echo "adb shell input keyevent 66 # Enter"
    adb shell input keyevent 66
    
    echo "Senha '$senha' enviada com sucesso."
    
    sleep 0.05 # reduziu o intervalo de sleep entre senhas para 50ms
done

echo "Todas as senhas foram enviadas."
