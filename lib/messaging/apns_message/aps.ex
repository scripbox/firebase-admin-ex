defmodule FirebaseAdminEx.Messaging.APNSMessage.Aps do
  @moduledoc """
  This module is responsible for representing the
  attributes of APNSMessage.Aps.
  """

  alias FirebaseAdminEx.Messaging.APNSMessage.Alert

  @keys [
    alert_string: "",
    alert: %Alert{},
    badge: 5,
    sound: "",
    category: ""
  ]

  @type t :: %__MODULE__{
          alert_string: String.t(),
          alert: struct(),
          badge: integer(),
          sound: String.t(),
          category: String.t()
        }

  defstruct @keys

  # Public API

  def new(attributes \\ []) do
    %__MODULE__{
      alert_string: Keyword.get(attributes, :alert_string),
      alert: Alert.new(attributes),
      badge: Keyword.get(attributes, :badge),
      sound: Keyword.get(attributes, :sound),
      category: Keyword.get(attributes, :category)
    }
  end

  def validate(%__MODULE__{alert_string: nil, alert: nil} = message), do: {:ok, message}

  def validate(%__MODULE__{alert_string: nil, alert: alert} = message_config) do
    case Alert.validate(alert) do
      {:ok, _} ->
        {:ok, message_config}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(%__MODULE__{alert_string: _, alert: nil} = message), do: {:ok, message}

  def validate(%__MODULE__{alert_string: _, alert: _}),
    do: {:error, "[APNSMessage.Aps] Multiple alert specifications"}

  def validate(_), do: {:error, "[APNSMessage.Aps] Invalid payload"}
end
