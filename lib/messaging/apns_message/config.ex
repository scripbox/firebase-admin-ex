defmodule FirebaseAdminEx.Messaging.APNSMessage.Config do
  @moduledoc """
  This module is responsible for representing the
  attributes of APNSMessage.Config.
  """

  alias FirebaseAdminEx.Messaging.APNSMessage.Payload

  @keys [
    headers: %{},
    payload: %Payload{
      aps: %{},
      custom_data: %{}
    }
  ]

  @type t :: %__MODULE__{
          headers: map(),
          payload: struct()
        }

  @derive Jason.Encoder
  defstruct @keys

  # Public API
  def new(attributes \\ %{}) do
    %__MODULE__{
      headers: Map.get(attributes, :headers, %{}),
      payload: Payload.new(Map.get(attributes, :payload))
    }
  end

  def validate(%__MODULE__{headers: _, payload: nil}),
    do: {:error, "[APNSMessage.Config] payload is missing"}

  def validate(%__MODULE__{headers: _, payload: payload} = message_config) do
    case Payload.validate(payload) do
      {:ok, _} ->
        {:ok, message_config}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(_), do: {:error, "[APNSMessage.Config] Invalid payload"}
end
