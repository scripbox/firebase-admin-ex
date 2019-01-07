defmodule FirebaseAdminEx.Messaging do
  alias FirebaseAdminEx.{Request, Response, Errors}
  alias FirebaseAdminEx.Messaging.Message

  @fcm_endpoint "https://fcm.googleapis.com/v1"
  @messaging_scope "https://www.googleapis.com/auth/firebase.messaging"

  # Public API

  @doc """
  The send/2 function makes an API call to the
  firebase messaging `send` endpoint with the auth token
  and message attributes.
  """
  @spec send(String.t(), struct()) :: tuple()
  def send(client_email, message) do
    {:ok, project_id} = Goth.Config.get(client_email, :project_id)
    {:ok, token} = Goth.Token.for_scope({client_email, @messaging_scope})

    send(project_id, token.token, message)
  end

  @doc """
  send/3 Is the same as send/2 except the user can supply their own
  authentication token
  """
  @spec send(String.t(), String.t(), struct()) :: tuple()
  def send(project_id, oauth_token, %Message{} = message) do
    with {:ok, message} <- Message.validate(message),
         {:ok, response} <-
           Request.request(
             :post,
             send_url(project_id),
             %{message: message},
             auth_header(oauth_token)
           ),
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
