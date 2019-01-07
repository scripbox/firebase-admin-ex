defmodule FirebaseAdminEx.Messaging.APNSMessage.Payload do
  @moduledoc """
  This module is responsible for representing the
  attributes of APNSMessage.Payload.
  """

  alias FirebaseAdminEx.Messaging.APNSMessage.Aps

  @keys [
    aps: %{},
    custom_data: %{}
  ]

  @type t :: %__MODULE__{
          aps: map(),
          custom_data: map()
        }

  @derive Jason.Encoder
  defstruct @keys

  # Public API

  def new(attributes \\ %{}) do
    %__MODULE__{
      aps: Aps.new(Map.get(attributes, :aps)),
      custom_data: Map.get(attributes, :custom_data)
    }
  end

  def validate(%__MODULE__{aps: nil} = message), do: {:ok, message}

  def validate(%__MODULE__{aps: aps} = message_config) do
    case Aps.validate(aps) do
      {:ok, _} ->
        {:ok, message_config}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(_), do: {:error, "[APNSMessage.Payload] Invalid payload"}
end
