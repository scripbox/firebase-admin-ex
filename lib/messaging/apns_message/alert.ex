defmodule FirebaseAdminEx.Messaging.APNSMessage.Alert do
  @moduledoc """
  This module is responsible for representing the
  attributes of APNSMessage.Alert.
  """

  @keys [
    title: "",
    body: "",
    "loc-key": "",
    "loc-args": [],
    "title-loc-key": "",
    "title-loc-args": [],
    "action-loc-key": "",
    "launch-image": ""
  ]

  @type t :: %__MODULE__{
          title: String.t(),
          body: String.t(),
          "loc-key": String.t(),
          "loc-args": List.t(),
          "title-loc-key": String.t(),
          "title-loc-args": List.t(),
          "action-loc-key": String.t(),
          "launch-image": String.t()
        }

  @derive Jason.Encoder
  defstruct @keys

  # Public API

  def new(attributes \\ %{}) do
    %__MODULE__{
      title: Map.get(attributes, :title),
      body: Map.get(attributes, :body),
      "loc-key": Map.get(attributes, :"loc-key", ""),
      "loc-args": Map.get(attributes, :"loc-args", []),
      "title-loc-key": Map.get(attributes, :"title-loc-key", ""),
      "title-loc-args": Map.get(attributes, :"title-loc-args", []),
      "action-loc-key": Map.get(attributes, :"action-loc-key"),
      "launch-image": Map.get(attributes, :"launch-image", "")
    }
  end

  def validate(%__MODULE__{"title-loc-key": "", "title-loc-args": title_loc_args})
      when length(title_loc_args) > 0 do
    {:error, "[APNSMessage.Alert] title-loc-key is required when specifying title-loc-args"}
  end

  def validate(%__MODULE__{"loc-key": "", "loc-args": loc_args})
      when length(loc_args) > 0 do
    {:error, "[APNSMessage.Alert] loc-key is required when specifying loc-args"}
  end

  def validate(%__MODULE__{} = message), do: {:ok, message}
  def validate(_), do: {:error, "[APNSMessage.Alert] Invalid payload"}
end
