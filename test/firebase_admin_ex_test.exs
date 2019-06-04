defmodule FirebaseAdminExTest do
  use ExUnit.Case

  import Mock

  alias FirebaseAdminEx.Request
  alias FirebaseAdminEx.RequestMock
  alias FirebaseAdminEx.Auth
  alias FirebaseAdminEx.Auth.ActionCodeSettings

  @project_id "FIREBASE-PROJECT-ID"
  @client_email "FIREBASE-CLIENT-EMAIL"

  defmacro with_request_mock(block) do
    quote do
      with_mocks([
        {
          Request,
          [],
          [
            request: fn method, url, body, headers -> RequestMock.post(url, body, headers) end
          ]
        },
        {
          Goth.Token,
          [],
          [
            for_scope: fn _auth_scope -> {:ok, %{token: "token_test"}} end
          ]
        }
      ]) do
        unquote(block)
      end
    end
  end

  test "should createa a new email/password user" do
    with_request_mock do
      
      attributes = %{
        "email" => "user@email.com",
        "password" => :crypto.strong_rand_bytes(256) |> Base.url_encode64() |> binary_part(0, 256)
      }

      {:ok, _response} = Auth.create_email_password_user(attributes, @client_email)
    end
  end

  test "should generates the email action link for sign-in flows, using valid action code settings" do
    with_request_mock do
      
      action_code_settings = 
        ActionCodeSettings.new(
          %{
            requestType: "EMAIL_SIGNIN",
            email: "user@email.com",
            returnOobLink: true,
            continueUrl: "www.test.com",
            canHandleCodeInApp: false,
            dynamicLinkDomain: "",
            androidPackageName: "",
            androidMinimumVersion: "",
            androidInstallApp: false,
            iOSBundleId: ""
          }
        )

      {:ok, _response} = Auth.generate_sign_in_with_email_link(action_code_settings, @client_email, @project_id)
    end
  end

  test "should not generates the email action link for sign-in flows, using invalid action code settings" do
    with_request_mock do

      action_code_settings = 
        ActionCodeSettings.new(
          %{
            requestType: "EMAIL_SIGNIN",
            returnOobLink: true,
            continueUrl: "www.test.com"
          }
        )

      {:error, "[ActionCodeSettings] email is missing"} == Auth.generate_sign_in_with_email_link(action_code_settings, @client_email, @project_id)
    end
  end

end
