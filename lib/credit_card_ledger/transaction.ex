defmodule CreditCardLedger.Transaction do

  alias CreditCardLedger.Repo
  alias CreditCardLedger.Entity.User
  alias CreditCardLedger.Entity.Transaction
  import Ecto.Query

  def add_transaction(user_id, amount) do

    # carregar todas as transacoes
    with user = %User{} <- Repo.get(User, user_id),
      used_limit <- get_available_limit(user) do

        case used_limit + amount <= user.credit_limit do
          #fazer a transacao
          true -> Transaction.cast(%{amount: amount}, user) |> Repo.insert()
          false -> :error
        end

      end

    # get user from db

    # check credit limit

    # create transaction

    # insert transaction in db

  end

  defp get_available_limit(%{id: user_id}) do
    # retornar todo o limite que tem
    from(t in Transaction, where: t.user_id == ^user_id, select: sum(t.amount))
    |> Repo.all()
    |> IO.inspect()
    |> case do
      [nil] -> 0.0
      [number] -> number
      _ -> 0.0
    end
  end

end
