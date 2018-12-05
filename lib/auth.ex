defmodule FirebaseAdminEx.Auth do
  alias FirebaseAdminEx.{Request, Response, Errors}

  @auth_endpoint "https://www.googleapis.com/identitytoolkit/v3/relyingparty/"
  @auth_scope "https://www.googleapis.com/auth/cloud-platform"

  @doc """
  Get a user's info by UID
  """
  @spec get_user(String.t()) :: tuple()
  def get_user(uid), do: get_user(:localId, uid)

  @doc """
  Get a user's info by phone number
  """
  @spec get_user_by_phone_number(String.t()) :: tuple()
  def get_user_by_phone_number(phone_number),
    do: get_user(:phone_number, phone_number)

  @doc """
  Get a user's info by email
  """
  @spec get_user_by_email(String.t()) :: tuple()
  def get_user_by_email(email), do: get_user(:email, email)

  defp get_user(key, value), do: do_request("getAccountInfo", %{key => value})

  @doc """
  Delete an existing user by UID
  """
  @spec delete_user(String.t()) :: tuple()
  def delete_user(uid), do: do_request("deleteAccount", %{localId: uid})

  # TODO: Add other commands:
  # list_users
  # create_user
  # update_user
  # import_users

  defp do_request(url_suffix, payload) do
    with {:ok, response} <-
      Request.post(@auth_endpoint <> url_suffix, payload, auth_header()),
         {:ok, body} <- Response.parse(response) do
      {:ok, body}
    else
      {:error, error} -> raise Errors.ApiError, Kernel.inspect(error)
    end
  end

  defp auth_header() do
    {:ok, token} = Goth.Token.for_scope(@auth_scope)
    %{"Authorization" => "Bearer #{token.token}"}
  end
end
