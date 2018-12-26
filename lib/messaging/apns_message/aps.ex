defmodule FirebaseAdminEx.Messaging.APNSMessage.Aps do
  @moduledoc """
  This module is responsible for representing the
  attributes of APNSMessage.Aps.
  """

  alias FirebaseAdminEx.Messaging.APNSMessage.Alert

  @keys [
    alert_string: "",
    alert: %Alert{},
    badge: 0,
    sound: "",
    category: "",
    "content-available": 0
  ]

  @type t :: %__MODULE__{
          alert_string: String.t(),
          alert: struct(),
          badge: integer(),
          sound: String.t(),
          category: String.t(),
          "content-available": integer()
        }

  @derive Jason.Encoder
  defstruct @keys

  # Public API

  def new(attributes \\ %{}) do
    %__MODULE__{
      alert_string: Map.get(attributes, :alert_string),
      alert: Alert.new(Map.get(attributes, :alert)),
      badge: Map.get(attributes, :badge, 0),
      sound: Map.get(attributes, :sound),
      category: Map.get(attributes, :category, ""),
      "content-available": Map.get(attributes, :"content-available")
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
