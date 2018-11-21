defmodule FirebaseAdminEx.Request do
  use HTTPoison.Base

  defp base_headers do
    %{"Content-Type" => "application/json"}
  end

  def process_request_body(body) when is_map(body) do
    body
    |> Poison.encode!()
  end

  def process_request_body(body), do: body

  # Override the base headers with any passed in.
  def process_request_headers(request_headers) do
    headers =
      request_headers
      |> Enum.into(%{})

    Map.merge(base_headers(), headers)
    |> Enum.into([])
  end

  # :timeout - timeout to establish a connection, in milliseconds.
  # :recv_timeout - timeout used when receiving a connection.
  def process_request_options(_options) do
    [timeout: 5000, recv_timeout: 2000]
  end
end
