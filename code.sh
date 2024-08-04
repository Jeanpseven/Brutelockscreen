#!/bin/bash

# Solicita ao usuário para inserir a lista de senhas separadas por espaço
read -p "Digite a lista de senhas separadas por espaço: " -a password_list

# Itera sobre cada senha na lista
for password in "${password_list[@]}"; do
    echo "Processando senha: $password"
    
    # Itera sobre cada caractere da senha
    for (( i=0; i<${#password}; i++ )); do
        # Extrai o caractere atual
        char="${password:$i:1}"
        
        # Converte o caractere para o comando adb correspondente
        if [[ "$char" =~ [a-zA-Z0-9] ]]; then
            echo "adb shell input text \"$char\""
        elif [[ "$char" == " " ]]; then
            echo "adb shell input keyevent 62 # Espaço"
        else
            # Para caracteres especiais, você pode adicionar casos específicos aqui
            echo "Caractere especial: $char. Adicione mapeamento específico para este caractere."
        fi
    done
    
    # Adiciona o comando "Enter" após a senha
    echo "adb shell input keyevent 66 # Enter"
    
    echo "---------"
done
