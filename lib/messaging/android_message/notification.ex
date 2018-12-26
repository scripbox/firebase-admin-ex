defmodule FirebaseAdminEx.Messaging.AndroidMessage.Notification do
  @moduledoc """
  This module is responsible for representing the
  attributes of AndroidMessage.Notification.
  """

  @keys [
    title: "",
    body: "",
    icon: "",
    color: "",
    sound: "",
    tag: "",
    click_action: "",
    body_loc_key: "",
    body_loc_args: [],
    title_loc_key: "",
    title_loc_args: []
  ]

  @type t :: %__MODULE__{
          title: String.t(),
          body: String.t(),
          icon: String.t(),
          color: String.t(),
          sound: String.t(),
          tag: String.t(),
          click_action: String.t(),
          body_loc_key: String.t(),
          body_loc_args: List.t(),
          title_loc_key: String.t(),
          title_loc_args: List.t()
        }

  @derive Jason.Encoder
  defstruct @keys

  # Public API

  def new(attributes \\ %{}) do
    %__MODULE__{
      title: Map.get(attributes, :title),
      body: Map.get(attributes, :body),
      icon: Map.get(attributes, :icon),
      color: Map.get(attributes, :color),
      sound: Map.get(attributes, :sound),
      tag: Map.get(attributes, :tag),
      click_action: Map.get(attributes, :click_action),
      body_loc_key: Map.get(attributes, :body_loc_key),
      body_loc_args: Map.get(attributes, :body_loc_args),
      title_loc_key: Map.get(attributes, :title_loc_key),
      title_loc_args: Map.get(attributes, :title_loc_args)
    }
  end

  def validate(%__MODULE__{title: nil, body: _}),
    do: {:error, "[AndroidMessage.Notification] title is missing"}

  def validate(%__MODULE__{title: _, body: nil}),
    do: {:error, "[AndroidMessage.Notification] body is missing"}

  def validate(%__MODULE__{title: _, body: _} = message), do: {:ok, message}
  def validate(_), do: {:error, "[AndroidMessage.Notification] Invalid payload"}
end
