defmodule FirebaseAdminEx.Messaging do
  alias FirebaseAdminEx.{Request, Response, Errors}
  alias FirebaseAdminEx.Messaging.Message

  @fcm_endpoint "https://fcm.googleapis.com/v1"

  # Public API

  @doc """
  The send/2 function make an API call to the
  firebase messaging `send` endpoint with the auth token
  and message attributes.
  """
  @spec send(String.t(), String.t(), struct()) :: tuple()
  def send(project_id, oauth_token, %Message{} = message) do
    with {:ok, message} <- Message.validate(message),
         {:ok, response} <-
           Request.post(send_url(project_id), %{message: message}, auth_header(oauth_token)),
         {:ok, body} <- Response.parse(response) do
      {:ok, body}
    else
      {:error, error} ->
        raise Errors.ApiError, Kernel.inspect(error)
    end
  end

  # Private API
  defp send_url(project_id) do
    "#{@fcm_endpoint}/projects/#{project_id}/messages:send"
  end

  defp auth_header(oauth_token) do
    %{"Authorization" => "Bearer #{oauth_token}"}
  end
end
