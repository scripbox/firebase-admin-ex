defmodule FirebaseAdminEx.Errors.ApiError do
  defexception [:reason]

  def exception(reason), do: %__MODULE__{reason: reason}

  def message(%__MODULE__{reason: reason}), do: "FirebaseAdminEx::ApiError - #{reason}"
end

defmodule FirebaseAdminEx.Errors.ApiLimitExceeded do
  defexception [:reason]

  def exception(reason), do: %__MODULE__{reason: reason}

  def message(%__MODULE__{reason: reason}), do: "FirebaseAdminEx::ApiLimitExceeded - #{reason}"
end
