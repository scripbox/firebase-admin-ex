defmodule FirebaseAdminEx.Messaging.AndroidMessage.Config do
  @moduledoc """
  This module is responsible for representing the
  attributes of AndroidMessage.Config.
  """

  alias FirebaseAdminEx.Messaging.AndroidMessage.Notification

  @keys [
    collapse_key: "",
    priority: "normal",
    ttl: "",
    restricted_package_name: "",
    data: %{},
    notification: %Notification{
      title: "",
      body: ""
    }
  ]

  @type t :: %__MODULE__{
          collapse_key: String.t(),
          priority: String.t(),
          ttl: String.t(),
          restricted_package_name: String.t(),
          data: map(),
          notification: struct()
        }

  defstruct @keys

  # Public API
  def new(attributes \\ []) do
    %__MODULE__{
      collapse_key: Keyword.get(attributes, :collapse_key),
      priority: Keyword.get(attributes, :priority),
      ttl: Keyword.get(attributes, :ttl),
      restricted_package_name: Keyword.get(attributes, :restricted_package_name),
      data: Keyword.get(attributes, :data, %{}),
      notification: Notification.new(attributes)
    }
  end

  def validate(%__MODULE__{data: _, notification: nil}),
    do: {:error, "[AndroidMessage.Config] notification is missing"}

  def validate(%__MODULE__{data: _, notification: notification} = message_config) do
    case Notification.validate(notification) do
      {:ok, _} ->
        {:ok, message_config}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(_), do: {:error, "[AndroidMessage.Config] Invalid payload"}
end
