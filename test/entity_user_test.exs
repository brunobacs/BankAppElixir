defmodule CreditCardLedger.Entity.UserTest do
  use ExUnit.Case

  alias CreditCardLedger.Repo
  alias CreditCardLedger.Entity.User


  setup do
    # Faz o checkout da conexão para o processo do teste
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "save a user in the database" do
    params = %{
      fullname: "Some Body"
    }

    changeset = User.changeset(%User{}, params)
    # 2. Insere (usamos _user com underscore pois não vamos ler essa variável agora)
    {:ok, _user} = Repo.insert(changeset)

    users = Repo.all(User)

    # pattern match dizendo que é uma lista de uma estrturua de dados chamada user
    assert [%User{fullname: "Some Body"}] = users

  end
end
