defmodule CreditCardLedger.Entity.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :fullname, :string
    field :inserted_at, :naive_datetime
  end

  # @spec cast(any)::nil
  # def cast(_params) do
  # end

  def changeset(struct, params) do
    struct
    |> cast(params, [:fullname]) # Filtra e permite apenas o campo :fullname
    |> validate_required([:fullname]) # Garante que o nome não seja nulo
  end

end
