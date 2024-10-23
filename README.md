### Documentação: Atualização de Segurança para Servidores Ubuntu

Este guia descreve como utilizar o playbook Ansible para realizar atualizações de segurança em servidores Ubuntu. Ele aborda os ajustes necessários antes de iniciar a execução e como rodar o script de atualização. A documentação é destinada para quem for usar esse projeto, explicando cada etapa em detalhes.

---

### 1. **Configurações Iniciais**

#### 1.1. Ajustar o Arquivo `hosts.ini`

O arquivo `hosts.ini` contém as informações dos servidores onde o Ansible deve rodar. **Não publique credenciais confidenciais** neste arquivo. Antes de usar, faça os seguintes ajustes:

1. **Substitua os endereços IP e usuários pelos valores adequados ao seu ambiente**.
   - No arquivo, você verá placeholders como `{{ server1_ip }}` e `{{ ansible_user }}`. Substitua esses valores por variáveis reais ou defina-os em um arquivo de variáveis.

2. **Exemplo de Arquivo `hosts.ini`** ajustado:

   ```ini
   [servers]
   server1 ansible_host={{ server1_ip }} ansible_user={{ ansible_user }} ansible_python_interpreter=/usr/bin/python3
   ```

   Onde:
   - `server1_ip`: Deve ser o IP real do seu servidor.
   - `ansible_user`: O nome de usuário com permissões de sudo para o servidor.

3. **Crie o arquivo de variáveis** (`vars.yml`):

   Para definir os valores reais das variáveis de forma separada:

   ```yaml
   server1_ip: "SEU_IP_AQUI"
   ansible_user: "SEU_USUARIO_AQUI"
   ```

#### 1.2. Ajustar o Script `.sh`

O script `.sh` é responsável por executar o playbook e gerar logs. Antes de executá-lo, ajuste:

1. **Chave SSH**: Verifique que o caminho para sua chave SSH está correto. No script, a linha que adiciona a chave SSH pode ser ajustada da seguinte forma:

   ```bash
   ssh-add /path/to/your/ssh-key.key  # Ajustar o caminho para sua chave SSH
   ```

2. **Caminho dos Logs**: Defina o caminho onde os logs serão salvos. O script utiliza a variável `LOG_DIR` para armazenar logs de execução e erros:

   ```bash
   LOG_DIR="/path/to/logs"
   ```

   Ajuste esse caminho conforme necessário no seu ambiente.

3. **Limpeza de Logs**: O script limpa o diretório de logs antes de cada execução. Se você deseja manter logs antigos, remova ou comente esta linha:

   ```bash
   sudo rm -rf "$LOG_DIR"/*
   ```

#### 1.3. Preparar a Execução

1. **Defina as variáveis no arquivo `vars.yml`** conforme o exemplo fornecido.
2. **Configure o acesso SSH** aos servidores corretamente, garantindo que as chaves SSH estão carregadas no agente.

---

### 2. **Execução do Script**

Após ajustar o `hosts.ini` e o script `.sh`, siga os passos abaixo para rodar a atualização de segurança:

1. **Permissões de Execução**: Certifique-se de que o script `.sh` tem permissões de execução:

   ```bash
   chmod +x run_playbook.sh
   ```

2. **Executar o Script**:

   Execute o script diretamente para iniciar o processo de atualização:

   ```bash
   ./run_playbook.sh
   ```

   O script fará o seguinte:
   - Iniciará o `ssh-agent` e adicionará a chave SSH ao agente.
   - Executará o playbook Ansible para atualizar os pacotes de segurança nos servidores Ubuntu listados no arquivo `hosts.ini`.
   - Gerará logs de execução e erros no diretório configurado.

3. **Verificar Logs**:

   Após a execução, os logs de sucesso e erro serão armazenados no diretório definido em `LOG_DIR`. Verifique esses logs para garantir que o playbook foi executado corretamente e que as atualizações de segurança foram aplicadas.

---

### 3. **Comandos Úteis**

- **Executar o Playbook com Variáveis Externas**: Se as variáveis estão definidas em um arquivo separado (ex.: `vars.yml`), rode o playbook da seguinte forma:

  ```bash
  ansible-playbook -i hosts.ini main.yml --extra-vars "@vars.yml"
  ```

- **Verificar Logs**: Após a execução, os logs estarão localizados no diretório definido. Exemplo de comandos para verificar os logs:

  ```bash
  cat /path/to/logs/update_ok.log  # Logs de execução bem-sucedida
  cat /path/to/logs/update_erro.log  # Logs de erros
  ```

---

### 4. **Conclusão**

Este projeto facilita a atualização de pacotes de segurança em servidores Ubuntu usando Ansible. Ajuste os arquivos conforme o ambiente de destino, e utilize o script `.sh` para automatizar o processo de atualização e geração de logs.

---