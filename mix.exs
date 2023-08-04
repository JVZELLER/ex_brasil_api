defmodule ExBrasilApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_brasil_api,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExBrasilApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.16"},
      # Tests
      {:bypass, "~> 2.1", only: :test}
    ]
  end
end
