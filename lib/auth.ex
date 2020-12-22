defmodule FirebaseAdminEx.Auth do
  alias FirebaseAdminEx.{Request, Response, Errors}
  alias FirebaseAdminEx.Auth.ActionCodeSettings

  @auth_endpoint "https://www.googleapis.com/identitytoolkit/v3/relyingparty/"
  @auth_endpoint_account "https://identitytoolkit.googleapis.com/v1/projects/"
  @auth_scope "https://www.googleapis.com/auth/cloud-platform"
  @auth_cert_url "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"

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

  @doc """
  Update an existing user by UID
  Pick one or more fields that require updation.
  Passing the firebase UID as local_id is mandatory, force check this in the client before using update_user api.
  iex(9)> request_body =  %{email_verified: true, local_id: "iD1vovu1QsOcOFrkB2XBw2F4jsZ2"}
        %{email_verified: true, local_id: "iD1vovu1QsOcOFrkB2XBw2F4jsZ2"}
  iex(10)> FirebaseAdminEx.Auth.update_user(request_body)
        {:ok, _UPDATED_USER_BODY_RESPONSE}

  """
  @spec update_user(map, String.t() | nil) :: tuple()
  def update_user(request_body, client_email \\ nil),
    do: do_request("setAccountInfo", request_body, client_email)

  # TODO: Add other commands:
  # list_users
  # create_user
  # update_user
  # import_users

  @doc """
  Create an email/password user
  """
  @spec create_email_password_user(map, String.t() | nil) :: tuple()
  def create_email_password_user(
        %{"email" => email, "password" => password},
        client_email \\ nil
      ),
      do:
        do_request(
          "signupNewUser",
          %{:email => email, :password => password, :returnSecureToken => true},
          client_email
        )

  @doc """
  Generates the email action link for sign-in flows, using the action code settings provided
  """
  @spec generate_sign_in_with_email_link(ActionCodeSettings.t(), String.t(), String.t()) :: tuple()
  def generate_sign_in_with_email_link(action_code_settings, client_email, project_id) do
    with {:ok, action_code_settings} <- ActionCodeSettings.validate(action_code_settings) do
      do_request("accounts:sendOobCode", action_code_settings, client_email, project_id)
    end
  end

  @doc """
      Fetch environment specific Firebase project_id
  """
  def firebase_project_id() do
      Goth.Config.get(:project_id) |> elem(1)
  end

  @doc """
    Verify id token based on certificate, token issuer and timestamp
  """
  @spec verify_token(String.t(), boolean()) :: tuple()
  def verify_token(id_token, allow_unverified \\ true) do
      with    {:ok, fields} <- resolve_token_firebase(id_token, @auth_cert_url),
              {true,_} <- check_payload_email_verified(fields["email_verified"],allow_unverified),
              {true,_} <- check_payload_audience(fields["aud"]),
              {true,_} <- check_payload_issuer(fields["iss"]),
              {true,_} <- check_payload_expiry(fields["exp"]) do
              {:ok, fields}
      else
          {:error, reason} -> {:error, reason}
          {false, reason} -> {:error, reason}
      end
  end

  @doc """
      Resolve id token based on certificate into firebase user data
  """
  @spec resolve_token_firebase(String.t(), String.t()) :: tuple()
  def resolve_token_firebase(id_token, cert_url) do
      with true <- !is_nil(id_token),
          {:ok, response} <- HTTPoison.get(cert_url),
          %{body: body} = response,
          certs = Poison.Parser.parse!(body, %{}),
          {:ok, header} <- Joken.peek_header(id_token),
          jwks = JOSE.JWK.from_firebase(certs),
          true <- !is_nil(jwks[header["kid"]]),
          jwk = jwks[header["kid"]] |> JOSE.JWK.to_map |> elem(1),
          {true, jose_jwt, _} = JOSE.JWT.verify(jwk, id_token) do
          fields = JOSE.JWT.to_map(jose_jwt) |> elem(1)
          {:ok, fields}
      else
          false -> {:error, "id_token is nil"}
          {:error, _} -> {:error, "Unable to resolve id_token error"}
          {false,_} -> {:error, "Unable to resolve id_token due to certificate mismatch"}
      end
	end

  @doc """
      Check if the email in the payload is verified. If client allows unverified users,
      set allow_unverified to true
  """
  @spec check_payload_email_verified(String.t(), boolean()) :: tuple()
  def check_payload_email_verified(field_value, allow_unverified) do
    if field_value || allow_unverified do
      {true, "Email is verified"}
    else
      {false, "Email is not verified"}
    end
  end

  @doc """
      Check if the issuer in the payload matches client's firebase project
  """
  @spec check_payload_issuer(String.t()) :: tuple()
  def check_payload_issuer(field_value) do
    firebase_project_id = firebase_project_id()
    if field_value == "https://securetoken.google.com/" <> firebase_project_id do
      {true, "Issuer matches client's firebase project"}
    else
      {false, "Token issuer does not match client's firebase project"}
    end
  end

  @doc """
      Check if the audience in the payload matches client's firebase project
  """
  @spec check_payload_audience(String.t()) :: tuple()
  def check_payload_audience(field_value) do
    firebase_project_id = firebase_project_id()
    if field_value == firebase_project_id do
      {true, "Audience matches client's firebase project"}
    else
      {false, "Token aud does not match client's firebase project"}
    end
  end

  @doc """
      Check that the token expiry time has not passed.
  """
  @spec check_payload_expiry(integer()) :: tuple()
  def check_payload_expiry(field_value) do
    current_datetime = DateTime.utc_now |> DateTime.to_unix
    if field_value > current_datetime do
      {true, "Token is valid"}
    else
      {false, "Token has passed it's expiry time"}
    end
  end

  defp do_request(url_suffix, payload, client_email, project_id) do
    with {:ok, response} <-
           Request.request(
             :post,
             "#{@auth_endpoint_account}#{project_id}/#{url_suffix}",
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
