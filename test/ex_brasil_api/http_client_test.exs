defmodule ExBrasilApi.HttpClientTest do
  use ExUnit.Case, async: true

  alias ExBrasilApi.HttpClient

  setup do
    bypass = Bypass.open()

    Application.put_env(:ex_brasil_api, :http_client,
      services: %{foo: [url: "http://127.0.0.1:#{bypass.port}/"]}
    )

    {:ok, bypass: bypass}
  end

  describe "get/3" do
    test "should perform GET request successfully", %{bypass: bypass} do
      service_url = "/api/v1/cep/123"

      Bypass.expect(bypass, "GET", service_url, fn conn ->
        Plug.Conn.resp(conn, 200, "")
      end)

      {:ok, %Finch.Response{status: 200, body: ""}} = HttpClient.get(:foo, service_url)
    end

    test "should request with custom headers custom headers", %{bypass: bypass} do
      service_url = "/api/v1/cep/123"
      custom_header = {"x-request-id", "my-request-id"}

      Bypass.expect(bypass, "GET", service_url, fn conn ->
        assert [elem(custom_header, 1)] == Plug.Conn.get_req_header(conn, elem(custom_header, 0))

        Plug.Conn.resp(conn, 200, "")
      end)

      {:ok, %Finch.Response{status: 200, body: ""}} =
        HttpClient.get(:foo, service_url, [custom_header])
    end

    test "should return errors when external service returns errors", %{bypass: bypass} do
      service_url = "/api/v1/cep/123"
      expected_body = ~s<{"errors": [{"code": 88, "message": "Rate limit exceeded"}]}>

      Bypass.expect(bypass, "GET", service_url, fn conn ->
        Plug.Conn.resp(conn, 429, expected_body)
      end)

      {:ok, %Finch.Response{status: 429, body: ^expected_body}} =
        HttpClient.get(:foo, service_url)
    end
  end
end
