defmodule FirebaseAdminEx.Messaging.WebMessage.Config do
  @moduledoc """
  This module is responsible for representing the
  attributes of WebMessage.Config.
  """

  alias FirebaseAdminEx.Messaging.WebMessage.Notification

  @keys [
    headers: %{},
    data: %{},
    notification: %Notification{
      title: "",
      body: ""
    }
  ]

  @type t :: %__MODULE__{
          headers: map(),
          data: map(),
          notification: struct()
        }

  @derive Jason.Encoder
  defstruct @keys

  # Public API

  def new(attributes \\ %{}) do
    %__MODULE__{
      headers: Map.get(attributes, :headers, %{}),
      data: Map.get(attributes, :data, %{}),
      notification: Notification.new(attributes)
    }
  end

  def validate(%__MODULE__{headers: _, data: _, notification: nil}),
    do: {:error, "[WebMessage.Config] notification is missing"}

  def validate(%__MODULE__{headers: _, data: _, notification: notification} = message_config) do
    case Notification.validate(notification) do
      {:ok, _} ->
        {:ok, message_config}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(_), do: {:error, "[WebMessage.Config] Invalid payload"}
end
