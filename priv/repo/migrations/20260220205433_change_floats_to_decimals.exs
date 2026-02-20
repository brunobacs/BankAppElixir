defmodule CreditCardLedger.Repo.Migrations.ChangeFloatsToDecimals do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :credit_limit, :decimal, precision: 15, scale: 2
    end

    alter table(:transactions) do
      modify :amount, :decimal, precision: 15, scale: 2
    end
  end
end
