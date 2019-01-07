defmodule FirebaseAdminEx.MessagingTest do
  use ExUnit.Case
  import Mock

  alias FirebaseAdminEx.Request
  alias FirebaseAdminEx.Messaging
  alias FirebaseAdminEx.RequestMock
  alias FirebaseAdminEx.Messaging.Message
  alias FirebaseAdminEx.Messaging.WebMessage.Config, as: WebMessageConfig
  alias FirebaseAdminEx.Messaging.AndroidMessage.Config, as: AndroidMessageConfig
  alias FirebaseAdminEx.Messaging.APNSMessage.Config, as: APNSMessageConfig

  @project_id "FIREBASE-PROJECT-ID"

  defmacro with_request_mock(block) do
    quote do
      with_mock Request,
        request: fn method, url, body, headers -> RequestMock.post(url, body, headers) end do
        unquote(block)
      end
    end
  end

  describe "send/2" do
    test "[WebPush] returns response with valid message and oauth_token" do
      with_request_mock do
        oauth_token = "oauth token"

        message =
          Message.new(%{
            data: %{},
            token: "registration-token",
            webpush:
              WebMessageConfig.new(%{
                headers: %{},
                data: %{},
                title: "notification title",
                body: "notification body",
                icon: "https://icon.png"
              })
          })

        {:ok, _response} = Messaging.send(@project_id, oauth_token, message)
      end
    end

    test "[Android] returns response with valid message and oauth_token" do
      with_request_mock do
        oauth_token = "oauth token"

        message =
          Message.new(%{
            data: %{},
            token: "registration-token",
            android:
              AndroidMessageConfig.new(%{
                headers: %{},
                data: %{},
                title: "notification title",
                body: "notification body",
                icon: "https://icon.png"
              })
          })

        {:ok, _response} = Messaging.send(@project_id, oauth_token, message)
      end
    end

    test "[APNS] returns response with valid message and oauth_token" do
      with_request_mock do
        oauth_token = "oauth token"

        message =
          Message.new(%{
            data: %{},
            token: "registration-token",
            apns:
              APNSMessageConfig.new(%{
                headers: %{},
                payload: %{
                  aps: %{
                    alert: %{
                      title: "Message Title",
                      body: "Message Body"
                    },
                    sound: "default",
                    "content-available": 1
                  },
                  custom_data: %{}
                }
              })
          })

        {:ok, _response} = Messaging.send(@project_id, oauth_token, message)
      end
    end

    test "[DATA] returns response with valid message and oauth_token" do
      with_request_mock do
        oauth_token = "oauth token"

        message =
          Message.new(%{
            data: %{
              key_1: "value 1",
              key_2: "value 2"
            },
            token: "registration-token"
          })

        {:ok, _response} = Messaging.send(@project_id, oauth_token, message)
      end
    end
  end
end
