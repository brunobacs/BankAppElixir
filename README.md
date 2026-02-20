# CreditCardLedger
Este é um sistema de gerenciamento de transações de cartão de crédito focado em consistência e concorrência, utilizando a BEAM (Erlang VM) para garantir que cada conta processe transações de forma sequencial através de processos isolados. 

## 🛠 Arquitetura e Fluxo de Dados
O projeto utiliza um padrão de Sistemas Distribuídos dentro da própria VM do Elixir para evitar condições de corrida (race conditions) no limite de crédito: 

- Interface HTTP: Recebe requisições via Plug.Cowboy.
- SafeTransaction (DynamicSupervisor): Gerencia o ciclo de vida dos Workers de conta. Ele garante que cada usuário tenha apenas um processo ativo por vez.
- AccountWorker (GenServer): Um processo dedicado por user_id que enfileira as transações, garantindo que o limite seja verificado e debitado de forma atômica para aquele usuário.
- Camada de Persistência: Utiliza Ecto com MariaDB para armazenar usuários e transações.


## 🚀 Como Executar
**Pré-requisitos**
- Elixir 1.19+ 
- Docker e Docker Compose

1- Subir o Banco de Dados:

```bash
docker-compose up -d
```

2- Instalar Dependências:
```bash
mix deps.get
```

3- Configurar o Banco:
```bash
mix ecto.setup  # (Caso tenha o alias configurado) ou mix ecto.create && mix ecto.migrate
```

4- Iniciar o Terminal Interativo (IEx):
```bash
iex -S mix
```

