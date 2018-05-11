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

  defstruct @keys

  # Public API

  def new(attributes \\ []) do
    %__MODULE__{
      title: Keyword.get(attributes, :title),
      body: Keyword.get(attributes, :body),
      icon: Keyword.get(attributes, :icon),
      color: Keyword.get(attributes, :color),
      sound: Keyword.get(attributes, :sound),
      tag: Keyword.get(attributes, :tag),
      click_action: Keyword.get(attributes, :click_action),
      body_loc_key: Keyword.get(attributes, :body_loc_key),
      body_loc_args: Keyword.get(attributes, :body_loc_args),
      title_loc_key: Keyword.get(attributes, :title_loc_key),
      title_loc_args: Keyword.get(attributes, :title_loc_args)
    }
  end

  def validate(%__MODULE__{title: nil, body: _}),
    do: {:error, "[AndroidMessage.Notification] title is missing"}

  def validate(%__MODULE__{title: _, body: nil}),
    do: {:error, "[AndroidMessage.Notification] body is missing"}

  def validate(%__MODULE__{title: _, body: _} = message), do: {:ok, message}
  def validate(_), do: {:error, "[AndroidMessage.Notification] Invalid payload"}
end
