defmodule FirebaseAdminEx.Response do
  def parse(%HTTPoison.Response{} = response) do
    case response do
      %HTTPoison.Response{status_code: 200, body: body} ->
        {:ok, body}

      %HTTPoison.Response{status_code: status_code, body: body} ->
        error_message = Jason.decode!(body) |> Map.get("error", %{}) |> Map.get("message")
        {:error, "#{status_code} - #{error_message}"}
    end
  end

  def parse(_response) do
    {:error, "Invalid response"}
  end
end
