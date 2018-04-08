defmodule FirebaseAdminEx.Messaging.Message do
  @moduledoc """
  This module is responsible for representing the
  attributes of FirebaseAdminEx.Message.
  """

  alias __MODULE__
  alias FirebaseAdminEx.Messaging.WebMessageConfig

  # Sample Schema
  # {
  #   data: %{},
  #   webpush: %WebMessageConfig{},
  #   token: ""
  # }
  @keys [
    data: %{},
    webpush: %WebMessageConfig{},
    token: ""
  ]

  @type t :: %__MODULE__{
          data: map(),
          webpush: struct(),
          token: String.t()
        }

  defstruct @keys

  # Public API

  def new(data: data, token: token, webpush: webpush) do
    %Message{
      data: data || %{},
      webpush: webpush,
      token: token
    }
  end

  def validate(%Message{data: _, token: nil, webpush: _}),
    do: {:error, "[Message] token is missing"}

  def validate(%Message{data: _, token: _, webpush: nil} = message), do: {:ok, message}

  def validate(%Message{data: _, token: _, webpush: web_message_config} = message) do
    case WebMessageConfig.validate(web_message_config) do
      {:ok, _} ->
        {:ok, message}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(_), do: {:error, "[Message] Invalid payload"}
end
