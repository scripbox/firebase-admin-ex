defmodule FirebaseAdminEx.Auth.ActionCodeSettings do
  @moduledoc """
  This module is responsible for representing the
  attributes of ActionCodeSettings.
  """

  @keys [
    requestType: "",
    email: "",
    returnOobLink: true,
    continueUrl: "",
    canHandleCodeInApp: false,
    dynamicLinkDomain: "",
    androidPackageName: "",
    androidMinimumVersion: "",
    androidInstallApp: false,
    iOSBundleId: ""
  ]

  @type t :: %__MODULE__{
    requestType: String.t(),
    email: String.t(),
    returnOobLink: boolean(),
    continueUrl: String.t(),
    canHandleCodeInApp: boolean(),
    dynamicLinkDomain: String.t(),
    androidPackageName: String.t(),
    androidMinimumVersion: String.t(),
    androidInstallApp: boolean(),
    iOSBundleId: String.t()
  }

  @derive Jason.Encoder
  defstruct @keys

  # Public API
  def new(attributes \\ %{}) do
    %__MODULE__{
      requestType: Map.get(attributes, :requestType),
      email: Map.get(attributes, :email),
      returnOobLink: Map.get(attributes, :returnOobLink),
      continueUrl: Map.get(attributes, :continueUrl),
      canHandleCodeInApp: Map.get(attributes, :canHandleCodeInApp),
      dynamicLinkDomain: Map.get(attributes, :dynamicLinkDomain),
      androidPackageName: Map.get(attributes, :androidPackageName),
      androidMinimumVersion: Map.get(attributes, :androidMinimumVersion),
      androidInstallApp: Map.get(attributes, :androidInstallApp),
      iOSBundleId: Map.get(attributes, :iOSBundleId)
    }
  end

  def validate(%__MODULE__{email: nil}),
    do: {:error, "[ActionCodeSettings] email is missing"}
  
  def validate(%__MODULE__{} = action_code_settings),
    do: {:ok, action_code_settings}

  def validate(_), do: {:error, "[ActionCodeSettings] Invalid payload"}
end
