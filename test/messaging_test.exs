defmodule FirebaseAdminEx.MessagingTest do
  use ExUnit.Case
  import Mock

  alias FirebaseAdminEx.Request
  alias FirebaseAdminEx.Messaging
  alias FirebaseAdminEx.RequestMock
  alias FirebaseAdminEx.Messaging.{Message, WebMessageConfig}

  defmacro with_request_mock(block) do
    quote do
      with_mock Request, [post: fn(url, body, auth_header) -> RequestMock.post(url, body, auth_header) end] do
        unquote(block)
      end
    end
  end

  describe "send/2" do
    test "returns response with valid message and oauth_token" do
      with_request_mock do
        oauth_token = "oauth token"

        message = Message.new(
          data: %{},
          token: "registration-token",
          webpush: WebMessageConfig.new(
            headers: %{},
            data: %{},
            title: "notification title",
            body:  "notification body",
            icon:  "https://icon.png"
          )
        )

        {:ok, _response} = Messaging.send(oauth_token, message)
      end
    end
  end
end
