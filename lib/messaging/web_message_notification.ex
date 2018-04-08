defmodule FirebaseAdminEx.Messaging.WebMessageNotification do
  @moduledoc """
  This module is responsible for representing the
  attributes of WebMessageNotification.
  """

  alias __MODULE__

  # Sample Schema
  # {
  #   title: "message title",
  #   body: "message body",
  #   icon: "icon url"
  # }
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

  defstruct @keys

  # Public API

  def validate(%WebMessageNotification{title: nil, body: _, icon: _}),
    do: {:error, "[WebMessageNotification] title is missing"}

  def validate(%WebMessageNotification{title: _, body: nil, icon: _}),
    do: {:error, "[WebMessageNotification] body is missing"}

  def validate(%WebMessageNotification{title: _, body: _, icon: _} = message), do: {:ok, message}
  def validate(_), do: {:error, "[WebMessageNotification] Invalid payload"}
end
