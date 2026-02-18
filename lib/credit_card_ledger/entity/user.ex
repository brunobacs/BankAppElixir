defmodule CreditCardLedger.Entity.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :fullname, :string
    field :credit_limit, :float
    field :inserted_at, :naive_datetime
  end

  # def changeset(struct, params) do
  #   struct
  #   |> cast(params, [:fullname]) # Filtra e permite apenas o campo :fullname
  #   |> validate_required([:fullname, :credit_limit]) # Garante que o nome não seja nulo
  # end

  # outra forma de fazer o changeset
  def cast(params) do
    now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    %__MODULE__{inserted_at: now}
    |> cast(params, [:fullname]) # vai verificar se é string
    |> validate_required([:fullname, :credit_limit]) # nao pode ser nula, tem que testar aqui
    |> apply_changes()
  end

end
