import subprocess
import time

# Função para converter caracteres em comandos keyevent
def convert_char_to_keyevent(char):
    if char.islower():
        return f"keyevent {ord(char) - ord('a') + 29}"
    elif char.isupper():
        return f"keyevent {ord(char) - ord('A') + 29}"
    elif char.isdigit():
        return f"keyevent {ord(char) - ord('0') + 7}"
    elif char == ' ':
        return "keyevent 62"
    else:
        print(f"keyevent for special character '{char}' not defined")
        return None

# Solicita o caminho do arquivo com as senhas
file_path = input("Digite o caminho do arquivo com as senhas: ")

# Verifica se o arquivo existe
try:
    with open(file_path, 'r') as file:
        passwords = file.readlines()
except FileNotFoundError:
    print(f"Arquivo não encontrado: {file_path}")
    exit(1)

# Verifica se há um dispositivo conectado
try:
    subprocess.run(['adb', 'get-state'], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
except subprocess.CalledProcessError:
    print("Nenhum dispositivo encontrado. Conecte um dispositivo e tente novamente.")
    exit(1)

print("Enviando senhas para o dispositivo...")

# Processa cada senha do arquivo
for password in passwords:
    password = password.strip()  # Remove espaços em branco no início e no final
    if not password:
        continue

    print(f"Processando senha: {password}")

    # Envia cada caractere da senha como um comando keyevent
    for char in password:
        keyevent_cmd = convert_char_to_keyevent(char)
        if keyevent_cmd:
            print(f"adb shell input {keyevent_cmd}")
            subprocess.run(['adb', 'shell', 'input', keyevent_cmd], check=True)
        time.sleep(0.1)  # Atraso entre os caracteres

    # Envia o comando "Enter" após a senha
    print("adb shell input keyevent 66 # Enter")
    subprocess.run(['adb', 'shell', 'input', 'keyevent', '66'], check=True)
    
    print(f"Senha '{password}' enviada com sucesso.")
    time.sleep(1)  # Atraso antes de passar para a próxima senha

print("Todas as senhas foram enviadas.")
