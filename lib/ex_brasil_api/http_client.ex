defmodule ExBrasilApi.HttpClient do
  @moduledoc """
  HTTP client used to requet Brasil API services
  """

  @doc """
  Defines the child spec for the Finch HTTP client
  """
  @spec child_spec(keyword()) :: Supervisor.child_spec()
  def child_spec(opts) do
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

    Finch.child_spec(Keyword.merge([pools: pools], opts))
  end

  @spec get(service :: atom(), url :: String.t(), headers :: Finch.Request.headers()) ::
          {:ok, Finch.Response.t()}
  def get(service, url, headers \\ []) when is_binary(url) do
    :ex_brasil_api
    |> Application.get_env(:http_client)
    |> Keyword.fetch!(:services)
    |> Map.get(service)
    |> Keyword.get(:url)
    |> URI.merge(url)
    |> URI.to_string()
    |> then(&Finch.build(:get, &1, headers))
    |> Finch.request(ExBrasilApi.FinchClient)
  end
end
