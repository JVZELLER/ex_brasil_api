defmodule ExBrasilApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    pools =
      :ex_brasil_api
      |> Application.get_env(:http_client)
      |> Keyword.fetch!(:services)
      |> Map.new(fn {service, opts} ->
        url = Keyword.get(opts, :url)
        opts = Keyword.get(opts, :pool_opts, [])

        if is_nil(url) do
          raise ArgumentError, "missing :url option for service #{service}"
        end

        {url, opts}
      end)

    children = [
      {Finch, name: ExBrasilApi.FinchClient, pools: pools}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExBrasilApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
