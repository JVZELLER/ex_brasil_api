defmodule ExBrasilApi.HttpClient do
  @moduledoc """
  HTTP client used to requet Brasil API services
  """

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
