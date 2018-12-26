defmodule FirebaseAdminEx.Request do
  @default_headers %{"Content-Type" => "application/json"}
  @default_options Application.get_env(:firebase_admin_ex, :default_options)

  def request(method, url, data, headers \\ %{}) do
    method
    |> HTTPoison.request(
      url,
      process_request_body(data),
      process_request_headers(headers),
      @default_options
    )
  end

  # Override the base headers with any passed in.
  def process_request_headers(headers) when is_map(headers) do
    Map.merge(@default_headers, headers)
    |> Enum.into([])
  end

  def process_request_headers(_), do: @default_headers

  defp process_request_body(body) when is_map(body) do
    Jason.encode!(body)
  end

  defp process_request_body(body), do: body
end
