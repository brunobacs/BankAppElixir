# primeiro

```bash
mix new --sup credit_card_ledger
```

### leger 
livro de registros de transações
> adiciona registros, mas nunca apaga
> só insere transações, nao apaga


### Principio mais simples possível:
cliente tem um limite específico para conta.
Limite = saldo - transações


============================

## Elixir
- *.exs = como se fosse o npm => como se fosse o package.json do javascript
- exs = elixir script
    - define nome do projeto, versao do elixir..


- elixir usa árvore de processos = ecto model
    - supervisor supervisiona processo ou outros supervisor
    - com BD

```elixir
  def application do
    [
      extra_applications: [:logge, :ecto],
      mod: {CreditCardLedger.Application, []}
    ]
  end
```

Quando coloca o :ecto == faz com que a app suba tambem um supervisor pra essa biblioteca
com 10 conexoes abertas, vai ver a config e sobe 10 processos. Cada processo tem uma conexao aberta com BD.
Supervisor vai saber pra qual processo vai alocar.
ecto = nome da biblioteca de conexao com BD

Ao ter erro, sabe como corrigir = restabelecer conexao e reiniciar processo

Vamos usar supervisor dinamico
    - vai criar mais ou menos processos pra gerenciar


.formatter.exs == pra dar um mix format no codigo pra usar essas config pro código

===============================
### TESTES

```elixir
defmodule CreditCardLedgerTest do
  use ExUnit.Case
  doctest CreditCardLedger

  test "greets the world" do
    assert CreditCardLedger.hello() == :world
  end
end
```

use = é como se fosse heranca do ExUnit.Case. Ele nao é herenca, só puxa uns comportamentos

doctest = permite escrever documentacao e executar codigo da doc pra ver se passa

Pra testar: 

```bash
mix test
```

se mudar var no codigo, precisa mudar na documentacao tambem
Pra quem escreve bibliotecas, vale a pena, nmo nosso cenario nao vamos usar doc no codigo

no arquivo de teste avisa onde esta'a doc
> doctest CreditCardLedger

e no arquivo do .ex, havia a doc explicita que precisaria ser mudada

```elixir
  @doc """
  Hello world.

  ## Examples

      iex> CreditCardLedger.hello()
      :world

  """
```

===================================== 
### Mix run

Quando usa mix run

vai procurar o start que esta na pasta lib/credit_card_ledger/application.ex

start executa e sobe todos os processos e supervisores filhos == cadastrados aqui e inicializa

```elixir
  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: CreditCardLedger.Worker.start_link(arg)
      # {CreditCardLedger.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CreditCardLedger.Supervisor]
    Supervisor.start_link(children, opts)
  end
```

várias estratégias

one for one, one for many...


--sup = ja vem pre-setado no mix new sobre os supervisores



======================================
### Lib
doc do readme para criar biblioteca é gerada a partir do mix new

> ## Installation

> If [available in Hex](https://hex.pm/docs/publish), the package can be installed
> by adding `credit_card_ledger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:credit_card_ledger, "~> 0.1.0"}
  ]
end
```

> Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
> and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
> be found at <https://hexdocs.pm/credit_card_ledger>.


## Dependencias

Repositorio das linguagens Elixir e Erlang
- hex.pm = https://hexdocs.pm/

#### Escolhidas

- {:credo, "~> 1.4"} ==> faz lint, style check pro codigo
- {:plug_cowboy, "~> 2.8"}, == pluga etapas, faz pipeline. De uma req ate executar um codigo. Cowboy = servidor http  em erlang. Essa faz integracao do plug com cowboy
- ecto_sql => como se fosse active records do ruby 
- myxql = modo pra conectar em banco mysql


> mix deps.get  = pra baixar as dependencias 
> mix test pra compilar tudo de novo

Acrescentou em  mix.exs na funcao project, a seguinte chamada de funcao:

```elixir
  def project do
    [
      app: :credit_card_ledger,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases() ## <<<<<----------------------
    ]
  end


  # ............



  defp aliases do
    [
      lint: "credo --strict"
    ]

  end
```
pra chamar mix lin em vez de mix credo, porque em pt-br é estranho
lint é uma config de JS

```bash
mix lint
```

Compila de novo pra versao em DEV
Acontece pra compilar primeira vez pra ambiente de DEV e de TESTE

mix test ==> ambiente de DEV ==> compilacao diferente pra diferentes ambientes

mix run = vai ser mais rapido


elixir == compila pra bytecode da bean == erlang VM, mas consegue interpretar codigo ja compilado aneriormente, só compila o código novo.

===============================
# Parte 3
===============================

### Config
Configuracoes do elixir => pasta config

> config.exs
- sempre começa com import Config


### Comunicacao com banco

repo: CreditCardLedger.Repo ==> criar no lib/nome
  - repo.ex
  
  ```elixir
    defmodule CreditCardLedger.Repo do
      use Ecto.Repo,
        otp_app: :credit_car_ledger,
        adapter: Ecto.Adapters.MyXQL
    end
  ``` 

  Esse repo pra fazer queries no banco

  #### Ecto para migrations

```bash
  mix ecto.gen.migration create_users_table
```

  edita o arquivo criado com as info do banco => create table

  ```elixir
    def change do
      create table(:users, primary_key: false) do
        add :id, :uuid, primary_key: true
        add :fullname, :string, nullable: false
        add :inserted_at, :naive_datetime
      end
    end
  ```
```bash
mix ecto.create
mix ecto.migrate

```


iex -S mix ==> carregar o terminal interativo do elixir e carregar o escopo -S mix da aplicacao
CreditCardLedger.Repo. TAB pra ver os comandos do DB pra fazer

precisa popular as tabelas

> OBS.: em Elixir tudo é imutável ==> pra fazer update no BD precisa fazer um conjunto de mudanças ==> import Ecto.Changeset ==> gera novo objeto da ED pra atualizar

=======================================
# Parte 4
=======================================


