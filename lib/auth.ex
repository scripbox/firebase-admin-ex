defmodule FirebaseAdminEx.Auth do
  alias FirebaseAdminEx.{Request, Response, Errors}

  @auth_endpoint "https://www.googleapis.com/identitytoolkit/v3/relyingparty/"
  @auth_endpoint_email "https://identitytoolkit.googleapis.com/v1/projects/"
  @auth_scope "https://www.googleapis.com/auth/cloud-platform"

  @valids_action_code_settings [
    "requestType",
    "email",
    "returnOobLink",
    "continueUrl",
    "canHandleCodeInApp",
    "dynamicLinkDomain",
    "androidPackageName",
    "androidMinimumVersion",
    "androidInstallApp",
    "iOSBundleId"
  ]
  
  @doc """
  Get a user's info by UID
  """
  @spec get_user(String.t(), String.t() | nil) :: tuple()
  def get_user(uid, client_email \\ nil), do: get_user(:localId, uid, client_email)

  @doc """
  Get a user's info by phone number
  """
  @spec get_user_by_phone_number(String.t(), String.t() | nil) :: tuple()
  def get_user_by_phone_number(phone_number, client_email \\ nil),
    do: get_user(:phone_number, phone_number, client_email)

  @doc """
  Get a user's info by email
  """
  @spec get_user_by_email(String.t(), String.t() | nil) :: tuple()
  def get_user_by_email(email, client_email \\ nil),
    do: get_user(:email, email, client_email)

  defp get_user(key, value, client_email),
    do: do_request("getAccountInfo", %{key => value}, client_email)

  @doc """
  Delete an existing user by UID
  """
  @spec delete_user(String.t(), String.t() | nil) :: tuple()
  def delete_user(uid, client_email \\ nil),
    do: do_request("deleteAccount", %{localId: uid}, client_email)

  # TODO: Add other commands:
  # list_users
  # create_user
  # update_user
  # import_users

  @doc """
  Create an email/password user
  """
  @spec create_email_password_user(map, String.t() | nil) :: tuple()
  def create_email_password_user(%{"email" => email, "password" => password}, client_email \\ nil),
    do: do_request("signupNewUser", %{:email => email, :password => password, :returnSecureToken => true}, client_email)


  @doc """
  Generates the email action link for sign-in flows, using the action code settings provided
  """
  @spec generate_sign_in_with_email_link(String.t(), map, String.t(), String.t()) :: tuple()
  def generate_sign_in_with_email_link(email, action_code_settings, client_email, project_id) do
    initial_settings = %{
      "requestType" => "EMAIL_SIGNIN",
      "email" => email,
      "returnOobLink" => true
    }
    payload = 
      unless action_code_settings == nil do
        action_code_settings
        |> Map.take(@valids_action_code_settings)
        |> Map.merge(initial_settings, fn _k, _v1, v2 -> v2 end)
      else ->
        initial_settings
      end
    do_request("accounts:sendOobCode", payload, client_email, project_id, :accounts)
  end
   
  defp do_request(url_suffix, payload, client_email, project_id, :accounts) do
    with {:ok, response} <-
           Request.request(
             :post,
             "#{@auth_endpoint_email}#{project_id}/#{url_suffix}",
             payload,
             auth_header(client_email)
           ),
         {:ok, body} <- Response.parse(response) do
      {:ok, body}
    else
      {:error, error} -> raise Errors.ApiError, Kernel.inspect(error)
    end
  end

  defp do_request(url_suffix, payload, client_email) do
    with {:ok, response} <-
           Request.request(
             :post,
             @auth_endpoint <> url_suffix,
             payload,
             auth_header(client_email)
           ),
         {:ok, body} <- Response.parse(response) do
      {:ok, body}
    else
      {:error, error} -> raise Errors.ApiError, Kernel.inspect(error)
    end
  end

  defp auth_header(nil) do
    {:ok, token} = Goth.Token.for_scope(@auth_scope)

    do_auth_header(token.token)
  end

  defp auth_header(client_email) do
    {:ok, token} = Goth.Token.for_scope({client_email, @auth_scope})

    do_auth_header(token.token)
  end

  defp do_auth_header(token) do
    %{"Authorization" => "Bearer #{token}"}
  end
end
