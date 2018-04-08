defmodule FirebaseAdminEx.Messaging.WebMessageConfig do
  @moduledoc """
  This module is responsible for representing the
  attributes of WebMessageConfig.
  """

  alias __MODULE__
  alias FirebaseAdminEx.Messaging.WebMessageNotification

  # Sample Schema
  # {
  #   headers: %{},
  #   data: %{},
  #   notification: %WebMessageNotification{},
  # }
  @keys [
    headers: %{},
    data: %{},
    notification: %WebMessageNotification{
      title: "",
      body: ""
    }
  ]

  @type t :: %__MODULE__{
          headers: map(),
          data: map(),
          notification: struct()
        }

  defstruct @keys

  # Public API

  def new(headers: headers, data: data, title: title, body: body, icon: icon) do
    %WebMessageConfig{
      headers: headers || %{},
      data: data || %{},
      notification: %WebMessageNotification{
        title: title,
        body: body,
        icon: icon
      }
    }
  end

  def validate(%WebMessageConfig{headers: _, data: _, notification: nil}),
    do: {:error, "[WebMessageConfig] notification is missing"}

  def validate(
        %WebMessageConfig{headers: _, data: _, notification: notification} = message_config
      ) do
    case WebMessageNotification.validate(notification) do
      {:ok, _} ->
        {:ok, message_config}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(_), do: {:error, "[WebMessageConfig] Invalid payload"}
end
