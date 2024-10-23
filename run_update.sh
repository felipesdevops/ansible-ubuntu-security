#!/bin/bash

# Iniciar o ssh-agent
eval "$(ssh-agent -s)"

# Adicionar a chave SSH ao agente (use uma chave genérica ou carregue a chave de forma segura)
ssh-add /path/to/your/ssh-key.key  # Substituir o caminho para um genérico ou usar variáveis de ambiente

# # Caminhos de log
LOG_DIR="/path/to/logs"  # Ajuste o caminho de forma genérica
LOG_OK="$LOG_DIR/update_ok.log"
LOG_ERR="$LOG_DIR/update_erro.log"

sudo mkdir -p "$LOG_DIR"

# Limpar a pasta antes de iniciar a execução
sudo rm -rf "$LOG_DIR"/*

#Certifique-se de que os logs sejam sobrescritos a cada execução
: > $LOG_OK
: > $LOG_ERR

# Comando para rodar o playbook de atualização
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.ini main.yml \
    | tee -a "$LOG_OK" \
    2> >(tee -a "$LOG_ERR" >&2)

# Verificar se o playbook foi executado com sucesso
if [ $? -eq 0 ]; then
    echo "Playbook executado com sucesso. Logs salvos em $LOG_OK"
else
    echo "Erro na execucao do playbook. Verifique os logs em $LOG_ERR"
fi
































# #!/bin/bash

# # # Iniciar o ssh-agent
# eval "$(ssh-agent -s)"

# # # Adicionar a chave SSH ao agente
# ssh-add ~/ansible/ansible.key


# # Definir variáveis para os logs
# LOG_DIR="/var/log/ansible"
# LOG_OK="$LOG_DIR/update_ok.log"
# LOG_ERR="$LOG_DIR/update_err.log"

# # Certifique-se de que o diretório de logs existe
# mkdir -p $LOG_DIR

# # Executar o playbook Ansible e registrar os logs
# ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ~/ansible/att-update/hosts.ini ~/ansible/att-update/update.yml > $LOG_OK 2> >(tee $LOG_ERR >&2)










# #!/bin/bash

# # Iniciar o ssh-agent
# eval "$(ssh-agent -s)"

# # Adicionar a chave SSH ao agente
# ssh-add ~/ansible/ansible.key

# # Definir caminhos dos logs
# LOG_OK="/var/log/ansible/update_ok.log"
# LOG_ERR="/var/log/ansible/update_erro.log"

# # Executar o playbook e redirecionar a saída para os logs apropriados
# ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ~/ansible/att-update/hosts.ini /ansible/att-update/update_security.yml > >(tee -a $LOG_OK) 2> >(tee -a $LOG_ERR >&2)
