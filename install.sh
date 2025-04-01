#!/bin/bash

# Verifica se o usuário é root
if [[ $(id -u) != "0" ]]; then
    echo "Erro: Execute este script como root."
    exit 1
fi

# Solicita o nome do tema
read -p "Digite o nome do tema: " contra

# Define o diretório do tema no GRUB
THEME_DIR="/boot/grub/themes/$THEME_NAME"

# Pergunta de onde copiar os arquivos
read -p "Digite o caminho da pasta onde estão os arquivos do tema (ou pressione Enter para usar a pasta atual): " SOURCE_DIR

# Se não for especificado, usa a pasta onde o script está rodando
if [[ -z "$SOURCE_DIR" ]]; then
    SOURCE_DIR="$(pwd)"
fi

# Cria o diretório do tema
mkdir -p "$THEME_DIR"

# Copia os arquivos para o diretório do GRUB
echo "Copiando arquivos do tema..."
cp -r "$SOURCE_DIR"/* "$THEME_DIR/"

# Configura o GRUB para usar o novo tema
echo "Configurando o GRUB..."
sed -i 's|.*GRUB_THEME=.*||' /etc/default/grub
echo "GRUB_THEME=$THEME_DIR/theme.txt" >> /etc/default/grub

# Atualiza o GRUB
echo "Atualizando o GRUB..."
update-grub || grub-mkconfig -o /boot/grub/grub.cfg

# Instala o Grub Customizer
echo "Instalando o Grub Customizer..."
apt update && apt install -y grub-customizer

# Executa o Grub Customizer
#echo "Abrindo o Grub Customizer..."
#grub-customizer
