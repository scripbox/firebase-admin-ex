defmodule FirebaseAdminEx.Messaging.WebMessage.Notification do
  @moduledoc """
  This module is responsible for representing the
  attributes of WebMessage.Notification.
  """

  @keys [
    title: "",
    body: "",
    icon: ""
  ]

  @type t :: %__MODULE__{
          title: String.t(),
          body: String.t(),
          icon: String.t()
        }

  @derive Jason.Encoder
  defstruct @keys

  # Public API

  def new(attributes \\ %{}) do
    %__MODULE__{
      title: Map.get(attributes, :title),
      body: Map.get(attributes, :body),
      icon: Map.get(attributes, :icon)
    }
  end

  def validate(%__MODULE__{title: nil, body: _, icon: _}),
    do: {:error, "[WebMessage.Notification] title is missing"}

  def validate(%__MODULE__{title: _, body: nil, icon: _}),
    do: {:error, "[WebMessage.Notification] body is missing"}

  def validate(%__MODULE__{title: _, body: _, icon: _} = message), do: {:ok, message}
  def validate(_), do: {:error, "[WebMessage.Notification] Invalid payload"}
end
