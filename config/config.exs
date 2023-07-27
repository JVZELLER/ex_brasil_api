import Config

config :ex_brasil_api, :http_client,
  services: %{
    cep_v1: [url: "https://brasilapi.com.br/api/cep/v1/"],
    cep_v2: [url: "https://brasilapi.com.br/api/cep/v2/"]
  }
