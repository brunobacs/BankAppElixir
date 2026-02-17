defmodule CreditCardLedger.MixProject do
  use Mix.Project

  def project do
    [
      app: :credit_card_ledger,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CreditCardLedger.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7"},
      {:plug_cowboy, "~> 2.8"},
      {:ecto_sql, "~> 3.13"},
      {:jason, "~> 1.5.0-alpha.2"},
      {:myxql, "~> 0.8" }

    ]
  end
  defp aliases do
    [
      lint: "credo --strict"
    ]

  end


end
